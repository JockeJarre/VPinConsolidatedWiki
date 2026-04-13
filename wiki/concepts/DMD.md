# DMD

DMD (Dot Matrix Display) is the digital alphanumeric/dot-matrix display found on modern pinball machines (post-1990). In virtual pinball, the DMD is rendered as a separate window or embedded within the [backglass](Backglass.md).

## Physical DMDs

Real pinball machines from the early 1990s onward replaced mechanical score reels with dot-matrix plasma displays. These show scores, animations, and game information using a grid of orange-amber dots (typically 128×32 pixels).

## Virtual DMD Implementations

![FlexDMD architecture — DMD rendering pipeline in the VPX ecosystem](../../raw/FlexDMD/repo/docs/media/architecture.svg)

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


