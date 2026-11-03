# VPX Insert Lighting

Insert rendering techniques across the three community eras — Skitso flasher inserts, the Flupper 3-layer system, and VLM toolkit inserts — with the depth-bias, z-fighting, additive-material, and lightmap mechanics that make inserts work.

> ⚠️ Priority: Secondary — from the [VPW Knowledge Base](../sources/VPW%20Knowledge%20Base.md) (authoring community); Primary sources win on conflicts. Raw: `[raw/vpw-wiki/docs/guides/insert-lighting.md](https://vpw-wiki.skirmishofwit.com/guides/insert-lighting/) ("the definitive insert reference" per the collection, 30+ table builds).

## The Three Eras

From raw §Three Eras:

1. **Skitso flasher inserts** (pre-10.8) — require playfield reflections enabled
2. **Flupper 3-layer system** — ~5 elements per insert (ON, OFF, lens, light, flasher):

   | Layer | Depth bias | BlendDisableLighting | Z | ZSize |
   |-------|-----------|----------------------|---|-------|
   | OFF | 1000 | 1 | 0 | 6 |
   | ON | 1100 | 0 | 0 | 6 |
   | BULB | 1200 | 1 + DisableLightingFromBelow=1 | −3 | 30 |

   The VPX light exists for ball reflection only; the ON layer's BlendDisableLighting is the visible illumination
3. **VLM toolkit** — two Blender lights per insert, one VPX light. Space Station two-layer depth trick: under-PF opaque color + top glass layer, depth bias −1000 + layer separator

Depth-bias values **reset silently after crashes and VPX updates — re-verify all layered primitives** (raw §Z-Fighting; corroborated in troubleshooting.md).

## BlendDisableLighting Semantics

From raw §DisableLighting Semantics:

- `DisableLighting` (DL): **0 = fully lit by the scene (darkest), 1 = fullbright**; scripts can exceed 1.0; the editor clamps 0–1
- `BlendDisableLighting` (BDL) = self-illumination on additive/transparent primitives; script values >1.0 overbright
- **Never negative** — Metallica: colors invert and wash out

## Toolkit Two-Light Method

Bottom cavity light + a top spherical "spread" light; the top light only needs to look right from the bake camera; an invisible dispersing mesh inside the toolkit insert — a light above that mesh gives a harsh hotspot (raw §Blender Two-Light Method).

Insert brightness: high environment light during a bake drowns insert lightmaps — compensate with double upper-light strength ("+50%"). Debug in `Table1_Init`: two `UpdateMaterial` calls setting `VLM.Bake.Active`/`VLM.Bake.Solid` to RGB(0,0,0) black out environment and GI to inspect raw inserts (raw §Insert Brightness).

## Insert Cups and Tray Tuning (iaakki, Batman DE)

From raw §Insert Cups: bake inserts into shallow cups (flat inserts look wrong in VR); tray at Z=0 with origin at top; **insert opacity 0.995–0.999 — tiny changes matter**. Tune in order: light intensity 0 → opacities/colors → off-prim dark at 0.8–0.95 → bulb-prim hot spot → on-prim → finally the VPX light at height −3, transmit 0, falloff ~3, intensity ~5, ball reflection only.

## Additive Inserts (10.7.1+, niwak, Game of Thrones)

- OFF prim: static + non-active material
- ON prim: non-static + "active" material, color mid-gray **127** (compensates VPX's ×2 environment multiply when DL=1)
- Change `.color` on the **primitive**, not the material

## VPX 10.8 "Lightmap" Property

The Lightmap property auto-drives primitive opacity from the linked light (render mode Hidden, fader Incandescent) — replaces custom fader subs; fine control via `_Animate` + `GetInPlayIntensity/Intensity` (raw §Lightmap Property). Color changes from script propagate to attached lightmaps when the lightmap name contains the light name or the light name is in `UserValue` (see [VPX Light State Controller](VPX%20Light%20State%20Controller.md)).

- The "Active" material checkbox being unchecked makes objects ignore GI changes (raw troubleshooting.md)

## Z-Fighting and Depth Bias Rules

- Insert z = −0.1 (not 0); ball shadow z = 1.01 VP units; playfield bakemap z = −0.2 in Blender (−4.7 breaks)
- niwak scale trick: shrink the opaque bottom prim to 99.99% instead of using depth bias (backend-consistent)
- VR: ON=0 / OFF=30 minimum depth-bias separation; bloom bleed-through of OFF prims → bloom strength 0.01, halo height −0.5; cabinet underside visible through inserts → dark bottom texture/blocker

## Insert Split, Masks, Layer Separator

- The insert collection's lightmapper property must be **Split** for per-insert lightmaps — re-run group + render after changing it
- Toolkit inserts need two mask layers (text mask + shape mask)
- **Layer separator between the playfield and under-PF inserts, not below** — wrong placement causes bleed and reduced light influence

## Text, Bloom, Color

- Insert text: separate image layer / second flasher; Image mode "World" not "Wrap" for overlapped text; per-insert shadows parallel to the text baseline; 5 px transparent border + 2 px overlap into the hole; no anti-alias on playfield insert-hole edges (jaggies with the flasher method)
- Bloom lights: size ≈ 1/3 of the intuitive size (sixtoe); dual light — under-PF white core + over-PF very dark colored bloom; naming `LL001`/`LLb001` exploits VPX auto-increment on copy/paste; **falloff power 1 emits no visible light — use 3–4**
- Never pure RGB: use RGB(255,32,0), FF0505 not FF0000, so the DL ramp gains warm highlights; red bleeds (lower intensity), blue needs more
- Verify insert colors against IPDB blank-playfield photos (the F-14 crosshair insert is white plastic that only appears green under GI bulb covers)
- **Normal maps: tangent space mandatory** (object space breaks VR); normal maps on ON prims silently break `UpdateMaterial` in VR — keep them on OFF prims only
- VPX 10.8: the visual playfield can be non-static, so alpha transparency works — the 132-alpha Photoshop hack is obsolete (GIMP was always fine)
  - ⚠️ CONFLICT (secondary source, internal to VPW): 3d-art-pipeline.md §Playfield Mesh Setup says "the playfield texture's alpha channel does not work in VPX"
    ([raw/vpw-wiki/docs/guides/3d-art-pipeline.md](https://vpw-wiki.skirmishofwit.com/guides/3d-art-pipeline/) — same collection, insert-lighting.md §Playfield Alpha Cutouts: "VPX 10.8 … the visual playfield can be set to non-static, which means alpha transparency works correctly." Reconciliation: the static-rendered mesh has dead alpha; a non-static image primitive's alpha works

## See Also

- [VPX Lights and Rendering](VPX%20Lights%20and%20Rendering.md) — engine-level lighting system
- [VPX GI and Flashers](VPX%20GI%20and%20Flashers.md) — flasher decay code shared with inserts
- [VPX Light State Controller](VPX%20Light%20State%20Controller.md) — driving insert states in script
- [VPX 3D Art Pipeline](VPX%203D%20Art%20Pipeline.md) — toolkit bake side
- [VPW Knowledge Base](../sources/VPW%20Knowledge%20Base.md) — source collection (secondary)
