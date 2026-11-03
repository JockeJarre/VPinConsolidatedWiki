# VPX Debugging

Debugging workflow for [Visual Pinball X](../projects/Visual%20Pinball%20X.md) regressions and crashes: bisecting builds, capturing logs and stack traces, frame-capturing rendering issues, and filing a useful bug report.

> Source: community wiki (secondary); fully additive — the primary docs have no debugging page.

## Bisecting Regressions

Use `git bisect` on the vpinball repository between a known-good and known-bad build: check out midpoints, build each candidate, test one table, and mark good/bad until the regressing commit is isolated ([raw/dekay-vpinball-wiki/Debugging.md](https://github.com/dekay/vpinball-wiki/wiki/Debugging), §git bisect).

## Debug Builds and Logs

- Run **debug builds with symbols** to capture stack traces from crashes; symbolize crash dumps against the matching build
- Consult the **stdout/debug log** — VPX-Debug builds write a debug log; on Windows, when no GUI console is attached, capture with a DebugView/OutputDebugView-style tool
- **Windows Event Log** and crash dialogs identify the faulting module
- The runtime log file is `vpinball.log` in the configuration directory — see [VPX File Layout](VPX%20File%20Layout.md)

## Render Frame Capture

Capture a single VPX frame with **Renderdoc** to inspect draw calls, textures, and shader passes — the way to localize rendering regressions to a specific pass ([raw/dekay-vpinball-wiki/Debugging.md](https://github.com/dekay/vpinball-wiki/wiki/Debugging), §Renderdoc).

## Crash Reporting Protocol

A useful VPX bug report includes ([raw/dekay-vpinball-wiki/Debugging.md](https://github.com/dekay/vpinball-wiki/wiki/Debugging), §Crash reporting):

1. VPX build/version (release number or Actions revision)
2. GPU model and driver version
3. The `VPinballX.ini` (or the relevant keys)
4. The table: `.vpx` file and its version
5. Exact reproduction steps
6. The log file and/or crash dump

Mobile platforms: iOS support goes through email/Discord (`#vpx-standalone-mobile`), **not** GitHub issues; script errors on mobile are usually Wine VBScript quirks — see [VPX Standalone](VPX%20Standalone.md).

## Table-Level Repair

- **NVRAM reset**: "high scores gone / mechanism stuck at boot" → delete the table's NVRAM files (`keyram`/`backupram`, per the Glossary definitions: keyram = battery-backed game settings, backupram = high scores) to force clean re-initialization ([raw/dekay-vpinball-wiki/Table-Fixes-&-Performance-Optimizations.md](https://github.com/dekay/vpinball-wiki/wiki/Table-Fixes-&-Performance-Optimizations), §NVRAM fix)
- **Custom fonts**: tables referencing fonts load them from the OS font directory (not embedded) — missing fonts break the display; install the font (matters on Linux/Wine)
- Sidecar `.vbs` overrides and `vpxtool` script extraction/repair — see [VPX File Layout](VPX%20File%20Layout.md) and the community patch repo jsm174/vpx-standalone-scripts
- Performance tuning levers (texture scaling/compression, PreRenderLimit, disable reflections/SSAO, lower FSAA) sit on the same ini surface as [VPX Latency](VPX%20Latency.md) settings

## See Also

- [VPX File Layout](VPX%20File%20Layout.md) — log and ini locations
- [VPX Latency](VPX%20Latency.md) — rendering/latency settings to isolate
- [VPX Standalone](VPX%20Standalone.md) — mobile support channels, script quirks
- [Unofficial Visual Pinball Wiki](../sources/Unofficial%20Visual%20Pinball%20Wiki.md) — source collection (secondary)
