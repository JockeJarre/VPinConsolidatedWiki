# Wiki Log

Chronological record of wiki operations.

## [2026-11-03] update | raw/ framing clarified in AGENTS.md + raw/FETCH.md

Per user: `raw/` mainly holds the **official documentation of each tool's vendor/author** (Primary tier); `raw/ExternalWikis/` holds the **two external community wikis used to fill gaps** (Secondary tier). Framing added to the AGENTS.md raw-layout tree and the root `raw/FETCH.md` intro; no content or tier rules changed (consistent with the existing Source Priority table).

## [2026-11-03] update | FETCH.md fit-check after ExternalWikis restructure

Verified every `raw/**/FETCH.md` against actual staging content after dekay-vpinball-wiki and vpw-wiki moved to `raw/ExternalWikis/<name>/repo/`; fixed all drift:

- **Scripts**: `update-raw.ps1` + `update-raw.sh` dekay/vpw clone targets, DESCRIPTION, and final path lists retargeted to the new `raw/ExternalWikis/...` locations (ps1 tokenizes clean; sh `bash -n` clean)
- **FETCH.md fixes**: ExternalWikis clone/refresh commands updated to new paths; vpw tables count 83→84 (incl. index.md); DOF `Documentation` count ~25→~102 files; VPX docs count ~37→~78 files; FlexDMD docs clarified as 4 `.md` + svg + 2 PNGs; PUP page examples corrected to real filenames (79 html, not ~78; `popper.html`/`pinup_display.html` do not exist); root FETCH.md folder rows moved under `ExternalWikis/` plus an SSFImpactor provenance note (file currently absent from staging)
- **Verified matching**: B2S 31 pages, dekay 48 `.md`, pinscape 133 `.adoc` = 133 `.md`, DMD-Extensions README + LibDmd + PinMameDevice + Console/Server + ProPinballBridge, vpw manifest (108 extractions, 3136 nuggets, 2026-02-12)
- **AGENTS.md**: raw layout tree, Source Priority rows, conflict-note example, citation example, and upstream URL mapping rows updated to the new paths
- **Wiki sweep**: 134 citation-label replacements across 44 pages (`raw/dekay-vpinball-wiki/` → `raw/ExternalWikis/dekay-vpinball-wiki/repo/`, `raw/vpw-wiki/` → `raw/ExternalWikis/vpw-wiki/repo/`); log.md exempt (append-only); lint re-run clean

## [2026-11-03] query | PUP videos in VPX 10.8.1 with the legacy file structure

Answered how PUP videos configure under 10.8.1 with the old global (Baller-era) layout: PinUp Player's global `C:\PinUpSystem\PuPVideos\<rom>` pack folder (unaffected by the layout change), the beside-`.vpx` search resolving to a global `C:\pinball\tables\pupvideos\`, option `.bat` files, the B2S-plugin/Freezy integration stack, directb2s 6-character prefix conflicts, and per-pack `PinUPPlayer.ini` overrides.

- Sources: raw/PUP/site/puppack_troubleshoot.html, pinup_player_tables.html, pinup_pack_layout.html, pup_capture.html ([wikipinup](https://www.nailbuster.com/wikipinup/doku.php?id=start)); dekay PUP-Packs.md / File-Layout.md
- Filed as new §Placement in the Legacy (Baller-Era) Layout in [PuP Packs](concepts/PuP%20Packs.md); cross-linked from [VPX File Layout](concepts/VPX%20File%20Layout.md) §Legacy Global Layout

## [2026-11-01] lint | Upstream link conversion scan

Converted every wiki citation of a `raw/` snapshot into a markdown link to its **upstream URL** (raw/ is local staging, never committed), then scanned all links.

- 113 markdown links and ~150 plain-text `(raw/...)` citations retargeted across all wiki pages via an idempotent script; mapping verified against `update-raw.ps1` (B2S/VPX/DOF/FlexDMD/DMD-Extensions GitHub repos, pinscape `main`-branch `.adoc` book, nailbuster wiki, mjrnet.org, dekay GitHub wiki, vpw-wiki.skirmishofwit.com)
- Fixed 5 double-wrapped links (doubled `\[...](url)](url)` wrappers) in VPX File Layout, VPX Stereo 3D, Visual Pinball X; added a dedupe guard to the conversion script
- Spot-checked live: dekay U+2010 page URL (`PAL-%E2%80%90-4-Colors`) and VPW guide URL resolve correctly
- Extended the lint script with a **local-raw-link** check (log.md exempt); full scan: 0 violations, 0 unencoded spaces, 0 `%20` in link texts, 0 placeholder targets, no orphan pages
- Remaining 11 findings are the same historical [log.md](log.md) entries previously allowed; untouched per the append-only rule

## [2026-11-01] ingest | VPW Knowledge Base (108 extractions, secondary source)

Ingested `raw/vpw-wiki/` (Virtual Pinball Workshop Discord knowledge base, https://vpw-wiki.skirmishofwit.com/, knowledge extracted Mar 2026) — second **secondary-priority** collection; focus is **table authoring**.

- Created [VPW Knowledge Base](sources/VPW%20Knowledge%20Base.md) source page with the Secondary-priority callout, full 83-table catalog (tables are case studies; guides are the knowledge tier), and errata (index count drift 81/88 vs real 83/108; theatre-of-magic mislabel; superseded cirqus-voltaire trigger margin)
- Created 17 new concept pages from the 13 guides + 5 references: VPX 3D Art Pipeline, VPX Authoring Best Practices, VPX Authoring Tools, VPX Example Table, VPX Game Rules Design, VPX GI and Flashers, VPX Insert Lighting, VPX Light State Controller, VPX Physics Tuning, VPX Playfield Scanning, VPX Scripting Patterns, VPX Software Setup, VPX Table Build Workflow, VPX Table Troubleshooting, VPX Transparent Elements, VPX VR Authoring, Fleep Sound Packages
- Swept facts into existing pages: Visual Pinball X, VPX Scripting, VPX Lights and Rendering, VPX Standalone (gBOT→GetBalls ~95% standalone segfaults; FlexDMD `On Error Resume Next` guard), FlexDMD (new §Script Detection and Portability), VPX Latency (KL25Z ~20ms vs PS/2 hack 5–8ms, 16.7ms frame floor, sosramp, PinAffinity), VPX View Setup (POV conflict note; Anti Ball Stretch aspect-ratio tip), Pincab Setup (DOF `DOFPulse` solenoid safety, 10.8.1 native tilt, analog plunger seat bug), VPX VR Setup (`VRRoom` 0/1/2 stutter isolation)
- Updated [index.md](index.md) (all new pages, VPW source entry marked `(secondary source)`), [overview.md](overview.md) (ten collections, authoring section), and `AGENTS.md` (raw layout, Source Citation convention with the upstream-URL mapping table, log.md exemption)

## [2026-11-01] lint | Link scan after dekay wiki ingest

Scanned all wiki markdown links for missing targets, unencoded spaces in targets, and `%20` in link text.

- Fixed 4 project-page links in [PinUp Player](projects/PinUp%20Player.md) missing the `../concepts/` prefix (`Pincab Setup.md`, `PuP Packs.md` ×3)
- Remaining 11 findings are the same historical [log.md](log.md) entries previously allowed (pre-rename filenames, superseded `_schema.md`, raw README links recorded at 2026-04-12 depths); untouched per the append-only rule
- No unencoded spaces; no `%20` in link texts; plain-text raw citations use the exact U+2010 filenames where applicable

## [2026-11-01] ingest | Unofficial Visual Pinball Wiki (48 files, secondary source)

Ingested `raw/dekay-vpinball-wiki/` (mirror of the Unofficial Visual Pinball Wiki, github.com/dekay/vpinball-wiki) — the first **secondary-priority** collection: primary sources win conflicts; disagreements are recorded as `⚠️ CONFLICT (secondary source)` notes.

- Created [Unofficial Visual Pinball Wiki](sources/Unofficial%20Visual%20Pinball%20Wiki.md) source page with the Secondary-priority callout, coverage table, key facts, and open-conflicts list
- Created 11 new pages from the extraction sweep:
  - [VPX File Layout](concepts/VPX%20File%20Layout.md) — per-table 10.8.1 layout, three-part structure, `.vpx`/`.vpz`/`.vpxz`, companion-file search priority, legacy Baller-era notes
  - [Altcolor](concepts/Altcolor.md) — PAL/patched-ROM/VNI/PAC/Serum format ladder, `.crz`→`.cromc` auto-migration
  - [DOF Addressable LEDs](concepts/DOF%20Addressable%20LEDs.md) — Wemos/Teensy controllers, wiring, ini files, HD/SD matrices, cross-platform serial quirks
  - [VPX Standalone](concepts/VPX%20Standalone.md) — cross-platform architecture (POLE, Wine-vbscript, BGFX, SDL3), input mapping, mobile specifics, Batocera
  - [PinUp Player](projects/PinUp%20Player.md) — pack file anatomy, screen IDs, SendMSG mt:301 API, standalone gaps
  - [PuP Packs](concepts/PuP%20Packs.md) — installation mechanics, dated reconciliation of "do not work" vs Rev 4837+ VR-table display injection
  - [VPinFE](projects/VPinFE.md) — cross-platform frontend, VPS-ID matching workflow, Linux window-title integration
  - [Pinscape Pico](concepts/Pinscape%20Pico.md) — gamepad/xInput/OPD interfaces, canonical 10.8.1 mapping table, KL25Z notes
  - [VPX Debugging](concepts/VPX%20Debugging.md) — git bisect, debug builds, Renderdoc, crash-report protocol, NVRAM/font repairs
  - [VPX ScoreView Plugin](concepts/VPX%20ScoreView%20Plugin.md) — activation, form factors, `.scv` layout format
  - [VPX VR Setup](concepts/VPX%20VR%20Setup.md) — per-table VR rooms, OpenComposite, ASW disable, ROM chores
- Swept existing pages with conflict notes and additions: [Visual Pinball X](projects/Visual%20Pinball%20X.md) (DX9 go-to, Standalone scope, ini-vs-registry era), [VPX Stereo 3D](concepts/VPX%20Stereo%203D.md) (VR OpenXR dated snapshot), [VPX Latency](concepts/VPX%20Latency.md) (VisualLatencyCorrection default, SyncMode/BGFX 0-1, registry-era framing), [Open Pinball Device](concepts/Open%20Pinball%20Device.md) (Pico OPD broken Linux #3303), [VPX Plunger Input](concepts/VPX%20Plunger%20Input.md) (`plunger.z0`, #4055 workaround), [VPX Accelerometer Input](concepts/VPX%20Accelerometer%20Input.md) (rx/ry-vs-x/y axis conventions), [Pinscape Controller](projects/Pinscape%20Controller.md) (USB-C KL25Z no accelerometer, 10 s disconnect reboot), [DirectOutput Framework](projects/DirectOutput%20Framework.md) (built-in 10.8.1 DOF plugin + config paths, GlobalConfig dual spelling, per-device ini numbering), [DOF Output Controllers](concepts/DOF%20Output%20Controllers.md) (Vroonsh 2100-LED fork, Art-Net ESP8266 note, ini-numbering table), [DMD](concepts/DMD.md) (LED-grid vs plasma claim, 8-alpha/7-DMD display profiles, unlit-color recipes), [Screen Configuration](concepts/Screen%20Configuration.md) (Linux window-rule scope note)
- Cross-linked [Pincab Setup](concepts/Pincab%20Setup.md) and [overview.md](overview.md); raw source collections raised from eight to nine
- [index.md](index.md) updated with 11 concept/project entries plus the source entry marked `(secondary source)`
- Notes: five raw filenames use U+2010 hyphens (DOF, PAC, PAL-4-Colors, PINPAD, Standalone-VR) — plain-text citations use the exact characters; Vroonsh 2100-LED and `.pak` claims verified present/absent against raw before filing

## [2026-11-01] lint | Link scan after SSFImpactor ingest

Scanned all wiki markdown links for missing targets, unencoded spaces in targets, and `%20` in link text.

- Fixed broken raw link in [DMD Extensions](projects/DMD%20Extensions.md): PinballFX_IDs reference was missing the `repo/` path segment
- Remaining 11 findings are all inside historical [log.md](log.md) entries (pre-rename filenames, superseded `_schema.md`, raw README links recorded at 2026-04-12 depths); left untouched per the append-only rule
- No unencoded spaces; no `%20` in link texts

## [2026-11-01] ingest | SSFImpactor Guide (1 PDF)

Ingested `raw/SSFImpactor Guide.pdf` (Rev 1.1, March 2019), the user guide for the SSFImpactor software force-feedback controller:

- Created [SSFImpactor](projects/SSFImpactor.md) as a new project page: software LEDWiz-alike DOF controller, 15 fixed output ports, Cabinet.xml `<SSFImpactController>` tuning, BASS audio routing, LedWizEquivalent integration, reference cabinet
- Created [SSFImpactor Guide](sources/SSFImpactor%20Guide.md) source summary with key facts and quotes
- Updated [DOF Output Controllers](concepts/DOF%20Output%20Controllers.md) with SSFImpactor as the software controller (table row + section)
- Updated [DOF Toys and Effects](concepts/DOF%20Toys%20and%20Effects.md) with the canonical LedWizEquivalent mapping example
- Updated [DirectOutput Framework](projects/DirectOutput%20Framework.md): SSFImpactor ships in DOF R3++ Grand Unified Edition
- Updated [Pincab Setup](concepts/Pincab%20Setup.md) Hardware Feedback and Audio sections (exciters, SSF routing warning)
- Updated [index.md](index.md) and [overview.md](overview.md); raw source collections raised from seven to eight
- Open question: guide is community-distributed (SSF Facebook group / VPinball forum); no canonical upstream URL recorded. Related to Pinscape-hosted DOF installer — cross-referenced from Pinscape Controller's resources site mention

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



## [2026-11-04] ingest | Visual Pinball X documentation (late-2026 10.8.1 stream refresh)
- Scope: upstream docs moved since 2026-04-09 ingest (clone is depth-1; upstream diff taken via GitHub API since 2026-04-12)
- New material filed: VPZ table pack format (preliminary), unified Mobile.md guide (App Store/Google Play/Quest), B2SLegacy plugin removal, Opus audio, ScoreView→Nixie rename (.nix layouts), VPinMAME system scripts 3.62 (spike1/tecnoplay/wpc_ph/p2k/pinheck/playbar; F4/F5/F6/F12 keys → in-game UI table options; cvpmTimer fixes), Wasm builds, VideoCap deprecation
- Pages updated: sources/VPX Docs.md (counts, 4 new file rows, Late-2026 Changes), projects/Visual Pinball X.md (new section), concepts/VPX File Layout.md (VPZ primary citation, .nix tree line), concepts/VPX Scripting.md (Opus, System Script Updates 3.62), concepts/VPX Scripting Patterns.md (cvpmTimer note on vpmTimer.Add stance)

## [2026-11-04] update | Renamed concept VPX ScoreView Plugin → VPX Nixie Plugin (upstream rename, Oct 2026)
- Page rewritten with rename note + primary/secondary conflict note (.scv/ScoreView vs .nix/Nixie); fixed unclosed-paren citation link from old page
- Inbound links updated: index.md, overview.md, concepts/DMD.md, concepts/VPX File Layout.md, concepts/PuP Packs.md, sources/Unofficial Visual Pinball Wiki.md

## [2026-11-04] ingest | DMD Extensions documentation (late-2026 refresh)
- Bundled libserum 2.8.2 (commit 9387c66), PinMameDevice DmdDevice.ini + PinballFX_IDs refresh (Jun 2026)
- Flagged: cross-platform LibDmd.Core / FSQ decoding / native packaging work is outside fetched docs folders — not filed as features
- Pages updated: sources/DMD Extensions Docs.md, projects/DMD Extensions.md

## [2026-11-04] update | Nightly refresh sweep — collections reviewed, no change filed
- DOF (HEAD 2025-10-02), B2S wiki (HEAD 2026-02-14, predates ingest), FlexDMD (HEAD 2024-03-10), Pinscape Build Guide (HEAD 2023-11-09): no upstream movement since last ingest
- VPW Knowledge Base: HEAD 038f6fe (v3 re-extraction) already ingested 2026-11-01; structure verified (13 guides / 83+index tables / 5 references) — skipped
- Unofficial Visual Pinball Wiki (dekay): single commit since last ingest (c323972, correct vpxtool optimize --mono flag in Table-Fixes page); claim not filed on any wiki page — no update needed
- PUP mirror re-crawled (update-raw.sh --pup): content stable, page count 78 → 80; sources/PinUp Popper Docs.md and index.md counts updated

## [2026-11-04] lint | Link scan after nightly ingest
- Full scan of wiki (log.md exempt): 0 targets with literal spaces, 0 %20 in link labels, 0 local raw/ targets, 0 broken relative links — clean

## [2026-11-04] ingest | Unofficial Visual Pinball Wiki (dekay) — vpxtool optimize refresh
- Upstream HEAD c323972 (2026-11-03, "Correct vpxtool --mono flag"): Table-Fixes-&-Performance-Optimizations.md now documents `vpxtool optimize --mono --flac` (mono playfield audio is lossless-safe in VPX 10.8.1+; backglass stereo preserved) and `--max-image-size=768`
- Filed in concepts/VPX Debugging.md (§Table-Level Repair) and linked from concepts/VPX Standalone.md (§Community Tools); sources/Unofficial Visual Pinball Wiki.md Key Facts updated
- Supersedes the prior "no update needed" review note for this commit; index.md summaries unchanged

## [2026-11-04] lint | Site link fix: index.md AGENTS.md link retargeted to docs-root copy (mkdocs build); log.md historical links left exempt

## [2026-11-04] update | Site imagery: VPX logo as site header icon + favicon (gen-nav theme), hero logo on overview; diagrams added to VPX Latency, VPX View Setup, FlexDMD, VPX Lights and Rendering from raw VPX/FlexDMD docs (copied to wiki/assets/)

## [2026-11-04] ingest | vpxtool README (raw/vpxtool/) — new Primary source
- Registered collection: single-file README fetch in update-raw.sh/.ps1, FETCH.md, manifest fingerprint, AGENTS.md tier+URL mapping
- Created [projects/Vpxtool.md] usage page (CLI surface, selective extract, table packs, verify/audit, optimize flags incl. --opus, scores, frontend, TOML config, vpxz_excludes); Building section excluded per scope
- Created [sources/Vpxtool README.md]; linked from VPX Debugging, VPX Standalone, VPX Authoring Tools, VPX File Layout; index updated

## [2026-11-04] ingest | VPinballX Starter (raw/VPinballX-Starter/) — new Primary source
- Registered collection: full clone depth 100 (commit history is source material) in update-raw.sh/.ps1, FETCH.md, manifest git_head, AGENTS.md tier+URL mapping
- Created [projects/VPinballX Starter.md]: version routing, ini reference, keyboard-state switching, pre/post cmd files, plus "Changelog — Commit Messages Not Yet in the Documentation" filing 13 upstream commits whose behavior the README never documented
- Created [sources/VPinballX Starter.md]; index updated

## [2026-11-04] update | Favicon switched to the VPX editor ball icon (src/ui/win/res/ball.ico from vpinball master, multi-size 16-256px) — copied to wiki/assets/VPX Ball.ico; header wordmark logo kept

## [2026-11-04] update | Nightly pipeline: new-source proposals — pi appends strict [NEW-SOURCE] lines to SOURCE-PROPOSALS.md (registry of accepted proposals, bootstrapped); nightly.sh 4b files ONE branch+PR per proposal (source/<slug>, no auto-merge, per-proposal accept/reject); metrics + manifest now track prop rc

## [2026-11-04] update | Source removed: VPW Knowledge Base deregistered from pipeline; references stripped from 31 pages (14 edited, 17 VPW-derived concept pages deleted); source page deleted

## [2026-11-06] ingest | Unofficial Visual Pinball Wiki (dekay) — Pinscape guide Nudge & Plunger setup/settings split (upstream 2026-11-05)
- Pico LiveUI guidance extended in [Pinscape Pico](concepts/Pinscape%20Pico.md): Nudge Sensor Type (Cabinet Sensor vs Intent Sensor), Cabinet Weight visibility, 2 Gravity / 0.2048 m/s / 12.5 p.u/s sensor units, separate-axis rule, empty-dropdown = sensor unrecognized, graph-based swap verification
- Source page note added in [Unofficial Visual Pinball Wiki](sources/Unofficial%20Visual%20Pinball%20Wiki.md)
- Collections checked, no actionable doc changes: VPX (commit 2026-11-06 "Spatial audio: all emitters are mono points" is code-only, no docs/ delta), DOF, B2S, FlexDMD, DMD-Extensions, VPinballX-Starter, pinscape-build-guide, PUP

## [2026-11-07] ingest | VPX docs (Primary, upstream 2026-11-06 "VR: better positionning, UI, and docs") — docs/VR.md added: OpenXR 4-space-reference scene model, room/lockbar positioning parameter model + full PlayerVR.* settings reference, in-play view nudge / Align VR view / controller recentering, seated tilt & feet-to-ground, colorkeyed AR passthrough (10.8.1 Beta); filed into VPX VR Setup (primary sections), source page + index updated (40 top-level doc files)

## [2026-11-07] ingest | Unofficial Visual Pinball Wiki (dekay, secondary, upstream 2026-11-06 "Reorg plus new Sub & SSF Link") — 2 new pages (50 total): Sound.md (missing PinMAME table sound from split-set clone ROMs lacking sampled audio; parent-ROM / merged-zip / global-dir fixes; vpinball.log "SOUND WAS DISABLED" diagnosis) filed into VPX Debugging; Subs-and-SSF.md is an empty scaffold — recorded as not-citable in the source page, cross-linked from SSFImpactor

## [2026-11-07] update | Unofficial Visual Pinball Wiki (dekay, secondary, upstream 2026-11-06 "No AI kthxbye") — provenance note added to the source page: upstream Contribution-Guidelines now bans AI-written contributions (collection is human-authored community experience); no filed-page content impact

## [2026-11-06] create | References page: link-only external resources channel; first entry Virtual Pinball Spreadsheet (https://virtualpinballspreadsheet.github.io/), accepted from proposal #8 as linked reference without raw registration

## [2026-11-08] ingest | Unofficial Visual Pinball Wiki (dekay, secondary, upstream 2026-11-07 "Stuck on 10.8.0") — Baller Installer version pinning (bundles stable releases e.g. 10.8.0, does not track 10.8.1 dev builds), Windows.md in-source staleness flag (10.8.0-based), FAQ note that the 10.8.0 Windows build supports single-directory file layout only; filed into VPX File Layout §Legacy Global Layout, Visual Pinball X §Settings, source page Key Facts; page count unchanged (50)
- Collections checked, no actionable doc changes: VPX (commit 2026-11-07 "Fix bad AA factor creating visible seams" is renderer code-only, no docs/ delta; snapshot file counts match the source page), PUP (re-crawl page list unchanged, 80 pages + index; fingerprint drift only, newest upstream page save 2026-10-05), DOF, B2S, FlexDMD, DMD-Extensions, VPinballX-Starter, pinscape-build-guide, vpxtool README (md5 unchanged)

## [2026-11-14] ingest | Visual Pinball X docs (Primary, upstream 2026-11-13/14 Changelog.txt deltas) — per-table **Physics Profile** option (default 10.8; new tables 10.9) documented in the changelog: the 10.9 profile's gate model (trigger-zone collider tracking the actual moving wire/plate between angle limits, replacing static line segments) and exact sloped-quad ramp side walls (fixes ball escapes through steep-ramp dead zones and phantom hits under raised parts); filed into Visual Pinball X §Late-2026 Upstream Changes + sources/VPX Docs §Late-2026 Changes; docs/ file count unchanged (40)
- Unofficial Visual Pinball Wiki (dekay, secondary, upstream 2026-11-10..12) — Pinscape guide §Nudge & Plunger: **openpindev status rewritten as a dated timeline** (Pico `openpindev` in 10.8.1+ broken on Windows before 2026-07-24 and on Linux/Mac before 2026-11-09; fixed in newer builds, now **recommended over gamepad/xinput** for performance, superseding the vpinball #3303 "broken on Linux" warning; guide's JSON examples remain gamepad-based and are flagged in-source as needing an openpindev update); velocity-over-USB support confirmed for the **Arnoz Dudescab** (PinOne: leave velocity sensors unmapped); Sound.md §Volume Adjustment via the LiveUI expanded from TODO (per-source gain on the F12 LiveUI Audio Settings page); File-Layout.md in-source staleness flag for the new PinMAME `memmaps`/`gamedefs` folders. Filed into Pinscape Pico §Device Interfaces + §VPX LiveUI Settings, Open Pinball Device §Supported Devices (conflict entry re-dated), VPX Debugging §Table-Level Repair, VPX File Layout, source page Key Facts + Conflicts; PINPAD Discord-handle typo and `--max-image-size` wording clarification not filed (trivial); page count unchanged (50)
- DMD Extensions (Primary, upstream 2026-11-12 build-nuget/README.md) — new `LibDmd.Core.Unity` NuGet package (Windows + SDL display backends, Unity `System.IO.Ports.dll` shim under `unity/managed/`), `LibDmd.Core.Native.win-x64` payload widened (Serum/ZeDMD/USB support DLLs incl. `libserialport.dll`), `core-v*` publishes moved to NuGet Trusted Publishing; recorded in sources/DMD Extensions Docs.md as developer-facing packaging (no end-user feature change; project page untouched)
- Collections checked, no actionable doc changes: PUP (page list unchanged, 80 pages + index), DOF (HEAD 2025-10-02), B2S (HEAD 2026-02-14), FlexDMD (HEAD 2024-03-10), pinscape-build-guide (HEAD 2023-11-09), VPinballX-Starter (HEAD 2026-09-23), vpxtool README (md5 9ba29f98… unchanged); SSFImpactor Guide.pdf still absent from local staging (manual fetch)
- New-source proposals: none appended — the sources surfaced by this run (Pinscape Pico JSON config reference, PinMAME/VPinMAME, libserum, Arnoz Dudescab) are all already covered by existing `source/<slug>` proposal branches
