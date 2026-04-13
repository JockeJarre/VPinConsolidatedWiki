# VPX Docs (Source Summary)

Summary of the local Visual Pinball X documentation snapshot in [raw/VPX/repo/docs](../../raw/VPX/repo/docs/) (37 files total in the current mirror). Run `update-raw.ps1` to refresh it before re-ingesting.

## Canonical Upstream

- [Visual Pinball X Docs](https://github.com/vpinball/vpinball/tree/master/docs)

## Source Files

Current snapshot file count: 37 files. The table below lists the core files currently referenced by the wiki.

| File                                                                                                                     | Topic                      |
| ------------------------------------------------------------------------------------------------------------------------ | -------------------------- |
| [README.md](../../raw/VPX/repo/docs/README.md)                                                                           | Overview                   |
| [Build Differences.md](../../raw/VPX/repo/docs/Build%20Differences.md)                                                   | BGFX vs DX9 vs OpenGL      |
| [Script API Reference.md](../../raw/VPX/repo/docs/Script%20API%20Reference.md)                                           | Full scripting API         |
| [View Setup.md](../../raw/VPX/repo/docs/View%20Setup.md)                                                                 | Camera/projection config   |
| [Lights.md](../../raw/VPX/repo/docs/Lights.md)                                                                           | Lighting system            |
| [Stereo.md](../../raw/VPX/repo/docs/Stereo.md)                                                                           | 3D stereo rendering        |
| [Latency.md](../../raw/VPX/repo/docs/Latency.md)                                                                         | Latency analysis           |
| [LiveUI.md](../../raw/VPX/repo/docs/LiveUI.md)                                                                           | In-game editor             |
| [Command Line.md](../../raw/VPX/repo/docs/Command%20Line.md)                                                             | CLI options                |
| [FileLayout.md](../../raw/VPX/repo/docs/FileLayout.md)                                                                   | Directory structure        |
| [Plunger Velocity Input User Guide.md](../../raw/VPX/repo/docs/Plunger%20Velocity%20Input%20User%20Guide.md)             | Plunger velocity setup     |
| [Plunger Velocity Input Tech Note.md](../../raw/VPX/repo/docs/Plunger%20Velocity%20Input%20Tech%20Note.md)               | Plunger velocity internals |
| [Accelerometer Velocity Input User Guide.md](../../raw/VPX/repo/docs/Accelerometer%20Velocity%20Input%20User%20Guide.md) | Nudge velocity setup       |
| [Accelerometer Velocity Input Tech Note.md](../../raw/VPX/repo/docs/Accelerometer%20Velocity%20Input%20Tech%20Note.md)   | Nudge velocity internals   |
| [Open Pinball Device User Guide.md](../../raw/VPX/repo/docs/Open%20Pinball%20Device%20User%20Guide.md)                   | OPD support                |
| [Upgrading Table 10.8.md](../../raw/VPX/repo/docs/Upgrading%20Table%2010.8.md)                                           | 10.7→10.8 migration        |
| [Upgrading Table 10.8.1.md](../../raw/VPX/repo/docs/Upgrading%20Table%2010.8.1.md)                                       | 10.8→10.8.1 migration      |
| [Hotkeys.txt](../../raw/VPX/repo/docs/Hotkeys.txt)                                                                       | Keyboard shortcuts         |
| [RegistryKeys.txt](../../raw/VPX/repo/docs/RegistryKeys.txt)                                                             | Registry configuration     |
| [Scripts.txt](../../raw/VPX/repo/docs/Scripts.txt)                                                                       | Script notes               |
| [CommandReference.txt](../../raw/VPX/repo/docs/CommandReference.txt)                                                     | Internal command reference |
| [layoutGuideline.txt](../../raw/VPX/repo/docs/layoutGuideline.txt)                                                       | Table layout tips          |
| [vp10_issues.txt](../../raw/VPX/repo/docs/vp10_issues.txt)                                                               | Known issues               |

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


