# Analytics Store

## Goal

Enable dynamic, agentic analysis and visualization of workout data — not a pre-built dashboard or application, but a platform for LLM agents and MCP tools to answer arbitrary questions.

## Why?

Several projects already offer "ready made UI's" for deeper analysis and visualizations on top of workout data.
I maintain a list on [awesome-health-fitness-oss](https://github.com/Dieterbe/awesome-health-fitness-oss/). But they focus on giving the user a UI.
This project focuses on:
 * giving the user a simple reusable platform to allow custom dynamic analysis/visualization, using agents, mcp tools, (and longterm maybe even something like https://a2ui.org though that seems a bit too limited right now).
 * leveraging body.builds deeper capabilities (e.g. tracking 1RM over time, but allowing out-of-order workouts, e.g. only consider sets that are not affected by other recent sets that affected the same muscle group, which also considers exercise tweaks)

## Architecture

```
body.build SQLite export (manual backup, e.g. via Google Drive)
        ↓
bin/enrich.dart  (Dart CLI, imports body.build as path dependency)
  - reads workout_sets, resolves Ex + tweaks → calls Ex.recruitment()
  - writes set_recruitments table to analytics SQLite
        ↓
analytics SQLite  (enriched, queryable)
        ↓
mcp_server.py  (Python MCP server)
  - tool: raw_sql(query)
  - tool: fresh_sets(muscle_groups, cutoff_hours, min_recruitment)
  - ... more tools as needed
        ↓
Claude Desktop / any MCP client
```

## Storage: analytics SQLite schema

**Passthrough from body.build export** (unchanged):
- `workout_sets` — id, workout_id, exercise_id, tweaks (JSON), weight, reps, rir, timestamp, completed

**Enriched by `enrich.dart`**:
- `set_recruitments` — set_id, program_group (ProgramGroup enum name), volume (0.0–1.0)
  - One row per (set, ProgramGroup) where volume > 0
  - Computed via `Ex.recruitment(pg, tweakOptions)` for all ProgramGroups

## Key design decisions

- **SQLite only** (no DuckDB, no Cube.dev, no Grafana for now) — sufficient for personal data volumes, `json_extract()` handles tweak filtering.  No need for anything hosted.
- **Long-format recruitments table** — one row per (set, muscle group) naturally handles exercises which recruit multiple ProgramGroups.
- **Dart for enrichment** — muscle recruitment logic (`Ex.recruitment()`) lives in Dart and cannot be replicated in SQL; enrich.dart uses the same code as the app. This does mean we do an ETL step to convert the app sqlite (which uses json maps for tweaks) to a new sqlite (which has all recruitments calculated).
- **Python for MCP** — thin wrapper over SQLite; no business logic, just query execution + app-level filters.
- **App-level filters as MCP tools** — e.g. "fresh sets" (no same muscle group worked in last N hours) cannot be a simple SQL query; exposed as named MCP tools callable by agents.
- **Exercise dataset versioning** — `enrich.dart` should assert `exerciseDatasetVersion` matches between the export and the running CLI to avoid silently wrong recruitment values. TODO: actually no, we could just auto-migrate.

## Location

- `bin/enrich.dart` and `analytics/mcp_server.py`.

## Future directions

- Strava integration (outdoor workouts alongside gym sets for cross-source analysis and freshness checks)
- In-app analysis: same Dart library imported directly into Flutter, bypassing MCP entirely
