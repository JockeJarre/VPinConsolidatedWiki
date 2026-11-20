# Open Pinball Device

Open Pinball Device (OPD) is a new USB HID interface specifically designed for pinball cabinet controllers, supported by [Visual Pinball X](../projects/Visual%20Pinball%20X.md). It replaces generic joystick emulation for [pincab](Pincab%20Setup.md) input devices.

## Why OPD?

Traditional pincab controllers emulate joysticks, which causes:
- Confusion with non-pinball games looking for joystick input
- No way for VPX to know the device is actually a pinball controller
- Extra manual configuration required

With OPD, VPX knows the connected device is a pinball controller, reducing configuration and avoiding interference with other applications. This is a direct improvement over older joystick-emulating cabinet controllers such as the KL25Z-based [Pinscape Controller](../projects/Pinscape%20Controller.md).

## Supported Devices

- **Pinscape Pico** (in development as of Sept 2024)
  - ⚠️ CONFLICT (secondary source): dated status note — the Pico's `openpindev` interface in VPX 10.8.1+ was broken on Windows before **2026-07-24** and on Linux/Mac before **2026-11-09**; use a newer build to access it, and prefer `openpindev` (better performance) over `gamepad` (next best) or `xinput` where the build is new enough
    ([raw/ExternalWikis/dekay-vpinball-wiki/repo/Pinscape-KL25Z-and-Pinscape-Pico-Controllers.md](https://github.com/dekay/vpinball-wiki/wiki/Pinscape-KL25Z-and-Pinscape-Pico-Controllers), §Nudge & Plunger Setup, updated 2026-11-11; supersedes the earlier "broken on Linux per vpinball #3303" report) — Primary: OPD is the intended interface (design stands; the secondary report is a dated platform-status note)
- Specification publicly available: [OpenPinballDeviceHID.htm](http://mjrnet.org/pinscape/OpenPinballDevice/OpenPinballDeviceHID.htm)

## Features

### Pre-Assigned Buttons
Standard pinball buttons (Start, Left Flipper, Right Flipper, Coin In, etc.) are pre-assigned — no VPX configuration needed.

### Generic Buttons
Buttons #1–#32 can be configured like joystick buttons in the VPX Keys dialog.

### Axis Inputs
For [plunger](VPX%20Plunger%20Input.md) and [accelerometer/nudge](VPX%20Accelerometer%20Input.md) inputs, select **OpenPinDev** in the dropdown. No need to specify which axis (unlike joystick X/Y/RX/RY selection).

### Multiple Controllers
- Inputs from multiple OPD controllers are automatically combined
- Assumes one accelerometer and one plunger per system
- Button inputs are OR'd together (any controller's button = active)

### Mixing with Joystick
Fully supports mixing OPD controllers with traditional joystick-emulating devices.

## See Also

- [Visual Pinball X](../projects/Visual%20Pinball%20X.md) — The engine supporting OPD
- [VPX Plunger Input](VPX%20Plunger%20Input.md) — Plunger via OPD
- [VPX Accelerometer Input](VPX%20Accelerometer%20Input.md) — Nudge via OPD
- [Pincab Setup](Pincab%20Setup.md) — Physical cabinet using OPD controllers


