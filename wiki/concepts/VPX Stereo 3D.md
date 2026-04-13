# VPX Stereo 3D

[Visual Pinball X](../projects/Visual%20Pinball%20X.md) supports stereoscopic 3D rendering for VR headsets, 3D TVs, and anaglyph glasses. The BGFX build provides "real stereo" (one image per eye) for the highest quality.

## Output Modes

- **VR Headsets** — via OpenXR (BGFX build)
- **3D TVs** — passive or active glasses
- **Anaglyph glasses** — red/cyan or other filter combinations on standard monitors

## Rendering Approaches

### Fake Stereo
Single rendered image + depth information → per-eye views derived mathematically. Less powerful, some visual glitches. Available in DX9 build.

### Real Stereo (Recommended)
One complete image rendered per eye. Better quality, correct occlusion. Available in BGFX and OpenGL builds.

## Anaglyph Filters

| Filter | Ghosting | Retinal Rivalry | Brightness | Color Quality | Calibration |
|--------|----------|-----------------|------------|---------------|-------------|
| **None** | High | High | Low | Good | No |
| **Dubois** | Low | Moderate | Medium | Bad | No |
| **Deghost** | Low | Moderate | Medium | Medium | No |
| **Luminance** | Very Low | High | Good | Good | **Yes** |
| **Dynamic Desaturation** | Very Low | Very Low | Good | Medium | **Yes** |

### Calibration (for Luminance and Dynamic Desaturation)
Available via LiveUI (Settings → Video Options):
1. Close one eye
2. Adjust brightness until both filter channels match luminance
3. Use Left/Right Shift keys to adjust, Control keys to navigate steps

## Cabinet / 3D TV Notes

- Passive glasses on **rotated TVs** (portrait mode for cabinets) may need rotated polarizing filter sheets
- Active glasses sometimes require this too, depending on manufacturer
- **Verify TV compatibility before purchase** for rotated cabinet use
- See [Pincab Setup](Pincab%20Setup.md) for physical installation details

## Script Properties

| Property | Description |
|----------|-------------|
| `MaxSeparation` | Maximum eye separation |
| `ZPD` | Zero parallax distance (screen plane) |
| `Offset` | Stereo offset adjustment |
| `RenderingMode` | 0=2D, 1=Stereo, 2=VR |

Toggle stereo during play with **F10**.

## See Also

- [Visual Pinball X](../projects/Visual%20Pinball%20X.md) — The rendering engine
- [VPX View Setup](View%20Setup.md) — Camera configuration affects stereo
- [Pincab Setup](Pincab%20Setup.md) — 3D TV in cabinet context
- [VPX Lights and Rendering](Lights%20and%20Rendering.md) — Lighting interacts with stereo



