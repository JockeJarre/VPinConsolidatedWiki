# VPX Lights and Rendering

[Visual Pinball X](../projects/Visual%20Pinball%20X.md) uses a sophisticated lighting system to simulate the illuminated playfield of real pinball machines. Lights interact with balls (reflections, shadows) and support multiple fading models.

## Lightmaps

VPX renders lights as flat surfaces:

- **Classic lights**: Opaque surfaces that represent playfield inserts
- **Halo lights**: Transparent additive surfaces for glow effects
- **Custom lightmaps**: Flasher or Primitive objects with a `lightmap` property pointing to a Light element

In VPX 10.8 the primitive **Lightmap property** auto-drives the primitive's opacity from the linked light (render mode Hidden, fader Incandescent), replacing custom fader subs. Script color changes propagate to attached lightmaps when the lightmap primitive's name contains the light name (e.g. `_l01_`) or the light name appears in the light's `UserValue` ([raw/vpw-wiki/docs/guides/insert-lighting.md](https://vpw-wiki.skirmishofwit.com/guides/insert-lighting/), §Lightmap Property; [raw/vpw-wiki/docs/reference/light-state-controller.md](https://vpw-wiki.skirmishofwit.com/reference/light-state-controller/)

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
- Community working fade values: ~40 ms up / 120 ms down — the filament heats faster than it cools ([raw/vpw-wiki/docs/guides/gi-and-flashers.md](https://vpw-wiki.skirmishofwit.com/guides/gi-and-flashers/), §Lampz)

### Lampz (pre-10.8 legacy)

Before the native faders, tables used the **Lampz/ModLampz** script library for per-lamp fading (FadeSpeed LED ½/⅛, incandescent 1/40/1/120). Dated status per the VPW collection:
- ⚠️ CONFLICT (secondary source, internal to VPW): "ROM-based tables should still use Lampz/vpmMapLights"
  ([raw/vpw-wiki/docs/reference/light-state-controller.md](https://vpw-wiki.skirmishofwit.com/reference/light-state-controller/) — same collection, newer: Lampz was removed from the VPW Example Table at v1.5.15 (March 2024); "Lampz is no longer needed for either ROM or original tables" ([raw/vpw-wiki/docs/reference/example-table.md](https://vpw-wiki.skirmishofwit.com/reference/example-table/) Treat Lampz as pre-10.8 legacy; current paths are native faders, `light_animate`, and `vpmMapLights`
- `vpmMapLights` + TimerInterval = ROM lamp index replaces manual Lampz lamp mapping for ROM tables
- 10.8 `light_animate` subs (`l86_Animate` + `GetInPlayIntensity`) replace Lampz for insert-blend control on toolkit tables — see [VPX Insert Lighting](VPX%20Insert%20Lighting.md)

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



