# Wiki Log

Chronological record of wiki operations.

## [2026-04-13] update | Ingest Pinscape Build Guide and repair stale scoped links

Added Pinscape coverage for the newly mirrored `raw/pinscape-build-guide/repo/book/` source collection and fixed stale concept links left behind by earlier scoped renames:

- Created [Pinscape Controller](projects/Pinscape%20Controller.md) as a new project page covering KL25Z-based inputs, plunger support, nudging, and output control
- Created [Pinscape Build Guide](sources/Pinscape%20Build%20Guide.md) as a new source summary for the 133-file AsciiDoc cabinet-building guide
- Updated [index.md](index.md) and [overview.md](overview.md) to include Pinscape as a first-class project/source and raised raw source coverage from six to seven collections
- Updated [Pincab Setup](concepts/Pincab%20Setup.md), [VPX Plunger Input](concepts/VPX%20Plunger%20Input.md), [VPX Accelerometer Input](concepts/VPX%20Accelerometer%20Input.md), [Open Pinball Device](concepts/Open%20Pinball%20Device.md), and [DOF Output Controllers](concepts/DOF%20Output%20Controllers.md) to connect existing cabinet/input concepts to the Pinscape source material
- Repaired stale internal links in concept pages that still pointed at pre-rename filenames such as `View Setup.md`, `Output Controllers.md`, `Stereo 3D.md`, and `Accelerometer Input.md`

## [2026-04-12] update | Link root README.md files from raw sources

Added proper links to README.md files at the root level of raw source repositories:

- [DOF Documentation](sources/DOF%20Documentation.md): Added [README.md](../../raw/DOF/repo/README.md) to source files table (26 files total, updated from 25)
- Verified other root-level READMEs are properly linked:
  - DMD Extensions: Linked via [README.md](../../raw/DMD-Extensions/repo/README.md) in [DMD Extensions Docs](sources/DMD%20Extensions%20Docs.md) ✓
  - VPX: Linked via [README.md](../../raw/VPX/repo/docs/README.md) in [VPX Docs](sources/VPX%20Docs.md) ✓
  - FlexDMD: Linked via [README.md](../../raw/FlexDMD/repo/docs/README.md) in [FlexDMD Docs](sources/FlexDMD%20Docs.md) ✓
  - B2S: Uses wiki snapshot source, no root README ✓

## [2026-04-12] update | Apply scoped concept titles across wiki

Expanded subsystem-scoped naming beyond initial examples and updated cross-links:

- Renamed concepts to scoped titles:
  - `Accelerometer Input` → [VPX Accelerometer Input](concepts/VPX%20Accelerometer%20Input.md)
  - `Plunger Input` → [VPX Plunger Input](concepts/VPX%20Plunger%20Input.md)
  - `View Setup` → [VPX View Setup](concepts/VPX%20View%20Setup.md)
  - `Lights and Rendering` → [VPX Lights and Rendering](concepts/VPX%20Lights%20and%20Rendering.md)
  - `Stereo 3D` → [VPX Stereo 3D](concepts/VPX%20Stereo%203D.md)
  - `Output Controllers` → [DOF Output Controllers](concepts/DOF%20Output%20Controllers.md)
  - `Plugins` → [B2S Plugins](concepts/B2S%20Plugins.md)
- Updated all inbound links in wiki project/concept/source/index/overview pages to the new filenames
- Updated [projects/Visual Pinball X.md](projects/Visual%20Pinball%20X.md) section headings to `VPX View Setup`, `VPX Lights and Rendering`, and `VPX Stereo 3D`
- Updated [AGENTS.md](../AGENTS.md) concept list and naming rule language to enforce scoped prefixes for ambiguous project-scoped concepts

## [2026-04-12] update | Scope concept names by subsystem

Applied subsystem-scoped naming to avoid ambiguous concept titles:

- Renamed [concepts/Toys and Effects.md](concepts/Toys%20and%20Effects.md) to [concepts/DOF Toys and Effects.md](concepts/DOF%20Toys%20and%20Effects.md)
- Renamed [concepts/Latency.md](concepts/Latency.md) to [concepts/VPX Latency.md](concepts/VPX%20Latency.md)
- Updated inbound links across [index.md](index.md), [overview.md](overview.md), project pages, source pages, and related concept pages
- Updated [projects/Visual Pinball X.md](projects/Visual%20Pinball%20X.md) section heading from `Latency` to `VPX Latency`
- Updated [AGENTS.md](../AGENTS.md) page-structure guidance with scoped-title rule and examples (`DOF ...`, `VPX ...`, `B2S ...`)

## [2026-04-12] update | Rename concept to DOF Table Configuration

Clarified DOF-specific terminology by renaming the generic concept title:

- Renamed concept page from `Table Configuration` to [DOF Table Configuration](concepts/DOF%20Table%20Configuration.md)
- Updated cross-links in [index.md](index.md), [overview.md](overview.md), [projects/DirectOutput Framework.md](projects/DirectOutput%20Framework.md), [sources/DOF Documentation.md](sources/DOF%20Documentation.md), and related concept pages
- Updated [AGENTS.md](../AGENTS.md) with a naming rule requiring scoped titles for project-specific concepts (example: `DOF Table Configuration`)

## [2026-04-12] lint | Replaced all broken raw/ links; added update-raw.ps1

Raw source content had been deleted (only .url shortcut files remained). Fixed all broken links:

- Created `update-raw.ps1` at repo root: sparse-clones upstream repos into `raw/` (depth 1, blobs deferred)
  - B2S wiki → `raw/B2S/b2s-backglass.wiki/` (full clone, wiki is tiny)
  - DOF → `raw/DOF/repo/Documentation/` (sparse, cone mode)
  - FlexDMD → `raw/FlexDMD/repo/docs/` (sparse, cone mode)
  - VPX → `raw/VPX/repo/docs/` (sparse, cone mode)
  - DMD Extensions → `raw/DMD-Extensions/repo/` (sparse, no-cone mode)
- Updated `.gitignore`: added all 5 clone target directories
- Fixed 4 broken `architecture.svg` embeds in `wiki/concepts/DMD.md`, `wiki/projects/FlexDMD.md`, `wiki/projects/DMD Extensions.md`, `wiki/overview.md` → now use `https://raw.githubusercontent.com/vbousquet/flexdmd/master/docs/media/architecture.svg`
- Rewrote source file tables in all 5 source pages to use GitHub upstream URLs instead of local raw/ paths:
  - [sources/B2S Wiki.md](sources/B2S%20Wiki.md) — 27 entries → GitHub wiki page URLs
  - [sources/DOF Documentation.md](sources/DOF%20Documentation.md) — 25 entries → GitHub blob URLs
  - [sources/VPX Docs.md](sources/VPX%20Docs.md) — 23 entries → GitHub blob URLs
  - [sources/FlexDMD Docs.md](sources/FlexDMD%20Docs.md) — 5 entries → GitHub blob URLs
  - [sources/DMD Extensions Docs.md](sources/DMD%20Extensions%20Docs.md) — 6 entries → GitHub blob URLs; added Canonical Upstream section; corrected file count (5→6)

## [2026-04-12] update | Point wiki source links at downloaded raw snapshots

Switched wiki references for downloaded documentation back to local `raw/` content after running `update-raw.ps1`:

- Updated source summaries to link their file tables to the downloaded snapshots instead of GitHub:
  - [sources/B2S Wiki.md](sources/B2S%20Wiki.md)
  - [sources/DOF Documentation.md](sources/DOF%20Documentation.md)
  - [sources/FlexDMD Docs.md](sources/FlexDMD%20Docs.md)
  - [sources/VPX Docs.md](sources/VPX%20Docs.md)
  - [sources/DMD Extensions Docs.md](sources/DMD%20Extensions%20Docs.md)
- Updated the FlexDMD architecture diagram embeds to use the downloaded local asset in:
  - [overview.md](overview.md)
  - [concepts/DMD.md](concepts/DMD.md)
  - [projects/FlexDMD.md](projects/FlexDMD.md)
  - [projects/DMD Extensions.md](projects/DMD%20Extensions.md)
- Left PinUp Popper and other true external references unchanged because they are not downloaded by `update-raw.ps1`

## [2026-04-12] update | Add PinUp Popper HTML mirroring to update-raw.ps1

Extended `update-raw.ps1` to mirror the public PinUp Popper DokuWiki into local HTML snapshots without adding external dependencies:

- Added a bounded crawler that follows internal `doku.php?id=` links and stores pages under `raw/PUP/site/`
- Wrote a local page manifest at `raw/PUP/site/site-index.json`
- Updated `.gitignore` to exclude generated PinUp snapshots
- Updated [sources/PinUp Popper Docs.md](sources/PinUp%20Popper%20Docs.md) and [overview.md](overview.md) to describe the new local snapshot flow

## [2026-04-12] update | Refresh wiki metadata after fresh raw snapshot run

Updated wiki pages to reflect the latest `update-raw.ps1` output:

- Refreshed source counts in [sources/B2S Wiki.md](sources/B2S%20Wiki.md), [sources/DOF Documentation.md](sources/DOF%20Documentation.md), [sources/VPX Docs.md](sources/VPX%20Docs.md), and [sources/PinUp Popper Docs.md](sources/PinUp%20Popper%20Docs.md)
- Updated [index.md](index.md) source summaries to match current snapshot counts (B2S 31, DOF 25, VPX 37, PinUp 78)
- Updated [overview.md](overview.md) Raw Sources section from three collections to six current collections

## [2026-04-12] update | Clarify AGENTS link rules for local raw file paths

Updated [AGENTS.md](../AGENTS.md) link conventions to prevent broken local file links in source pages:

- Kept `%20` encoding requirement for wiki-internal links under `wiki/`
- Added explicit exception for local filesystem links under `raw/`: use literal spaces, not `%20`
- Updated examples and lint checklist to enforce this split rule

## [2026-04-12] update | Restore URL-encoded raw link policy for Obsidian compatibility

Corrected link policy after validation in Obsidian:

- Reverted [AGENTS.md](../AGENTS.md) to require `%20` encoding for spaces in all link targets, including links into `raw/`
- Fixed broken VPX source link in [sources/VPX Docs.md](sources/VPX%20Docs.md): replaced missing `SharedMemoryAPI.txt` target with existing `CommandReference.txt`

## [2026-04-12] update | Added canonical upstream URLs to all source summary pages

Read upstream URLs from raw shortcut files. Added `## Canonical Upstream` sections to:
- [sources/B2S Wiki.md](sources/B2S%20Wiki.md) → https://github.com/vpinball/b2s-backglass/wiki
- [sources/DOF Documentation.md](sources/DOF%20Documentation.md) → https://github.com/DirectOutput/DirectOutput/tree/master/Documentation
- [sources/VPX Docs.md](sources/VPX%20Docs.md) → https://github.com/vpinball/vpinball/tree/master/docs
- [sources/FlexDMD Docs.md](sources/FlexDMD%20Docs.md) → https://github.com/vbousquet/flexdmd/tree/master/docs

Created new source page:
- [sources/PinUp Popper Docs.md](sources/PinUp%20Popper%20Docs.md) → https://www.nailbuster.com/wikipinup/doku.php?id=start

Updated [index.md](index.md) to include PinUp Popper Docs.

## [2026-04-12] lint | Fixed %20 in link texts; added rule to AGENTS.md

Scanned all wiki markdown links. Found 16 links where `%20` appeared in the link text (label) instead of only in the path.
- Fixed 5 links in [sources/DOF Documentation.md](sources/DOF%20Documentation.md)
- Fixed 11 links in [sources/VPX Docs.md](sources/VPX%20Docs.md)

Updated [AGENTS.md](../AGENTS.md):
- Links section: added explicit rule — URL-encode paths, never URL-encode link text, with ✓/✗ examples
- Lint workflow: added step to check this rule on every lint pass

## [2026-04-10] ingest | DMD Extensions documentation (6 files)

Ingested all files from `raw/DMD-Extensions/`. Created:
- Project page: [DMD Extensions](projects/DMD%20Extensions.md)
- Source summary: [DMD Extensions Docs](sources/DMD%20Extensions%20Docs.md)
- Updated [index.md](index.md): added DMD Extensions to Projects and Sources
- Updated [concepts/DMD.md](concepts/DMD.md): added DMD Extensions and FlexDMD to See Also
- Updated [projects/FlexDMD.md](projects/FlexDMD.md): linked DmdDevice.dll reference to DMD Extensions wiki page

## [2026-04-09] ingest | B2S Backglass Server wiki (26 files)

Ingested all markdown files from `raw/B2S/b2s-backglass.wiki/`. Created:
- Project page: [B2S Backglass Server](projects/B2S%20Backglass%20Server.md)
- Concept pages: [Backglass](concepts/Backglass.md), [DMD](concepts/DMD.md), [Screen Configuration](concepts/Screen%20Configuration.md), [B2S Plugins](concepts/B2S%20Plugins.md), [Pincab Setup](concepts/Pincab%20Setup.md)
- Source summary: [B2S Wiki](sources/B2S%20Wiki.md)

## [2026-04-09] ingest | DirectOutput Framework documentation (24 files)

Ingested all markdown files from `raw/DOF/Documentation/`. Created:
- Project page: [DirectOutput Framework](projects/DirectOutput%20Framework.md)
- Concept pages: [DOF Output Controllers](concepts/DOF%20Output%20Controllers.md), [Toys and Effects](concepts/Toys%20and%20Effects.md), [Table Configuration](concepts/Table%20Configuration.md)
- Source summary: [DOF Documentation](sources/DOF%20Documentation.md)

## [2026-04-09] ingest | Visual Pinball X documentation (23 files)

Ingested all files from `raw/VPX/docs/`. Created:
- Project page: [Visual Pinball X](projects/Visual%20Pinball%20X.md)
- Concept pages: [VPX Scripting](concepts/VPX%20Scripting.md), [VPX View Setup](concepts/VPX%20View%20Setup.md), [VPX Lights and Rendering](concepts/VPX%20Lights%20and%20Rendering.md), [VPX Stereo 3D](concepts/VPX%20Stereo%203D.md), [Latency](concepts/Latency.md), [VPX Plunger Input](concepts/VPX%20Plunger%20Input.md), [VPX Accelerometer Input](concepts/VPX%20Accelerometer%20Input.md), [Open Pinball Device](concepts/Open%20Pinball%20Device.md)
- Source summary: [VPX Docs](sources/VPX%20Docs.md)

## [2026-04-09] create | Overview and index

Created [overview.md](overview.md) synthesizing the full virtual pinball ecosystem. Created [index.md](index.md) cataloging all 23 wiki pages. Created [_schema.md](_schema.md) defining wiki conventions.

## [2026-04-10] ingest | FlexDMD documentation (5 files)

Ingested all files from `raw/FlexDMD/docs/`. Created:
- Project page: [FlexDMD](projects/FlexDMD.md)
- Source summary: [FlexDMD Docs](sources/FlexDMD%20Docs.md)
- Updated [index.md](index.md): added FlexDMD to Projects and Sources, fixed stale `_schema.md` Meta link to point to `AGENTS.md`

## [2026-04-10] update | Replaced _schema.md with root AGENTS.md

Deleted `wiki/_schema.md`. Created `AGENTS.md` at repo root with improved visual layout, read-only `raw/` rule prominently stated, and tables for all conventions. Auto-loaded by GitHub Copilot as workspace instructions.

## [2026-04-10] update | Link maintenance and schema cleanup

Validated and fixed wiki link consistency after content edits:
- Corrected raw source link paths in [sources/B2S Wiki.md](sources/B2S%20Wiki.md), [sources/DOF Documentation.md](sources/DOF%20Documentation.md), and [sources/VPX Docs.md](sources/VPX%20Docs.md) to use the correct `../../raw/...` relative base from `wiki/sources/`
- Updated [_schema.md](_schema.md) examples and guidance to clarify relative-path rules for raw links and to avoid lint false positives from example links
- Re-ran markdown link lint to verify no broken links and no unencoded-space filenames in internal links


