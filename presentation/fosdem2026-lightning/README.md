# FOSDEM 2026 Lightning Talk – body.build

This folder contains the slide deck for the FOSDEM 2026 lightning talk introducing **body.build**.

---

## Building the slides with Marp

### 1. Install Marp CLI

Install via package manager (marp-cli on Arch), or:
```bash
npm install -g @marp-team/marp-cli
# or use npx without global install
```

### 2. Preview (live reload)

```bash
npx @marp-team/marp-cli -s --allow-local-filesslides-marp.md
```

Opens a local server; edits refresh automatically.

### 3. Export to PDF

```bash
npx @marp-team/marp-cli slides-marp.md --allow-local-files --pdf
```

Produces `slides-marp.pdf` in the same folder.

---

## Alternatives considered

| Tool | Issues / Concerns |
|------|-------------------|
| **Typst** | Promising single-binary workflow, but the Typst syntax for gradients, layouts (`column`, `stack`), and paragraph settings kept erroring out across versions. Debugging required constant API lookups; not worth the friction for a quick deck. |
| **Slidev** | Feature-rich Vue-based system, but requires a full Node.js project setup. Global theme installs failed with permission errors (`EACCES` on `/usr/lib`), and local installs pulled heavy dependencies. Overkill for a 5-minute talk. |
| **Pandoc + Beamer** | Mature pipeline, but needs a working TeX distribution. Extra installation overhead and LaTeX debugging weren't justified for a simple presentation. |

### Why Marp won

- **Minimal setup** – easy to install
- **Plain Markdown** – easy to version-control and AI-assist.
- **Built-in theming** – dark backgrounds, custom CSS, image positioning (`![bg left:40%]`) all work out of the box.
- **Fast PDF export** – Playwright-based rendering with no extra config.

For future talks, would like to look at Slidev and Typst again, but for now, Marp has proven itself
