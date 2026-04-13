# VPX Latency

Latency in [Visual Pinball X](../projects/Visual%20Pinball%20X.md) is the delay between a physical action (button press, nudge) and its visible result on screen. Minimizing it is critical for a responsive pinball experience, especially in [pincab setups](Pincab%20Setup.md).

## Three Types of Latency

### 1. Input Latency
Time from physical stimulus to VPX processing. Target: **<1ms**. VPX polls input continuously.

### 2. Physics/Emulation Latency
Time from input event to emulation awareness. Typically **~0.5ms** for WPC machines. Optimized with FastFlips (see below).

### 3. Visual Latency
Time from game state change to display. Typically **7–10ms** on optimized hardware. Most complex to minimize.

## Latency Chain (Button Press → Flipper Movement)

1. Physical button press → mechanical contact
2. USB transmission via pinball input device
3. Windows input API processing
4. VPX reads input, notifies table script
5. Script updates switch state for PinMAME
6. PinMAME emulates CPU, toggles virtual solenoid
7. VPX syncs with PinMAME, script notifies physics engine
8. Physics engine moves flipper
9. Renderer draws new frame
10. Display presents frame

## FastFlips Optimization

Skips the standard solenoid emulation chain: applies flipper changes immediately rather than waiting for the PinMAME CPU emulation cycle. Crucial for DX9/OpenGL where input is sampled at framerate (~16.6ms at 60Hz). Reduces latency below the standard 0.5ms physics loop.

## Optimization Strategies

- **Use BGFX build** — Multithreaded engine decouples rendering from gameplay
- **Fullscreen or fullscreen window** — Avoids desktop composition overhead
- **Check display mode via PresentMon** — Aim for "Hardware: Independent Flip"
- **Disable post-processing** — Reduces render time
- **Disable V-Sync** if possible — Removes frame-sync wait
- **TV/Monitor "Game Mode"** — Reduces display processing
- **Latency Correction** — Renders balls at predicted position. Set to -1 (auto) or specific ms value

## Registry Keys

| Key | Description |
|-----|-------------|
| `EnableLegacyMaximumPreRenderedFrames` | Force VP9.x pre-rendered frame discard |
| `MinPhysLoopTime` | Artificially extend physics loop (microseconds, 900 recommended) |
| `PhysicsMaxLoops` | Override max physics iterations per frame |

## See Also

- [Visual Pinball X](../projects/Visual%20Pinball%20X.md) — The engine with latency settings
- [VPX Plunger Input](Plunger%20Input.md) — Plunger-specific latency concerns
- [VPX Accelerometer Input](Accelerometer%20Input.md) — Nudge input latency
- [VPX View Setup](View%20Setup.md) — Rendering mode affects visual latency


