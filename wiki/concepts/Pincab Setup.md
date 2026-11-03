# Pincab Setup

A pincab (pinball cabinet) is a physical cabinet housing monitors and hardware to simulate a real pinball machine. The virtual pinball ecosystem — [VPX](../projects/Visual%20Pinball%20X.md), [B2S Backglass Server](../projects/B2S%20Backglass%20Server.md), and [DOF](../projects/DirectOutput%20Framework.md) — is designed to work together in this setup.

## Typical Cabinet Layout

### Dual Screen (Standard)
- **Screen 1 (Playfield)**: Large TV/monitor mounted horizontally, viewed from above
- **Screen 2 (Backglass)**: Smaller monitor mounted vertically behind the playfield
- Optional: Dedicated [DMD](DMD.md) display

### Three Screen
- Screen 1: Playfield
- Screen 2: [Backglass](Backglass.md)
- Screen 3: DMD and/or Topper

### Single Screen (Desktop)
- All elements on one display — backglass and DMD as floating windows
- Disable exclusive fullscreen in VPX for window visibility
- Enable "Bring form to front" in B2S Settings

## Windows Display Requirements

- All screens **aligned horizontally on Y=0** in Windows Display Settings
- All monitors set to **100% scaling**
- Keep consistent screen order — changing it requires updating all [screen configuration](Screen%20Configuration.md) files

Verify alignment with PowerShell:
```powershell
Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.Screen]::AllScreens
```

## 64-bit Setup Guide

For a complete 64-bit pincab environment:

1. **VPX**: Install both x86 and x64 versions from GitHub
2. **VPinMAME**: Register both 32-bit (`Setup.exe`) and 64-bit (`Setup64.exe`)
3. **Freezy DMD extensions** (2.0+) for improved 64-bit support
4. **FlexDMD** (v1.9+) if needed
5. **B2S Server**: Runs as AnyCPU; set up separate `Plugins/` and `Plugins64/` folders
6. **DOF**: Install for both architectures
7. **Frontend** (e.g., PinUp Popper): Configure to launch appropriate architecture per table

## Camera / View Configuration

For cabinet setups, use **Window Projection** mode in VPX — see [VPX View Setup](VPX%20View%20Setup.md). This simulates the player positioned at the side of a real screen. Configure screen dimensions in centimeters for accurate perspective.

## Cabinet I/O Hardware

A common DIY control stack is [Pinscape Controller](../projects/Pinscape%20Controller.md). In a single KL25Z-based setup it can cover cabinet buttons, analog nudging, plunger sensing, and optionally cabinet outputs for feedback devices.

## Hardware Feedback

[DOF](../projects/DirectOutput%20Framework.md) connects to physical [DOF Output Controllers](DOF%20Output%20Controllers.md) to drive:
- **Solenoids/contactors** for flipper and bumper feedback
- **Motors/shakers** for vibration
- **RGB LEDs** for ambient lighting
- **Fans** for air effects

A cabinet without an output board can use [SSFImpactor](../projects/SSFImpactor.md) instead: a software DOF controller that renders contactor, gear, and shaker effects as tactile audio sent to exciters and shakers through the sound card.

See [DOF Toys and Effects](DOF%20Toys%20and%20Effects.md) for the full device catalog.

## Audio

- Use AppAudioConfig from Nirsoft for per-application volume levels
- PinVol (`PinVolSettings.ini`) consolidates PinUp forms under one volume entry
- EqAPO for audio equalization with SSF (Surround Sound Feedback) integration
- SSF cabinets route tactile signals to exciters via surround channels into 2.1 amps with crossovers — never plain speakers (risk of damage); see [SSFImpactor](../projects/SSFImpactor.md)

## Frontend Integration

Frontends like PinUp Popper manage table selection and launching. B2SRandom can randomize [backglasses](Backglass.md) per session via the launch script:
```cmd
CALL C:\vPinball\B2SServer\B2STools\B2SRandom.cmd "[GAMEFULLNAME]"
```

## DOF Safety Rules

Field rules from the authoring community ([raw/ExternalWikis/vpw-wiki/repo/docs/guides/hardware-cabinet.md](https://vpw-wiki.skirmishofwit.com/guides/hardware-cabinet/), 2026 extraction):

- Solenoid-related DOF outputs must use **`DOFPulse`, never `DOFOn`** — a table whose GI code sent `DOFOn` left solenoids continuously energized and burnt fuse/solenoid hardware
- `DOFOn` is reserved for flippers, button lights, and RGB effects; diverters get pulses without contactors — only flippers stay energized
- Cap solenoid outputs with a maximum-duration setting (e.g. `S5 MAX100`) so a stuck on-signal cannot cook a coil
- Use DOTK v0.09 when developing DOF table effects (v0.10 had bugs)

## Nudge and Tilt

- VPX 10.8.1 includes native tilt plumb-through: cabinet nudge input reaches the emulated ROM tilt bob directly, no table-script shim required
- Three nudge models are available — legacy digital nudge key, accelerometer (native), and analog nudge via a [Pinscape controller](../projects/Pinscape%20Controller.md); analog is preferred for proportional, ROM-accurate tilt ([raw/ExternalWikis/vpw-wiki/repo/docs/guides/hardware-cabinet.md](https://vpw-wiki.skirmishofwit.com/guides/hardware-cabinet/), 2026 extraction). See [VPX Accelerometer Input](VPX%20Accelerometer%20Input.md)
- Budget trick: mount the coin door so leaning on the glass closes a micro-switch wired as the nudge button ([raw/ExternalWikis/vpw-wiki/repo/docs/guides/hardware-cabinet.md](https://vpw-wiki.skirmishofwit.com/guides/hardware-cabinet/), 2026 extraction)

## Known Hardware-Side Gotchas

- **Analog plunger seat position**: keyboard-emulation pluggers (ServoSting, encoders in keyboard mode) can report a resting value VPX reads as pulled, so tables drop the ball mid-multiball; fix by using raw-axis mode (Pinscape analog plunger) so the device is a true joystick axis ([raw/ExternalWikis/vpw-wiki/repo/docs/guides/hardware-cabinet.md](https://vpw-wiki.skirmishofwit.com/guides/hardware-cabinet/), 2026 extraction)
- POV calibration for cabinets (Inclination 6–20, FOV 29–45, Layback 42–70) — see the conflict note in [VPX View Setup](VPX%20View%20Setup.md)

## See Also

- [Screen Configuration](Screen%20Configuration.md) — Monitor layout configuration
- [VPX View Setup](VPX%20View%20Setup.md) — VPX camera/projection for cabinets
- [Backglass](Backglass.md) — Backglass display on secondary monitor
- [DMD](DMD.md) — Digital Message Display
- [DOF Output Controllers](DOF%20Output%20Controllers.md) — Hardware driving cabinet feedback
- [B2S Backglass Server](../projects/B2S%20Backglass%20Server.md) — Manages backglass rendering
- [DirectOutput Framework](../projects/DirectOutput%20Framework.md) — Drives physical feedback
- [SSFImpactor](../projects/SSFImpactor.md) — Software controller for tactile-audio feedback
- [Pinscape Controller](../projects/Pinscape%20Controller.md) — Common DIY cabinet input/output controller
- [Pinscape Pico](Pinscape%20Pico.md) — Second-generation cabinet controller
- [DOF Addressable LEDs](DOF%20Addressable%20LEDs.md) — Strip/matrix wiring, firmware, configuration
- [VPX Standalone](VPX%20Standalone.md) — Non-Windows cabinet builds
- [VPX File Layout](VPX%20File%20Layout.md) — Per-table file organization


