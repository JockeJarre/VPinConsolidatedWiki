# DirectOutput Framework

The DirectOutput Framework (DOF) R3 is an extensible C# framework that connects virtual pinball cabinets to physical hardware feedback devices. It processes table element state changes from [Visual Pinball X](Visual%20Pinball%20X.md) and triggers effects on [DOF Output Controllers](../concepts/DOF%20Output%20Controllers.md) to drive [toys](../concepts/DOF%20Toys%20and%20Effects.md) like contactors, RGB LEDs, solenoids, motors, and shakers.

## Overview

Released autumn 2015, DOF provides a multithreaded architecture ensuring optimal performance without stuttering. It acts as an abstraction layer hiding complex hardware differences, supporting both legacy INI file configuration and powerful XML configuration. DOF operates as a [plugin](../concepts/B2S%20Plugins.md) for [B2S Backglass Server](B2S%20Backglass%20Server.md), receiving table element updates and translating them into physical effects.

Since the 10.8.1 development cycle, VPX also ships a **built-in DOF plugin** — no B2S plugin installation is needed on that path, and DOF is built into VPX Standalone on Linux/macOS (since late June 2025). The community wiki's DOF guide documents this flow end to end:

- Windows (built-in plugin): config files live in `%APPDATA%\VPinballX\10.8\directoutputconfig`; external B2S-plugin-era installs use `C:\DirectOutput\config`
- Linux/macOS: `~/.local/share/VPinballX/10.8/directoutputconfig/` (see [VPX File Layout](../concepts/VPX%20File%20Layout.md))
- Enable keys: 10.8.0 `[Standalone] DOFPlugin=1`; 10.8.1 `[Plugin.DOF] Enable=1` (expect churn — the codebase is moving to a plugin architecture)

- ⚠️ CONFLICT (secondary source): "DOF operates as a plugin for B2S Backglass Server" (framing of this page, from the primary DOF docs)
  ([raw/ExternalWikis/dekay-vpinball-wiki/repo/DOF-‐-The-Direct-Output-Framework.md](https://github.com/dekay/vpinball-wiki/wiki/DOF-%E2%80%90-The-Direct-Output-Framework) — Primary: DOF's own docs describe the B2S.Server plugin. Both are true per era: the B2S plugin is the classic path; the built-in VPX plugin (10.8.1+) bypasses B2S

## Architecture

DOF has three main areas:

### Table Layer
- Processes events from PinMAME/table scripts (solenoid changes, lamp states)
- Maintains static effects triggered on initialization
- Routes element state changes to assigned effects

### Cabinet Layer
- **[DOF Output Controllers](../concepts/DOF%20Output%20Controllers.md)**: Hardware units (LedWiz, PacLed64, Art-Net) controlling physical outputs
- **[Toys](../concepts/DOF%20Toys%20and%20Effects.md)**: Logical representations of cabinet devices (RGB LEDs, contactors, motors)
- **Effects Applied**: Direct controls on toys responding to table events
- Manages all outputs as abstract `IOutput` interface for cross-controller compatibility

### Effects System
- **Toy Effects**: Direct control of toys (fade-to-color, motor power level)
- **Effect Effects**: Chain/stack other effects for complex behavior
- **Effect Chaining**: Delay → Blink → Fade creates sophisticated animations
- Events trigger effects → effects update toys → toys control output controllers

### Multithreading
- Separate thread per LedWiz communicating with hardware
- Main loop thread processes queued external data
- Prevents blocking and maintains responsiveness

## Installation

1. [B2S Backglass Server](B2S%20Backglass%20Server.md) must be installed first (DOF is a B2S plugin)
2. Create `/plugins/DirectOutput/` directory in the B2S installation
3. Extract DOF package contents
4. Unblock DLLs (right-click → Properties → Unblock on Vista/Win7)
5. Activate "Active Plugins" in B2S Server settings or set `<ArePluginsOn>1</ArePluginsOn>` in `B2STableSettings.xml`
6. Replace `VPinMAME.Controller` with `B2S.Server` in table scripts

## Configuration System

### GlobalConfig (`GlobalConfiguration_b2SServer.xml`)

- The community guide consistently names the file **`GlobalConfig_B2SServer.xml`** — the primary DOF docs use **both** spellings (`GlobalConfiguration_b2SServer.xml` in the installation chapter, `GlobalConfig_B2SServer.xml` in the GlobalConfig chapter), so treat both names as the same file
- INI file search paths
- Cabinet configuration file location
- Logging settings (enable/disable, path, clear on session start)
- Minimum effect duration settings
- Placeholders: `{InstallDir}`, `{BinDir}`, `{TableDir}`, `{TableName}`, `{RomName}`, `{DateTime}`

### CabinetConfig (XML)
Defines physical hardware in the cabinet:
- **Output Controllers**: List of hardware units with names and identifiers
- **Toys**: Logical device definitions mapped to controller outputs
- **Colors**: Named color definitions for effects
- **Curves**: Custom fading curves (256-value input→output mappings)

### TableConfig (XML)
Per-table configuration defining:
- **TableElements**: Solenoids, lamps, switches with assigned effects
- **Effects**: Effect definitions (type, parameters, chaining)
- **AssignedStaticEffects**: Effects triggered on table initialization

### INI Files (`directoutputconfig.ini`)
Legacy format with `[Config DOF]` section. ROM name rows with 32+ columns for LedWizEquivalent outputs. Numbered by controller (1–16 for LedWiz, 19 PacDrive, 20–27 PacLed64, 30+ custom).

- ⚠️ CONFLICT (secondary source): the community guide's July-2025 table numbers each **controller class** with its own base file — LedWiz = the unnumbered `directoutputconfig.ini` with suffixes appended per extra unit, FRDM-KL25Z (Pinscape Gen 1) = 8, PinOne = 11, PacDrive = 19, PacLed = 20, UltimateI/O = 27, WS2811 = 30, SainSmart = 40, Pinscape = 51, Philips Hue = 70, Pincontrol1 = 80, Pincontrol2 = 85, DudesCab = 90, Art-Net = 100, **Pinscape Pico = 120**; extra boards of a type increment the base by 1, and only PacDrive is capped at one per cabinet
  ([raw/ExternalWikis/dekay-vpinball-wiki/repo/DOF-‐-The-Direct-Output-Framework.md](https://github.com/dekay/vpinball-wiki/wiki/DOF-%E2%80%90-The-Direct-Output-Framework), §Supported Hardware and Their ini Files) — Primary: the 1–16/19/20–27 ranges above. Full table on [DOF Output Controllers](../concepts/DOF%20Output%20Controllers.md)

## Supported Hardware

| Controller | Outputs | Features |
|-----------|---------|----------|
| **LedWiz** | 32 @ 49 PWM levels | 50Hz PWM, auto-detected, up to 16 units |
| **PacLed64** | 64 @ 256 PWM levels | 100kHz constant-current 20mA, up to 4 units |
| **PacDrive** | 16 digital | On/off only, 1 unit |
| **PacUIO** | 96 @ 256 PWM levels | 100kHz constant-current, up to 2 units |
| **Art-Net/DMX** | 512 per universe | Ethernet-based stage lighting, unlimited |
| **TeensyStripController** | 8 channels × 1100 LEDs | WS2811/WS2812 addressable strips |
| **FT245RBitbang** | 8 digital | SainSmart USB relays |
| **Philips Hue** | ~150 channels | Zigbee wireless RGB |
| **DudesCab** | 128 PWM | RP2040-based, up to 5 units |
| **SSFImpactor** | 15 software ports | Contactor/gear/shaker effects as synthesized tactile audio (BASS), no hardware board |

See [DOF Output Controllers](../concepts/DOF%20Output%20Controllers.md) for details.

## Built-in Toys

| Toy | Description |
|-----|-------------|
| **Lamp** | Simple on/off with fading curve |
| **Motor/GearMotor** | Kickstart pulse, min/max power, max runtime |
| **RGBAToy / RGBLed** | RGB LED with multi-layer alpha channel |
| **AnalogAlphaToy** | Single-channel with layers and transparency |
| **LedStrip** | Addressable LED matrix (WS2812, configurable arrangement) |
| **Contactor / ReplayKnocker** | Solenoid-driven impact devices |
| **LedWizEquivalent** | Maps INI columns to outputs (legacy support) |

See [DOF Toys and Effects](../concepts/DOF%20Toys%20and%20Effects.md) for details.

## Built-in Effects

| Effect | Description |
|--------|-------------|
| **RGBFadeOnOff** | Fade RGB color based on trigger value |
| **OnOffEffect** | Simple binary control |
| **DurationEffect** | Activates for specified time |
| **BlinkEffect** | Configurable interval and pulse width |
| **DelayEffect** | Delays trigger signal |
| **AnalogAlphaMatrixBitmapEffect** | Display bitmap on LED matrix |
| **RGBPlasmaEffect** | Plasma animation on matrix |
| **TriggerCondition** | Conditional effect triggering |
| **ValueInvertEffect** | Inverts effect values |

Effects can be chained: `Delay(2s) → Blink(500ms) → Blink(50ms) → RGBFade`

## B2S Server Integration

- **Location**: `DirectOutput_B2SServer_Plugin.dll` in plugins directory
- **Interfaces**: Implements `IDirectPlugin` and `IDirectPluginFrontend`
- **Data Flow**: B2S Server forwards `Controller.B2SSetData(ElementID, Value)` from table scripts
- Separate `Plugins/` (32-bit) and `Plugins64/` (64-bit) folders for architecture support

## DOF Table Configuration Workflow

### Solid State (ROM-based) Tables
1. Replace `CreateObject("VPinMAME.Controller")` with `CreateObject("B2S.Server")`
2. PinMAME data automatically flows through B2S to DOF

### EM / Original Tables
1. Instantiate B2S Server with a fake ROM name
2. Send element updates via `Controller.B2SSetData 205, 1`
3. Create table config XML referencing element IDs

See [DOF Table Configuration](../concepts/DOF%20Table%20Configuration.md) for details.

## PinballX Integration

Separate `DirectOutput PinballX Plugin.dll` loaded via PinballX Plugin Manager. Uses fuzzy matching to identify ROM names. Provides named triggers: `$PBXWheel`, `$PBXMenu`, `$RomName`, etc.

## SSFImpactor

The **DirectOutput Framework R3++ Grand Unified Edition** (distributed from the Pinscape resources site) bundles [SSFImpactor](SSFImpactor.md), a software output controller that emulates solenoids, shakers, and gear motors as synthesized tactile audio routed to exciters — any DOF-responsive table gains impact effects with no output board installed. Its integration path is identical to adding a LedWiz-equivalent device.

## Troubleshooting

| Issue                   | Solution                                                                      |
| ----------------------- | ----------------------------------------------------------------------------- |
| B2S not loading DOF     | Check registry for correct DLL path; multiple B2S installs can conflict       |
| DLLs blocked            | Right-click → Properties → Unblock                                            |
| Effects not triggering  | Verify table script sends `B2SSetData` calls; check config naming matches ROM |
| Hardware not responding | Verify cabinet.xml controller names and output numbers                        |
| INI not loading         | Use `LedControlFileTester.exe` to validate syntax                             |

Enable logging in GlobalConfig editor for debugging. Check log files for initialization errors.

## See Also

- [DOF Output Controllers](../concepts/DOF%20Output%20Controllers.md) — Supported hardware devices
- [DOF Toys and Effects](../concepts/DOF%20Toys%20and%20Effects.md) — Logical devices and effect system
- [B2S Plugins](../concepts/B2S%20Plugins.md) — Plugin architecture in B2S
- [B2S Backglass Server](B2S%20Backglass%20Server.md) — Host application for DOF
- [DOF Table Configuration](../concepts/DOF%20Table%20Configuration.md) — Configuring DOF per table
- [DOF Addressable LEDs](../concepts/DOF%20Addressable%20LEDs.md) — WS2811/WS2812 strip and matrix setup end to end
- [Pinscape Pico](../concepts/Pinscape%20Pico.md) — Controller with its own ini number (120)
- [Pincab Setup](../concepts/Pincab%20Setup.md) — Physical cabinet configuration
- [SSFImpactor](SSFImpactor.md) — Bundled software controller for tactile-audio impact effects
- [Unofficial Visual Pinball Wiki](../sources/Unofficial%20Visual%20Pinball%20Wiki.md) — source collection (secondary)


