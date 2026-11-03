# SSFImpactor

The SSFImpactor is a software-based, LEDWiz-like [DOF Output Controller](../concepts/DOF%20Output%20Controllers.md) that produces force-feedback effects for virtual pinball cabinets without any output hardware. It emulates the physical character of solenoids, shakers, and gear motors by synthesizing tactile audio signals and sending them through sound-card channels to exciters and shakers connected to amplifiers.

## Overview

- Enhances force feedback on tables that carry [Surround Sound Feedback (SSF)](../concepts/Pincab%20Setup.md) configurations, and allows control of those effects via [DOF](DirectOutput%20Framework.md)
- SSF does **not** replace table sounds: it adds the sensation of physical impact for solenoids, and replaces "playback samples" of pulses and gear motors with dynamic software-generated ones whose parameters are controlled by DOF
- Once installed and configured, SSFImpactor adds its effect to **any table that responds to DOF commands**, "just like a LEDWiz would"
- Uses the BASS audio library internally; its 15 output ports are enumerated in `DirectOutput.log` at startup
- Support lives on the Surround Sound Feedback Facebook group and the VPinball.com SSF forum

## Installation

- **Official installer**: SSFImpactor is included in the DirectOutput Framework R3++ Grand Unified Edition, distributed from the Pinscape resources site (`mjrnet.org/pinscape/dll-updates.html`) — see [Pinscape Controller](Pinscape%20Controller.md)
- **Group beta zips**: contain `DirectOutput.dll`, `B2SServerDirectOutputPlugin.dll`, the guide, and DOF configuration files. Hand-edited `directoutputconfig.ini` files must **not** be replaced by the zip versions
- **"Instant DOF" path** (no existing DOF): the `InstantDOF+SSF.zip` unpacks a `DirectOutput` folder (copy to `C:\DirectOutput`) and a `Tables` folder (copy into the Visual Pinball Tables folder). Verification uses `DirectOutputConfigTester` with `GlobalConfig_B2SServer.xml`: Activate All / Deactivate All should click every solenoid, run the gear motor, and vibrate the cab with the shaker
- The guide repeatedly warns: **turn down amps/volume before testing**

## Configuration (Cabinet.xml)

SSFImpactor is defined as an `<SSFImpactController>` entry in the `<OutputControllers>` section:

| Tag | Example | Description |
|-----|---------|-------------|
| `<Name>` | `SSFImpactor` | Controller name |
| `<FrontExciters>` | `Rear` | Speaker-pair channel for front exciters |
| `<RearExciters>` | `RearCenter` | Speaker-pair channel for rear exciters |
| `<Shaker1>` / `<Shaker2>` | `RearCenter` / `Rear` | Channels for the two shakers |
| `<LowImpactMode>` | `false` | Reduced-impact mode toggle |
| `<ImpactFactor>` | `100` | Global mix level of SSFImpactor effects, 0–100% |
| `<ShakerImpactFactor>` | `100` | Shaker effect level, 0–100%; **not** scaled by ImpactFactor |
| `<FlipperLevel>` | `25` | Flipper impact level, relative to ImpactFactor |
| `<BumperLevel>` | `75` | Pop bumper level, relative to ImpactFactor |
| `<SlingsLevel>` | `100` | Sling level, relative to ImpactFactor |
| `<GearLevel>` | `65` | Gear motor level, 0–100%; **not** scaled by ImpactFactor |
| `<DeviceNumber>` | `2` | BASS audio output device index (from `DirectOutput.log`) |

Audio levels can additionally be tuned with amp crossovers, Windows audio driver enhancements, and equalization software (see EqAPO on [Pincab Setup](../concepts/Pincab%20Setup.md)).

## Output Ports

SSFImpactor exposes 15 fixed ports (log shows ports 0–13; port 14 appears in the canonical Cabinet.xml mapping):

| Port | Output | Port | Output |
|------|--------|------|--------|
| 0 | FlipperLeft | 8 | 10-BumperMiddleCenter |
| 1 | FlipperRight | 9 | 10-BumperMiddleRight |
| 2 | SlingshotLeft | 10 | Knocker |
| 3 | SlingshotRight | 11 | Shaker |
| 4 | 10-BumperBackLeft | 12 | Gear |
| 5 | 10-BumperBackCenter | 13 | HellBallMotor |
| 6 | 10-BumperBackRight | 14 | Bell |
| 7 | 10-BumperMiddleLeft | | |

## Audio Routing

- The target audio device is set with `<DeviceNumber>`; SSFImpactor logs all BASS devices at startup (e.g. `BASS device 2 is Realtek Digital Output`)
- Exciter tags address **speaker pairs**: `Front` (ch 1/2), `Rear` (ch 3/4), `CenterLFE` (ch 5/6), `RearCenter` (ch 7/8). Single-channel values (`Left`, `Right`, `FrontLeft`, `FrontRight`, `RearLeft`, `RearRight`, `Center`, `LFE`, `RearCenterLeft`, `RearCenterRight`) are valid for shaker signals
- ⚠️ The guide warns that SSF signals are designed for tactile exciters: they sound terrible on speakers and **can damage them**. SSF is "not a sub thump" — re-routing everything to subs defeats tactile feedback

## Integration with an Existing DOF Setup

Adding SSFImpactor follows standard DOF procedure for a new LedWiz-equivalent device:

1. Add the `<SSFImpactController>` to `<OutputControllers>` in `Cabinet.xml`
2. Map its outputs in the DOF Config Tool as a new LedWiz-equivalent device and increase the LedWiz device count
3. Generate the `directoutput*.*` config files into the Tables folder
4. Align the SSFImpactor directives with the assigned LedWiz output numbers

The appendix ships a canonical `Cabinet.xml` where each port is wrapped in [DOF toys](../concepts/DOF%20Toys%20and%20Effects.md) — `<Contactor>` toys (slings, flippers, bumpers, shaker, gear, motor, bell), a `<ReplayKnocker>`, and `<LedWizEquivalentOutput>` entries mapping ports 0–14 to LedWiz output numbers 1–15.

## Visual Pinball Settings

For full effect, VPX must have DOF and sound effects enabled together. The guide's screenshots show the DOF Controller Options dialog (Contactors, Knocker, Chimes, Bell, Gear, Shaker, Sound FX, Flippers, Targets, Drop Targets) — these options only apply to tables that use the controller VBS in their script code.

## Reference Cabinet

The "out of the box" configuration targets the **SSF Impactor Reference Cabinet**: a single 7.1 audio card where the front outputs carry backbox/game audio and the surround channels carry table/mechanical/SSF sounds, with exciters connected to 2.1 amps with crossovers. The appendix wiring diagram adds full-range speakers, two bass shakers (front shaker on a Dayton Audio TCS-8 PICK-UP for its low-frequency response), a subwoofer, and multiple 2.1 amps; Windows speaker setup enables channel positioning with per-channel bass settings.

## See Also

- [DirectOutput Framework](DirectOutput%20Framework.md) — The framework that drives SSFImpactor
- [DOF Output Controllers](../concepts/DOF%20Output%20Controllers.md) — Controller catalog including SSFImpactor
- [DOF Toys and Effects](../concepts/DOF%20Toys%20and%20Effects.md) — Contactor/Knocker toys and LedWizEquivalent mapping
- [Pincab Setup](../concepts/Pincab%20Setup.md) — Cabinet audio and SSF context
- [SSFImpactor Guide](../sources/SSFImpactor%20Guide.md) — Source documentation summary
