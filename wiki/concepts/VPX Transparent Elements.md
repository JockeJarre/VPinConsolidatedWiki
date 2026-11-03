# VPX Transparent Elements

Authoring guidance for transparent geometry in VPX — ramps, plastics, and glass: refraction probe rules, ramp baking methods, wire-ramp techniques, glass "mayo" and dust effects, and the dominant transparency performance ceiling.

> ⚠️ Priority: Secondary — from the [VPW Knowledge Base](../sources/VPW%20Knowledge%20Base.md) (authoring community); Primary sources win on conflicts. Raw: `[raw/ExternalWikis/vpw-wiki/repo/docs/guides/transparent-elements.md](https://vpw-wiki.skirmishofwit.com/guides/transparent-elements/)

## Quick Rules

From raw §Quick Start:

- **One refraction probe per depth layer** — overlapping layers sharing one probe make a layer vanish
- Probe thickness: 1–4 for plastics, 5 for thin ramps (per-build consensus: Medieval Madness 4, No Fear 1–4; thick props 10–20, e.g. the LOTR sword)
- **Probe roughness 0** — up to 40% FPS gain; the roughness blur is a DX9-era renderer limit (apophis79: zero roughness is realistic for a freshly clearcoated table); roughness drives white-flash/ghosting bugs (see [VPX VR Authoring](VPX%20VR%20Authoring.md))
- Transparent objects: **"Hide Parts Behind" UNCHECKED** — niwak: depth masking on transparents is "usually a bug"; the toolkit sets this automatically from "Opaque"
- Plastics: PNG + alpha (JPG kills transmission); UV-unwrap **after** Solidify
- Blender Cycles transparent bounces **16–32** (Render → Light Paths); low values = cloudy shadows

## Ramp Baking Approaches

From raw §Ramp Baking, three methods:

1. **POV-projected texture** — looks right only from the bake camera; desktop-only
2. **UV-unwrapped** — correct from all angles, less glossy; Blender 3.6 "bake from camera" + AI denoise handles backfaces for VR
3. **Hybrid** (benji084, Godzilla) — POV pass + separate UV-transparent bake, imported as two meshes with separate materials and probes

Keep environment glossiness enabled during baking, or ramps look flat.

**Ramp visibility (CFTBL)**: three knobs — bakemap EXR grey alpha overlay 5–8% (20% = too opaque), Blender material alpha, VPX refraction tint darkening. The "invisible → too opaque" window is single-digit percentages.

**Aged ramps**: Subsurface Scattering on the ramp material reproduces milky aged acrylic (CFTBL, reference-photo driven).

## Refraction Probes in VPX

- Created in the VPX Render Probe Manager, assigned per primitive with thickness; roughness = fogginess
- Ghost/doubling artifacts when one primitive spans multiple depth levels → split the mesh at depth transitions (sixtoe split Justice League ramps into 4)
- **Removing ramp refractions: 100%→90% GPU cost** (GTX 1060 4K60 became playable); expose a refraction toggle in the F12 options menu
- SSR on ramps is deprecated with the toolkit ("no need for SSR" — apophis79)
- VPX ramps do not support BlendDisableLighting (raw tables/index.md, Transporter)

## Wire Ramps and Plastic Edges

- Wire ramps: Blender + Octane bake (F-14 Tomcat "best wires ever"); visual mesh + invisible VPX ramp for physics
- Poly budget is critical: Spider-Man 70K→17K tris with no visible change; Lethal Weapon 3 multiball stutter from overlapping alpha meshes multiplying exponentially (500K × 5 layers = 2.5M effective)
- Toolkit plastic edge technique (Police Force/benji084): minimal-diffuse bake + fake RGB-split white edge strips; VPX material settings **Edge Opacity 0.5, Transparency Thickness 1, Refraction Thickness 10, Refraction Roughness 2**
- Pre-10.8 Cactus Canyon: Flupper vertex-painted alpha in Cinema 4D

## Depth Bias for Transparent Overlaps

Counter-intuitive: the **topmost** element gets the biggest **negative** bias (−10000), lower elements positive (Batman DE). Insert convention ON=0 / OFF=30 (Indiana Jones); values reset after crashes. Pure black breaks light transport through transparents — minimum RGB(10,10,10) (Stargate). Z-fighting fixes: 99.99% scale trick (niwak, Iron Man), playfield depth bias −500 (Police Force), insert z −0.1, ball shadow 1.01. See [VPX Insert Lighting](VPX%20Insert%20Lighting.md).

## Glass Effects: Mayo and Dust

- **"Mayo"** = flasher glass-reflection smudges at glass height over each flasher, per-flasher script control (`f6_mayo.intensityscale = p * 0.5`); Metallica refinement: exponential falloff (level²/level³); always optional in the F12 menu
- Glass dust: a plane primitive with a dust texture, opacity from its alpha channel (ambientcg.com public-domain PBR sources)

## Performance Ceiling

- **"Limit non-opaque parts" is the #1 performance rule** (niwak top-3)
- Bumper caps (two-mesh dome, each with its own probe) cost more than ramps
- F11 stats showing transparent elements at 50% of frame time = overload (Tron)

## Transparent Shadow Fix

Blender Light Path node: *Is Shadow Ray* → Mix Shader between the plastic shader and a Transparent BSDF, so plastics stop casting opaque shadows (niwak, Iron Man) — critical under plastic ramps and protectors.

## See Also

- [VPX 3D Art Pipeline](VPX%203D%20Art%20Pipeline.md) — probe management, bake workflow
- [VPX Insert Lighting](VPX%20Insert%20Lighting.md) — depth-bias conventions
- [VPX VR Authoring](VPX%20VR%20Authoring.md) — VR-specific transparency bugs
- [VPX Table Troubleshooting](VPX%20Table%20Troubleshooting.md) — symptom-indexed fixes
- [VPW Knowledge Base](../sources/VPW%20Knowledge%20Base.md) — source collection (secondary)
