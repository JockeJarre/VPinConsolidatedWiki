# VPX Lights and Rendering

[Visual Pinball X](../projects/Visual%20Pinball%20X.md) uses a sophisticated lighting system to simulate the illuminated playfield of real pinball machines. Lights interact with balls (reflections, shadows) and support multiple fading models.

![VPX ball shadows](../assets/VPX%20Ball%20Shadows.png)

*Ball shadows cast by playfield lights (VPX 10.8 rendering options)* ([raw/VPX/repo/docs/img/Upgrade10.8-BallShadows.png](https://github.com/vpinball/vpinball/blob/master/docs/img/Upgrade10.8-BallShadows.png))

![VPX reflections](../assets/VPX%20Reflections.png)

*Reflections rendering option* ([raw/VPX/repo/docs/img/Upgrade10.8-ReflectionsOption.png](https://github.com/vpinball/vpinball/blob/master/docs/img/Upgrade10.8-ReflectionsOption.png))

## Lightmaps

VPX renders lights as flat surfaces:

- **Classic lights**: Opaque surfaces that represent playfield inserts
- **Halo lights**: Transparent additive surfaces for glow effects
- **Custom lightmaps**: Flasher or Primitive objects with a `lightmap` property pointing to a Light element

## Light Fading Modes

### None (LED)
Instantaneous on/off — simulates modern LED inserts.

### Linear
Simple interpolation between on and off states.

### Incandescent (10.8+)
Physical model simulating filament temperature:
- Full brightness corresponds to **2700K** color temperature
- Filament cools gradually when turned off, producing a warm red glow
- Temperature readable via `FilamentTemperature` [script property](VPX%20Scripting.md)
- Most authentic for classic machines with incandescent bulbs

## Shadows

Dynamic **raytraced shadows** between balls and lightmaps:
- Computed from light source position and bulb radius (0.1 inches)
- Shadow softness depends on ball-to-bulb distance and radii
- Enabled per-light via `Shadows` property (0=off, 1=raytraced)
- Added in VPX 10.8

## Reflections

### Ball Reflections
Direct rendering of lights on ball surfaces. Controlled per-light:
- `ShowReflectionOnBall` property
- Lights set to "None" fading can still have reflections enabled separately

### Reflection Probes (10.8+)
New system for scalable, VR-compatible reflections:
- Handle actual playfield geometry
- Replace older sphere mapping (equirectangular mapping for VR compatibility)
- View-dependent rendering for correct perspective

## Script Properties

| Property | Description |
|----------|-------------|
| `State` | 0=off, 1=on, 2=blinking |
| `Color` | Light color |
| `Intensity` | Brightness level |
| `IntensityScale` | Brightness multiplier |
| `Fader` | None, Linear, or Incandescent |
| `BlinkPattern` | Blink sequence string |
| `Shadows` | 0=off, 1=raytraced |
| `FilamentTemperature` | Current filament temp (read-only, incandescent mode) |
| `ShowReflectionOnBall` | Enable ball reflection |

## Table-Level Lighting Properties

| Property | Description |
|----------|-------------|
| `LightAmbient` | Global ambient light color |
| `Light0Emission` | Primary directional light |
| `LightEmissionScale` | Light intensity multiplier |
| `AOScale` | Ambient occlusion strength |
| `BloomStrength` | Post-process bloom intensity |

## See Also

- [Visual Pinball X](../projects/Visual%20Pinball%20X.md) — The rendering engine
- [VPX Scripting](VPX%20Scripting.md) — Script access to light properties
- [VPX Stereo 3D](VPX%20Stereo%203D.md) — 3D rendering interacts with lighting
- [VPX View Setup](VPX%20View%20Setup.md) — Camera affects light appearance



