# VPX Scripting

[Visual Pinball X](../projects/Visual%20Pinball%20X.md) uses VBScript for table game logic. Scripts handle input, physics interactions, display updates, sound, and communication with PinMAME and [B2S Backglass Server](../projects/B2S%20Backglass%20Server.md).

## Global Variables

### Time
| Variable | Description |
|----------|-------------|
| `GameTime` | Milliseconds since table start |
| `PreciseGameTime` | Seconds since table start (high precision) |
| `SystemTime` | Current system time |
| `FrameIndex` | Current rendered frame number |

### Input Keys
`LeftFlipperKey`, `RightFlipperKey`, `PlungerKey`, `StartGameKey`, `AddCreditKey`, `AddCreditKey2`, `LeftMagnaSave`, `RightMagnaSave`, `LeftTiltKey`, `RightTiltKey`, `CenterTiltKey`, `MechanicalTilt`, `ExitGame`, `VolumeUp`, `VolumeDown`

### Rendering
| Variable | Description |
|----------|-------------|
| `RenderingMode` | 0=2D, 1=[Stereo](VPX%20Stereo%203D.md), 2=VR |
| `WindowWidth` / `WindowHeight` | Render target size |

## Key Element Types

### Ball
Position (`X`, `Y`, `Z`), velocity (`VelX`, `VelY`, `VelZ`), `Mass`, `Radius`, `Image`, `Color`, `BulbIntensityScale`, `ForceReflection`, `Visible`

### Flipper
Position, geometry (`BaseRadius`, `EndRadius`, `Length`, `Height`), angles (`StartAngle`, `EndAngle`), physics (`Force`, `Elasticity`, `Strength`, `Scatter`), `CurrentAngle` (read-only).

Methods: `RotateToEnd()`, `RotateToStart()`

### Light
`State` (0=off, 1=on, 2=blinking), `Color`, `Intensity`, `IntensityScale`, `Fader` (None/Linear/Incandescent), `BlinkPattern`, `Shadows` (0=off, 1=raytraced), `FilamentTemperature`. See [VPX Lights and Rendering](VPX%20Lights%20and%20Rendering.md).

### Plunger
`Position()`, `FireSpeed`, `MechPlunger`, `ParkPosition`, `MechStrength`, `Stroke`. Methods: `Pullback()`, `Fire()`, `CreateBall()`. See [VPX Plunger Input](VPX%20Plunger%20Input.md).

### Bumper
Position, `Force`, `RingDropOffset`, `RingSpeed`, `EnableSkirtAnimation`

### Kicker
Methods: `Kick(angle, speed, inclination)`, `CreateBall()`, `DestroyBall(ballId)`, `LastCapturedBall`

### Wall
`HasHitEvent`, `Elasticity`, `Friction`, `Collideable`, `IsDropped`, `Disabled`

### Ramp
`HeightBottom`/`HeightTop`, `WidthBottom`/`WidthTop`, `Type`, `Elasticity`, `Friction`

### Trigger
Position, `Radius`, `TriggerShape`, `Surface`, `HitHeight`

## Key Events

| Event | Description |
|-------|-------------|
| `Table_Init()` | Table initialization |
| `Table_Exit()` | Table teardown (release COM objects, e.g. PuPlayer) |
| `Table_KeyDown(keycode)` | Key pressed |
| `Table_KeyUp(keycode)` | Key released |
| `Animate()` | Visual property sync (10.8+) |
| `Timer_Timer()` | Timer tick |
| `MusicDone()` | Music finished playing |
| `OnBallBallCollision(ball1, ball2, velocity)` | Ball-to-ball collision |

### Animate Event (10.8+)
Replaces timer-based approaches for syncing visual properties. Called automatically when elements animate:

```vbscript
' OLD (10.7) - timer-based flipper shadow
Sub LeftFlipper_Timer()
  FlipperLSh.RotZ = LeftFlipper.CurrentAngle
End Sub

' NEW (10.8) - Animate event
Sub LeftFlipper_Animate()
  FlipperLSh.RotZ = LeftFlipper.CurrentAngle
End Sub
```

## Audio

| Method | Description |
|--------|-------------|
| `PlaySound(name)` | Play sound effect |
| `StopSound(name)` | Stop sound |
| `PlayMusic(name)` | Play background music |
| `MusicVolume(vol)` | Set music volume |

- Table sounds and music may be `Ogg Opus` files (`.opus`, decoded by libopusfile) — added in the 10.8.1 stream ([raw/VPX/repo/docs/Changelog.txt](https://github.com/vpinball/vpinball/blob/master/docs/Changelog.txt))

## DMD Control

| Property | Description |
|----------|-------------|
| `DMDWidth` | DMD pixel width |
| `DMDHeight` | DMD pixel height |
| `DMDPixels` | Byte array (0–100 intensity) for monochrome |
| `DMDColoredPixels` | RGB array for full color |

See [DMD](DMD.md).

## Table Properties

### Physics
`Gravity`, `Friction`, `Elasticity`, `Scatter`, `GlobalDifficulty`, `SlopeMax`/`SlopeMin`, `PhysicsLoopTime`, `NudgeTime`

### Display
`Width`, `Height`, `Inclination`, `Rotation`, `ScaleX`/`ScaleY`/`ScaleZ`, `Layback`, `FieldOfView`

### Lighting
`LightAmbient`, `Light0Emission`, `LightEmissionScale`, `AOScale`, `BloomStrength`

### Stereo
`MaxSeparation`, `ZPD`, `Offset`. See [VPX Stereo 3D](VPX%20Stereo%203D.md).

## Material Control

- `UpdateMaterial(name, ...)` / `GetMaterial(name, ...)` — Dynamic material changes
- `UpdateMaterialPhysics(name, elasticity, friction, scatter)` — Physics material properties
- `MaterialColor(name)` — Base color access

## Serial Communication

For custom hardware integration:
- `GetSerialDevices()` — List COM ports
- `OpenSerial(port)` / `CloseSerial(port)`
- `SetupSerial(baud, bits, parity, stopbit, rts, dtr)`
- `ReadSerial(port)` / `WriteSerial(port, data)`

## PinMAME Helper Classes

Core VBS scripts provide helper classes for common game mechanics:

| Class | Purpose |
|-------|---------|
| `cvpmTrough` | Ball trough management |
| `cvpmSaucer` | Ball saucer/scoop |
| `cvpmMagnet` | Magnetic ball capture |
| `cvpmTurnTable` | Spinning disc mechanics |
| `cvpmMech` | Generic mechanical device |
| `cvpmDropTarget` | Drop target banks |
| `cvpmFlips2` | Flipper management |
| `cvpmNudge` | Nudge handling |

## Utility Methods

| Method | Description |
|--------|-------------|
| `GetCustomParam(1..9)` | Read command-line custom parameters |
| `UserDirectory()` | User data directory path |
| `TablesDirectory()` | Tables folder path |
| `GetBalls()` | Array of all active balls |
| `GetElements()` | Array of all table elements |

## System Script Updates (VPinMAME 3.62, late 2026)

From [raw/VPX/repo/docs/Changelog_Scripts.txt](https://github.com/vpinball/vpinball/blob/master/docs/Changelog_Scripts.txt):

- New system `.vbs` files: `spike1.vbs` (Stern Spike 1), `tecnoplay.vbs` (X Force, Space Team), `wpc_ph.vbs`, `p2k.vbs`, `pinheck.vbs`, `playbar.vbs`
- Hardcoded keys removed from all system scripts: **F12** volume, **F6** dips, **F4** display lock, **F5** double size → all become **in-game UI table options** (VPinMAME COM controller only, not the PinMAME plugin)
- `core.vbs` `cvpmTimer` fixes: `Update` no longer double-copies a queued `GetRef` callback (error 450 halt); `AddTimer2` accepts an object as its ID and fired timers drop the reference; a timer is removed before its callback runs, so an erroring callback no longer blocks queued timers
- `SolOnAboveZero(68)`: solenoids whose modulated value may stay below half while on turn their `SolCallback` on at any value above 0 (with `UseVPMModSol = 2`)

## See Also

- [Visual Pinball X](../projects/Visual%20Pinball%20X.md) — The engine running these scripts
- [VPX Lights and Rendering](VPX%20Lights%20and%20Rendering.md) — Light element details
- [DMD](DMD.md) — DMD scripting interface
- [VPX Plunger Input](VPX%20Plunger%20Input.md) — Plunger script properties
- [B2S Backglass Server](../projects/B2S%20Backglass%20Server.md) — COM interface from scripts


