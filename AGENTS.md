# VPXwiki — Agent Instructions

This file is auto-loaded by GitHub Copilot as workspace instructions. It defines how the LLM must maintain this wiki.

---

## 🔒 Critical Rules

> **`raw/` is READ-ONLY.** Never create, edit, move, or delete any file under `raw/`. It is source material only — the LLM reads it, never writes to it.

> **`wiki/` is the only writable area.** All LLM output goes here.

---

## Repository Layout

```
VPXwiki/
├── AGENTS.md               ← You are here. Agent instructions.
├── llm-wiki.md             ← LLM prompt / entry point for wiki tasks.
│
├── raw/                    ← READ-ONLY source material. Never modified.
│   ├── B2S/                   B2S Backglass Server wiki export
│   ├── DOF/                   DirectOutput Framework documentation
│   ├── Popper/                PinballY/Popper documentation
│   └── VPX/                   Visual Pinball X documentation
│
└── wiki/                   ← LLM-written and LLM-maintained.
    ├── _schema.md              Legacy schema reference (superseded by this file)
    ├── index.md                Catalog of all pages — always keep current
    ├── log.md                  Append-only operation log — always append, never edit
    ├── overview.md             High-level ecosystem synthesis
    │
    ├── projects/               Deep-dive pages per project
    │   ├── B2S Backglass Server.md
    │   ├── DirectOutput Framework.md
    │   └── Visual Pinball X.md
    │
    ├── concepts/               Cross-cutting entity and concept pages
    │   ├── VPX Accelerometer Input.md
    │   ├── Backglass.md
    │   ├── DMD.md
    │   ├── VPX Latency.md
    │   ├── VPX Lights and Rendering.md
    │   ├── Open Pinball Device.md
    │   ├── DOF Output Controllers.md
    │   ├── Pincab Setup.md
    │   ├── B2S Plugins.md
    │   ├── VPX Plunger Input.md
    │   ├── Screen Configuration.md
    │   ├── VPX Stereo 3D.md
    │   ├── DOF Table Configuration.md
    │   ├── DOF Toys and Effects.md
    │   ├── VPX View Setup.md
    │   └── VPX Scripting.md
    │
    └── sources/                One summary page per raw source collection
        ├── B2S Wiki.md
        ├── DOF Documentation.md
        └── VPX Docs.md
```

---

## Conventions

### Filenames

| Rule | Example |
|------|---------|
| Use readable names with spaces | `Visual Pinball X.md` ✓ |
| Never use underscores or camelCase | `visual_pinball_x.md` ✗ |
| URL-encode spaces in links | `Visual%20Pinball%20X.md` |

### Links

| Scenario | Pattern |
|----------|---------|
| From `wiki/` to a project page | `[VPX](projects/Visual%20Pinball%20X.md)` |
| From `wiki/concepts/` to another concept | `[DMD](DMD.md)` |
| From `wiki/concepts/` to a project | `[VPX](../projects/Visual%20Pinball%20X.md)` |
| From `wiki/sources/` to raw source | `[raw file](../../raw/VPX/docs/Script%20API%20Reference.md)` |

- Always use **relative paths**.
- **MUST** URL-encode all spaces as `%20` in link targets (the path part inside `()`) for wiki links and raw file links.
- **NEVER** use literal spaces in a link target path.
- **Never URL-encode link text** (the label inside `[]`) — it must be human-readable.
  - ✓ `[Script API Reference.md](../../raw/VPX/docs/Script%20API%20Reference.md)`
  - ✗ `[Script API Reference.md](../../raw/VPX/docs/Script API Reference.md)`
  - ✗ `[Script%20API%20Reference.md](../../raw/VPX/docs/Script%20API%20Reference.md)`
- Cross-reference liberally — every concept with its own page should be linked on first mention per section.

### Page Structure

Every wiki page must follow this structure:

```markdown
# Title

1–3 sentence summary of what this page covers.

## Section One
...

## See Also
- [Related Page](../path/to/Related%20Page.md)
```

- Start with `# Title`
- Follow with a short summary (1–3 sentences)
- Use specific, scoped titles for project-specific concepts (e.g., `DOF Table Configuration` instead of generic `Table Configuration`)
- For project-scoped concepts, prefix with the owning subsystem acronym for clarity whenever the unscoped title could be ambiguous:
  `DOF ...`, `VPX ...`, `B2S ...` (examples: `DOF Toys and Effects`, `VPX Latency`)
- Use `## Section` headings throughout
- End with `## See Also` listing related wiki pages as links
- **Split pages** that exceed ~200 lines into sub-pages

### index.md

```
- Page Title (projects/Page%20Title.md) — one-line summary
```

- Grouped by category: Root, Projects, Concepts, Sources
- Updated on every ingest, page creation, or rename

### log.md

```
## [YYYY-MM-DD] operation | description
```

| Operation | When to use |
|-----------|-------------|
| `ingest`  | After processing raw source material |
| `create`  | After creating a new wiki page |
| `update`  | After editing an existing page |
| `query`   | After answering a question from wiki content |
| `lint`    | After a link/consistency scan |

- **Append-only** — never edit or delete past entries.

---

## Workflows

### Ingest (adding new source material)

1. Read the raw source(s) under `raw/` — **do not modify them**.
2. Create or update the matching summary in `wiki/sources/`.
3. Create or update relevant `wiki/projects/` and `wiki/concepts/` pages.
4. Update `wiki/index.md`.
5. Append an `ingest` entry to `wiki/log.md`.

### Query (answering a question)

1. Read `wiki/index.md` to identify relevant pages.
2. Read those pages and synthesize an answer.
3. If the answer is valuable and reusable, file it as a new concept or project page.
4. Append a `query` entry to `wiki/log.md`.

### Lint (validation pass)

1. Scan for: broken links, orphan pages, missing cross-references, contradictions, stale info.
2. Check every markdown link: path must have spaces URL-encoded (`%20`); link text must **not** contain `%20`.
3. Fix issues in-place.
4. Append a `lint` entry to `wiki/log.md` summarizing what was found and fixed.


