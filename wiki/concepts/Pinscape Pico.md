# Pinscape Pico

The Pinscape Pico is the second-generation [Pinscape Controller](../projects/Pinscape%20Controller.md) by mjr, built on the Raspberry Pi **RP2040** microcontroller. It covers cabinet buttons, analog nudge, plunger sensing, IR output, and [DOF](../projects/DirectOutput%20Framework.md) identity, configured through a JSON file and exposed to VPX as a gamepad, xInput device, or Open Pinball Device.

> Source: community wiki (secondary). The Pinscape build guide (primary) covers the KL25Z generation; the community Pinscape guide is the main Pico setup reference.

## Device Interfaces

The Pico presents one of three interfaces to the host; VPX sees each differently ([raw/ExternalWikis/dekay-vpinball-wiki/repo/Pinscape-KL25Z-and-Pinscape-Pico-Controllers.md](https://github.com/dekay/vpinball-wiki/wiki/Pinscape-KL25Z-and-Pinscape-Pico-Controllers)

| Interface | Notes |
|-----------|-------|
| **`gamepad`** (HID gamepad + keyboard) | Preferred on VPX 10.8.1+ |
| **`xInput`** | Fallback when a host (e.g. OnePlus Pad3) doesn't recognize the Pico's HID gamepad; **max 15 buttons** (15 valid xInput button names) |
| **`openpindev`** (Open Pinball Device) | ⚠️ detection broken on Linux per vpinball issue #3303 — "Use the `gamepad` (preferred) or `xinput` interfaces instead" |

- ⚠️ CONFLICT (secondary source): OpenPinDev detection on the Pico is broken (Linux); use gamepad/xInput
  ([raw/ExternalWikis/dekay-vpinball-wiki/repo/Pinscape-KL25Z-and-Pinscape-Pico-Controllers.md](https://github.com/dekay/vpinball-wiki/wiki/Pinscape-KL25Z-and-Pinscape-Pico-Controllers), §Nudge & Plunger Setup) — Primary: [Open Pinball Device](Open%20Pinball%20Device.md) recommends selecting OpenPinDev for plunger/nudge input; Pico support "in development as of Sept 2024". Status (secondary) beats design (primary) — dated 2026 note

## Canonical VPX 10.8.1+ Mapping

VPX 10.8.1+ accepts simultaneous position+speed plunger and velocity+acceleration nudge. Each reading needs its **own axis**; axis choice is arbitrary (IMPORTANT callout in the guide). The guide's gamepad JSON:

| Axis | Reading |
|------|---------|
| `rx`, `ry` | nudge **acceleration** x/y |
| `x`, `y` | nudge **velocity** x/y |
| `rz` | `plunger.z0` (instantaneous position) |
| `z` | `plunger.speed` |

- **`plunger.z0` is recommended over `plunger.z`** for speed-capable programs (mjr's PlungerCal help, quoted in the guide) — with a speed sensor, Z0 reports position directly
  - ⚠️ CONFLICT (secondary source): use `plunger.z0`
    ([raw/ExternalWikis/dekay-vpinball-wiki/repo/Pinscape-KL25Z-and-Pinscape-Pico-Controllers.md](https://github.com/dekay/vpinball-wiki/wiki/Pinscape-KL25Z-and-Pinscape-Pico-Controllers) — Primary: [VPX Plunger Input](VPX%20Plunger%20Input.md) lists "Custom `plunger.z` and `plunger.speed` axes" for the Pico
- **VPX bug vpinball #4055** (late Sept 2026): configuring both plunger position *and* velocity misbehaves — workaround: set the velocity sensor to `Unmapped`
- xInput mapping: `xLeft/yLeft = nudge.x/y`, `leftTrigger = plunger.z0`, `xRight/yRight = nudge.vx/vy`, `rightTrigger = plunger.speed`; buttons use `action:{type:"xInput"}`
- VPX merges all joystick inputs — route each sensor to exactly one emulated device (mjr)

## VPX LiveUI Settings for Pinscape

Guide reorganized upstream 2026-11-05: the Nudge & Plunger chapter is now split into **Setup** (Pico JSON/gamepad wiring, above) and **Settings** (VPX LiveUI, below); the Settings steps also work for the KL25Z and largely for other controllers ([raw/ExternalWikis/dekay-vpinball-wiki/repo/Pinscape-KL25Z-and-Pinscape-Pico-Controllers.md](https://github.com/dekay/vpinball-wiki/wiki/Pinscape-KL25Z-and-Pinscape-Pico-Controllers))

- Entry point: **F12** LiveUI → `Nudge & Tilt Settings` → *Add a new nudge sensor*; `Plunger Settings` → *Add a new plunger sensor* (screenshots `img/settings/AddNudgeSensor.jpg`, `NudgeSettings.jpg`, `AddPlungerSensor.jpg`, `PlungerSettings.jpg` upstream)
- **Nudge Sensor Type**: `Cabinet Sensor` for a classic four-legged pincab that springs back to position; **`Intent Sensor`** (guide's wording) for free-sliding devices that do not spring back (PinOne Mini, VirtuaTilt X-Arcade). `Cabinet Weight` is shown only for `Cabinet Sensor`
- Set the real **Cabinet Weight** (not the 1 kg default)
- Acceleration Sensor Unit = **2 Gravity** (unit scale auto 2×9.80665 = 19.613 m/s²); leave Unit scale alone — it auto-computes. Pinscape firmware should use the 2G range
- Velocity Sensor Unit = **0.2048 m/s [Pinscape nudge velocity]**; plunger velocity unit = **12.5 p.u/s [Pinscape plunger velocity]**; plunger Position Unit Scale = 1 to start
- All four nudge sensors on **separate** inputs; plunger Position and Velocity on **separate** inputs; empty dropdown lists mean VPX is not recognizing the sensor
- Boards without velocity-over-USB (e.g. PinOne): leave the velocity sensors `unmapped` — VPX computes velocity
- **Verification**: after setup, sensor values are plotted in a graph on each settings page — nudge the cabinet and shoot the plunger to catch swapped pairs (nudge Acceleration↔Velocity, plunger Velocity↔Position)

- ⚠️ CONFLICT (secondary source): nudge **acceleration on `rx`/`ry`**, velocity on `x`/`y`
  ([raw/ExternalWikis/dekay-vpinball-wiki/repo/Pinscape-KL25Z-and-Pinscape-Pico-Controllers.md](https://github.com/dekay/vpinball-wiki/wiki/Pinscape-KL25Z-and-Pinscape-Pico-Controllers) — "These setup instructions also work for the KL25Z") — Primary: [VPX Accelerometer Input](VPX%20Accelerometer%20Input.md) documents "KL25Z: X/Y = accelerations, RX/RY = velocity". Both work — the guide itself calls axis choice arbitrary; do not "fix" one page into the other

## DOF and Misc

- DOF ini identity: Pinscape = `directoutputconfig51.ini`, **Pinscape Pico = `directoutputconfig120.ini`** ([raw/ExternalWikis/dekay-vpinball-wiki/repo/DOF---The-Direct-Output-Framework.md](https://github.com/dekay/vpinball-wiki/wiki/DOF-%E2%80%90-The-Direct-Output-Framework); Pico config carries `id.unitNum` / `ledWizUnitNum` plumbing
- **IR remote**: from Linux via `hidapitester` (vidpid `fafa:eaeb`); the Pico uses its **own IR encoding** — standard IR codes from the internet do not work (sample: little-endian byte-swap, send ×3)
- Coin-door **NC switch** → `End` key via `type:"pulse"` (fires on open and close); debounce defaults 1500/1000 µs
- Windows 11 hazard: an accelerometer mapped to the xInput **left** stick pops the Start menu — map acceleration to the **right** axis

## KL25Z Notes Carried Here

([raw/ExternalWikis/dekay-vpinball-wiki/repo/Pinscape-KL25Z-and-Pinscape-Pico-Controllers.md](https://github.com/dekay/vpinball-wiki/wiki/Pinscape-KL25Z-and-Pinscape-Pico-Controllers), §Pinscape KL25Z)

- The newest FRDM-KL25Z boards (**USB-C port**) have **no onboard accelerometer** — only older micro-USB stock does; buy old stock or move to the Pico
  - ⚠️ CONFLICT (secondary source): USB-C KL25Z stock lacks the accelerometer
    ([raw/ExternalWikis/dekay-vpinball-wiki/repo/Pinscape-KL25Z-and-Pinscape-Pico-Controllers.md](https://github.com/dekay/vpinball-wiki/wiki/Pinscape-KL25Z-and-Pinscape-Pico-Controllers), CAUTION) — Primary: [Pinscape Controller](../projects/Pinscape%20Controller.md) states "the KL25Z's built-in accelerometer" unqualified
- Pinscape **resets every 10 s if its joystick output is not read**, killing keyboard events during resets; fix: Config Tool "Reboot on Disconnect" off, or set config var 12 `disconnectRebootTimeout=0` and save to flash

## PINPAD Reference Build

A community docking station for an Android tablet: a plain Raspberry Pi Pico running Pinscape Pico firmware, **VL6180x** time-of-flight plunger sensor on I2C0, LIS3DSH nudge on I2C1 (heading says LIS3DH — file internally inconsistent). Durable facts ([raw/ExternalWikis/dekay-vpinball-wiki/repo/PINPAD---a-Dockingstation-for-an-Android-Tablet-using-a-Pinscape-Pico-2040-as-Inputdevice.md](https://github.com/dekay/vpinball-wiki/wiki/PINPAD-%E2%80%90-a-Dockingstation-for-an-Android-Tablet-using-a-Pinscape-Pico-2040-as-Inputdevice)

- Nudge: **MMA8451 works; generic MMA845x is not supported** — buy the exact chip
- **iPad recognizes only a keyboard** as input device — attached Pico sensors do not work there
- Android tablet (OnePlus Pad3) recognized the Pico **only via xInput**

## See Also

- [Pinscape Controller](../projects/Pinscape%20Controller.md) — KL25Z generation and the build guide
- [VPX Plunger Input](VPX%20Plunger%20Input.md) / [VPX Accelerometer Input](VPX%20Accelerometer%20Input.md) — VPX-side input model
- [Open Pinball Device](Open%20Pinball%20Device.md) — the standard interface
- [DOF Output Controllers](DOF%20Output%20Controllers.md) — per-device ini numbering
- [Unofficial Visual Pinball Wiki](../sources/Unofficial%20Visual%20Pinball%20Wiki.md) — source collection (secondary)
