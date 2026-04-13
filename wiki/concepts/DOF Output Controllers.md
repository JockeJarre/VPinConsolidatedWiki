# DOF Output Controllers

Output controllers are hardware units that translate digital signals from the [DirectOutput Framework](../projects/DirectOutput%20Framework.md) into physical outputs — PWM signals for LEDs, digital on/off for solenoids, and DMX channels for stage lighting. They form the hardware backbone of a [pincab](Pincab%20Setup.md) feedback system.

## Supported Controllers

| Controller | Outputs | PWM Levels | Interface | Max Units |
|-----------|---------|------------|-----------|-----------|
| **LedWiz** | 32 | 49 (50Hz) | USB, auto-detected | 16 |
| **PacLed64** | 64 | 256 (100kHz) | USB, constant-current 20mA | 4 |
| **PacDrive** | 16 | Digital only | USB, auto-detected | 1 |
| **PacUIO (Ultimate I/O)** | 96 | 256 (100kHz) | USB, constant-current | 2 |
| **Art-Net / DMX** | 512/universe | 256 | Ethernet | Unlimited |
| **TeensyStripController** | 8 ch × 1100 LEDs | 256 | USB | Multiple |
| **WS2811 Controller** | Unlimited | 256 | FT245R + Atmel DIY | Unlimited |
| **FT245RBitbang** | 8 | Digital only | USB (SainSmart relays) | Multiple |
| **DirectStripController** | Unlimited | 256 | Swisslizard design | Multiple |
| **Philips Hue** | ~150 (50 lights × 3) | 256 | Zigbee wireless | Unlimited |
| **DudesCab** | 128 | 256 | RP2040-based USB | 5 |
| **Pinscape (LedWiz emulation)** | 22+ standalone, 65+ with expansion boards | LedWiz-compatible | USB | Cabinet-specific |

## LedWiz

The most common output controller for virtual pinball. 32 outputs at 49 PWM levels with 50Hz PWM frequency. Auto-detected by DOF. Up to 16 units can be daisy-chained. In DOF INI files, columns 1–16 map to LedWiz units 1–16.

## PacLed64

Higher-end alternative with 64 outputs at 256 PWM levels and 100kHz frequency. Constant-current 20mA outputs protect LEDs. INI columns 20–27 map to PacLed64 units.

## Art-Net / DMX

Professional stage lighting protocol over Ethernet. 512 channels per universe with unlimited universes. Useful for large LED installations or integration with existing stage lighting infrastructure.

## Addressable LED Controllers

**TeensyStripController**, **WS2811 Controller**, and **DirectStripController** drive addressable LED strips (WS2811/WS2812). These enable:
- LED matrix effects (plasma, bitmaps, animations)
- Addressable undercab lighting
- Individual LED control for hundreds or thousands of LEDs

## Configuration

Output controllers are defined in the DOF **CabinetConfig** XML:

```xml
<OutputControllers>
  <LedWiz>
    <Name>LedWiz 01</Name>
    <Number>1</Number>
  </LedWiz>
  <ArtNet>
    <Name>ArtNet Node</Name>
    <Universe>0</Universe>
  </ArtNet>
</OutputControllers>
```

[DOF Toys and Effects](DOF%20Toys%20and%20Effects.md) reference controller outputs by name (e.g., `LedWiz 01.01` for LedWiz unit 1, output 1).

## DOF Abstraction

DOF manages all outputs through an abstract `IOutput` interface, allowing cross-controller compatibility. A [toy](DOF%20Toys%20and%20Effects.md) can be mapped to any controller's output regardless of hardware type. Each controller runs on its own thread for non-blocking communication.

Pinscape is relevant here because its guide describes using the controller as a LedWiz-style output target, either from a standalone KL25Z with booster circuitry or from the larger expansion-board stack.

## See Also

- [DirectOutput Framework](../projects/DirectOutput%20Framework.md) — The framework that drives these controllers
- [DOF Toys and Effects](DOF%20Toys%20and%20Effects.md) — Logical devices mapped to controller outputs
- [Pincab Setup](Pincab%20Setup.md) — Physical cabinet using these controllers
- [DOF Table Configuration](DOF%20Table%20Configuration.md) — Per-table effect assignments
- [Pinscape Controller](../projects/Pinscape%20Controller.md) — DIY controller with LedWiz-style output support



