# VPX VR Authoring

Table-authoring guidance for shipping VR support: VR room creation, the `VRRoom` variable, VR-specific rendering bugs (probe roughness ghosting), blocker walls, backglass depth bias, and the frame-pacing performance budget.

> ⚠️ Priority: Secondary — from the [VPW Knowledge Base](../sources/VPW%20Knowledge%20Base.md) (authoring community); Primary sources win on conflicts. Raw: `[raw/vpw-wiki/docs/guides/vr-development.md](https://vpw-wiki.skirmishofwit.com/guides/vr-development/) Player-side configuration is on [VPX VR Setup](VPX%20VR%20Setup.md).

## VR Rooms and the VRRoom Variable

- `VRRoom` script variable: **0 = desktop, 1 = standard room, 2 = room + backglass positioning**
- Ship releases with **VRRoom = 0** for desktop — VR-room primitives cost 20–40 FPS
- Rooms: low-poly baked meshes, **baked ambient lighting only** — never dynamic lights that fight table GI (the Fish Tales room hit 75 MB)
- Hide desktop-only elements in VR: `Textbox1.visible = false`, `Table.BackdropImage_DT = Empty`
- Mode-switch pattern: `If VRRoom = True Then` swaps primitives/materials; a "playmode" F12 option (0=Desktop/1=Cab/2=VR); separate VR ramp textures

## Rendering Bugs Specific to VR

- **Non-zero render probe roughness causes white flashing and ghosting in VR** (GitHub issue #939) — ship two probes (rough desktop / zero-rough VR) and switch by mode; removing roughness gives up to +40% FPS even on desktop. See [VPX Transparent Elements](VPX%20Transparent%20Elements.md)
- High light `transmit` → floating artifacts in VR; wire-ramp meshes need `DisableLightingFromBelow = 1`
- GI bulb light centers at the physical bulb top, not a POV-adjusted position
- Light "swimming" in VR on static+transparent primitives → set them active (static primitives cannot be script-changed; costs performance)
- Normal maps in tangent space only; normal maps on insert ON prims silently break `UpdateMaterial` in VR

## Blocker Walls

Copy the cabinet primitive, shrink it fractionally, flip normals inward → an inner shell blocking see-through at the plunger lane. Purely visual; first done on Breakshot, now standard. Sideblade z-fighting: `DisableLightingFromBelow = 1`; mirrored sideblades need "dynamic" bakemap reflections. Cabinet underside visible through inserts → dark bottom texture/blocker.

## Backglass in VR

- VR backglass depth bias: BGBright **−500** / BGDark **+100** — desktop values do not transfer; test in the headset
- Flashers behind the backglass image are preferred over B2S for VR; the toolkit can bake segment displays into the VR backglass

## Performance Budget

- **Frame pacing beats raw FPS**: a flat 110 is better than a fluctuating 130–150
- 90 Hz Oculus standard; GTX 1060 minimum, GTX 1660 satisfactory
- Overlapping refractions cost more than single ones — reduce thickness; disable `quality_smaa` for VR
- Timer consolidation matters most in VR
- Any LUT costs performance at VR resolution; an undefined LUT slot freezes head tracking (VPX bug #1741)
- Expose in the F12 options menu: probe roughness, refractions, scratches, LUT, room brightness (the F12 menu can make the backglass vanish in VR)

## Backend

- Niwak recommends **OpenGL** for VR: exact refresh delivery, MSAA, adaptive sync; 90 Hz Oculus standard
  - ⚠️ CONFLICT (secondary source): "VPX supports OpenGL for VR rendering… recommended for both desktop and VR play"
    ([raw/vpw-wiki/docs/guides/vr-development.md](https://vpw-wiki.skirmishofwit.com/guides/vr-development/), §SteamVR vs OpenXR) — Primary: [Visual Pinball X](../projects/Visual%20Pinball%20X.md) marks OpenGL deprecated, superseded by BGFX/OpenXR. The VPW knowledge base documents DX9/OpenGL-era builds (~2020–2023); on current VPX use BGFX/OpenXR

## Ball Reflections

- The ball image should equal the table environment image (equirectangular, not the legacy spherical map)
- The playfield image must be assigned even if the mesh is invisible
- `PlayfieldReflectionScale = 0` for marbles

## Fake Reflections

Sixtoe: "Fake reflections look bloody awful in VR, always" — prefer material quality; a dust/dirt flasher layer at opacity 200–250 sells glass.

## VR Testing Exposes Geometry

VR reveals ramp geometry errors (uphill wire ramps), insert z-fighting at shallow angles, and cabinet-underside visibility — test desktop **and** VR before release. FlexDMD in VR: F1 → External DMD; one FlexDMD instance only; no flasher-Use-DMD-script duplication.

## See Also

- [VPX VR Setup](VPX%20VR%20Setup.md) — player-side VR configuration
- [VPX Stereo 3D](VPX%20Stereo%203D.md) — stereoscopic rendering modes
- [VPX Transparent Elements](VPX%20Transparent%20Elements.md) — probe rules shared with VR
- [VPX Table Build Workflow](VPX%20Table%20Build%20Workflow.md) — VR specialist role in the build
- [VPW Knowledge Base](../sources/VPW%20Knowledge%20Base.md) — source collection (secondary)
