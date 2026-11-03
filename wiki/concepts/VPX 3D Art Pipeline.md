# VPX 3D Art Pipeline

The Blender-to-VPX authoring pipeline used by premium tables: the VPX Lightmapper (VLM) toolkit collections and export settings, bake/nestmap architecture, EXR HDR workflow, tonemappers, model cleanup, and render probes.

> ⚠️ Priority: Secondary — from the [VPW Knowledge Base](../sources/VPW%20Knowledge%20Base.md) (authoring community); Primary sources win on conflicts. Raw: `[raw/ExternalWikis/vpw-wiki/repo/docs/guides/3d-art-pipeline.md](https://vpw-wiki.skirmishofwit.com/guides/3d-art-pipeline/), `[raw/ExternalWikis/vpw-wiki/repo/docs/guides/build-workflow.md](https://vpw-wiki.skirmishofwit.com/guides/build-workflow/)

## VLM Toolkit Compatibility

- **VPX Lightmapper Toolkit** — the core Blender plugin: batch render, lightmaps, nestmap packing, VPX export
- **Blender 3.6 confirmed working; 4.0 broken** (bump maps/export unreliable); 4.1 restored light soft falloff (raw §Toolkit Compatibility, troubleshooting.md §Blender)
- X-Men was the toolkit's first real project, proving one-click Blender→VPX (raw tables/index.md)

## Collection Schema

From raw §Blender Toolkit Workflow:

| Collection | Role |
|-----------|------|
| `VLM.Bake` | static bake targets; `.Solid` on opaque, `.Active` on transparent; movables get `_Animate` |
| `VLM.Lights` | inserts **Split**, GI per string **Grouped** (shadow casters split out), flashers Split, room lights Solid |
| `VLM.Movables` | animated mechanisms — must NOT have the static flag |

- At least one light collection in "Solid" render mode, else no bakemaps are exported
- Insert light naming `p32on`/`p32off`/`p32bulb` (number = ROM lamp); flashers `f` + `1` + solenoid number (solenoid 9 → `f109`)
- **VPX has a 31-character hard name limit, silently truncated** → duplicate-name conflicts; keep component names ≤6 chars; names cannot start with a digit; `NoExp` prefix on Blender modifiers excludes objects from export

## Batch Export Settings

- Nestmap size **8192** (256 explodes into dozens of tiny images); render ratio 25%/50%/100% for 1K/2K/4K passes — ratio × Blender render % are multiplicative
- **Max lights 12–16 to prevent GPU OOM** (0 = unlimited crashes GPUs)
- Export mode "Hide", not "Remove All"; delete the render-results directory when re-running the same blend filename
- Toolkit "Optimize Mesh" deletes thin wire geometry (spinner/gate wires) — disable per mesh (raw troubleshooting.md)
- Export button grayed = any object with nestmap −1 (usually an inverted-normal plane)

## Nestmap Architecture

- One image per lighting scenario per object (Bad Cats: 134 images for the playfield alone), trimmed into 8K nestmaps
- Two render methods: "Camera" render (shared lightmaps, fewer draw calls) vs "Unwrapped baked projection" (per-object lightmaps, manual UV unwrap)
- Nestmap packing starves peripheral objects — GnR's effective playfield width is only ~2050 px inside an 8K nestmap; keep effective width ≥2000 px (raw §Nestmap Architecture, best-practices.md)
- Toolkit prunes lightmap meshes below 0.01 light influence; a **pure black #000000 playfield is a divide-by-zero for light bounce → use minimum #111111**, a gamma-node lift, or noise in dark areas

## Post-Import Checklist

From raw §Import/Post-Import:

- Re-apply "Hide parts behind" on the playfield
- Reflection probe strength **0.2**, not 1
- Refraction probes on ramp layers (they are lost on import)
- Playfield image assigned (for ball reflections)
- Timers off VLM.Visual

## EXR / HDR Lightmaps

- Use DWAA compression, level 20–25 (45 destroys HDR brightness)
- EXR >1.0 values give true HDR flasher-fade detail; VPX converts textures to GPU float internally
- Photoshop editing risks 1-px seam shifts and clipping >1.0 — **Blender Texture Paint is the safe editor**

## Color Management

- **Tony McMapFace** (niwak's tonemapper; replaces Blender Filmic, which over-saturates; drop-in replacement of `datafiles/colormanagement`) — enables true 2700K GI
- **AgX tonemapper** for red-insert hotspots (not Reinhard/Filmic/Neutral)
- LUTs applied post-tonemap lose HDR: build saturated, desaturate with the LUT, never the reverse. LUTs shrink dynamic range; label "Color Saturation" and disable (not neutral) when unused
- HDRI: indoor, no bright point lights, strength ~0.3, desaturated; VPW named assets `shinyenvironment3blur4`, `artist_workshop_8k`
- Never set Blender material channels to exactly 0/1 (≥0.1)

## Model Cleanup and Polygon Reduction

From raw §Ramp Modeling / §Polygon Reduction:

- VPX-exported ramps always have unmerged vertices: merge by distance, delete internal faces, bevel **before** subdivision, clean UVs
- **Apply Solidify before UV unwrap** (unwrap after applying Solidify — CFTBL lesson); **never apply subdivision; must apply solidify before export**
- niwak reduction recipe: merge by distance → limited dissolve ~0° → reset normals → mark sharp → small bevel → weighted normals. Decimate breaks organic shapes
- Flupper remesh recipe: Solidify → Remesh → Decimate: 100K → ~2K tris
- Spider-Man: 70K→17K tris with no visible change; overlapping alpha meshes multiply cost exponentially (Lethal Weapon 3 multiball stutter)

## Render Probes

- Made in the VPX Render Probe Manager; **one per overlapping depth layer**
- Default thickness 10 is too much — use 1–4
- **Probe roughness 0 = up to 40% FPS gain**; roughness blur bugs: white flashing, VR ghosting (GitHub #939); VR needs a zero-roughness probe duplicate
- Stern "orange peel" playfields justify roughness 1–2 on desktop
- niwak top-3 performance: limit non-opaque parts, limit bake groups, limit active shadow-casting lights

## Parts Libraries

- **Niwak's Pinball Parts Library** — `github.com/vbousquet/pinball-parts`: screws, posts, era-specific bats, McMaster-Carr measurements
- **Flupper's Insert Collection** — VPW-internal (MEGA) links
- **VPX Core Parts Library** — <400 tris, modeled in inches

## Pivot and Orientation Conventions

- Pivot = Blender origin at 0,0,0; insert mesh pivot at the top surface
- Primitives have **two rotation systems: ObjRot applied first, then world Rot**
- Drop targets face the drain at RotZ=0

## Ambient Occlusion

Two options (raw §Ambient Occlusion): baked multiply into the playfield texture (~80%, reliable) — **recommended** — or a separate AO flasher layer tied to GI (`PlayfieldShadow.opacity = 110 - gilevel * 100`, prone to depth-bias clipping; Hook reverted this approach).

## VR Rooms

Authoring-side VR room guidance (raw §VR Room; full page: [VPX VR Authoring](VPX%20VR%20Authoring.md)): low-poly baked meshes, floor aligned to the VR floor plane, room rotated ~6° from the player for table slope, far plane 2000–3000; "VR blocker wall" = cabinet copy with normals flipped inward.

## See Also

- [VPX Insert Lighting](VPX%20Insert%20Lighting.md) — inserts in toolkit and pre-toolkit eras
- [VPX Transparent Elements](VPX%20Transparent%20Elements.md) — ramps, plastics, probes
- [VPX GI and Flashers](VPX%20GI%20and%20Flashers.md) — GI collections and flasher bake
- [VPX Playfield Scanning](VPX%20Playfield%20Scanning.md) — upstream art capture
- [VPX Authoring Tools](VPX%20Authoring%20Tools.md) — full tool directory
- [VPW Knowledge Base](../sources/VPW%20Knowledge%20Base.md) — source collection (secondary)
