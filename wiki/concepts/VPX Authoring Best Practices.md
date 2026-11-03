# VPX Authoring Best Practices

Community conventions for VPX table authoring: object naming, layer maps, versioning and release practice, performance rules, testing, anti-patterns, DOF output safety, and modding ethics.

> ⚠️ Priority: Secondary — from the [VPW Knowledge Base](../sources/VPW%20Knowledge%20Base.md) (authoring community); Primary sources win on conflicts. Raw: `[raw/vpw-wiki/docs/guides/best-practices.md](https://vpw-wiki.skirmishofwit.com/guides/best-practices/)

## Naming Conventions

From raw §Naming:

- Toolkit prefixes `bm_` / `lm_` / `pf_` — misnamed objects are silently skipped by the export
- VPX's 31-char name limit → **keep component names ≤6 chars**; names cannot start with a digit (`9_Rails_BM_Room` breaks generated script arrays)
- **Flashers: `f1` + solenoid number** (sol 9 → `f109`) — the leading 1 disambiguates from lamps
- Inserts: `p32on` / `p32off` / `p32bulb`, keyed to the ROM lamp number
- Sound files: **skip leading zeros** (script reliability beats sort order)

## Layer Map

1–3 collidables, 4–6 primitives/inserts, 7–9 lights, 10–11 VR + playfield flashers; timers live on the Timers layer to survive re-bakes.

## Versioning and Release

- WIP v003–v104 → RC1–RC9 → v1.0 → patches
- VPW **Bot checkout system**: one file holder at a time; version + changelog comment per check-in
- Wait ≥1 week after RC before publishing; avoid releasing immediately after another premium VPW table

## Performance Rules

- **Probe roughness 0 = the biggest single win** (+40%)
- Niwak top-3: transparency, bake groups, active lights
- Nestmap effective playfield width ≥ 2000 px
- Inserts ≈ 82% of render time/file size in toolkit tables
- WEBP −30–50% vs PNG (forces 72 DPI — bad for playfield scans); 4K inlane textures → 2K (Maverick 190→100 MB)
- **Power-of-two playfield textures blur from mipmapping — non-PoT (e.g. 4000×2000) is sharpest**; nestmap atlases still must be 8192

## Testing

- Competitive play finds release bugs (three found post-release on one VP Chat competition table)
- Test desktop + VR, DirectX + OpenGL, B2S on + off
- Physics feedback from players needs PAPA video timestamps
- Tables are tuned as "new/well-maintained machines"

## Anti-Patterns

From raw §Anti-patterns:

- `vpmTimer.Add` (broken); Lampz at frame rate
- RubberBandPost zero-point at center → set Z = 25
- **Friction 0 forbidden (minimum 0.1)**; pure black #000000
- `debug.print` in hot paths (file I/O frame drops) — strip before release
- Ball mass 1.3 (widebody included) breaks flipper physics

The full pre-release validation checklist is on [VPX Table Build Workflow](VPX%20Table%20Build%20Workflow.md) (§Release Checklist).

## Physics Conventions

Era-based flipper strengths, the EOSReturn 0.4 / EOSTorque 0.375 pair, sling threshold == hit threshold (1.5–2.0), bumper strength 13–15, playfield friction 0.15–0.25 by era — details on [VPX Physics Tuning](VPX%20Physics%20Tuning.md).

## Lighting Conventions

- GI rendered pure-white in Blender, colored in script (unlimited user mods without re-render)
- Flasher fade `FlashLevel*0.93 − 0.01` cubic (per-flasher variation)
- Lampz-era fade ratios LED ½/⅛ vs incandescent 1/40/1/120 (asymmetric = filament physics)
- Insert bloom ≈ 1/3 of the intuitive size; **mods default OFF** (the Metallica "snake" lesson)
- See [VPX GI and Flashers](VPX%20GI%20and%20Flashers.md), [VPX Insert Lighting](VPX%20Insert%20Lighting.md)

## Texture and Color

Render neutral, grade via LUT; **vector redraws beat scans for toolkit tables**.

## DOF Output Safety

- Solenoids: **`DOFPulse` only**; `DOFOn` is for flippers, buttons, RGB — a held `DOFOn` on a toy solenoid risks burnt coils
- No contactors on diverters (hold-on coils burn out)
- TerryRed rule: only flippers may stay "on"; everything else max-duration-capped (`S5 MAX100` = 100 ms auto-off)
- Back up DOF config (public-DB overwrite corruption)
- See [DOF Table Configuration](DOF%20Table%20Configuration.md), [DOF Output Controllers](DOF%20Output%20Controllers.md)

## POV Reference Values

Cabinet-tuned starting ranges (raw §POV Calibration): **Inclination 6–20, FOV 29–45, Layback 42–70** (Flupper reference 6/45/65 — table top tucks under the backbox); once dialed per cabinet, only X/Y per table.

- ⚠️ CONFLICT (secondary source): "Inclination 6–20, FOV 29–45, Layback 42–70"
  ([raw/vpw-wiki/docs/guides/best-practices.md](https://vpw-wiki.skirmishofwit.com/guides/best-practices/), §POV Calibration) — Primary: [VPX View Setup](VPX%20View%20Setup.md) starts at Inclination ~10, FOV ~10, Layback ~30–40. Scope note: VPW ranges are cabinet-calibrated; the primary starting values suit desktop

The Anti-Ball-Stretch checkbox alone is insufficient — enter the monitor aspect ratio (may need a 9:16 swap on rotated monitors).

## Modding Ethics

- "Not Free to Mod" covers PUP media integral to the table (Team Tuga incident)
- Adopting abandoned tables: contact the author, preserve the original vision, credit the original author
- Check rights holders for IP before original-table distribution

## See Also

- [VPX Table Build Workflow](VPX%20Table%20Build%20Workflow.md) — process and release checklist
- [VPX Table Troubleshooting](VPX%20Table%20Troubleshooting.md) — fixes for common failures
- [VPX View Setup](VPX%20View%20Setup.md) — player-side camera configuration
- [VPW Knowledge Base](../sources/VPW%20Knowledge%20Base.md) — source collection (secondary)
