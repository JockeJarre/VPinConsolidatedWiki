# VPinballX Starter

**VPinballX.starter** (JockeJarre — the wiki owner's own tool) is a small Windows launcher that starts the *right* Visual Pinball X version for each table: it reads the version stored in the `.vpx` file, looks up the configured executable, and relaunches with the original parameters unchanged. Renamed to `VPinballX.exe`, it transparently replaces the simulator in any frontend ([raw/VPinballX-Starter/repo/README.md](https://github.com/JockeJarre/VPinballX.starter/blob/main/README.md)).

## How It Works

1. Started with exactly the same parameters as `VPinballX.exe`
2. Loads the table file and reads the version it was saved with (via OpenMcdf — the OLE reader also used for `.directb2s` streams)
3. Maps that version through the `[VPinballX]` section to a specific executable (e.g. `10.80=VPinballX85.exe`)
4. Runs that executable with the original parameters untouched

Fallbacks: no table argument → `DefaultVersion` from `[VPinballX.starter]`; table without a stored version → `Default` from `[VPinballX]`. Each start appends a log line to `VPinballX.starter.log` (`LogVersions=0` disables it). Works with Explorer, PinballX, PinballY and PinUp Popper — see [PinUp Player](PinUp%20Player.md).

## Configuration (VPinballX.starter.ini)

All behavior is ini-driven; double-clicking the starter with no ini generates a template ([raw/VPinballX-Starter/repo/README.md](https://github.com/JockeJarre/VPinballX.starter/blob/main/README.md)).

### `[VPinballX.starter]` — main section

| Key | Purpose |
|-----|---------|
| `DefaultVersion` | Version used when started without a table |
| `LogVersions` | `0` disables the per-start log entry |
| `ActivateWindow="title", timeout=N` | Activates the named VPX window ("Visual Pinball Player") once displayed, up to N seconds |
| `FirstArgTableName` | First argument becomes the table name |
| `PREPOSTactive`, `PREcmdExtension`, `POSTcmdExtension` | Enable pre/post batch scripts (below) |
| `AddParameter=...` | Extra VPX command-line parameters; `AddParameter.-play=...` applies only when the call contains `-play` (mode-dependent) |
| `AddPath=...` | Prepend directories (`;`-separated) to the VPX process PATH; `AddPath.<text>=...` only when the table filename contains `<text>` |
| `ActivateConfig.<key>=other.ini` | Keyboard-state ini switching (below) |
| `ActivateSetting.<key>=Suffix` | Keyboard-state section suffix switching (below) |

### `[VPinballX]` — version → executable map

```ini
[VPinballX]
Default=VPinballX72.exe
10.70=VPinballX71.exe
10.80=VPinballX85.exe
10.80x32=VPinballX85x32.exe
10.80GL=VPinballX85_GL.exe
10.81=C:\vPinball\VisualPinball10.81\VPinballX_BGFX64.exe
```

### `[TableNameExceptions]` — string hints

If the left string is found in the table filename, the right string is appended to the version lookup key — pure string handling, no logic. E.g. exception `GL` with a 10.80 table looks up `10.80GL` in `[VPinballX]` ([raw/VPinballX-Starter/repo/README.md](https://github.com/JockeJarre/VPinballX.starter/blob/main/README.md)).

### Version-dependent sections

`AddParameter` and `AddPath` can be overridden per VPX executable version in `[VPinballX.starter.10.8.1]` (Major.Minor.Build of the selected exe, **not** the table version); the compact form `[VPinballX.starter.10.81]` works as well. Lookup order: full form → compact form → `[VPinballX.starter]` ([raw/VPinballX-Starter/repo/README.md](https://github.com/JockeJarre/VPinballX.starter/blob/main/README.md)).

### Local ini per table directory

When a table file is given, the starter first looks for `VPinballX.starter.ini` in the **table directory**; the ini next to the exe is the fallback. A folder of VR tables can therefore run a completely different VPX version.

### Keyboard-state switching (ScrollLock / NumLock / CapsLock / Shift / Ctrl)

- `ActivateConfig.<key>=VPinballX.starter.ScrollLock.ini` — switch to a whole different ini (resolved next to the ini in use)
- `ActivateSetting.<key>=RightShiftVR` — append a suffix to the section lookup: `[VPinballX.RightShiftVR]`, `[TableNameExceptions.RightShiftVR]`

Supported keys: `NumLock`, `ScrollLock`, `CapsLock`, `LeftShift`, `RightShift`, `LeftCtrl`, `RightCtrl`. Pressed Shift/Ctrl keys take priority over the toggle keys ([raw/VPinballX-Starter/repo/README.md](https://github.com/JockeJarre/VPinballX.starter/blob/main/README.md)).

## PRE and POST Command Files

With `PREPOSTactive=true`, the starter runs batch files before/after the table: per-table `<tablename>.pre.cmd` / `.post.cmd` plus always-on `VPinballX.starter.pre.cmd` / `.post.cmd`. The caller process name is detected, enabling caller-specific extensions (e.g. `PREcmdExtension.explorer=.preexplorer.cmd`; PinUp Popper shows up as `anonymous`) ([raw/VPinballX-Starter/repo/README.md](https://github.com/JockeJarre/VPinballX.starter/blob/main/README.md)).

> ⚠️ Never start anything blocking inside these cmd files.

Typical use: PRE loads stage state for a table (backglass images, controller modes), POST cleans up — pairs naturally with [DOF Toys and Effects](../concepts/DOF%20Toys%20and%20Effects.md) and [Screen Configuration](../concepts/Screen%20Configuration.md) workflows.

## Setup

Copy `VPinballX.starter.exe` next to your `VPinballX.exe` files, double-click it, follow the generated-ini instructions, edit, then rename it to `VPinballX.exe`. Releases live on [GitHub Releases](https://github.com/JockeJarre/VPinballX.starter/releases); issue builds are under Actions ([raw/VPinballX-Starter/repo/README.md](https://github.com/JockeJarre/VPinballX.starter/blob/main/README.md)).

## Changelog — Commit Messages Not Yet in the Documentation

The README covers the features above; the upstream commit history contains behavior that the README has never documented. These commit messages are the source of record ([raw/VPinballX-Starter/repo/](https://github.com/JockeJarre/VPinballX.starter/tree/main)):

| Commit | Date | Message / undocumented behavior |
|--------|------|--------------------------------|
| [`834ec74`](https://github.com/JockeJarre/VPinballX.starter/commit/834ec74) | 2026-08-26 | **"Log the VPX call"** — the full VPX command line is written to the log, not just the chosen version as the README describes |
| [`3811de4`](https://github.com/JockeJarre/VPinballX.starter/commit/3811de4) | 2026-07-20 | **"Strip quotes from values in the ini"** — ini values are quote-stripped at parse time |
| [`5e1688f`](https://github.com/JockeJarre/VPinballX.starter/commit/5e1688f) | 2026-01-15 | **"Check if the file size goes down"** — guards against tables that are still being written/saved when launched |
| [`b1d90bf`](https://github.com/JockeJarre/VPinballX.starter/commit/b1d90bf) | 2026-01-14 | **"Check if there is a VPinballX executable already running"** — an already-running VPX instance is detected before launch (the AddPath half of this commit is documented) |
| [`3074498`](https://github.com/JockeJarre/VPinballX.starter/commit/3074498) | 2026-01-24 | **#18 "Window title and timeout is configurable"** — `ActivateWindow` key; the README shows it only as an ini comment, never as prose documentation |
| [`20dd71c`](https://github.com/JockeJarre/VPinballX.starter/commit/20dd71c) | 2026-08-07 | **"Add improved GUI for first starting instance to show instructions for generating the ini file"** — first-run GUI guide |
| [`62d20b9`](https://github.com/JockeJarre/VPinballX.starter/commit/62d20b9) | 2024-01-24 | **#8 "Call WaitForInputIdle, as PinballY does it"** — startup handshake for PinballY compatibility |
| [`fd4fe24`](https://github.com/JockeJarre/VPinballX.starter/commit/fd4fe24) | 2024-03-30 | **#11 "Add VPin Process to ChildProcessTracker"** — VPX is killed when the starter dies (no orphaned player windows) |
| [`da801aa`](https://github.com/JockeJarre/VPinballX.starter/commit/da801aa) | 2024-03-29 | **#10 "Change solution to a 'fake' WPF program"** — starts without a console window |
| [`507030a`](https://github.com/JockeJarre/VPinballX.starter/commit/507030a) | 2023-12-10 | **#9 "Add better logging and error message if table file is not found"** — table-not-found diagnostics |
| [`31e11c0`](https://github.com/JockeJarre/VPinballX.starter/commit/31e11c0) | 2023-12-03 | **#7 "choose vpx independent of table version: Default is a 'version'"** — `Default` may name a version key, not just an exe |
| [`d362420`](https://github.com/JockeJarre/VPinballX.starter/commit/d362420) | 2026-07-20 | **#21 "Upgrading OpenMcdf 2.4.1 to 3.1.4"** — OLE reader upgrade |
| [`6e64ca3`](https://github.com/JockeJarre/VPinballX.starter/commit/6e64ca3) | 2025-05-05 | **#16 "Upgrade .net to 8.0 LTS"** — runtime baseline |

Fully documented features (for reference): pre/post commands + caller variants (#13), `FirstArgTableName` + multiple pre/post chains (#14), mode-dependent parameters (#15), local ini priority (#19/#20), ScrollLock/NumLock ini support (#22/#23), Shift/Ctrl support, version-dependent `AddParameter` sections incl. compact form (2026-08/09).

## See Also

- [Visual Pinball X](Visual%20Pinball%20X.md) — the simulator being version-routed
- [PinUp Player](PinUp%20Player.md) — a frontend whose launches the starter routes (shows up as `anonymous` caller)
- [VPX File Layout](../concepts/VPX%20File%20Layout.md) — sidecar/ini conventions
- [Source: VPinballX Starter](../sources/VPinballX%20Starter.md)
