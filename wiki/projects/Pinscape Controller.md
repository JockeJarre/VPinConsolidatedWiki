# Pinscape Controller

Pinscape Controller is an open-source virtual pinball cabinet I/O platform built around the Freescale/NXP KL25Z microcontroller board. It combines button input, analog nudge sensing, plunger sensing, and optional feedback-output control in a single Windows-configurable controller.

## Overview

The Pinscape guide presents Pinscape as a DIY cabinet controller that can replace several separate devices at once:

- Key encoder for flipper, start, coin, and service buttons
- Analog nudge controller using the KL25Z's built-in accelerometer (see the USB-C caveat under Hardware Variants)
- Mechanical plunger interface with multiple sensor options
- Feedback output controller, either directly on the KL25Z or through expansion boards

The design is open source in both firmware and hardware. The controller is configured with a Windows Config Tool rather than by editing firmware directly for normal setups.

## Hardware Variants

### Standalone KL25Z

The simplest build uses only the KL25Z board. In that mode, Pinscape can already handle button input, accelerometer nudging, and plunger sensing with compatible sensors. It can also drive feedback devices, but high-power devices require external booster circuitry.

The second-generation controller is the RP2040-based [Pinscape Pico](../concepts/Pinscape%20Pico.md), which the community wiki documents in detail. Two community observations apply to the KL25Z generation as well:

- ⚠️ CONFLICT (secondary source): "The newest version of the FRDM-KL25Z development board **does not** have the onboard accelerometer… If the board has a USB-C port, it will be the newer version" — buy micro-USB-era old stock or move to the Pico
  ([raw/dekay-vpinball-wiki/Pinscape-KL25Z-and-Pinscape-Pico-Controllers.md](https://github.com/dekay/vpinball-wiki/wiki/Pinscape-KL25Z-and-Pinscape-Pico-Controllers), CAUTION) — Primary: the build guide assumes every KL25Z has the onboard MMA845x accelerometer
- Pinscape **resets every 10 seconds if its joystick output is not being read**, which drops keyboard events during each reset; fix by unchecking "Reboot on Disconnect" in the Config Tool, or set config variable 12 (`disconnectRebootTimeout=0`) and save to flash ([raw/dekay-vpinball-wiki/Pinscape-KL25Z-and-Pinscape-Pico-Controllers.md](https://github.com/dekay/vpinball-wiki/wiki/Pinscape-KL25Z-and-Pinscape-Pico-Controllers), §KL25Z quirks)

### Expansion Boards

The guide also documents a larger expansion-board system that adds:

- More output ports for lights, solenoids, motors, and contactors
- Built-in handling for higher-power feedback devices
- Optional specialized boards such as chime support
- A cleaner single-system cabinet wiring approach

This turns Pinscape into a combined input and output backbone for a DIY pincab.

## Cabinet Inputs

Pinscape exposes the cabinet to Windows primarily through standard HID-style input conventions rather than a custom VPX-only protocol.

- Buttons can be mapped as keyboard keys and/or joystick buttons
- Nudge input can be reported on joystick X/Y or Rx/Ry axes
- Plunger input can be reported as position plus a separate speed axis for better VPX launches

The guide emphasizes correct physical mounting and orientation of the KL25Z so that accelerometer readings match cabinet movement.

## Feedback Output

Pinscape can also act as a cabinet feedback controller. The guide describes LedWiz-style compatibility, night mode support, and two main output approaches:

- Standalone KL25Z with separate booster circuits for attached devices
- Expansion boards that expose many more protected high-power outputs

That makes Pinscape relevant not only to [VPX Plunger Input](../concepts/VPX%20Plunger%20Input.md) and [VPX Accelerometer Input](../concepts/VPX%20Accelerometer%20Input.md), but also to [DOF Output Controllers](../concepts/DOF%20Output%20Controllers.md) and general [Pincab Setup](../concepts/Pincab%20Setup.md).

## Ecosystem Role

Pinscape is not one of the main runtime software layers like [Visual Pinball X](Visual%20Pinball%20X.md), [B2S Backglass Server](B2S%20Backglass%20Server.md), or [DirectOutput Framework](DirectOutput%20Framework.md). Instead, it is a common hardware bridge that lets a cabinet present real buttons, plunger motion, nudging, and cabinet feedback hardware to that software stack.

The Pinscape resources site (mjrnet.org/pinscape) also hosts the unified DirectOutput R3++ Grand Unified Edition installer, which bundles [SSFImpactor](SSFImpactor.md).

## See Also

- [Pincab Setup](../concepts/Pincab%20Setup.md)
- [Pinscape Pico](../concepts/Pinscape%20Pico.md) — Second-generation RP2040 controller
- [VPX Plunger Input](../concepts/VPX%20Plunger%20Input.md)
- [VPX Accelerometer Input](../concepts/VPX%20Accelerometer%20Input.md)
- [DOF Output Controllers](../concepts/DOF%20Output%20Controllers.md)
- [SSFImpactor](SSFImpactor.md)
- [Pinscape Build Guide](../sources/Pinscape%20Build%20Guide.md)