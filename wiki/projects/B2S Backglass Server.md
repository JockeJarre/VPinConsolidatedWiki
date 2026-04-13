# B2S Backglass Server

B2S Backglass Server (B2S = Backglass 2nd Screen) is a Windows COM server that displays dynamic backglasses for [Visual Pinball X](Visual%20Pinball%20X.md) tables. It simulates illuminated artwork panels found on real pinball machines by rendering `.directb2s` files on a secondary monitor.

## Overview

Originally started in 2012 by Stefan Wuehr ('Herweh'), B2S Server loads XML-based [backglass](../concepts/Backglass.md) files and displays lamp animations triggered by ROM data from VPinMAME or direct commands from VPX table scripts. It runs as a registered Windows COM object invoked automatically when VPX tables start.

A companion tool, **B2S Backglass Designer**, provides a WYSIWYG editor for creating and editing `.directb2s` files.

## Core Components

| Component | Description |
|-----------|-------------|
| **B2SBackglassServer.dll** | Main COM component, runs in-process with VPX |
| **B2SBackglassServerEXE.exe** | Standalone executable with improved performance, Large Address Aware |
| **B2SBackglassServerRegisterApp.exe** | Registers the COM component and context menus |
| **B2SServerPluginInterface.dll** | Plugin support interface |
| **B2SScreenResIdentifier.exe** | Visual editor for [Screen Configuration](../concepts/Screen%20Configuration.md) |
| **B2SWindowPunch.exe** | Creates transparent holes in overlapping windows |

### DLL vs EXE Mode

- **DLL Mode**: Runs in-process with VPX via COM. Lower overhead, fewer features.
- **EXE Mode**: Runs as a separate process. Supports [Backgrounds](#backgrounds), improved animation frame skipping, and gets new features first. Selectable per-ROM in settings.

## Key Features

### B2S-DMD

An additional window providing a designated space for the pinball machine's [DMD](../concepts/DMD.md) (Digital Message Display). Can be positioned and resized per-table using `tablename.res` files. Works with Freezy DMD extensions and PinUp Player.

### B2SScreenResIdentifier

A visual editor that displays 2–4 draggable windows (Playfield, Backglass, Background, B2S-DMD) for configuring [screen layout](../concepts/Screen%20Configuration.md). Eliminates manual editing of `ScreenRes.txt` and `tablename.res` files.

### B2SWindowPunch

A command-line utility that creates transparent holes in overlapping windows using smaller windows as stencils. Default configuration works out-of-the-box with VPX, B2S Server, and PinUp Player. Can be deactivated per-table via `tablename.res`.

### Backgrounds

Displays an additional image (JPG/PNG) as a background — useful for filling black bars from aspect ratio mismatches or as a standalone background for tables without backglasses. Supports template placeholders for dynamic filename substitution:

- `{name}` — Table name (e.g., "Blood Machines")
- `{manufactor}` — Manufacturer (e.g., "VPW")
- `{year}` — Year (e.g., "2022")
- `{tablename}` — Full table name
- `{gamename}` — ROM name

### Settings System

Right-click context menu on the backglass window provides:

- Switch between "Authentic" and "Fantasy" display modes
- Toggle Backglass, B2S-DMD, DMD Window, Grill visibility
- Control window behavior (Bring to front, Form No Focus)
- Tune performance (skip animation frames, LED types)
- Configure [B2S Plugins](../concepts/B2S%20Plugins.md) (DOF, PinUp Player)
- Save screenshots
- Exact `.directb2s` match (default ON since v2.0.2)

### B2SRandom

Batch file for randomizing backglasses before starting VPX. Picks from variants named `table-1.directb2s` through `table-9.directb2s`.

## Installation

1. Extract files to install directory (e.g., `C:\Visual Pinball\B2SServer\`) using 7-Zip to auto-unblock
2. Run `B2SBackglassServerRegisterApp.exe` to register COM component and context menus
3. Ensure Microsoft Visual C++ Redistributables are installed
4. Works as AnyCPU — automatically adapts to both x86 and x64 VPX

## Configuration

### ScreenRes.txt (Global)

Contains monitor positions and sizes. See [Screen Configuration](../concepts/Screen%20Configuration.md) for full details. The server searches for configuration in this priority order:

1. `tablename.res` next to the `.vpx` file
2. `screenres.txt` in the same folder as `.vpx`
3. `screenres.txt` as `tablename/screenres.txt`
4. `screenres.txt` in the B2SBackglassServerEXE.exe directory

### B2STableSettings.xml

Stores all settings per table/ROM. Both global defaults (header) and ROM-specific settings can be configured. Key settings include:

- `ArePluginsOn` — Enable/disable [B2S Plugins](../concepts/B2S%20Plugins.md)
- `DefaultStartMode` — 1=COM DLL, 2=EXE
- `HideGrill`, `HideB2SDMD`, `HideDMD` — Visibility per ROM
- `LampsSkipFrames`, `SolenoidsSkipFrames` — Performance tuning
- `UsedLEDType` — 0=Classic, 1=Icy, 2=Custom
- `StartAsEXE` — Per-ROM mode override

### Registry Keys

- `HKCU\Software\B2S\B2STableSettingsExtendedPath` — Check both table and install folder for XML
- `HKCU\Software\B2S\B2SScreenResFileNameOverride` — Custom ScreenRes filename
- `HKCU\Software\B2S\B2SWindowPunchActive` — Global window punch toggle

## API Methods

B2S Server exposes methods callable from VPX [VBScript](../concepts/VPX%20Scripting.md):

### Lighting & Data
- `B2SSetData(id, value)` — Set lamp data
- `B2SPulseData(id)` — Pulse a lamp
- `B2SSetIllumination(name, value)` — Set illumination level

### Score Display
- `B2SSetScore(display, value)` — Set score (displays 1–24)
- `B2SSetScorePlayer(playerno, score)` — Per-player score
- `B2SSetLED(digit, value)` — Set LED digit
- `B2SSetLEDDisplay(display, text)` — Set LED text
- `B2SSetReel(digit, value)` — Set reel value

### Game State
- `B2SSetCredits`, `B2SSetPlayerUp`, `B2SSetCanPlay`, `B2SSetBallInPlay`
- `B2SSetTilt`, `B2SSetMatch`, `B2SSetGameOver`, `B2SSetShootAgain`

### Animation
- `B2SStartAnimation(name, playreverse)` / `B2SStopAnimation(name)`
- `B2SStopAllAnimations()` / `B2SIsAnimationRunning(name)`

### Sound
- `B2SStartSound(name)` / `B2SPlaySound(name)` / `B2SStopSound(name)`

## Plugin Support

B2S Server supports two major [B2S Plugins](../concepts/B2S%20Plugins.md):

- **PinUP Player** — Controls playback of media using PuP Packs
- **[DirectOutput Framework](DirectOutput%20Framework.md)** — Drives physical feedback hardware (LEDs, motors, solenoids)

Plugins are loaded from `Plugins/` (32-bit) and `Plugins64/` (64-bit) directories.

## Updating

1. Back up: B2S folder, `ScreenRes.txt`, `B2STableSettings.xml`, all `tablename.res` files
2. Extract new release using 7-Zip
3. Copy into existing installation, overwriting old files
4. Do NOT overwrite `ScreenRes.txt` or `B2STableSettings.xml`
5. Re-run `B2SBackglassServerRegisterApp.exe`
6. Test with a table

**Key change in v2.0.2+**: "Exact .directb2s match" now defaults to ON. Backglass filenames must match VPX table filenames exactly.

## See Also

- [Backglass](../concepts/Backglass.md) — The concept of digital backglasses
- [DMD](../concepts/DMD.md) — Digital Message Display integration
- [Screen Configuration](../concepts/Screen%20Configuration.md) — Monitor layout for pincabs
- [B2S Plugins](../concepts/B2S%20Plugins.md) — B2S plugin architecture
- [DirectOutput Framework](DirectOutput%20Framework.md) — Hardware feedback system
- [Visual Pinball X](Visual%20Pinball%20X.md) — The table simulator
- [Pincab Setup](../concepts/Pincab%20Setup.md) — Physical cabinet configuration


