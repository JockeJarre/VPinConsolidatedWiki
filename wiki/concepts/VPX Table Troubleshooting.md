# VPX Table Troubleshooting

Symptom → cause → fix cookbook for VPX table authoring, distilled from the VPW troubleshooting guide: rendering, physics, scripting, sound, ROM, Blender, VR, and editor entries.

> ⚠️ Priority: Secondary — from the [VPW Knowledge Base](../sources/VPW%20Knowledge%20Base.md) (authoring community); Primary sources win on conflicts. Raw: `[raw/ExternalWikis/vpw-wiki/repo/docs/guides/troubleshooting.md](https://vpw-wiki.skirmishofwit.com/guides/troubleshooting/) (40-entry symptom index). Process-level regression bisecting is on [VPX Debugging](VPX%20Debugging.md).

## Rendering

- **Black playfield** — `playfield_mesh` placed in the `ON_Prims` collection (10.8 splits visible vs physics mesh)
- **Missing bakemaps** — no light collection set to "Solid" render mode
- **Reflections gone** — duplicate `playfield_mesh` primitives; keep exactly one
- **Depth bias is counter-intuitive: the topmost element needs the biggest negative** (insert ON=0, OFF=30); values reset silently after crashes/updates — re-verify
- **Transparency/refractions = #1 performance cost** (niwak top-3: limit non-opaque parts, bake groups, active lights)
- Insert lightmaps pruned at influence < 0.01 on near-black playfields — never pure black; minimum #111111
- **32-bit VPX downsamples nestmaps → blurry on GI activation; use 64-bit** (32-bit deprecated per Niwak)
- Near-plane culling near the lockdown bar — place an invisible ramp as a spacer
- Objects ignore GI changes — material "Active" checkbox unchecked
- **F6 realtime depth bias broken since 10.7.0 (fixed 10.7.3) — use F5 + press D + `plastic001.depthbias = -200`**

## Physics

- **Ball through geometry** — causes: backface normals (collidable mesh needs thickness and outward normals), holes cut in the playfield mesh for rollovers (rollovers are software sensors — use transparent texture, not geometry), un-chamfered 90° edges vs fast balls
- **Ball hovering over flippers** — playfield mesh polygons inside the flipper swing arc
- **Sluggish flippers** — ball mass 1.3 (must be 1), elasticity ~0.88, blockers in front of slings
- Duplicate collidable primitives → jitter
- **Ramp-stuck balls** — friction 0.8 "velcro ramp" (unify at ~0.2), geometry gaps, fractional speed bumps; scripted velocity-nudge pattern (z/x bounds + `vely -= 0.1`) as a last resort
- **Pop bumper radius = metal ring / rubber skirt, NOT the visual cap** (Big Bang Bar 43→38)
- Inlane-post ball curl → reshape the post collision geometry

## Scripting

- Missing SolCallback sub → async runtime errors; stub them all
- Solenoid fires twice → missing `If Enabled Then` guard
- gBOT segfault in standalone → use `GetBalls` in `Cor.Update` (see [VPX Scripting Patterns](VPX%20Scripting%20Patterns.md))
- 1 ms fixed timers → catch-up spiral; use −1 per-frame for visuals (moving `Cor.Update` to the FrameTimer recovered 20–30 FPS)
- Duplicate variable declarations — 10.8.1 flags them as validation warnings
- `vpmTimer.Add` + globalplugin namespace collisions → cryptic `VBSE_OLE_NO_PROP_OR_METHOD`; prefix subs, convert to queue/tick timers

## Sound

- `AudioPan` crash — the passed object (e.g. a wall) lacks X/Y; pass primitives/kickers/targets
- **bass.dll bug in early 10.8 permanently corrupts saved sound files — rebuild the table from a pre-corruption backup**
- WPC ROM sound clips at volume 31 — use 30
- Stereo playfield sounds degrade SSF — convert to mono

## ROM

- `UseVPMModSol` 0/1/2 semantics: 2 = float 0..1 physics, needs adapted callbacks; Whitestar needs 2; **2 can strand DOF solenoids on at startup → `MAX100` in the DOF config** (see [DirectOutput Framework](../projects/DirectOutput%20Framework.md))
- `HandleMech = 0` for stepper mechanisms (GitHub #226)
- Missing PulseTimer → Bally 6803 won't coin up
- **Delete the `.nv` (e.g. `cc_12.nv`) and `.cfg` files in the VPinMAME nvram directory for erratic ROM behavior — try this before blaming the script**
- Tilt + crash persists: bumper/sling thresholds saved at 100 → set them at init

## Blender

- Toolkit "Optimize Mesh" deletes thin wire geometry (spinner/gate wires) — disable per mesh
- Export button grayed — any object with nestmap −1 (usually an inverted-normal plane)
- Blackbody nodes break across Blender versions → all-red render
- Blender 4.0 vs 3.6 renders differ; 4.1 restored light soft falloff (toolkit: 3.6 confirmed, 4.0 broken)

## VR

- VR-collection primitives affect physics (walls collidable only in VR)
- Light swimming on transparent+static objects → set active; playfield opacity 1.0/cutouts
- Ghosting = probe roughness; backglass depth ordering −500/+100 — see [VPX VR Authoring](VPX%20VR%20Authoring.md)

## Editor

- Editor window lost off-screen → delete the window-position registry entries (the built-in reset is unreliable)
- 10.8.1 validation warnings to clear before release: duplicate vars, sub-60 FPS timer periods, mono DMD/sound, legacy textbox-DMD → flashers, legacy spherical ball mapping

## See Also

- [VPX Debugging](VPX%20Debugging.md) — regression bisecting, logs, crash reporting
- [VPX Scripting Patterns](VPX%20Scripting%20Patterns.md) — patterns whose misuse causes many entries
- [VPX Physics Tuning](VPX%20Physics%20Tuning.md) — correct physics values
- [VPX Authoring Best Practices](VPX%20Authoring%20Best%20Practices.md) — pre-release checklist
- [VPW Knowledge Base](../sources/VPW%20Knowledge%20Base.md) — source collection (secondary)
