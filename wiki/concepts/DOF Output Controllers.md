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
| **[SSFImpactor](../projects/SSFImpactor.md)** | 15 fixed ports | Software-synthesized (BASS audio) | Sound card channels, no board | Cabinet-specific |
| **Pinscape (LedWiz emulation)** | 22+ standalone, 65+ with expansion boards | LedWiz-compatible | USB | Cabinet-specific |

## LedWiz

The most common output controller for virtual pinball. 32 outputs at 49 PWM levels with 50Hz PWM frequency. Auto-detected by DOF. Up to 16 units can be daisy-chained. In DOF INI files, columns 1–16 map to LedWiz units 1–16.

## PacLed64

Higher-end alternative with 64 outputs at 256 PWM levels and 100kHz frequency. Constant-current 20mA outputs protect LEDs. INI columns 20–27 map to PacLed64 units.

## Art-Net / DMX

Professional stage lighting protocol over Ethernet. 512 channels per universe with unlimited universes. Useful for large LED installations or integration with existing stage lighting infrastructure.

- The community guide's Art-Net entry describes an **ESP8266-based LED controller "limited to 170 LEDs max, so not very popular these days"** — this is the community's DOF-adjacent usage view, narrower than the 512-channel DMX universe framing above ([raw/ExternalWikis/dekay-vpinball-wiki/repo/DOF-‐-The-Direct-Output-Framework.md](https://github.com/dekay/vpinball-wiki/wiki/DOF-%E2%80%90-The-Direct-Output-Framework), §Supported Hardware)

## Addressable LED Controllers

**TeensyStripController**, **WS2811 Controller**, and **DirectStripController** drive addressable LED strips (WS2811/WS2812). These enable:
- LED matrix effects (plasma, bitmaps, animations)
- Addressable undercab lighting
- Individual LED control for hundreds or thousands of LEDs

The Wemos D1 Mini / S2 Mini class of controllers (community-recommended, ini number 30) is documented on [DOF Addressable LEDs](DOF%20Addressable%20LEDs.md).

- ⚠️ CONFLICT (secondary source): the recommended Vroonsh TeensyStripController fork "improves the LED communication timing and allows for more LEDs per line (from 1100 to 2100 LEDs)", "likely to be merged into the mainline repo"
  ([raw/ExternalWikis/dekay-vpinball-wiki/repo/AddressableLED.md](https://github.com/dekay/vpinball-wiki/wiki/AddressableLED), §PJRC Teensy) — Primary: TeensyStripController at 8 channels × 1100 LEDs (mainline figure; the fork raises it)

## INI File Numbering

Each controller class has a base `directoutputconfig<N>.ini`; extra boards of the same type increment the number by 1, and only PacDrive is limited to one per cabinet. Community table, July 2025 snapshot ([raw/ExternalWikis/dekay-vpinball-wiki/repo/DOF-‐-The-Direct-Output-Framework.md](https://github.com/dekay/vpinball-wiki/wiki/DOF-%E2%80%90-The-Direct-Output-Framework), §Supported Hardware and Their `ini` Files):

| Controller | ini number |
|-----------|------------|
| FRDM-KL25Z (Pinscape Gen 1) | 8 |
| PinOne | 11 |
| LedWiz | base file, suffixes appended per unit |
| PacDrive | 19 |
| PacLed64 | 20 |
| Ultimate I/O | 27 |
| WS2811 (Wemos/Teensy strips) | 30 |
| SainSmart (FT245R relays) | 40 |
| Pinscape | 51 |
| Philips Hue | 70 |
| Pincontrol1 | 80 |
| Pincontrol2 | 85 |
| DudesCab | 90 |
| Art-Net | 100 |
| **Pinscape Pico** | 120 |

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

## SSFImpactor (Software Controller)

[SSFImpactor](../projects/SSFImpactor.md) is the software exception to the hardware rule: it emulates a LedWiz with 15 fixed ports (flippers, slings, six bumpers, knocker, shaker, gear, hellball motor, bell) and drives [contactor](DOF%20Toys%20and%20Effects.md)-style effects by synthesizing tactile audio through sound-card channels to exciters and shakers. It is configured as `<SSFImpactController>` in CabinetConfig XML and ships with the DirectOutput Framework R3++ Grand Unified Edition.

## See Also

- [DirectOutput Framework](../projects/DirectOutput%20Framework.md) — The framework that drives these controllers
- [DOF Toys and Effects](DOF%20Toys%20and%20Effects.md) — Logical devices mapped to controller outputs
- [Pincab Setup](Pincab%20Setup.md) — Physical cabinet using these controllers
- [DOF Table Configuration](DOF%20Table%20Configuration.md) — Per-table effect assignments
- [Pinscape Controller](../projects/Pinscape%20Controller.md) — DIY controller with LedWiz-style output support
- [Pinscape Pico](Pinscape%20Pico.md) — Second-generation controller (ini number 120)
- [DOF Addressable LEDs](DOF%20Addressable%20LEDs.md) — Wemos/Teensy strip and matrix setup end to end
- [SSFImpactor](../projects/SSFImpactor.md) — Software-only controller using tactile audio



