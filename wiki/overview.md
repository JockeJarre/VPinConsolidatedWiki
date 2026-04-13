# Virtual Pinball Ecosystem

This wiki covers the core software stack for virtual pinball: the table simulator, the backglass server, and the hardware feedback framework. Together they recreate the full pinball experience — from the playfield on a TV screen to the illuminated backglass on a second monitor to the physical thump of a solenoid when you hit a bumper.

## The Stack

```
┌─────────────────────────────────────────────────┐
│                  Frontend                        │
│            (PinUp Popper, PinballX)              │
├─────────────────────────────────────────────────┤
│               Visual Pinball X                   │
│     Table simulator + editor + physics engine    │
│         VBScript game logic + PinMAME            │
├──────────────────┬──────────────────────────────┤
│  B2S Backglass   │    DirectOutput Framework     │
│     Server       │         (DOF R3)              │
│                  │                               │
│  Backglass       │  Output    Toys    Effects    │
│  DMD window      │  Controllers                  │
│  Plugins         │  (LedWiz, Art-Net, ...)       │
├──────────────────┴──────────────────────────────┤
│                  Hardware                        │
│  Monitors · Solenoids · LEDs · Shakers · Fans    │
└─────────────────────────────────────────────────┘
```

> For a detailed view of the DMD rendering pipeline within this stack, see the [FlexDMD architecture diagram](../raw/FlexDMD/repo/docs/media/architecture.svg).

## Core Projects

### [Visual Pinball X](projects/Visual%20Pinball%20X.md)
The table simulator. Handles physics, rendering, scripting (VBScript), input, and audio. Supports desktop play, VR, stereo 3D, and pincab setups. Current build: BGFX (multithreaded, cross-platform).

### [B2S Backglass Server](projects/B2S%20Backglass%20Server.md)
Displays dynamic backglasses on a secondary monitor. Loads `.directb2s` files (XML with artwork and lamp definitions) and animates them based on ROM data or script commands. Hosts plugins for DOF and PinUp Player.

### [DirectOutput Framework](projects/DirectOutput%20Framework.md)
Connects game events to physical hardware. Translates solenoid/lamp/switch changes into physical effects (contactor kicks, LED flashes, motor vibrations) via output controllers. Runs as a B2S plugin.

## Key Concepts

### Display & Configuration
- [Backglass](concepts/Backglass.md) — Digital backglass panels with lamp animations
- [DMD](concepts/DMD.md) — Dot Matrix Display for scores and animations
- [Screen Configuration](concepts/Screen%20Configuration.md) — Monitor layout (ScreenRes.txt, tablename.res)
- [VPX View Setup](concepts/VPX%20View%20Setup.md) — VPX camera/projection (Perspective vs Window Projection)
- [Pincab Setup](concepts/Pincab%20Setup.md) — Physical cabinet configuration

### Rendering
- [VPX Lights and Rendering](concepts/VPX%20Lights%20and%20Rendering.md) — Lightmaps, fading, shadows, reflections
- [VPX Stereo 3D](concepts/VPX%20Stereo%203D.md) — VR, 3D TV, and anaglyph support

### Input
- [VPX Plunger Input](concepts/VPX%20Plunger%20Input.md) — Position vs velocity-based plunger
- [VPX Accelerometer Input](concepts/VPX%20Accelerometer%20Input.md) — Acceleration vs velocity-based nudge
- [Open Pinball Device](concepts/Open%20Pinball%20Device.md) — New USB HID standard for pincab controllers

A common DIY hardware bridge for these cabinet inputs is [Pinscape Controller](projects/Pinscape%20Controller.md), which can combine buttons, plunger sensing, nudge sensing, and cabinet output control on one KL25Z-based controller stack.

### Hardware Feedback
- [DOF Output Controllers](concepts/DOF%20Output%20Controllers.md) — LedWiz, PacLed64, Art-Net, etc.
- [DOF Toys and Effects](concepts/DOF%20Toys%20and%20Effects.md) — Logical devices and effect chaining
- [DOF Table Configuration](concepts/DOF%20Table%20Configuration.md) — Mapping game events to effects

### Integration
- [B2S Plugins](concepts/B2S%20Plugins.md) — B2S plugin architecture (DOF, PinUp Player)
- [VPX Scripting](concepts/VPX%20Scripting.md) — VBScript API reference
- [VPX Latency](concepts/VPX%20Latency.md) — Input-to-display latency optimization

## Data Flow

**Gameplay loop:**
1. VPX processes physics and runs table VBScript
2. Script calls PinMAME for ROM emulation (or drives elements directly)
3. PinMAME state changes flow to B2S Server via COM
4. B2S Server updates the backglass display and forwards data to plugins
5. DOF maps table elements to effects → toys → output controllers → physical hardware
6. Player sees updated playfield, backglass, and feels physical feedback

## Raw Sources

This wiki is currently maintained from seven source collections:
- [B2S Wiki](sources/B2S%20Wiki.md) — 31 markdown files from the B2S Backglass Server wiki mirror
- [DOF Documentation](sources/DOF%20Documentation.md) — 25 markdown files from the DirectOutput Framework docs mirror
- [VPX Docs](sources/VPX%20Docs.md) — 37 files from the Visual Pinball X docs mirror
- [FlexDMD Docs](sources/FlexDMD%20Docs.md) — 5 markdown files from the FlexDMD docs mirror
- [DMD Extensions Docs](sources/DMD%20Extensions%20Docs.md) — 6 documentation files from the DMD Extensions mirror
- [Pinscape Build Guide](sources/Pinscape%20Build%20Guide.md) — 133 AsciiDoc files covering cabinet construction and the Pinscape controller platform
- [PinUp Popper Docs](sources/PinUp%20Popper%20Docs.md) — 78 mirrored HTML pages from the PinUp Popper wiki

PinUp Popper pages are mirrored locally for reference, but are still less deeply modeled than the main VPX/B2S/DOF/FlexDMD/DMD Extensions/Pinscape project and concept pages.


