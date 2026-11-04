# Vpxtool

**vpxtool** (francisdb) is a cross-platform command-line utility for the Visual Pinball ecosystem: table inspection, extraction/assembly, verification, size optimization, a text-UI frontend, and mobile export — all from the terminal. This page covers its usage; building vpxtool from source is out of wiki scope. Source: ([raw/vpxtool/README.md](https://github.com/francisdb/vpxtool/blob/main/README.md))

## Installation

- **Release binaries**: download for your OS from the [releases page](https://github.com/francisdb/vpxtool/releases), extract, optionally symlink into `$HOME/bin` ([raw/vpxtool/README.md](https://github.com/francisdb/vpxtool/blob/main/README.md))
- **macOS**: after extracting, remove the quarantine flag — `System Settings → Privacy & Security → Allow Anyway`, or `xattr -d com.apple.quarantine vpxtool`
- **Homebrew**: community tap `gitfool/homebrew-vpinball`
- **cargo**: `cargo install vpxtool`

Verbosity: `-v` flag, or `RUST_LOG=debug` environment variable.

## Command Overview

`vpxtool --help` lists all subcommands (v0.35.x). Grouped by purpose:

| Area | Commands |
|------|----------|
| Inspect | `info`, `ls` (file contents), `romname` (PinMAME ROM), `dipswitches`, `nvram`, `scores`, `collections`, `materials`, `gameitems`, `gamedata` |
| Extract / assemble | `extract`, `extractvbs`, `importvbs`, `assemble`, `convert` (vpx ⇄ table pack), `export` (obj/gltf/glb, `.vpxz` mobile archive) |
| Quality | `verify` (MAC signature), `audit` (consistency report), `optimize` (shrink & repair), `images`, `sounds` |
| Locking | `lock`, `unlock`, `lock-status` — prevent edits in VPX |
| Launch | `frontend` (text UI), `index`, `capture` (playfield screenshot via vpinball) |
| Scripts / authoring | `script`, `diff` (script vs sidecar `.vbs`), `new` (minimal empty table), `patch` (VPURemix System patch) |
| Config | `config` (vpxtool config file) |

## Extracting Parts of a Table

`extract` writes the table as a directory of JSON, script, image, sound and mesh files. Filter with `--only` on paths as printed by `ls` (relative to the output directory; `*` does not cross a directory separator):

```shell
vpxtool extract --only gamedata.json table.vpx
vpxtool extract --only script.vbs --only 'gameitems/*.json' table.vpx
vpxtool extract --no-media table.vpx     # everything except images/sounds
```

Filtered-out files are not produced at all — extracting only JSON from a large table takes milliseconds. A partial directory cannot be assembled back into a table ([raw/vpxtool/README.md](https://github.com/francisdb/vpxtool/blob/main/README.md)).

## Table Packs

VPX can store a table as a *pack*: JSON documents plus assets in their own formats, as a `.vpz` zip archive or a folder. `convert` turns a `.vpx` into a pack and back (output kind follows the target name: `.vpx` → vpx file, `.vpz` → zip, otherwise folder). `audit` and `info show` accept packs; the frontend indexes and launches packs too ([raw/vpxtool/README.md](https://github.com/francisdb/vpxtool/blob/main/README.md)).

```shell
vpxtool convert table.vpx              # -> table.vpz
vpxtool convert table.vpz "Table 1.5"  # -> a pack folder
vpxtool convert "Table 1.5"            # -> Table 1.5.vpx
```

## Verifying and Auditing

- `verify` checks the MAC signature VPX stores in a table against its content; `--json` prints stored vs computed MAC per file for scripting
- `audit` reports consistency problems — the same findings `optimize` acts on, plus everything else it checks

## Shrinking a Table (`optimize`)

`optimize` applies the lossless fixes from the `vpin` library and rewrites the table in one go: unused embedded fonts are dropped; bitmap/png/tga images are re-encoded as lossless webp where smaller; images handed to [FlexDMD](../projects/FlexDMD.md) are left alone; sounds with the legacy `* Backglass Output *` path (which VPX 10.8.1 fails to load) get the sound name as `.wav` path. It prints what changed with bytes saved; `--dry-run` reports without writing ([raw/vpxtool/README.md](https://github.com/francisdb/vpxtool/blob/main/README.md)).

| Flag | Effect |
|------|--------|
| *(none)* | Lossless fixes + file compaction |
| `--mono` | Downmix stereo playfield sounds to mono exactly as VPX 10.8.1+ does internally. Opt-in: VPX 10.8.0 plays stereo in its two-speaker mode |
| `--flac` | Re-encode PCM WAV as lossless FLAC. Opt-in: VPX 10.8.0 does not decode FLAC |
| `--opus` | Re-encode lossless sounds as Ogg Opus (≤64 kb/s mono, ≤96 kb/s stereo). Lossy but transparent; only VPX builds after [vpinball/vpinball#4315](https://github.com/vpinball/vpinball/pull/4315) play Opus — every earlier version plays the table **without those sounds**. Keep originals (`--backup`) |
| `--max-image-size[=N]` | Scale images with a side over N pixels (default 1536 = VPX mobile "Maximum texture dimension"). Lossy (jpeg re-encoded); FlexDMD-drawn images, color-grade LUTs and images that would not shrink are left alone and reported |
| `--backup` | Keep the original file |

See [VPX Debugging](../concepts/VPX%20Debugging.md) §Table-Level Repair for the pincab-side guidance on `--mono`/`--flac`/`--max-image-size`.

## High Scores

```shell
vpxtool scores show /path/to/table.vpx
```

Works with PinMAME tables (resolved through pinmame-nvram maps) and rom-less tables backed by `VPReg.ini`, GLF `<cGameName>_glf.ini` sidecars, or Black's-style `user/*.txt` EM high-score files. `--format tsv` for scripting, `--format pinemhi` for a PINemHi-like layout ([raw/vpxtool/README.md](https://github.com/francisdb/vpxtool/blob/main/README.md)).

## Text-UI Frontend

`vpxtool frontend` indexes a directory of `.vpx` files (and packs) and presents a menu that launches VPX. The menu only offers actions that do not read the vpx file itself for packs. Every launch is appended to a play log in the platform data directory (`~/.local/share/vpxtool/play_log.jsonl` on Linux); "Recently played" and "Most played" menu entries are built from it — runs shorter than 30 seconds are logged but do not count as a play.

## Configuration

TOML config storing the VPX executable location and more; first frontend launch walks through setup. Locations: Linux `$XDG_CONFIG_HOME/vpxtool/vpxtool.cfg` (or `$HOME/.config/...`), macOS `$HOME/Library/Application Support/vpxtool/vpxtool.cfg`, Windows `...\AppData\Roaming\vpxtool\vpxtool.cfg`. Inspect with `vpxtool config path`, edit with `vpxtool config edit` ([raw/vpxtool/README.md](https://github.com/francisdb/vpxtool/blob/main/README.md)).

```toml
vpx_executable = "/home/myuser/vpinball/VPinballX_BGFX"
tables_folder = "/home/myuser/vpinball/tables"
vpx_config = "/home/myuser/.local/share/VPinballX/10.8/VPinballX.ini"
tables_scan_max_depth = 3
```

- **Launch templates** — `[[launch_templates]]` entries (name, executable, extra env, own `vpinball_config`) appear on top of the frontend table menu. Force fullscreen/windowed by pointing a template at a separate VPX ini with `FullScreen`/`PlayfieldFullScreen` overridden — the old `-EnableTrueFullscreen` CLI flags are deprecated upstream and absent in modern BGFX builds
- **Custom diff / editor** — `diff = "/path/to/mydiff"`, `editor = "code"` override system defaults for `diff` and edit actions
- **`vpxz_excludes`** — patterns dropped from `vpxtool export vpxz` (the mobile bundle): by default other `.vpx` files and their sidecars, mismatched-stem `.directb2s`, previous `.vpxz`; built-in defaults also drop `Downloads/`, `cache/`, `Thumbs.db`, `.DS_Store`, `*.bak`, `*~`. Setting the key replaces the defaults entirely ([raw/vpxtool/README.md](https://github.com/francisdb/vpxtool/blob/main/README.md))

## Related Projects

Used by: [vpx-editor](https://github.com/jsm174/vpx-editor), [vpin-studio](https://github.com/syd711/vpin-studio), [docker-vpxtool-resize](https://github.com/jsm174/docker-vpxtool-resize), [vpx-gui-tools](https://github.com/surtarso/vpx-gui-tools). Related readers/assembly tools: vpx-js (vpdb), ClrVpin, [freezy/dmd-extensions](../projects/DMD Extensions.md), vpx_lightmapper ([raw/vpxtool/README.md](https://github.com/francisdb/vpxtool/blob/main/README.md)).

## See Also

- [VPX Debugging](../concepts/VPX%20Debugging.md) — `optimize` flags in pincab practice
- [VPX Standalone](../concepts/VPX%20Standalone.md) — vpxtool in the headless toolchain
- [VPX File Layout](../concepts/VPX%20File%20Layout.md) — sidecars and formats vpxtool operates on
- [Source: Vpxtool README](../sources/Vpxtool%20README.md)
