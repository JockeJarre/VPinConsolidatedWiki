# VPX Docs (Source Summary)

Summary of the local Visual Pinball X documentation snapshot in [raw/VPX/repo/docs](https://github.com/vpinball/vpinball/tree/master/docs) (40 files in the current mirror at the top level, 79 including `img/` media; refreshed 2026-11-06). Run `update-raw.ps1` to refresh it before re-ingesting.

## Canonical Upstream

- [Visual Pinball X Docs](https://github.com/vpinball/vpinball/tree/master/docs)

## Source Files

Current snapshot file count: 40 top-level files (79 including `img/` media). The table below lists the core files currently referenced by the wiki.

| File                                                                                                                     | Topic                      |
| ------------------------------------------------------------------------------------------------------------------------ | -------------------------- |
| [README.md](https://github.com/vpinball/vpinball/blob/master/docs/README.md)                                                                           | Overview                   |
| [Build Differences.md](https://github.com/vpinball/vpinball/blob/master/docs/Build%20Differences.md)                                                   | BGFX vs DX9 vs OpenGL      |
| [Script API Reference.md](https://github.com/vpinball/vpinball/blob/master/docs/Script%20API%20Reference.md)                                           | Full scripting API         |
| [View Setup.md](https://github.com/vpinball/vpinball/blob/master/docs/View%20Setup.md)                                                                 | Camera/projection config   |
| [Lights.md](https://github.com/vpinball/vpinball/blob/master/docs/Lights.md)                                                                           | Lighting system            |
| [Stereo.md](https://github.com/vpinball/vpinball/blob/master/docs/Stereo.md)                                                                           | 3D stereo rendering        |
| [VR.md](https://github.com/vpinball/vpinball/blob/master/docs/VR.md)                                                                                     | OpenXR VR spaces, positioning, AR |
| [Latency.md](https://github.com/vpinball/vpinball/blob/master/docs/Latency.md)                                                                         | Latency analysis           |
| [LiveUI.md](https://github.com/vpinball/vpinball/blob/master/docs/LiveUI.md)                                                                           | In-game editor             |
| [Command Line.md](https://github.com/vpinball/vpinball/blob/master/docs/Command%20Line.md)                                                             | CLI options                |
| [FileLayout.md](https://github.com/vpinball/vpinball/blob/master/docs/FileLayout.md)                                                                   | Directory structure        |
| [Plunger Velocity Input User Guide.md](https://github.com/vpinball/vpinball/blob/master/docs/Plunger%20Velocity%20Input%20User%20Guide.md)             | Plunger velocity setup     |
| [Plunger Velocity Input Tech Note.md](https://github.com/vpinball/vpinball/blob/master/docs/Plunger%20Velocity%20Input%20Tech%20Note.md)               | Plunger velocity internals |
| [Accelerometer Velocity Input User Guide.md](https://github.com/vpinball/vpinball/blob/master/docs/Accelerometer%20Velocity%20Input%20User%20Guide.md) | Nudge velocity setup       |
| [Accelerometer Velocity Input Tech Note.md](https://github.com/vpinball/vpinball/blob/master/docs/Accelerometer%20Velocity%20Input%20Tech%20Note.md)   | Nudge velocity internals   |
| [Open Pinball Device User Guide.md](https://github.com/vpinball/vpinball/blob/master/docs/Open%20Pinball%20Device%20User%20Guide.md)                   | OPD support                |
| [Upgrading Table 10.8.md](https://github.com/vpinball/vpinball/blob/master/docs/Upgrading%20Table%2010.8.md)                                           | 10.7→10.8 migration        |
| [Upgrading Table 10.8.1.md](https://github.com/vpinball/vpinball/blob/master/docs/Upgrading%20Table%2010.8.1.md)                                       | 10.8→10.8.1 migration      |
| [Mobile.md](https://github.com/vpinball/vpinball/blob/master/docs/Mobile.md)                                                                           | Unified iOS/Android/Quest guide |
| [VPZ File Format.md](https://github.com/vpinball/vpinball/blob/master/docs/VPZ%20File%20Format.md)                                                     | Open table-pack format     |
| [Changelog.txt](https://github.com/vpinball/vpinball/blob/master/docs/Changelog.txt)                                                                   | 10.8.1 changelog           |
| [Changelog_Scripts.txt](https://github.com/vpinball/vpinball/blob/master/docs/Changelog_Scripts.txt)                                                   | System-script changelog    |
| [Hotkeys.txt](https://github.com/vpinball/vpinball/blob/master/docs/Hotkeys.txt)                                                                       | Keyboard shortcuts         |
| [RegistryKeys.txt](https://github.com/vpinball/vpinball/blob/master/docs/RegistryKeys.txt)                                                             | Registry configuration     |
| [Scripts.txt](https://github.com/vpinball/vpinball/blob/master/docs/Scripts.txt)                                                                       | Script notes               |
| [CommandReference.txt](https://github.com/vpinball/vpinball/blob/master/docs/CommandReference.txt)                                                     | Internal command reference |
| [layoutGuideline.txt](https://github.com/vpinball/vpinball/blob/master/docs/layoutGuideline.txt)                                                       | Table layout tips          |
| [vp10_issues.txt](https://github.com/vpinball/vpinball/blob/master/docs/vp10_issues.txt)                                                               | Known issues               |

## Key Takeaways

- VPX is cross-platform (Win/Mac/Linux/iOS/Android) with BGFX as the current build
- Multithreaded engine in BGFX decouples rendering from physics for low latency
- Rich VBScript API covering all table elements, physics, audio, and rendering
- Two view modes: Perspective Camera (desktop) and Window Projection (pincab)
- Physical lighting model with incandescent simulation (filament temperature)
- Velocity-based input (plunger + accelerometer) is strongly recommended over position/acceleration
- Open Pinball Device is the emerging standard for cabinet controllers
- SharedMemory API enables external apps (DMD, backglass, tools) to interface with VPX
- Comprehensive upgrade guides for 10.8 and 10.8.1 (input system rewrite)

## Late-2026 Changes (re-ingested 2026-11-04, 2026-11-06)

Upstream docs moved substantially since the April 2026 ingest ([Changelog.txt](https://github.com/vpinball/vpinball/blob/master/docs/Changelog.txt), [Changelog_Scripts.txt](https://github.com/vpinball/vpinball/blob/master/docs/Changelog_Scripts.txt)):

- **VPZ table pack format** — open zip/folder pack of JSON + scene assets, an editable alternative to the binary `.vpx` OLE container; preliminary, not production-ready ([raw/VPX/repo/docs/VPZ File Format.md](https://github.com/vpinball/vpinball/blob/master/docs/VPZ%20File%20Format.md)); core tables converted to VPZ packs
- **ScoreView plugin renamed to Nixie**; per-table layout files are now `.nix` with target-display sections ([raw/VPX/repo/docs/FileLayout.md](https://github.com/vpinball/vpinball/blob/master/docs/FileLayout.md))
- **B2SLegacy plugin removed** from the plugin set, superseded by B2S
- **Opus audio**: `.opus` (Ogg Opus, libopusfile) supported for table sounds and music
- **Hardcoded VPinMAME keys removed from system scripts**: F4 (lock display), F5 (double size), F6 (dips), F12 (volume) become in-game UI table options (VPinMAME COM controller only)
- **New system scripts 3.62**: `spike1.vbs` (Stern Spike 1), `tecnoplay.vbs`, `wpc_ph.vbs`, `p2k.vbs`, `pinheck.vbs`, `playbar.vbs`; core.vbs `cvpmTimer` queue/ownership fixes
- **Mobile guide unified** into [Mobile.md](https://github.com/vpinball/vpinball/blob/master/docs/Mobile.md) (iOS 26+ App Store, Android 13+ Google Play/APK, Meta Quest sideload); Wasm builds supported
- Flasher `VideoCap` API deprecated (reported by the table audit)
- **VR doc added upstream 2026-11-06**: [VR.md](https://github.com/vpinball/vpinball/blob/master/docs/VR.md) documents the OpenXR scene as 4 nested space references (Room / Cabinet feet / Cabinet / Playfield — only Playfield carries physics), the room-positioning + lockbar-dimension parameter model with the full `PlayerVR.*` settings reference, in-play view nudge / Align-VR-view / controller recentering, seated tilt, and colorkeyed passthrough **augmented reality** (10.8.1 Beta) → filed in [VPX VR Setup](../concepts/VPX%20VR%20Setup.md)

## Wiki Pages Generated

- [Visual Pinball X](../projects/Visual%20Pinball%20X.md) — Project page
- [VPX Scripting](../concepts/VPX%20Scripting.md) — Concept page
- [VPX View Setup](../concepts/VPX%20View%20Setup.md) — Concept page
- [VPX Lights and Rendering](../concepts/VPX%20Lights%20and%20Rendering.md) — Concept page
- [VPX Stereo 3D](../concepts/VPX%20Stereo%203D.md) — Concept page
- [VPX Latency](../concepts/VPX%20Latency.md) — Concept page
- [VPX Plunger Input](../concepts/VPX%20Plunger%20Input.md) — Concept page
- [VPX Accelerometer Input](../concepts/VPX%20Accelerometer%20Input.md) — Concept page
- [Open Pinball Device](../concepts/Open%20Pinball%20Device.md) — Concept page


