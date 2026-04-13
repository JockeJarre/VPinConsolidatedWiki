# DirectOutput Framework

The DirectOutput Framework (DOF) R3 is an extensible C# framework that connects virtual pinball cabinets to physical hardware feedback devices. It processes table element state changes from [Visual Pinball X](Visual%20Pinball%20X.md) and triggers effects on [DOF Output Controllers](../concepts/DOF%20Output%20Controllers.md) to drive [toys](../concepts/DOF%20Toys%20and%20Effects.md) like contactors, RGB LEDs, solenoids, motors, and shakers.

## Overview

Released autumn 2015, DOF provides a multithreaded architecture ensuring optimal performance without stuttering. It acts as an abstraction layer hiding complex hardware differences, supporting both legacy INI file configuration and powerful XML configuration. DOF operates as a [plugin](../concepts/B2S%20Plugins.md) for [B2S Backglass Server](B2S%20Backglass%20Server.md), receiving table element updates and translating them into physical effects.

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

## Troubleshooting

| Issue | Solution |
|-------|----------|
| B2S not loading DOF | Check registry for correct DLL path; multiple B2S installs can conflict |
| DLLs blocked | Right-click → Properties → Unblock |
| Effects not triggering | Verify table script sends `B2SSetData` calls; check config naming matches ROM |
| Hardware not responding | Verify cabinet.xml controller names and output numbers |
| INI not loading | Use `LedControlFileTester.exe` to validate syntax |

Enable logging in GlobalConfig editor for debugging. Check log files for initialization errors.

## See Also

- [DOF Output Controllers](../concepts/DOF%20Output%20Controllers.md) — Supported hardware devices
- [DOF Toys and Effects](../concepts/DOF%20Toys%20and%20Effects.md) — Logical devices and effect system
- [B2S Plugins](../concepts/B2S%20Plugins.md) — Plugin architecture in B2S
- [B2S Backglass Server](B2S%20Backglass%20Server.md) — Host application for DOF
- [DOF Table Configuration](../concepts/DOF%20Table%20Configuration.md) — Configuring DOF per table
- [Pincab Setup](../concepts/Pincab%20Setup.md) — Physical cabinet configuration


