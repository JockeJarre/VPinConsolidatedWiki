# VPX Authoring Tools

The community toolchain directory for VPX table authoring: scanning, stitching, texture/AI tools, Blender add-ons, parts libraries, VPX utilities, sound and display tools, DOF utilities, documentation references, and community sites.

> ⚠️ Priority: Secondary — from the [VPW Knowledge Base](../sources/VPW%20Knowledge%20Base.md) (authoring community); Primary sources win on conflicts. Raw: `[raw/vpw-wiki/docs/reference/tools-resources.md](https://vpw-wiki.skirmishofwit.com/reference/tools-resources/) (as of the 2026 snapshot; URLs volatile).

## Scanning and Photography

- **HP Scanjet 4600/4670** — the distortion-free playfield scanners (see [VPX Playfield Scanning](VPX%20Playfield%20Scanning.md))
- **Epson 4490** (plastics/backglass), **Epson V39** (flat decals only)
- 3D: **Polycam** (iOS), **Qclone** (iOS photogrammetry), **3DF Zephyr** (PC)

## Stitching

- **Autopano Giga** (now free, hdrmaps.com; Windows 11 fix: rename `libeay32.dll`)
- **PTGui** — most accurate, expensive
- Photoshop Photomerge — acceptable if lens-corrected first

## Image and Texture

- **Adobe Illustrator** (vector redraws, Brad1X); Inkscape for SVG traces
- **Photoshop exports alpha wrong for VPX** (value-132 workaround); **GIMP exports alpha correctly**
- **chaiNNer** AI upscaling (models at openmodeldb.info; recommended `realesrgan-x4plus-anime_x4`, `UltraMix_Restore`); **Topaz Gigapixel** ("High Fidelity" for faces/organic)
- **Optimage / ImageOptim** (macOS): lossless PNG −60%, WebP −90%
- **whatfontis.com / Fontspring Matcherator** — font identification, then re-type, never upscale

## 3D and Blender

- **VPX Lightmapper Toolkit** — the core Blender plugin (batch render, lightmaps, nestmap packing, VPX export); **Blender 3.6 confirmed, 4.0 broken**
- **Tony McMapFace** — niwak's tonemapper replacing Blender Filmic (drop-in replacement of `datafiles/colormanagement`)
- **Octane** renderer (physically accurate plastics/wire ramps); **Cycles** (standard toolkit baking)
- Parts libraries: **Niwak's Pinball Parts Library** (`github.com/vbousquet/pinball-parts`), **Flupper's Insert Collection** (VPW-internal MEGA links), **VPX Core Parts Library** (<400 tris, modeled in inches)

## VPX Utilities

- **vpxtool** — `github.com/francisdb/vpxtool`: decompiles `.vpx` to JSON/VBS/images for git; reversible via `vpxtool assemble`
- **PinAffinity** — mjrnet.org/pinscape/PinAffinity.html: dedicates CPU threads to pinball, cutting input lag and script timing jitter (see [VPX Latency](VPX%20Latency.md))
- **VPW Bot** — Discord check-in/check-out to prevent merge conflicts (see [VPX Table Build Workflow](VPX%20Table%20Build%20Workflow.md))
- **VPReg.stg viewer** — edit VPX persistent storage / high scores

## Sound and Display

- Fleep packages + Fleep Functions VBS — see [Fleep Sound Packages](Fleep%20Sound%20Packages.md)
- **BBC Sound Effects** (sound-effects.bbcrewind.co.uk); **Hanna-Barbera SFX** (2,200+ on archive.org)
- **FlexDMD** — scriptable DMD for original tables, built into standalone VPX
- **Freezy DMD Extensions** — external DMD rendering for VPinMAME; required for color DMD and 64-bit (see [DMD Extensions](../projects/DMD%20Extensions.md))
- **PUP** — video display system, separate pack alongside the VPX file (see [PinUp Player](../projects/PinUp%20Player.md))
- **B2S/DirectB2S** — as of v2.0, no separate x64 install needed (see [B2S Backglass Server](../projects/B2S%20Backglass%20Server.md))

## DOF and Output

- **DOF** with the shared online config DB (see [DirectOutput Framework](../projects/DirectOutput%20Framework.md))
- **DOTK v0.09** — `github.com/Vroonsh/DirectOutput/releases/tag/DOTKv0.09`; **v0.10 is buggy — use v0.09**
- **DOF Config Tool** — online cabinet configurator (see [DOF Output Controllers](DOF%20Output%20Controllers.md))

## Documentation References

- **VPForums VBS doc** (vpforums.org/Tutorials/vbsdoc.html) — the cvpm reference (see [VPX Scripting](VPX%20Scripting.md))
- **Orbital Pinball Framework docs** (docs.orbitalpin.com/vpx-documentation)
- **Visual Studio 2010 Isolated Shell** — VBScript debugging with full call stacks

## Community Reference Sites

IPDB, Pinside, VPUniverse (primary table distribution), VPForums; art sources and references listed on [VPX Playfield Scanning](VPX%20Playfield%20Scanning.md); **pinballmakers.com/wiki** (parts reference — "has known dimension errors"); **ambientcg.com** (CC0 PBR textures).

## Dimensions Quick Reference

WPC standard 20.25″×46″; Bally widebody the same (Black Rose); Gottlieb System 1 20.25″×42″; DE widebody — check the service bulletin. **`VP = inches × 800 / 17`; 50 VP = 1.0625″ = ball diameter.**

## See Also

- [VPX 3D Art Pipeline](VPX%203D%20Art%20Pipeline.md) — how the tools fit the pipeline
- [VPX Software Setup](VPX%20Software%20Setup.md) — installation and configuration
- [VPW Knowledge Base](../sources/VPW%20Knowledge%20Base.md) — source collection (secondary)
