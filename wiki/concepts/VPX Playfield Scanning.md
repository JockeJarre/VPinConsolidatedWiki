# VPX Playfield Scanning

Community procedure for capturing real-machine playfield artwork for VPX tables: the distortion-free scanner requirement, DPI verification, standard playfield dimensions, VP-unit conversion, and AI upscaling.

> ⚠️ Priority: Secondary — from the [VPW Knowledge Base](../sources/VPW%20Knowledge%20Base.md) (authoring community); Primary sources win on conflicts. Raw: `[raw/vpw-wiki/docs/guides/build-workflow.md](https://vpw-wiki.skirmishofwit.com/guides/build-workflow/), `[raw/vpw-wiki/docs/guides/3d-art-pipeline.md](https://vpw-wiki.skirmishofwit.com/guides/3d-art-pipeline/), `[raw/vpw-wiki/docs/reference/tools-resources.md](https://vpw-wiki.skirmishofwit.com/reference/tools-resources/)

## Scanner Requirement

- **HP Scanjet 4600/4670** see-through flatbed scanners: "the only scanners" that scan a playfield without distortion (the glass lip of normal flatbeds distorts). Discontinued; the USB cable can be spliced (~30 min solder). Scan at 300–600 DPI TIFF in a dark room; 15–20 minutes per playfield
- **Epson 4490** for raised objects — plastics, backglass (needs adjustable focus/depth of field); scanners struggle with plastics (transparency + depth)
- **Epson V39** for flat decals only (razor-thin focal range, USB2 issues)
- Cameras add barrel/pincushion distortion — apply Photoshop Lens Correction with EXIF data; calibrate with a photographed grid
- Hardtop overlays from outsideedgeproducts.com (~$350) are a clean art source where available

## 3D Scanning

From [raw/reference/tools-resources.md](https://vpw-wiki.skirmishofwit.com/reference/tools-resources/), §3D Scanning:

- **Polycam** (iOS): lazy-susan rotation; decimate 100K→4.6K tris in Blender; bake normal maps
- **Qclone** (iOS photogrammetry): printable grid, 30–40 photos, free with paid export
- **3DF Zephyr** (PC photogrammetry)

## Stitching and Scaling Rules

- **Autopano Giga** (now free; Windows 11 fix: rename `libeay32.dll`), **PTGui** (most accurate, expensive), Photoshop Photomerge (acceptable after lens correction)
- Stitch manually with a difference-layer check (~30 min)
- **Never scale stitched scans** — crop down to ~150 DPI at the asset's real display size instead

## DPI Verification and Dimensions

Verify before building (raw §Dimension Verification):

1. Pixel count ÷ DPI must match the physical playfield
2. Circular features serve as a circularity check
3. Export VPX→Blender to read exact table dimensions; aspect-ratio mismatch = stretched scan

Standard playfield dimensions:

| Machine class | Size | VP width |
|---------------|------|----------|
| Williams/Bally standard, WPC | 20.25″×46″ | 952 VP |
| Bally widebody (Black Rose) | 23″×46″ | — |
| DE widebody (WWF/GNR/Batman F) | check service bulletin | — |
| Gottlieb System 1 | 20.25″×42″ | — |
| Stern modern | 20.25″×45″ | — |

**VP unit conversion: `VP = inches × 800 / 17`; 50 VP = 1.0625″ = one ball diameter (27 mm); 47.059 px/inch** (the editor's Dimension Manager rounds to 47 and is imprecise).

## Color Correction and Upscaling

From [raw/guides/3d-art-pipeline.md](https://vpw-wiki.skirmishofwit.com/guides/3d-art-pipeline/)

- Lift blacks without crushing; GIMP Selective Gaussian Blur for JPEG artifacts
- Playfield clearcoat simulation: 4 px blur layer at 50% opacity, insert holes cleared first
- **chaiNNer** AI upscaling in Photoshop with layered models (`realesrgan-x4plus-anime_x4`, `UltraMix_Restore`; models at openmodeldb.info); Topaz Gigapixel "High Fidelity" for faces/organic; waifu2x works well on plastics
- GnR nestmaps upscaled to 14976×16384 with no FPS impact; **a high-res scan beats upscaling**
- Fonts: identify via whatfontis.com / Fontspring Matcherator, then **re-type text — never upscale it**
- Compression: Optimage/ImageOptim (macOS) — lossless PNG −60%, WebP −90%. WEBP saves 30–50% vs PNG but forces 72 DPI — bad for playfield scans

## Public Art Sources

From [raw/reference/tools-resources.md](https://vpw-wiki.skirmishofwit.com/reference/tools-resources/), §Reference Sites (as of the 2026 snapshot; links volatile): ebislit.com (stitched playfield repo), pinballrebel.com/pinball/cards/ (aprons/labels), kms-handel-shop.de (Stern plastics/translite imagery), londonpinball.co.uk (decals), IPDB, Pinside, VPUniverse.

## See Also

- [VPX 3D Art Pipeline](VPX%203D%20Art%20Pipeline.md) — what happens to the scan next
- [VPX Table Build Workflow](VPX%20Table%20Build%20Workflow.md) — where scanning fits in the build
- [VPX Authoring Tools](VPX%20Authoring%20Tools.md) — full tool directory
- [VPW Knowledge Base](../sources/VPW%20Knowledge%20Base.md) — source collection (secondary)
