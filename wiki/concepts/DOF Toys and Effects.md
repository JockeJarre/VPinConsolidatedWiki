# DOF Toys and Effects

In the [DirectOutput Framework](../projects/DirectOutput%20Framework.md), **toys** are logical representations of physical devices in the cabinet, and **effects** are the behaviors triggered by table events. Together they form the bridge between game events and physical feedback.

## Toys

Toys abstract physical devices so effects don't need to know about specific [DOF Output Controllers](DOF%20Output%20Controllers.md).

### Built-in Toy Types

| Toy | Description |
|-----|-------------|
| **Lamp** | Simple on/off light with configurable fading curve |
| **Motor / GearMotor** | Rotating motor with kickstart pulse, min/max power, and max runtime safety |
| **Shaker** | Like Motor but optimized for vibration feedback |
| **Contactor** | Solenoid-driven impact device (flipper/bumper feel) |
| **ReplayKnocker** | Solenoid that produces a knock sound |
| **RGBAToy** | RGB LED with multi-layer alpha channel support |
| **RGBLed** | Convenience wrapper for RGBAToy (red, green, blue outputs) |
| **AnalogAlphaToy** | Single-channel device with layers and transparency |
| **LedStrip** | Addressable LED matrix with configurable width, height, color order (GRB/RGB/WS2812), and arrangement pattern |
| **LedWizEquivalent** | Maps legacy INI file columns to actual outputs |
| **RGBAToyGroup / AnalogAlphaToyGroup** | Groups toys into controllable matrices |

### Toy Configuration

Toys are defined in the DOF CabinetConfig XML, mapping to [output controller](DOF%20Output%20Controllers.md) pins:

```xml
<Toys>
  <Contactor>
    <Name>Left Flipper</Name>
    <OutputName>LedWiz 01.01</OutputName>
  </Contactor>
  <RGBLed>
    <Name>Backboard LED</Name>
    <OutputNameRed>LedWiz 01.05</OutputNameRed>
    <OutputNameGreen>LedWiz 01.06</OutputNameGreen>
    <OutputNameBlue>LedWiz 01.07</OutputNameBlue>
  </RGBLed>
  <Motor>
    <Name>Shaker Motor</Name>
    <OutputName>LedWiz 01.15</OutputName>
    <MinPower>40</MinPower>
    <MaxPower>255</MaxPower>
    <KickstartPower>255</KickstartPower>
  </Motor>
</Toys>
```

## Effects

Effects define what happens to toys when table events fire.

### Built-in Effect Types

| Effect | Description |
|--------|-------------|
| **RGBFadeOnOff** | Fade RGB color based on trigger value |
| **OnOffEffect** | Simple binary on/off control |
| **DurationEffect** | Activates for a specified time, then deactivates |
| **BlinkEffect** | Blink with configurable interval and pulse width |
| **DelayEffect** | Delays the trigger signal by a specified time |
| **ValueInvertEffect** | Inverts effect values (high→low, low→high) |
| **TriggerCondition** | Conditional triggering based on value comparison |
| **AnalogAlphaMatrixBitmapEffect** | Display bitmap section on LED matrix |
| **AnalogAlphaMatrixBitmapAnimationEffect** | Animated bitmap on LED matrix |
| **AnalogAlphaMatrixFlickerEffect** | Random flicker with density/duration control |
| **AnalogAlphaMatrixShiftEffect** | Color shift animation through matrix |
| **RGBMatrixShapeEffect** | Display shapes from XML on matrix |
| **RGBPlasmaEffect** | Plasma animation on LED matrix |

### Effect Chaining

Effects can be stacked to create complex behaviors:

```
DelayEffect(2s) → BlinkEffect(500ms) → BlinkEffect(50ms) → RGBFadeOnOff
```

This creates a 2-second delayed, double-frequency blinking fade. Each effect in the chain modifies or gates the signal before passing it to the next.

### Effect Configuration

Effects are defined in DOF TableConfig XML:

```xml
<Effects>
  <RGBFadeOnOff>
    <EffectName>Left Flipper Flash</EffectName>
    <ToyName>Backboard LED</ToyName>
    <ActiveColor>Red</ActiveColor>
    <FadeDuration>100</FadeDuration>
  </RGBFadeOnOff>
</Effects>
```

### Static Effects

Effects triggered on table initialization (not by game events). Useful for illuminating start buttons, ambient cabinet lighting, or attract-mode animations.

## Fading Curves

Both toys and effects can use custom **fading curves** — 256-value lookup tables mapping input intensity (0–255) to output intensity (0–255). This enables non-linear brightness control (e.g., gamma correction for LEDs).

## Named Colors

The CabinetConfig defines named colors used by effects:

```xml
<Colors>
  <Color><Name>Red</Name><Red>255</Red><Green>0</Green><Blue>0</Blue></Color>
  <Color><Name>Warm White</Name><Red>255</Red><Green>200</Green><Blue>150</Blue></Color>
</Colors>
```

## See Also

- [DirectOutput Framework](../projects/DirectOutput%20Framework.md) — The framework hosting toys and effects
- [DOF Output Controllers](DOF%20Output%20Controllers.md) — Hardware that toys map to
- [DOF Table Configuration](DOF%20Table%20Configuration.md) — Per-table effect assignments
- [Pincab Setup](Pincab%20Setup.md) — Physical cabinet using these devices


