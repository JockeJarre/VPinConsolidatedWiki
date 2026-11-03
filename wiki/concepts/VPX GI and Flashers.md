# VPX GI and Flashers

General Illumination systems and flasher techniques for VPX table authoring: GI string tracing from real machines, per-era GI behaviors, the canonical flasher decay curve, solenoid PWM migration, and room-brightness handling.

> ⚠️ Priority: Secondary — from the [VPW Knowledge Base](../sources/VPW%20Knowledge%20Base.md) (authoring community); Primary sources win on conflicts. Raw: `[raw/vpw-wiki/docs/guides/gi-and-flashers.md](https://vpw-wiki.skirmishofwit.com/guides/gi-and-flashers/)

## GI String Tracing

GI wiring is undocumented on many machines; the community method (raw §GI String Tracing): trace wire colors in under-playfield photos (watch for switch-matrix color collisions), frame-step YouTube attract mode video (`,`/`.` keys), run the ROM's GI test menu on a real machine, cross-reference other machines for blown bulbs, decode Williams schematics. Manual gotchas: Black Rose "top/bottom" = bulb-pair position; the T2 manual lists GI twice (the second listing is correct).

**Numbering gotcha: hardware GI String 1 = `gi0lvl`, String 2 = `gi1lvl`** — off-by-one from the software channel index; a common source of bugs (first documented on Black Rose).

## Unusual GI Configurations

From raw §Unusual GI Configurations:

- SAM GI: single on/off relay — **not dimmable**
- Data East GI inverts solenoid logic (high = off) on some tables
- System 11 "GI Blink" solenoid dims GI when fired (TIP102)
- SAM lamp-matrix GI on lamp indices 130/132/134/136 (Metallica) bypasses standard GI callbacks

## GI Implementation Eras

- **Pre-toolkit**: per-string baked additive flasher textures, opacity = GI level (`FGIFront.opacity = 300 * GIFrontLvl`)
- **Toolkit**: per-string **Grouped** collections sharing one VPX light name; shadow casters split out. Grouped GI must **not** cast ball shadows; Split = per-light ball shadows (LW3)
- **GI ON/OFF fading (pre-toolkit)**: paired ON (layer 7, depth bias 0) / OFF (layer 9, depth bias 30) copies cross-faded via `UpdateMaterial`; both non-static; normal maps on ON prims break `UpdateMaterial` in VR
- **Per-material fade exponents** (TFTC/iaakki): wood `aLvl^5`, plastics `^3`, metal `^2`, bulb glass `^0.5`

## Lampz Fades (legacy) and the Native Fader

- Lampz/ModLampz **FadeSpeed by bulb type** (niwak, Iron Man): LED up 1/2, down 1/8; incandescent up 1/40, down 1/120 — the filament heats faster than it cools
- Use `Lampz.state()`, not `LampState()`; ModLampz internal levels cannot be overridden from outside (writes are overwritten each cycle)
- VPX 10.8 built-in incandescent fader working values: **40 ms up / 120 ms down**
- ⚠️ CONFLICT (secondary source, dated): Lampz usage guidance here is pre-10.8 era; [raw/reference/example-table.md](https://vpw-wiki.skirmishofwit.com/reference/example-table/) v1.5.15 (March 2024): "Lampz is no longer needed for either ROM or original tables" — see [VPX Example Table](VPX%20Example%20Table.md) for the lighting timeline
- GI cross-dimming (Black Rose): multi-color GI boost collection with `IntensityScale = (1 - gi2lvl) * gi1lvl` outside Lampz, for red-only states

## Ball Brightness and GI

- Ball brightness tracks GI level + distance to the nearest GI light (niwak)
- The Day/Night slider affects ball and lights but **not** baked toolkit primitive textures — tune separately
- "Skitso-style" ball-reflection lights at z≈52 around slingshots, tied to GI strings — **only real VPX lights reflect on the ball; flasher textures do not**
- GI bulb light centers at the physically correct bulb top — camera-POV offsets break in VR (Cactus Canyon); shadow-casting lights above the playfield drift with head movement in VR (Tommy)

## GI Color

Render GI **pure white in Blender, tint in script** (Haunted House/Stargate) — unlimited user color presets without re-rendering. Bop's 13-mode GI color system; iaakki caveat: RGB recoloring is a hack that can wreck the bake. Real GI ≈ **2700K** — 3000–3200K is only needed under Filmic; correct under Tony McMapFace/AgX (see [VPX 3D Art Pipeline](VPX%203D%20Art%20Pipeline.md)).

## Flasher Decay Curve

Canonical timer (raw §Flasher Decay; identical code in insert-lighting.md and the example table):

```vbs
FlashLevel = FlashLevel * 0.93 - 0.01
flashx3 = FlashLevel * FlashLevel * FlashLevel
Flasher.opacity = 110 * flashx3
Light.IntensityScale = 3 * flashx3
```

with per-solenoid `SolCallback` resetting `FlashLevel = 1`. Variation per element (speed, intensity, amber RGB shift) avoids the "Christmas tree" look; fade-up ramps matter for System 11 domes; **slow fadedowns → stacked flash events → catastrophic performance** (Metallica). A flasher sum limiter caps total multiball intensity (Simpsons PP); GI-aware opacity `(100 - 30*gilvl) * ObjLevel` (Jokerz). The asymmetric `FadeDisableLighting` insert ramp: down −0.25/step, up −0.5/step.

## Flasher Domes (Flupper)

From raw §Flasher Domes: name-pattern-driven iteration requires exact naming (`f1` + solenoid number: `f109`); 3 bloom elements per flasher; clear domes: delete back faces + larger lit-state duplicate mesh; dome rotation via script, not mesh rotation (texture is camera-fixed); lit/unlit dual prims — the base prim must use the OFF texture; filament glow one-liner `pBulbTest.BlendDisableLighting = 25 * ObjLevel(14)`; collection BDL wrapper sub registered via `Lampz.Callback(110) = "DisableLightingColl ColTest, 25,"` (legacy path).

## SolCallback vs SolModCallback and PWM

- `SolCallback(n)` is binary 0/1 and **fires with both True and False** — guard with `If Enabled Then`
- `SolModCallback` delivers 0–255 PWM (not universal); modulated values are erratic in practice (Congo Sol17: 27/72/109/36 at 56–3023 ms) → per-flasher decay timers beat direct drive; normalize WPC 0–255 → 0–100 opacity using observed real maxima
- **PinMAME 3.6 PWM migration**: `UseVPMModSol = 2` (1 = legacy), float 0..1 signals, remove SolMask arrays, fader Incandescent for lamps / None for PWM flashers; WPC/Whitestar-SAM need PWM, Sys11/DE relays benefit less; flipper-output PWM was added to PinMAME because of Scared Stiff; GI relay sounds need 0.01/0.99 threshold triggers under PWM
  - ⚠️ CONFLICT (secondary source): `UseVPMModSol=2` "can strand DOF solenoids on at startup → add `MAX100` in the DOF config"
    ([raw/vpw-wiki/docs/guides/troubleshooting.md](https://vpw-wiki.skirmishofwit.com/guides/troubleshooting/), §ROM) — Primary: DOF docs do not mention this interaction (see [DirectOutput Framework](../projects/DirectOutput%20Framework.md))

## Flasher Discovery and Conventions

- Naming `f1` + solenoid number (`f109`, `f125`) — the leading 1 disambiguates from lamps; simultaneous flashers may share one VPX light name
- Discovery for undocumented DE tables: test-flasher per candidate solenoid + `vpmTimer.PulseSw <n>`; an attract-mode solenoid dump found Sys11 backglass flashers on solenoids 33–36
- **Preload flasher textures at init (invisible opacity) to kill first-fire stutter** (Cactus Canyon/Indiana Jones)
- System 11 backbox flasher relay click sounds are authentic — keep them subtle
- Ramp BDL tied to GI: `lramp.blenddisablelighting = 0.01 * LM_giTop_Parts.opacity`; Hook pattern `gilevel * 0.12 + 0.03` (constant = minimum ramp visibility)

## Room Brightness

Bake with room lighting ON, then only darken via `SetRoomBrightness LightLevel/100` (scales bakemap material base colors toward black — it cannot brighten past the baked value). Double-darkening occurs if both `primitive.color` and SetRoomBrightness are used (CFTBL). `DisableStaticPrerendering` (build 1666+) enables live room-brightness changes without a restart; **VPX 10.8.1 changed it to an enable/disable count — set True once entering the options menu, False once leaving** ([raw/reference/example-table.md](https://vpw-wiki.skirmishofwit.com/reference/example-table/), §VPX 10.8+).

## See Also

- [VPX Insert Lighting](VPX%20Insert%20Lighting.md) — insert layers and the shared BDL semantics
- [VPX Lights and Rendering](VPX%20Lights%20and%20Rendering.md) — engine lighting model
- [VPX Scripting Patterns](VPX%20Scripting%20Patterns.md) — SolCallback guards and timer tiers
- [VPX 3D Art Pipeline](VPX%203D%20Art%20Pipeline.md) — GI baking in the toolkit
- [VPW Knowledge Base](../sources/VPW%20Knowledge%20Base.md) — source collection (secondary)
