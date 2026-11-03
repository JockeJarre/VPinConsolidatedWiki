# VPinFE

VPinFE is an open-source, cross-platform frontend for [Visual Pinball X](../projects/Visual%20Pinball%20X.md) / VPinball Standalone, written in Python by **superhac**. It is the frontend used by the community wiki's Linux cabinet guides and runs on Windows 11, Linux, and macOS.

> Source: community wiki (secondary). VPinFE has its own upstream wiki (github.com/vpinfe/vpinfe — Setup); the community "First Steps" page was retired in its favor (2026-10-24).

## Installation (Windows)

([raw/dekay-vpinball-wiki/Installing-VPINFE-on-Windows-11.md](https://github.com/dekay/vpinball-wiki/wiki/Installing-VPINFE-on-Windows-11)

- Source: `github.com/superhac/vpinfe`. Clone → `python -m venv venv-vpinfe --system-site-packages` → activate → `pip install pywebview screeninfo colorama requests olefile nicegui pynput` → `python main.py`
- Pins **Python 3.13**; the project site's prominent download button may offer a non-working build — use the pinned version
- **PowerShell script execution must be enabled** (and stay enabled) — the launcher is a PowerShell script; tip: set the launcher's "Open With" to PowerShell

## Workflow: VPS-ID Table Matching

Table identity is the **VPinball Services (VPS) ID** ([raw/dekay-vpinball-wiki/Frontend-VPinFE.md](https://github.com/dekay/vpinball-wiki/wiki/Frontend-VPinFE)

1. Table folders should be named with the VPS ID
2. `Scan Tables` + `Update All Tables` + `Download Media` populate the wheel
3. Mismatched tables list under **"unmatched Tables"** / "Unknown"
4. `Match VPS ID` → shorten the name for suggestions → `Associate` **renames the table folder to the VPS ID**; re-scan to fetch media

The ManagerUI runs on localhost (or remote) as a web view.

## Windowed Cabinet Integration (Linux)

VPinFE creates fixed-title windows that window rules position per screen: `VPinFE Table`, `VPinFE BG`, `VPinFE DMD`, alongside VPX's `Visual Pinball Player`, `Visual Pinball Backglass`, `Visual Pinball Score View`. KDE KWin rules and a Sway config (by the VPinFE author) position these for 2-screen cabinets; VPinFE **assumes an unrotated playfield display** ([raw/dekay-vpinball-wiki/Linux.md](https://github.com/dekay/vpinball-wiki/wiki/Linux) See [VPX Standalone](../concepts/VPX%20Standalone.md) and [Screen Configuration](../concepts/Screen%20Configuration.md).

## See Also

- [VPX Standalone](../concepts/VPX%20Standalone.md) — the engine VPinFE launches on non-Windows platforms
- [Screen Configuration](../concepts/Screen%20Configuration.md) — multi-display window placement
- [PinUp Popper Docs](../sources/PinUp%20Popper%20Docs.md) — the Windows-primary frontend ecosystem
- [Unofficial Visual Pinball Wiki](../sources/Unofficial%20Visual%20Pinball%20Wiki.md) — source collection (secondary)
