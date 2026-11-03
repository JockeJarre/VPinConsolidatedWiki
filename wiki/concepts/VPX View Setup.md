# VPX View Setup

[Visual Pinball X](../projects/Visual%20Pinball%20X.md) offers two camera/projection modes for rendering the playfield, optimized for different display setups.

## Perspective Camera (Desktop)

Traditional video game camera. Default for desktop computers. Configured via "Legacy" or "Camera" view layout mode.

**Parameters:**
| Parameter | Description |
|-----------|-------------|
| Player X/Y/Z | View position from playfield bottom center |
| Look At | % of playfield height (0% = lockbar, 100% = back) |
| Field of View | Camera FOV angle |
| Horizontal/Vertical Offset | Shift the view |
| Horizontal/Vertical Stretch | Scale the view |

### Avoiding Distortion
To prevent "egg-shaped" ball distortion:
- Start with Inclination ~10, FOV ~10, Layback ~30–40
- Keep X/Y scale similar (avoid >2.3:1 aspect ratio)
- Avoid decorative elements that change the bounding box

- ⚠️ CONFLICT (secondary source): VPW cabinet experience uses **Inclination 6–20, FOV 29–45, Layback 42–70**; Flupper's reference calibration is Inclination 6, FOV 45, Layback 65, "designed so the top of the table tucks under the backbox, matching real machine perspective"
  ([raw/vpw-wiki/docs/guides/hardware-cabinet.md](https://vpw-wiki.skirmishofwit.com/guides/hardware-cabinet/), 2026 extraction) — Primary: the ~10 FOV figures above come from the desktop distortion-avoidance guidance in the shipped docs; scopes differ (generic desktop camera vs POV-calibrated cabinet), so the ranges are not directly comparable

### Anti Ball Stretch

The "Anti Ball Stretch" checkbox alone is not sufficient — the monitor's aspect ratio must also be entered in the associated fields, or the ball stays egg-shaped on rotated screens; the ratio may need swapping (16:9 vs 9:16) depending on native orientation ([raw/vpw-wiki/docs/guides/hardware-cabinet.md](https://vpw-wiki.skirmishofwit.com/guides/hardware-cabinet/), 2026 extraction)

## Window Projection (Pincab)

Designed for [pincab setups](Pincab%20Setup.md) where a TV screen sits inside the cabinet. Simulates the player positioned at the side of a real screen. Supports headtracking and [VPX Stereo 3D](VPX%20Stereo%203D.md).

**Video Settings (global):**
| Parameter | Description |
|-----------|-------------|
| Screen Width/Height | Physical screen dimensions in centimeters |
| Screen Inclination | Angle of the playfield screen |
| Player X/Y/Z | Physical player position relative to screen |

**Per-Table Settings:**
| Parameter | Description |
|-----------|-------------|
| Table X/YZ Scale | 100% = real-world size |
| Horizontal/Vertical Offset | Fine-tune positioning |
| Window Top/Bottom Z Offset | Vertical alignment at screen edges |

## POV Camera Setup (In-Game)

1. Launch game and press **F12** to enter camera mode
2. Press **Plunger Key** to load auto-generated Window PoV
3. Use **MagnaSave keys** to navigate, **Flipper keys** to adjust values
4. Fine-tune **Window Top Z Offset** for vertical alignment
5. Set **Table XYZ Scale** to 100% for real ball size
6. Adjust **Vertical Offset** to align screen top with table back
7. Press **Start** to save to table-specific `.ini` file

### Day/Night Mode
Adjustable via POV settings. Tonemapper options:
- Reinhard classic
- Tony McMapFace custom
- Filmic modern

## Command Line

- `VPinballX.exe -PovEdit [file]` — Load in camera mode, export POV on exit
- `VPinballX.exe -Pov [file]` — Export POV and close
- `VPinballX.exe -Primary` — Force render on primary monitor

## See Also

- [Visual Pinball X](../projects/Visual%20Pinball%20X.md) — The rendering engine
- [Pincab Setup](Pincab%20Setup.md) — Physical cabinet display configuration
- [Screen Configuration](Screen%20Configuration.md) — B2S window positioning (separate system)
- [VPX Stereo 3D](VPX%20Stereo%203D.md) — 3D rendering modes
- [VPX Latency](VPX%20Latency.md) — Rendering latency considerations



