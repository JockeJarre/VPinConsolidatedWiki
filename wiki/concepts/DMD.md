# DMD

DMD (Dot Matrix Display) is the digital alphanumeric/dot-matrix display found on modern pinball machines (post-1990). In virtual pinball, the DMD is rendered as a separate window or embedded within the [backglass](Backglass.md).

## Physical DMDs

Real pinball machines from the early 1990s onward replaced mechanical score reels with dot-matrix displays showing scores, animations, and game information, typically at 128×32 pixels.

- ⚠️ CONFLICT (secondary source): "Later machines adopted Dot Matrix Displays (DMDs) **built from grids of individual LEDs**"
  ([raw/ExternalWikis/dekay-vpinball-wiki/repo/Backglasses,-Alphanumeric,-and-Dot-Matrix-Displays.md](https://github.com/dekay/vpinball-wiki/wiki/Backglasses,-Alphanumeric,-and-Dot-Matrix-Displays) §Display Types) — Primary: "dot-matrix **plasma** displays" (wording of this page's opening history, from community-era framing). Real machines used plasma panels (WMS), and many reproductions are LED grids — the rendering styles below cover both

Common resolutions (shared with [VPX ScoreView Plugin](VPX%20ScoreView%20Plugin.md) presets): usual DMD 128×32 (4:1), hi-res 256×64, wide 128×16 (8:1), Sega 192×64 (3:1).

## Display Profiles

VPinball renders **8 alphanumeric display profiles** and **7 DMD display profiles**, selected via F12 LiveUI → `Alpha/DMD Profile Settings` ([raw/ExternalWikis/dekay-vpinball-wiki/repo/Backglasses,-Alphanumeric,-and-Dot-Matrix-Displays.md](https://github.com/dekay/vpinball-wiki/wiki/Backglasses,-Alphanumeric,-and-Dot-Matrix-Displays) §Display Profiles):

| Index | Alpha profile | Index | DMD profile |
|:-----:|---------------|:-----:|-------------|
| 0 | Alpha: Neon Plasma | 0 | DMD: Legacy VPX |
| 1 | Alpha: Blue VFD | 1 | DMD: Neon Plasma |
| 2 | Alpha: Green VFD | 2 | DMD: Red LED |
| 3 | Alpha: Red LED | 3 | DMD: Green LED |
| 4 | Alpha: Green LED | 4 | DMD: Yellow LED |
| 5 | Alpha: Yellow LED | 5 | DMD: Generic Plasma |
| 6 | Alpha: Generic Plasma | 6 | DMD: Generic LED |
| 7 | Alpha: Generic LED | | |

The ini names are `ProfileX` in the `[Alpha]` / `[DMD]` sections of `VPinballX.ini`. VPX renders **unlit** segments/dots grey by default (hardware-accurate); for more "pop", set the unlit color to black per profile — LiveUI RGB sliders, or in the ini: `[Alpha] ProfileXUnlit=0` and `[DMD] ProfileXUnlitDotColor=0`.

## Virtual DMD Implementations

![FlexDMD architecture — DMD rendering pipeline in the VPX ecosystem](https://raw.githubusercontent.com/vbousquet/flexdmd/master/docs/media/architecture.svg)

### B2S-DMD
[B2S Backglass Server](../projects/B2S%20Backglass%20Server.md) provides a dedicated DMD window that can be positioned and resized independently. It displays DMD content from:
- **Freezy DMD extensions** (2.0+) — Improved 64-bit support, colorization
- **PinUp Player** — Media-driven DMD display
- **FlexDMD** (v1.9+) — Flexible DMD rendering

The B2S-DMD position is configured per-table via `tablename.res` files or globally in `ScreenRes.txt`. See [Screen Configuration](Screen%20Configuration.md).

### VPX Live DMD
[Visual Pinball X](../projects/Visual%20Pinball%20X.md) supports rendering DMD content directly via [scripting](VPX%20Scripting.md):
- `DMDWidth` / `DMDHeight` — Set DMD dimensions
- `DMDPixels` — Byte array (0–100 intensity) for monochrome
- `DMDColoredPixels` — RGB array for full color
- Flasher objects with `DMD` flag enable per-flasher DMD rendering (10.8+)

### SharedMemory DMD
External DMD applications can read/write VPX state via the SharedMemory API. Reserved client IDs include `UDMD` (UltraDMD) and `XDMD`.

## Configuration

In B2S Server, DMD visibility is controlled per-ROM in `B2STableSettings.xml`:
- `HideB2SDMD` — Hide the B2S-DMD window
- `HideDMD` — Hide the standard DMD window

The grill area automatically hides if DMD X/Y position is 0/0.

## Window Punch

[B2SWindowPunch](../projects/B2S%20Backglass%20Server.md) creates transparent holes in overlapping windows so the DMD shows through from behind. Works with Freezy DMD and PinUp Player by default.

## See Also

- [Backglass](Backglass.md) — The backglass panel that often contains the DMD area
- [Screen Configuration](Screen%20Configuration.md) — DMD positioning on monitors
- [B2S Backglass Server](../projects/B2S%20Backglass%20Server.md) — Hosts the B2S-DMD window
- [DMD Extensions](../projects/DMD%20Extensions.md) — DmdDevice.dll: routes DMD frames to real and virtual displays
- [FlexDMD](../projects/FlexDMD.md) — In-process COM DMD renderer; uses DmdDevice.dll for output
- [VPX Scripting](VPX%20Scripting.md) — Script-driven DMD rendering
- [VPX ScoreView Plugin](VPX%20ScoreView%20Plugin.md) — Table-script-free DMD window with style presets
- [Altcolor](Altcolor.md) — Colorizing the DMD content (PAL/VNI/PAC/Serum)
- [Unofficial Visual Pinball Wiki](../sources/Unofficial%20Visual%20Pinball%20Wiki.md) — source collection (secondary)


