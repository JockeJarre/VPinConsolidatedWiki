# VPX Plunger Input

Plunger input in [Visual Pinball X](../projects/Visual%20Pinball%20X.md) translates physical plunger movement from a [pincab](Pincab%20Setup.md) controller into in-game ball launching. Two approaches exist: traditional position-based and the newer velocity-based method.

## Position-Based (Traditional)

The controller reports instantaneous plunger position via a joystick axis.

**Problem**: USB polling occurs at ~10ms intervals, but a plunger traverses its full range in ~30ms. VPX sees only 1–2 position readings during a fast pull-and-release, causing "aliasing." VPX uses heuristics to synthesize speed from position, which is imperfect.

## Velocity-Based (Recommended)

The controller's microcontroller measures plunger speed directly at high frequency (~2.5ms intervals minimum) and reports it as a separate axis.

**Advantages:**
- Device has direct high-frequency sensor access
- Actual speed measurement rather than derived speed
- Avoids integration of velocity (which magnifies measurement error)
- VP uses instantaneous speed reading for collision impulse

### Compatible Devices
- **Pinscape Controller (KL25Z)**: Z axis = position, RZ axis = speed
- **Pinscape Pico**: Custom `plunger.z` and `plunger.speed` axes
- The [Pinscape Build Guide](../sources/Pinscape%20Build%20Guide.md) documents several sensor options for the KL25Z generation, including potentiometer and optical approaches

### Setup
In VPX Keys dialog, select both:
- **Plunger Position** axis
- **Plunger Speed** axis (separate dropdown)

## Script Properties

| Property | Description |
|----------|-------------|
| `Position()` | Current position (0–25 range) |
| `FireSpeed` | Launch velocity |
| `MechPlunger` | Enable mechanical plunger input |
| `ParkPosition` | Rest position for mechanical plungers |
| `MechStrength` | Coupling strength to simulation |
| `Stroke` | Plunger travel distance |

Methods: `Pullback()`, `Fire()`, `CreateBall()`

## See Also

- [Visual Pinball X](../projects/Visual%20Pinball%20X.md) — The engine handling plunger input
- [Open Pinball Device](Open%20Pinball%20Device.md) — New HID interface for plunger
- [VPX Accelerometer Input](VPX%20Accelerometer%20Input.md) — Related input system for nudge
- [VPX Latency](VPX%20Latency.md) — Input latency considerations
- [VPX Scripting](VPX%20Scripting.md) — Plunger script interface
- [Pinscape Controller](../projects/Pinscape%20Controller.md) — Common plunger-capable cabinet controller



