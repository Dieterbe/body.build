#!/usr/bin/env -S uv run
# /// script
# requires-python = ">=3.12"
# dependencies = ["mcp[cli]>=1.0.0"]
# ///
"""
Body.build analytics MCP server.

Exposes the enriched analytics SQLite (produced by bin/enrich.dart) to LLM
agents via the Model Context Protocol.

Requirements:
    uv (https://github.com/astral-sh/uv)

Usage (stdio transport, for Claude Desktop):
    uv run analytics-store/mcp_server.py --db /path/to/analytics.sqlite

Claude Desktop config (~/.config/Claude/claude_desktop_config.json):
    {
      "mcpServers": {
        "bodybuild-analytics": {
          "command": "uv",
          "args": ["run", "/path/to/body.build/analytics-store/mcp_server.py",
                   "--db", "/path/to/analytics.sqlite"]
        }
      }
    }
"""

import argparse
import json
import sqlite3
import sys
from pathlib import Path

from mcp.server.fastmcp import FastMCP

# ---------------------------------------------------------------------------
# Argument parsing (done before MCP server instantiation so --help works)
# ---------------------------------------------------------------------------

parser = argparse.ArgumentParser(description="Body.build analytics MCP server")
parser.add_argument("--db", required=True, help="Path to the enriched analytics SQLite file")
args = parser.parse_args()

db_path = Path(args.db).expanduser().resolve()
if not db_path.exists():
    print(f"Error: database not found: {db_path}", file=sys.stderr)
    sys.exit(1)

# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------

def get_conn() -> sqlite3.Connection:
    conn = sqlite3.connect(str(db_path))
    conn.row_factory = sqlite3.Row
    return conn


def rows_to_json(rows: list[sqlite3.Row]) -> str:
    return json.dumps([dict(r) for r in rows], indent=2)


# ---------------------------------------------------------------------------
# MCP server
# ---------------------------------------------------------------------------

mcp = FastMCP("bodybuild-analytics")


@mcp.tool()
def raw_sql(query: str) -> str:
    """
    Execute an arbitrary read-only SQL query against the analytics SQLite and
    return the results as JSON.

    The database has the following tables:

    workout_sets(id, workout_id, exercise_id, tweaks, weight, reps, rir,
                 comments, timestamp, completed)
      - exercise_id: human-readable string e.g. "bulgarian split squat"
      - tweaks: JSON object e.g. {"ROM": "full", "loading": "dumbbell"}
      - timestamp: Unix epoch (seconds)
      - completed: 1 if the set was completed

    set_recruitments(set_id, program_group, volume)
      - set_id: FK to workout_sets.id
      - program_group: one of the ProgramGroup enum names (see list_program_groups)
      - volume: float 0.0–1.0 representing recruitment intensity

    workouts(id, name, timestamp, ...)
    """
    if any(kw in query.upper() for kw in ("INSERT", "UPDATE", "DELETE", "DROP", "ALTER", "CREATE")):
        return json.dumps({"error": "Only SELECT queries are allowed."})
    with get_conn() as conn:
        try:
            rows = conn.execute(query).fetchall()
            return rows_to_json(rows)
        except sqlite3.Error as e:
            return json.dumps({"error": str(e)})


@mcp.tool()
def list_program_groups() -> str:
    """
    Return all ProgramGroup names present in set_recruitments. Use these
    exact strings in other tool calls that take a muscle group parameter.
    """
    with get_conn() as conn:
        rows = conn.execute(
            "SELECT DISTINCT program_group FROM set_recruitments ORDER BY program_group"
        ).fetchall()
    return json.dumps([r["program_group"] for r in rows])


@mcp.tool()
def fresh_sets(
    muscle_groups: list[str],
    cutoff_hours: float = 48.0,
    min_recruitment: float = 0.3,
    since_timestamp: int | None = None,
) -> str:
    """
    Return completed workout sets where NONE of the specified muscle groups
    were significantly recruited in the preceding cutoff_hours window.

    This is the "fresh muscle" filter: a set qualifies as fresh for a muscle
    group if no prior completed set that recruited that muscle group
    (volume >= min_recruitment) exists within cutoff_hours before it.

    Args:
        muscle_groups:    List of ProgramGroup names to check freshness for.
                          Use list_program_groups() to see available names.
        cutoff_hours:     How many hours back to look for prior work. Default 48.
        min_recruitment:  Volume threshold to consider a muscle group "worked".
                          0.0–1.0, default 0.3.
        since_timestamp:  Optional Unix epoch (seconds). If set, only return
                          sets on or after this time.

    Returns JSON array of workout_sets rows that are fresh for ALL listed muscles.
    """
    if not muscle_groups:
        return json.dumps({"error": "muscle_groups must not be empty"})

    cutoff_seconds = int(cutoff_hours * 3600)
    placeholders = ",".join("?" * len(muscle_groups))

    # For each set S, it's "fresh" for a muscle group G if there is no other
    # completed set S2 where:
    #   - S2.timestamp is in (S.timestamp - cutoff, S.timestamp)
    #   - S2 recruits G with volume >= min_recruitment
    # We need this to hold for ALL requested muscle groups.

    since_clause = "AND ws.timestamp >= ?" if since_timestamp is not None else ""
    params_base: list = list(muscle_groups) + [min_recruitment, cutoff_seconds]
    if since_timestamp is not None:
        params_base.append(since_timestamp)

    query = f"""
        SELECT ws.*
        FROM workout_sets ws
        WHERE ws.completed = 1
        {since_clause}
        AND (
            -- count how many of the requested muscle groups have prior work
            SELECT COUNT(DISTINCT sr2.program_group)
            FROM set_recruitments sr2
            JOIN workout_sets ws2 ON ws2.id = sr2.set_id
            WHERE sr2.program_group IN ({placeholders})
              AND sr2.volume >= ?
              AND ws2.completed = 1
              AND ws2.timestamp < ws.timestamp
              AND ws2.timestamp >= ws.timestamp - ?
        ) = 0
        ORDER BY ws.timestamp
    """

    # Reorder params: placeholders come first in the subquery
    params = list(muscle_groups) + [min_recruitment, cutoff_seconds]
    if since_timestamp is not None:
        # since_clause param goes before the subquery
        params = [since_timestamp] + params

    with get_conn() as conn:
        try:
            rows = conn.execute(query, params).fetchall()
            return rows_to_json(rows)
        except sqlite3.Error as e:
            return json.dumps({"error": str(e)})


@mcp.tool()
def weekly_volume(
    muscle_group: str,
    min_recruitment: float = 0.3,
    weeks: int = 12,
) -> str:
    """
    Return per-week volume for a given muscle group, going back N weeks.

    Each row: { week_start (ISO date), volume }

    Volume is the sum of sr.volume (0.0–1.0 per set) for sets above
    min_recruitment, giving a weighted measure of muscle stimulus rather
    than a raw set count.

    Useful for tracking training volume trends over time.

    Args:
        muscle_group:    ProgramGroup name (use list_program_groups()).
        min_recruitment: Volume threshold to include a set. Default 0.3.
        weeks:           How many recent weeks to include. Default 12.
    """
    query = """
        SELECT
            date(ws.timestamp, 'unixepoch', 'weekday 0', '-6 days') AS week_start,
            SUM(sr.volume) AS volume
        FROM workout_sets ws
        JOIN set_recruitments sr ON sr.set_id = ws.id
        WHERE sr.program_group = ?
          AND sr.volume >= ?
          AND ws.completed = 1
          AND ws.timestamp >= strftime('%s','now') - ? * 7 * 86400
        GROUP BY week_start
        ORDER BY week_start
    """
    with get_conn() as conn:
        try:
            rows = conn.execute(query, [muscle_group, min_recruitment, weeks]).fetchall()
            return rows_to_json(rows)
        except sqlite3.Error as e:
            return json.dumps({"error": str(e)})


if __name__ == "__main__":
    mcp.run()
