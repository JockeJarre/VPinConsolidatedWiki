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
  - ⚠️ CONFLICT (secondary source): mjr's config help "recommends the use of `z0`" — use **`plunger.z0`** (instantaneous position) instead of `plunger.z` for speed-capable programs (VPX 10.8.1+)
    ([raw/ExternalWikis/dekay-vpinball-wiki/repo/Pinscape-KL25Z-and-Pinscape-Pico-Controllers.md](https://github.com/dekay/vpinball-wiki/wiki/Pinscape-KL25Z-and-Pinscape-Pico-Controllers), quoting PlungerCal.htm) — Primary: `plunger.z` + `plunger.speed` axis names
  - ⚠️ CONFLICT (secondary source): VPX bug (vpinball issue #4055, late Sept 2026) — with both position *and* velocity configured the plunger "behaves strangely"; workaround: set the Velocity sensor to **Unmapped**
    ([raw/ExternalWikis/dekay-vpinball-wiki/repo/Pinscape-KL25Z-and-Pinscape-Pico-Controllers.md](https://github.com/dekay/vpinball-wiki/wiki/Pinscape-KL25Z-and-Pinscape-Pico-Controllers) — Primary: the Setup section above prescribes selecting both axes
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
- [Pinscape Pico](Pinscape%20Pico.md) — Pico mapping guidance



