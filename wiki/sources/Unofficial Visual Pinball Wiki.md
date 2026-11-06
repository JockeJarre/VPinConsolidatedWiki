# Unofficial Visual Pinball Wiki

> ⚠️ Priority: Secondary — community-maintained; Primary sources win on conflicts.

Summary of the mirror of the **Unofficial Visual Pinball Wiki** at [raw/ExternalWikis/dekay-vpinball-wiki/repo/](https://github.com/dekay/vpinball-wiki/wiki) — 48 markdown pages (≈527 KB), a GitHub wiki self-described as "Unofficial" and "a work in progress". It covers VPX/VPinball Setup on Windows plus the cross-platform **VPX Standalone** story (Linux, macOS, iOS, Android, Batocera), file layout, altcolor, addressable LEDs, PuP Packs, VPinFE, and Pinscape Pico.

## Canonical Upstream

- Unofficial Visual Pinball Wiki (GitHub wiki mirror; dekay's copy)

## Source Coverage

| Area | Files |
|------|-------|
| Core / setup | Home, About-Visual-Pinball, FAQ, Glossary, File-Layout, VPinball-Ini (ARCHIVED in-source), Windows, Windows-Baller-Installer, Debugging, Fixing-Broken-Tables, Table-Fixes-&-Performance-Optimizations, Backing-Up, Point-Of-View |
| Displays / graphics / plugins | Backglasses,-Alphanumeric,-and-Dot-Matrix-Displays, Altcolor, AddressableLED, VR, ScoreView-Plugin, Serum-Plugin, VNI-Plugin, PAC/PAL pages |
| DOF / controllers / media | DOF---The-Direct-Output-Framework, Pinscape-KL25Z-and-Pinscape-Pico-Controllers, PINPAD, PUP-Packs, PUP-Reverse-Engineering, Research |
| Frontends | Frontend-VPinFE, Installing-VPINFE-on-Windows-11 |
| Platforms | Linux, macOS, Android, iOS, Batocera, Running-On-Other-OSs, Optimizations-For-iOS-Etc, Dockingstation-for-Mobile-Devices, map-external-Gamecontroller, Standalone-(Mobile)-using-VR-Table-with-Puppack |
| Meta | _Sidebar, _Footer, Home, Contribution-Guidelines, Help-Wanted, Archived-Pages, Additional-Resources |

## Key Facts

- Upstream community conventions: prefer the name **"VPinball" over "VPX"** (anticipating v11); Visual Pinball is **GPLv3+** licensed ([raw/ExternalWikis/dekay-vpinball-wiki/repo/_Footer.md](https://github.com/dekay/vpinball-wiki/wiki/_Footer), Contribution-Guidelines.md)
- The wiki's own **Archived-Pages** ledger (2026-10-11 batch) dates ecosystem changes: PUP reverse-engineering issues fixed in the current PUP Plugin, `VPinballX.ini` doc dropped after massive 10.8.1 changes, PAL/VNI/Serum/PAC pages merged into a single **Altcolor** page
- File-Layout.md is the collection's most valuable page: the 10.8.1+ **per-table self-contained layout**, search priority, and per-OS user-data paths (Linux moved to `~/.local/share/VPinballX/<version>` Jan 2026)
- VPX Standalone = the port **without table editor/preferences GUI**; cross-platform builds shipped in official releases since **VPX 10.8**; per-commit betas on GitHub Actions
- DOF gained a **built-in VPX 10.8.1 plugin** (no B2S dependency), config at `%APPDATA%\VPinballX\10.8\directoutputconfig`; external plugin keeps `C:\DirectOutput\config`
- Several pages are marked **ARCHIVED in-source** (`VPinball-Ini.md`, `Fixing-Broken-Tables.md`, `PUP-Reverse-Engineering.md`, PAL/VNI/Serum/PAC): treat their parameter names/defaults as historic snapshots; verify against shipped `Default_VPinballX.ini` before relying on them
- **Pinscape guide restructured upstream 2026-11-05**: the Pico Nudge & Plunger chapter split into **Setup** (JSON/gamepad axis wiring) and **Settings** (VPX LiveUI sensor dialogs, with `img/settings/` screenshots); sensor-type/unit guidance filed in [Pinscape Pico](../concepts/Pinscape%20Pico.md)
- **vpxtool optimize** guidance refreshed upstream 2026-11-03 (`--mono` flag corrected): `vpxtool optimize --mono --flac table.vpx` is recommended because VPX 10.8.1+ converts stereo playfield sources to mono internally; `--max-image-size=768` targets VRAM-limited devices ([raw/ExternalWikis/dekay-vpinball-wiki/repo/Table-Fixes-&-Performance-Optimizations.md](https://github.com/dekay/vpinball-wiki/wiki/Table-Fixes-&-Performance-Optimizations)) → filed in [VPX Debugging](../concepts/VPX%20Debugging.md)

## Conflicts Opened (per Source Priority rule, Primary wins)

- **VR platforms**: Glossary/VR.md say VR "Windows-only, OpenXR port underway" — Primary (VPX project page) lists BGFX OpenXR as shipping → see [VPX Stereo 3D](../concepts/VPX%20Stereo%203D.md)
- **DX9 status**: About-Visual-Pinball calls DX9 "the go-to version for most users" — Primary marks the DX9 build deprecated → see [Visual Pinball X](../projects/Visual%20Pinball%20X.md)
- **VPX vs Standalone platform scope**: Home says "VPX only Windows; Standalone on other OSs" — Primary project page conflates cross-platform BGFX builds with full VPX; reconciliation: full editor VPX = Windows, cross-platform builds lack the editor
- **Serum format**: `.crz` superseded by auto-generated `.cromc` — Primary (DMD Extensions page) lists only `.cRZ` → see [Altcolor](../concepts/Altcolor.md)
- **Open Pinball Device on Pinscape Pico**: OPD detection broken on Linux (vpinball issue #3303); guide recommends `gamepad`/`xInput` → see [Open Pinball Device](../concepts/Open%20Pinball%20Device.md)
- **Plunger axis**: mjr recommends `plunger.z0` (not `plunger.z`) for VPX 10.8.1+ → see [VPX Plunger Input](../concepts/VPX%20Plunger%20Input.md)
- **KL25Z accelerometer**: newest USB-C FRDM-KL25Z boards have **no** onboard accelerometer → see [Pinscape Controller](../projects/Pinscape%20Controller.md)
- **DOF GlobalConfig filename**: resolved — the primary DOF docs use **both** spellings (`GlobalConfiguration_b2SServer.xml` in the installation chapter, `GlobalConfig_B2SServer.xml` in the GlobalConfig chapter); treat as the same file → see [DirectOutput Framework](../projects/DirectOutput%20Framework.md)
- **Latency defaults** (`VisualLatencyCorrection`, `SyncMode`, V-Sync advice): secondary values are from an archived ini doc; version drift — see [VPX Latency](../concepts/VPX%20Latency.md)
- **Legacy layout claims** (global `VPinMAME\roms`, registry settings, `~/vpinball`): VP9/Baller-era; superseded by per-table layout — see [VPX File Layout](../concepts/VPX%20File%20Layout.md)

## Filing

Claims from this collection were filed into: [VPX File Layout](../concepts/VPX%20File%20Layout.md), [Altcolor](../concepts/Altcolor.md), [DOF Addressable LEDs](../concepts/DOF%20Addressable%20LEDs.md), [VPX Standalone](../concepts/VPX%20Standalone.md), [PinUp Player](../projects/PinUp%20Player.md), [PuP Packs](../concepts/PuP%20Packs.md), [VPinFE](../projects/VPinFE.md), [Pinscape Pico](../concepts/Pinscape%20Pico.md), [VPX Debugging](../concepts/VPX%20Debugging.md), [VPX Nixie Plugin](../concepts/VPX%20Nixie%20Plugin.md), [VPX VR Setup](../concepts/VPX%20VR%20Setup.md), plus sweeps of existing pages.

## See Also

- [Visual Pinball X](../projects/Visual%20Pinball%20X.md)
- [VPX Standalone](../concepts/VPX%20Standalone.md)
- [VPX Docs](VPX%20Docs.md) — the Primary VPX documentation mirror
