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

For cabinet setups, use **Window Projection** mode in VPX — see [VPX View Setup](View%20Setup.md). This simulates the player positioned at the side of a real screen. Configure screen dimensions in centimeters for accurate perspective.

## Hardware Feedback

[DOF](../projects/DirectOutput%20Framework.md) connects to physical [DOF Output Controllers](Output%20Controllers.md) to drive:
- **Solenoids/contactors** for flipper and bumper feedback
- **Motors/shakers** for vibration
- **RGB LEDs** for ambient lighting
- **Fans** for air effects

See [DOF Toys and Effects](DOF%20Toys%20and%20Effects.md) for the full device catalog.

## Audio

- Use AppAudioConfig from Nirsoft for per-application volume levels
- PinVol (`PinVolSettings.ini`) consolidates PinUp forms under one volume entry
- EqAPO for audio equalization with SSF (Surround Sound Feedback) integration

## Frontend Integration

Frontends like PinUp Popper manage table selection and launching. B2SRandom can randomize [backglasses](Backglass.md) per session via the launch script:
```cmd
CALL C:\vPinball\B2SServer\B2STools\B2SRandom.cmd "[GAMEFULLNAME]"
```

## See Also

- [Screen Configuration](Screen%20Configuration.md) — Monitor layout configuration
- [VPX View Setup](View%20Setup.md) — VPX camera/projection for cabinets
- [Backglass](Backglass.md) — Backglass display on secondary monitor
- [DMD](DMD.md) — Digital Message Display
- [DOF Output Controllers](Output%20Controllers.md) — Hardware driving cabinet feedback
- [B2S Backglass Server](../projects/B2S%20Backglass%20Server.md) — Manages backglass rendering
- [DirectOutput Framework](../projects/DirectOutput%20Framework.md) — Drives physical feedback


