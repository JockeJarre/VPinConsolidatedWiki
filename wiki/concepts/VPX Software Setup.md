# VPX Software Setup

Author/maintainer software setup for VPX table work: 32-bit vs 64-bit installs, performance settings, PinMAME 64-bit and PWM migration, B2S, PUP, FlexDMD, dmdext, DOF toolkit pinning, the scripting debugger, and Blender compatibility.

> ⚠️ Priority: Secondary — from the [VPW Knowledge Base](../sources/VPW%20Knowledge%20Base.md) (authoring community); Primary sources win on conflicts. Raw: `[raw/vpw-wiki/docs/guides/software-setup.md](https://vpw-wiki.skirmishofwit.com/guides/software-setup/)

## VPX Installation

- 32-bit and 64-bit **coexist by renaming the executables** — no uninstall needed
- **32-bit is effectively deprecated** (Niwak): ~300–350 MB tables lose textures (go white); 64-bit is mandatory for Big Bang Bar; 32-bit downsamples nestmaps (see [VPX Table Troubleshooting](VPX%20Table%20Troubleshooting.md))
- Performance order of attack: disable playfield reflections/FXAA/AO/SSR first, then resolution, then texture tier; check for table-forced video settings overriding user settings
- **Set Maximum Pre-Rendered Frames = 0 on VPX 10.8+** — the frame scheduler conflicts with the GPU queue → intermittent drops
- VSync override ships as −1 in table User properties (1 crashes loading)

## OpenGL vs DirectX

Niwak: **OpenGL** gives hardware adaptive sync, MSAA, exact refresh — recommended desktop, cabinet, and VR (DX9-era advice; current VPX uses BGFX — see [Visual Pinball X](../projects/Visual%20Pinball%20X.md)). DX9 software-emulated sync performs better on some hardware. GL quirk: FlexDMD hidden behind the playfield on some configs.

## PinMAME

- **64-bit needs the separate `Setup64.exe`** — the common error is installing PinMAME only 32-bit
- **PWM migration (PinMAME 3.6+)**: `UseVPMModSol = 2`, float 0..1 signals (was 0..255), remove SolMask arrays, light fader "Incandescent"; ~5 minutes per table (see [VPX GI and Flashers](VPX%20GI%20and%20Flashers.md))
- Enforce a minimum VPM version in script: `LoadVPM "03060000", ..., 3.10`
- **Cabinet Mode checkbox on desktop too** — suppresses the splash and fixes B2S sticky flippers
- ROMs: parent/child sets both required; Gottlieb System 1 needs the "CF" spider-chip fixed redump (PinballNirvana pack for VPM 3.6.0-963+); `_h` home ROMs break coin-door features — prefer `_hc`; DIP defaults via `SetDefaultDips` script or a shipped `.nv`

## B2S, PUP, FlexDMD, dmdext

- B2S 2.0+ needs no separate x64 install; the B2S editor **cannot replace images in existing elements** (recreate the element); wrap all `Controller.B2SSetData` calls in `If B2SOn Then`
- PUP packs ship separately from the table and update with it; all videos 1920×1080; **`Set PuPlayer = Nothing` in `Table_Exit`** (COM leak → hung PUP processes); ffmpeg re-encode 2.65 GB→1.1 GB; VPX 10.8 broke the PupDMD desktop punch — "1-pixel trick" in GL. See [PinUp Player](../projects/PinUp%20Player.md)
- FlexDMD: check `FlexDMDUI.exe`, `DmdDevice.ini [virtualdmd] enabled`, install location; OutOfMemory on 32-bit → use 64-bit VPX; **log `minlevel=Trace` causes random stutters — set Warn**; auto-detect via `CreateObject` error handling. See [FlexDMD](../projects/FlexDMD.md)
- dmdext (Freezy): x64 + Lucky1 color files; SERUM preferred for standalone; 32/64-bit mixing crashes. See [DMD Extensions](../projects/DMD%20Extensions.md)

## DOF Toolkit Pin

- **DOTK v0.09 only — v0.10 is buggy** (`github.com/Vroonsh/DirectOutput/releases/tag/DOTKv0.09`); DOF Config Tool is the online configurator. See [DirectOutput Framework](../projects/DirectOutput%20Framework.md)

## VPinSPA (Stern SPA emulation)

Used by Ghostbusters: separate installer, MSVC 2012 x86, ROMs in `C:\Visual Pinball\VPinMAME\spagb100\`, pba-tools extraction, dmdext inside the VPinSPA folder; 64-bit via registry (removes WOW64 protection — undefined behavior).

## Altsound In-Table

A sound-command-listener intercepting ROM sounds; OGG in 10.7+ (~65 MB vs 150 MB WAV). With PinSound having dropped virtual pinball, baked altsound is described as "the future direction".

## Scripting Debugger

- **Visual Studio 2010 Isolated Shell** = breakpoints with full call stacks (the built-in D-debugger lacks stacks)
- F5 (not F6) for realtime property editing. See [VPX Scripting Patterns](VPX%20Scripting%20Patterns.md)

## Blender Compatibility

The toolkit requires a specific Blender: **3.6 confirmed; 4.0 bump maps/export unreliable**. Tony McMapFace tonemapper: replace the colormanagement files; makes 2700K bulbs correct where Filmic needed 3000–3200K. See [VPX 3D Art Pipeline](VPX%203D%20Art%20Pipeline.md).

## Misc

- Windows Defender "Wacatac" false positives on unsigned VPX archives — check on VirusTotal
- `SaveValue`/`LoadValue` persist to `VPReg.stg` in the user directory (cross-table; editable with the community VPReg.stg viewer — see [VPX File Layout](VPX%20File%20Layout.md))
- Table-state persistence bug: tilted-table thresholds saved at 100 → set thresholds at init (see [VPX Table Troubleshooting](VPX%20Table%20Troubleshooting.md))

## See Also

- [VPX Authoring Tools](VPX%20Authoring%20Tools.md) — tool directory
- [VPX Table Build Workflow](VPX%20Table%20Build%20Workflow.md) — the build process
- [VPX GI and Flashers](VPX%20GI%20and%20Flashers.md) — PWM migration details
- [VPW Knowledge Base](../sources/VPW%20Knowledge%20Base.md) — source collection (secondary)
