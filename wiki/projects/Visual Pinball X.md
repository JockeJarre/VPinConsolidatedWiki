# Visual Pinball X

Visual Pinball X (VPX) is a feature-rich pinball table simulator and editor for Windows and other platforms. It serves as both an all-in-one editor and player for creating and playing virtual pinball tables with physics simulation, supporting desktop play, VR/AR, [VPX Stereo 3D](../concepts/VPX%20Stereo%203D.md), and physical [pincab setups](../concepts/Pincab%20Setup.md).

## Overview

VPX is the core of the virtual pinball ecosystem. Tables are authored in the VPX editor using VBScript for game logic, then played in the VPX player which handles physics, rendering, and input. VPX integrates with [B2S Backglass Server](B2S%20Backglass%20Server.md) for [backglass](../concepts/Backglass.md) display, PinMAME for ROM emulation, and the [DirectOutput Framework](DirectOutput%20Framework.md) for physical feedback.

## Build Flavors

### BGFX (Current — 10.8.1+)
- Most modern and feature-complete variant
- Supports Vulkan, Metal, DirectX 11, OpenGL, OpenGL ES
- VR/AR via OpenXR, HDR display support
- Real [stereo rendering](../concepts/VPX%20Stereo%203D.md)
- **Multithreaded engine** decoupling rendering from gameplay for low [latency](../concepts/VPX%20Latency.md)
- Additional output windows ([DMD](../concepts/DMD.md), score displays)
- Cross-platform: Windows, Linux, macOS, iOS, Android, Raspberry Pi

### DirectX 9 (Deprecated)
- Original VPX flavor developed over 20+ years
- Reference build for backward compatibility; no longer recommended
- ⚠️ CONFLICT (secondary source): DX9 called "the go-to version for most users"
  ([raw/dekay-vpinball-wiki/About-Visual-Pinball.md](https://github.com/dekay/vpinball-wiki/wiki/About-Visual-Pinball) — Primary: DX9 is deprecated, BGFX is the recommended build ([raw/VPX docs](https://github.com/vpinball/vpinball/tree/master/docs))

### OpenGL (Deprecated)
- Initial VR headset support; superseded by BGFX

### Cross-Platform Builds — Standalone
The BGFX engine runs on all platforms, but the other-OS builds ship **without the table editor and preferences GUI** — the community calls them **VPX Standalone**; see [VPX Standalone](../concepts/VPX%20Standalone.md).

- ⚠️ CONFLICT (secondary source): "VPX is supported only on Windows, while VPX Standalone runs on other operating systems"
  ([raw/dekay-vpinball-wiki/Home.md](https://github.com/dekay/vpinball-wiki/wiki) — Primary: VPX (BGFX) is cross-platform ([raw/VPX docs](https://github.com/vpinball/vpinball/tree/master/docs)). Reconciliation: full editor VPX = Windows; cross-platform builds are the editor-less Standalone derivative

**Bitness**: Tables work on both 32-bit and 64-bit builds. x64 builds offer better multithreading and memory.

## File Layout

See [VPX File Layout](../concepts/VPX%20File%20Layout.md) for the full cross-platform layout, search priority, and per-OS configuration paths. Summary:

### Installation Structure (Windows)
- **Application**: `C:\Program Files\...`
- **Settings**: `C:\Users\xxx\AppData\Roaming\...` (per-minor-version subfolder in 10.8.1+)
- **Tables**: User-configured folder

### Recommended Table Folder Organization
```
Table Name (Manufacturer Year)/
├── Table file v1.1.vpx              ← Main VPX file
├── Table file v1.1.ini              ← Table setting overrides
├── Table Name.directb2s             ← Backglass
├── Table Name (Manufacturer Year).info  ← Metadata (JSON)
├── altsound/                        ← AltSound plugin files
├── cache/                           ← Auto-generated cache
├── music/                           ← For PlayMusic command
├── pinmame/roms/ pinmame/nvram/     ← PinMAME data
├── pupvideos/                       ← PinUp Player content
├── scripts/                         ← Additional scripts
├── user/                            ← VPReg.stg (saved values)
└── medias/                          ← Frontend media files
```

### File Search Priority
1. Along table file with table filename
2. Along table file with containing folder name
3. Custom legacy folder (component-specific)

### Settings
- **Global**: `VPinballX.ini` (user-adjustable via in-game UI)
- **Table overrides**: Named after table file or containing folder
- Custom settings file via `-Ini` command line option
- Settings moved from the Windows Registry to ini files; the registry-era layout (global `VPinMAME\roms\`, Baller-managed trees) survives in community FAQ/Windows pages as **legacy VP9-era advice** — see [VPX File Layout](../concepts/VPX%20File%20Layout.md)
  - ⚠️ CONFLICT (secondary source): registry-key settings storage, `regsvr32` repair steps, global ROM folders
    ([raw/dekay-vpinball-wiki/FAQ.md](https://github.com/dekay/vpinball-wiki/wiki/FAQ), Windows.md) — Primary: ini model with per-table config ([raw/VPX docs](https://github.com/vpinball/vpinball/tree/master/docs))

## Command Line Options

```
VPinballX.exe [options]
  -Play [file]           Load and play table
  -Edit [file]           Load into editor
  -PovEdit [file]        Camera mode, export POV on exit
  -Primary               Force render on primary monitor
  -DisableTrueFullscreen Force windowed mode
  -ExtMinimized          Minimized with Pause Menu
  -GLES [value]          Override global emission scale
  -Ini [file]            Use custom settings file
  -c1..c9 [param]        Custom params (GetCustomParam)
  -CaptureAttract [n] [fps] [file]  Capture attract frames
  -ListRes               List screen resolutions
  -ListSnd               List sound devices
```

## Scripting

VPX uses VBScript for table logic. See [VPX Scripting](../concepts/VPX%20Scripting.md) for the full API reference.

### Key Global Variables
| Category | Examples |
|----------|----------|
| **Time** | `GameTime`, `PreciseGameTime`, `SystemTime`, `FrameIndex` |
| **Input** | `LeftFlipperKey`, `RightFlipperKey`, `PlungerKey` |
| **Rendering** | `RenderingMode` (0=2D, 1=Stereo, 2=VR), `WindowWidth/Height` |
| **Audio** | `PlaySound()`, `StopSound()`, `PlayMusic()`, `MusicVolume()` |
| **DMD** | `DMDWidth`, `DMDHeight`, `DMDPixels`, `DMDColoredPixels` |

### Key Element Types
- **Ball**: Position, velocity, mass, radius, image, color
- **Flipper**: Position, radius, length, angles, force, `RotateToEnd()`/`RotateToStart()`
- **Light**: State (off/on/blinking), color, intensity, fader mode, shadow support
- **Plunger**: Position, fire speed, `MechPlunger`, `Pullback()`, `Fire()`, `CreateBall()`
- **Bumper**: Position, force, ring animation
- **Kicker**: `Kick(angle, speed, inclination)`, `CreateBall()`, `DestroyBall()`
- **Wall**: Hit events, elasticity, collidability, `IsDropped`

Object names face a **31-character hard limit that is silently truncated**, causing duplicate-name conflicts — the authoring community keeps component names ≤6 characters ([raw/vpw-wiki/docs/guides/best-practices.md](https://vpw-wiki.skirmishofwit.com/guides/best-practices/), §Naming). See [VPX Authoring Best Practices](../concepts/VPX%20Authoring%20Best%20Practices.md).

### Engine Audio Behavior

Positional audio uses a fixed pan law — **Left 100% / Middle 200% / Right 100%** — implemented in the engine, not scriptable ([raw/vpw-wiki/docs/reference/fleep-sounds.md](https://vpw-wiki.skirmishofwit.com/reference/fleep-sounds/) See [Fleep Sound Packages](../concepts/Fleep%20Sound%20Packages.md).

### Key Events
- `Table_Init()` — Table initialization
- `Table_Exit()` — Table teardown (PUP users must release the PuPlayer COM object here)
- `Table_KeyDown(keycode)` / `Table_KeyUp(keycode)` — Input
- `Animate()` — Visual property sync (10.8+, replaces timer-based flipper shadows)

## VPX View Setup

Two rendering modes — see [VPX View Setup](../concepts/VPX%20View%20Setup.md) for details:

### Perspective Camera (Desktop)
Traditional video game camera. Parameters: Player X/Y/Z, Look At, Field of View, offsets.

### Window Projection (Pincab)
Designed for physical cabinets with TV screens. Simulates player positioned at the side. Parameters: Screen width/height (cm), inclination, Player X/Y/Z, table scales, offsets.

## VPX Lights and Rendering

See [VPX Lights and Rendering](../concepts/VPX%20Lights%20and%20Rendering.md) for details.

- **Lightmaps**: Flat surfaces (classic opaque, halo transparent, custom via Flasher/Primitive)
- **Fading**: None (LED), Linear, Incandescent (physical filament temperature model at 2700K)
- **Shadows**: Dynamic raytraced between balls and lightmaps
- **Reflections**: Direct rendering on balls, reflection probes (10.8+)

## VPX Stereo 3D

See [VPX Stereo 3D](../concepts/VPX%20Stereo%203D.md) for details.

Supports VR headsets, 3D TVs, and anaglyph glasses. Real stereo rendering (one image per eye) in BGFX. Multiple anaglyph filter options with calibration support.

## VPX Latency

See [VPX Latency](../concepts/VPX%20Latency.md) for details.

Three types: input (<1ms target), physics/emulation (~0.5ms WPC), visual (7–10ms optimized). BGFX's multithreaded engine is key. FastFlips optimization reduces flipper latency.

## Input Devices

- [VPX Plunger Input](../concepts/VPX%20Plunger%20Input.md) — Position-based and velocity-based plunger support
- [VPX Accelerometer Input](../concepts/VPX%20Accelerometer%20Input.md) — Acceleration and velocity-based nudge
- [Open Pinball Device](../concepts/Open%20Pinball%20Device.md) — New USB HID interface for pinball cabinets

## PinMAME Integration

VPX tables use VBScript "core" scripts to interface with PinMAME for ROM emulation. PinMAME handles emulation of pinball machine CPUs (WPC, System 11, etc.) and provides lamp/solenoid callbacks and switch handling.

Helper classes: `cvpmTrough`, `cvpmSaucer`, `cvpmMagnet`, `cvpmTurnTable`, `cvpmMech`, `cvpmDropTarget`, `cvpmFlips2`, `cvpmNudge`.

## Upgrading Tables

### 10.8.0 Changes
- Parts below playfield now visible by default
- Reflections rendered differently
- Static parts adjustable during initialization
- New: ball shadows, reflection probes, `Animate()` event, playfield transparency

### 10.8.1 Changes
- Input system rewritten — must reconfigure joystick/keys
- New VR/XR space reference features (optional)
- Ball motion trail/blur moved to application settings

## SharedMemory API

Client-server shared memory for external applications ([DMD](../concepts/DMD.md), backglass, SpyTool) to read/write VPX state. Little Endian format. Reserved IDs: `VPVR` (server), `UDMD`, `XDMD`, `DB2S`, `SPYT`. Slot acquisition uses a handshake protocol with REQUEST_ID/ACK_ID validation.

## LiveUI

In-game editor allowing modification while a table plays. Supports orbit/pan/zoom viewport, grab/rotate/scale parts, and switching between startup state (persisted) and live state (animated). Key shortcuts: P (play/pause), G/R/S (grab/rotate/scale), F (fly camera).

## See Also

- [VPX Scripting](../concepts/VPX%20Scripting.md) — Full scripting API reference
- [VPX View Setup](../concepts/VPX%20View%20Setup.md) — Camera and projection configuration
- [VPX Lights and Rendering](../concepts/VPX%20Lights%20and%20Rendering.md) — Lighting system details
- [VPX Stereo 3D](../concepts/VPX%20Stereo%203D.md) — 3D rendering modes
- [VPX Latency](../concepts/VPX%20Latency.md) — Input-to-display latency optimization
- [B2S Backglass Server](B2S%20Backglass%20Server.md) — Backglass display
- [DirectOutput Framework](DirectOutput%20Framework.md) — Hardware feedback
- [Pincab Setup](../concepts/Pincab%20Setup.md) — Physical cabinet configuration
- [DMD](../concepts/DMD.md) — Digital Message Display
- [VPX Standalone](../concepts/VPX%20Standalone.md) — Cross-platform builds (Linux/macOS/iOS/Android/Batocera)
- [VPX File Layout](../concepts/VPX%20File%20Layout.md) — Per-table layout, config paths, search priority
- [VPX Debugging](../concepts/VPX%20Debugging.md) — Bisecting regressions, logs, crash reporting
- [VPX VR Setup](../concepts/VPX%20VR%20Setup.md) — Operational VR configuration


