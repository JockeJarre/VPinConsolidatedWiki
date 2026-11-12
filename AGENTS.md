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
├── raw/                    ← READ-ONLY source snapshots. Never modified.
│   │                          Primarily the OFFICIAL documentation of each tool's vendor/author (Primary tier).
│   │                          Local staging only — never committed, refreshed by update-raw.ps1.
│   │                          Wiki links into raw paths MUST use the upstream URLs below, never local paths.
│   ├── B2S/                   B2S Backglass Server wiki export (GitHub wiki mirror)
│   ├── DOF/                   DirectOutput Framework documentation (repo clone)
│   ├── VPX/                   Visual Pinball X documentation (repo clone)
│   ├── FlexDMD/               FlexDMD documentation (repo clone)
│   ├── DMD-Extensions/        Freezy DMD Extensions documentation (repo clone)
│   ├── pinscape-build-guide/  Pinscape Build Guide (repo clone, AsciiDoc book)
│   ├── PUP/                   PinUp system documentation mirror
│   ├── SSFImpactor Guide.pdf  SSFImpactor user guide PDF
│   └── ExternalWikis/         External community wikis used to fill gaps — SECONDARY priority (each clones into repo/)
│       └── dekay-vpinball-wiki/  Unofficial Visual Pinball Wiki mirror — SECONDARY priority
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

### Source Priority

| Tier | Sources | Rule |
|------|---------|------|
| **Primary** | B2S wiki, DOF docs, VPX docs, FlexDMD docs, DMD Extensions docs, Pinscape Build Guide, SSFImpactor Guide, PinUp Popper docs, vpxtool README, VPinballX Starter | Upstream docs of the owning project. Claims win on conflicts |
| **Secondary** | Unofficial Visual Pinball Wiki (`raw/ExternalWikis/dekay-vpinball-wiki/`) | Community wiki. Use for tips and platforms the Primary sources do not cover. Where it conflicts with a Primary source, keep the Primary claim and add a conflict note |
| **Link-only** | Entries in `wiki/references.md` (e.g. Virtual Pinball Spreadsheet; source proposals accepted as links, e.g. vendor sites not registered for ingest) | External lookup aids accepted as links only. Never fetched into `raw/`, never get a `wiki/sources/` page, never support standalone factual claims — cite tier sources as usual |

Conflict note format for Secondary-source disagreements:

```markdown
- ⚠️ CONFLICT (secondary source): <secondary claim>
  (raw/ExternalWikis/dekay-vpinball-wiki/repo/<File>.md) — Primary: <primary claim> (raw/<path>)
```

- The source page of a Secondary collection must open with the callout
  `> ⚠️ Priority: Secondary — community-maintained; Primary sources win on conflicts.`
- Its `index.md` entry ends with the marker `(secondary source)`.

### Source Proposals — Accept, Reject, or Link-only

Every `source/<slug>` proposal PR (opened by the nightly scan, one per
`- [NEW-SOURCE]` line in `SOURCE-PROPOSALS.md`) has three possible outcomes.
The repo owner chooses by commenting the keyword on the PR; the nightly
ingest acts on the comment:

| Directive (PR comment) | Effect |
|------------------------|--------|
| `accept` / `register` | Merge the PR (line enters the `SOURCE-PROPOSALS.md` registry on `main`), then register the collection: `update-raw.sh`/`.ps1` fetch step, `raw/<Name>/FETCH.md` + `raw/FETCH.md` row, AGENTS.md tier + upstream URL mapping rows (mirror AGENTS.md to `wiki/AGENTS.md`). The next nightly run ingests it. |
| `reject` / `close` | Close the PR and delete the branch with a `rejected` comment. Nothing lands. |
| **`link-only`** | **Accept the resource as a link, not an ingest.** Close the PR and delete the branch with a comment noting the link-only acceptance — do **not** merge it into `SOURCE-PROPOSALS.md`, do **not** register a fetch step, do **not** fetch or ingest it. Add the resource as an entry in `wiki/references.md` (name, upstream URL, one-line purpose) and a matching `wiki/index.md` Meta entry. It then lives in the **Link-only** tier: linkable from wiki pages as a lookup aid, never a citation target for factual claims. |

Link-only rules:

- A `link-only` proposal never appears in `SOURCE-PROPOSALS.md`'s accepted list — it lands in `wiki/references.md` instead. The closed PR is the audit trail.
- Dedup: closed `source/<slug>` branches stay in the PR list, so the nightly scan will not re-propose the same slug. If a link-only source later deserves full ingest, open a fresh proposal (e.g. branch `source/<slug>-ingest`) and `accept` it.
- Link-only entries cite as plain external markdown links (`[Name](https://upstream)`); they never use the `([raw/...](url))` raw-citation form.

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
| Any link to a raw-source document | `[raw/VPX/repo/docs/Script API Reference.md](https://github.com/vpinball/vpinball/blob/master/docs/Script%20API%20Reference.md)` |

- Always use **relative paths** for links between wiki pages.
- **Never** link into local `raw/` paths — raw snapshots are local staging and are not committed, so every citation of a raw file must be a markdown link whose **label** is the human-readable raw path and whose **target** is the upstream URL (see Source Citation below).
- **MUST** URL-encode all spaces as `%20` in link targets (the path part inside `()`).
- **NEVER** use literal spaces in a link target path.
- **Never URL-encode link text** (the label inside `[]`) — it must be human-readable.
  - ✓ `[Script API Reference.md](https://github.com/vpinball/vpinball/blob/master/docs/Script%20API%20Reference.md)`
  - ✗ `[Script API Reference.md](https://github.com/vpinball/vpinball/blob/master/docs/Script API Reference.md)`
  - ✗ `[Script%20API%20Reference.md](https://github.com/vpinball/vpinball/blob/master/docs/Script%20API%20Reference.md)`
- Cross-reference liberally — every concept with its own page should be linked on first mention per section.

### Source Citation

Facts derived from a raw collection cite the raw file path as link text, wrapped in a markdown link to the upstream URL. Plain-text `(raw/...)` citations are written as `([raw/...](https://upstream))`:

```markdown
- POV ranges are per-cabinet ([raw/ExternalWikis/dekay-vpinball-wiki/repo/Additional-Resources.md](https://github.com/dekay/vpinball-wiki/wiki/Additional-Resources), 2026 extraction)
```

Upstream URL mapping per collection (verified against `update-raw.ps1`; branch is `master` everywhere except pinscape-build-guide which is `main`):

| Raw collection | Upstream URL |
|----------------|--------------|
| `raw/B2S/b2s-backglass.wiki/<Stem>.md` | `https://github.com/vpinball/b2s-backglass/wiki/<Stem>` (`Home.md` → wiki root) |
| `raw/DOF/repo/<path>` | `https://github.com/DirectOutput/DirectOutput/blob/master/<path>` (repo root → project page) |
| `raw/VPX/repo/docs/<path>` | `https://github.com/vpinball/vpinball/blob/master/docs/<path>` (`raw/VPX` root → `…/vpinball/tree/master/docs`; the shorthand `raw/VPX docs` maps there too) |
| `raw/FlexDMD/repo/<path>` | `https://github.com/vbousquet/flexdmd/blob/master/<path>`; `docs/media/architecture.svg` → raw.githubusercontent.com |
| `raw/DMD-Extensions/repo/<path>` | `https://github.com/freezy/dmd-extensions/blob/master/<path>` (repo root → project page) |
| `raw/pinscape-build-guide/markdown/<stem>.md` | `https://github.com/concurrent-recursion/pinscape-build-guide/blob/main/book/<stem>.adoc` |
| `raw/PUP/**` | `https://www.nailbuster.com/wikipinup/doku.php?id=start` |
| `raw/SSFImpactor Guide.pdf` | `https://www.mjrnet.org/pinscape/BuildGuideV2/BuildGuide.php?sec=downloads` (ships inside the DOF R3++ Grand Unified Edition zip) |
| `raw/ExternalWikis/dekay-vpinball-wiki/repo/<Stem>.md` | `https://github.com/dekay/vpinball-wiki/wiki/<Stem>` (`Home.md` → wiki root; dekay page titles legitimately use U+2010 hyphens — write them literally in link text, percent-encode as `%E2%80%90` in URLs) |
| `raw/VPinballX-Starter/repo/<path>` | `https://github.com/JockeJarre/VPinballX.starter/blob/main/<path>` (repo root → `…/JockeJarre/VPinballX.starter/tree/main`; commit `sha` → `…/commit/<sha>`) |
| `raw/vpxtool/README.md` | `https://github.com/francisdb/vpxtool/blob/main/README.md` |

- **log.md exemption:** historical `log.md` entries keep their original local `raw/` links as-is (append-only rule). Lint checks and link conversion skip `log.md`.

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


