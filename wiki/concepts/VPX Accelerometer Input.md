# VPX Accelerometer Input

Accelerometer input in [Visual Pinball X](../projects/Visual%20Pinball%20X.md) translates physical cabinet nudging from [pincab](Pincab%20Setup.md) controllers into in-game ball physics. Two approaches exist: traditional acceleration-based and the newer velocity-based method.

## Acceleration-Based (Traditional)

The controller reports raw instantaneous accelerations. The microcontroller scales values and applies auto-calibration. VPX applies acceleration each time step: `velocity += acceleration`.

**Problems:**
- Asynchronous USB resampling causes over/under-counting (~10% frequency mismatch in practice)
- Can miss peak values or count the same sample twice
- Causes velocity accumulation/drift requiring "Nudge Filter"
- Inconsistent gain tuning experience

## Velocity-Based (Recommended)

The controller performs integration internally: `velocity = Σ(acceleration × Δt)`. VPX reads instantaneous velocity instead of raw acceleration.

**Advantages:**
- Eliminates aliasing problems — correct velocity regardless of USB polling misalignment
- High-frequency device sampling (up to 1000 Hz) for more accurate integration
- No drift accumulation — every USB read is instantaneous state, not a running total
- Overcomes the fundamental limitation of asynchronous PC-based integration

### Device-Side Filtering
- **DC removal**: Subtracts constant bias/gravity component
- **Noise filtering**: Hysteresis/jitter filtering preferred over dead zones
- **Friction filtering**: Gentle attenuation with ~2 second half-life (feels natural)

### Compatible Devices
- **Pinscape KL25Z**: X/Y = accelerations, RX/RY = velocity
- **Pinscape Pico**: `nudge.x`/`nudge.y` (acceleration) and `nudge.vx`/`nudge.vy` (velocity)

The KL25Z generation documented in the [Pinscape Build Guide](../sources/Pinscape%20Build%20Guide.md) also stresses cabinet mounting details: mount the board flat, square with the cabinet, close to the front, and firmly attached so the accelerometer tracks cabinet motion accurately.

### Setup in VPX
1. Check **"Analog Nudge Input is Velocity"**
2. **UNCHECK** "Enable Nudge Filter" (that's only for acceleration input)
3. Set X/Y gain percentages (experiment with Nudge Test Table)
4. Configure board mounting orientation and rotation settings

## See Also

- [Visual Pinball X](../projects/Visual%20Pinball%20X.md) — The engine handling nudge input
- [Open Pinball Device](Open%20Pinball%20Device.md) — New HID interface for accelerometer
- [VPX Plunger Input](VPX%20Plunger%20Input.md) — Related input system for plunger
- [VPX Latency](VPX%20Latency.md) — Input latency considerations
- [Pinscape Controller](../projects/Pinscape%20Controller.md) — Common accelerometer-based cabinet controller



