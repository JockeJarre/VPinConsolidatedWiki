# Screen Configuration

Screen configuration determines how [B2S Backglass Server](../projects/B2S%20Backglass%20Server.md) positions and sizes its windows across monitors. This is critical for [pincab setups](Pincab%20Setup.md) with multiple screens and important even for single-screen desktop play.

## Configuration Files

### ScreenRes.txt (Global)

The primary configuration file containing monitor positions and sizes. Located in the B2S Server installation directory.

**V2 format** (with version header):
```
# V2.0.0+
# Playfield screen width/height
2560
1440
# Backglass width/height
1920
1080
# Backglass display device (number, @xpos, or =index)
2
# Backglass X/Y position
0
0
# B2S-DMD width/height (0/0 for defaults)
676
320
# B2S-DMD X/Y relative to backglass screen
303
681
# Y-flip (upside down)
0
# Background X/Y position
0
655
# Background width/height
1280
369
# Background image path
C:\Visual Pinball\B2SServer\Backgrounds\SpikeTypeGrill.png
```

**Key features:**
- Comments starting with `#` are supported
- `V2` marker prevents value position swapping in newer versions
- Backglass display reference methods:
  - Device number: `2` → `\\.\DISPLAY2`
  - Position: `@1920` → screen at X=1920
  - Screen index: `=2` → second screen from left (**most stable**)

### tablename.res (Per-Table)

Copy `ScreenRes.txt` and rename to match the table (e.g., `Blood Machines (VPW 2022).res`). Placed alongside the `.vpx` file. Overrides the global configuration for that table.

**Workflow (v2.1.2+):**
1. Right-click `.directb2s` file → "B2S Server copy Screenres template"
2. Choose a preset
3. Adjust [DMD](DMD.md) position via B2SScreenResIdentifier
4. Save

**Advanced options in tablename.res:**
- `B2SWindowPunch=off` — Disable window punching for this table
- `B2SWindowPunch=<regex>` — Custom window punch pattern
- `cutter=<regex>` — Custom stencil window pattern

## File Search Priority

B2S Server searches for configuration in this order:
1. `tablename.res` next to the `.vpx` file
2. `screenres.txt` in the same folder as `.vpx`
3. `screenres.txt` as `tablename/screenres.txt`
4. `screenres.txt` in the B2SBackglassServerEXE.exe directory

## Example Configurations

### Single Screen (1920×1080)
[Backglass](Backglass.md) and [DMD](DMD.md) as small windows beside the playfield:
```
1920
1080
520
318
1
1379
31
520
318
-1356
0
```

### Dual Screen (1920×1080 PF + 1280×1024 BG)
Dedicated backglass monitor with background grill image:
```
# V2.0.0
1920
1080
1280
655
=2
0
0
676
320
303
681
0
0
655
1280
369
C:\Visual Pinball\B2SServer\Backgrounds\SpikeTypeGrill.png
```

## Registry Overrides

- `HKCU\Software\B2S\B2SScreenResFileNameOverride` — Use a custom filename instead of `ScreenRes.txt`
- `HKCU\Software\B2S\B2SWindowPunchActive` — Enable/disable B2SWindowPunch globally

## Batch Screen Reference Changes

Use Notepad++ with regex Find/Replace across `*.res` files to bulk-update screen references (e.g., change `^2$` to `=2` for screen index mode).

## Non-Windows / Standalone Windowing

This page covers the B2S-era Windows mechanism (`ScreenRes.txt`, `.res` files). On [VPX Standalone](VPX%20Standalone.md) platforms there is no B2S server — window placement falls to the OS window manager and the frontend. The community guide's recommended setup is **KDE KWin window rules** (absolute positioning + layers: Desktop < Normal < Above < Notification) driving the fixed window titles `Visual Pinball Player`, `Visual Pinball Backglass`, `Visual Pinball Score View`, and [VPinFE](../projects/VPinFE.md)'s `VPinFE Table`/`VPinFE BG`/`VPinFE DMD`; pure Wayland forbids this placement and Gnome has no placement rules ([raw/ExternalWikis/dekay-vpinball-wiki/repo/Linux.md](https://github.com/dekay/vpinball-wiki/wiki/Linux) Do not rotate the playfield display — VPinFE assumes unrotated output.

- ⚠️ CONFLICT (secondary source): the B2S ScreenRes/.res workflow on this page is Windows-only guidance; the community Linux page prescribes window-manager rules instead
  ([raw/ExternalWikis/dekay-vpinball-wiki/repo/Linux.md](https://github.com/dekay/vpinball-wiki/wiki/Linux) — Primary: B2S docs (this page). Scope note: complementary per platform, not contradictory

## See Also

- [B2S Backglass Server](../projects/B2S%20Backglass%20Server.md) — Uses these configuration files
- [VPX Standalone](VPX%20Standalone.md) — Cross-platform windowing constraints
- [VPinFE](../projects/VPinFE.md) — Frontend window titles used by the Linux rules
- [Pincab Setup](Pincab%20Setup.md) — Physical cabinet monitor layout
- [Backglass](Backglass.md) — The window being positioned
- [DMD](DMD.md) — DMD window positioning
- [VPX View Setup](VPX%20View%20Setup.md) — VPX camera configuration (separate from B2S screen config)


