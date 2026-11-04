# Wiki Index

Catalog of all pages in this wiki.

## Overview

- [Overview](overview.md) — High-level synthesis of the virtual pinball ecosystem and how the projects connect

## Projects

- [B2S Backglass Server](projects/B2S%20Backglass%20Server.md) — Windows COM server displaying dynamic backglasses for VPX tables
- [DirectOutput Framework](projects/DirectOutput%20Framework.md) — C# framework connecting virtual pinball to physical feedback hardware
- [DMD Extensions](projects/DMD%20Extensions.md) — DmdDevice.dll toolbox routing DMD frames from games to real and virtual displays
- [FlexDMD](projects/FlexDMD.md) — In-process COM DMD renderer for VPX; drop-in UltraDMD replacement with scene-graph API
- [Pinscape Controller](projects/Pinscape%20Controller.md) — Open-source KL25Z-based cabinet controller for buttons, plunger, nudge, and outputs
- [PinUp Player](projects/PinUp%20Player.md) — Closed-source Windows media player rendering PuP Pack content across pincab displays
- [SSFImpactor](projects/SSFImpactor.md) — Software DOF controller emulating contactors/shakers as tactile audio for exciters
- [Visual Pinball X](projects/Visual%20Pinball%20X.md) — Pinball table simulator, editor, and physics engine
- [VPinFE](projects/VPinFE.md) — Open-source cross-platform Python frontend for VPX/VPinball Standalone

## Concepts

### Tables, displays, and rendering

- [Backglass](concepts/Backglass.md) — Digital backglass panels with lamp animations (.directb2s files)
- [B2S Plugins](concepts/B2S%20Plugins.md) — B2S Backglass Server plugin architecture (DOF, PinUp Player)
- [DMD](concepts/DMD.md) — Dot Matrix Display for scores, animations, and game information
- [Altcolor](concepts/Altcolor.md) — DMD colorization formats: PAL, patched ROM, VNI, PAC, Serum
- [Fleep Sound Packages](concepts/Fleep%20Sound%20Packages.md) — Real-machine sound recordings replacing VPX default SFX; era-based cartridge matching
- [PuP Packs](concepts/PuP%20Packs.md) — PinUp Player media packs: installation, standalone status
- [VPX Lights and Rendering](concepts/VPX%20Lights%20and%20Rendering.md) — VPX lighting system: lightmaps, fading, shadows, reflections
- [VPX Stereo 3D](concepts/VPX%20Stereo%203D.md) — VR, 3D TV, and anaglyph stereoscopic rendering in VPX

### Cabinet hardware and setup

- [DOF Addressable LEDs](concepts/DOF%20Addressable%20LEDs.md) — WS2811/WS2812 strip and matrix controllers, wiring, configuration
- [DOF Output Controllers](concepts/DOF%20Output%20Controllers.md) — Hardware units driving physical feedback (LedWiz, Art-Net, etc.)
- [DOF Table Configuration](concepts/DOF%20Table%20Configuration.md) — Mapping VPX game events to DOF physical effects
- [DOF Toys and Effects](concepts/DOF%20Toys%20and%20Effects.md) — DOF logical devices (toys) and effect chaining system
- [Open Pinball Device](concepts/Open%20Pinball%20Device.md) — New USB HID interface standard for pinball cabinet controllers
- [Pincab Setup](concepts/Pincab%20Setup.md) — Physical pinball cabinet configuration with multiple monitors and feedback
- [Pinscape Pico](concepts/Pinscape%20Pico.md) — RP2040 second-generation Pinscape controller: interfaces, mapping, quirks
- [Screen Configuration](concepts/Screen%20Configuration.md) — Monitor layout via ScreenRes.txt and tablename.res files
- [VPX Accelerometer Input](concepts/VPX%20Accelerometer%20Input.md) — Acceleration vs velocity-based nudge input for cabinet controllers
- [VPX Latency](concepts/VPX%20Latency.md) — Input-to-display latency types and optimization strategies
- [VPX Plunger Input](concepts/VPX%20Plunger%20Input.md) — Position vs velocity-based plunger input for cabinet controllers
- [VPX View Setup](concepts/VPX%20View%20Setup.md) — VPX camera/projection modes (Perspective vs Window Projection)
- [VPX VR Setup](concepts/VPX%20VR%20Setup.md) — Operational VR configuration: VR rooms, OpenComposite, ASW

### VPX platforms and operation

- [VPX Debugging](concepts/VPX%20Debugging.md) — Bisecting regressions, logs, frame capture, crash reporting
- [VPX File Layout](concepts/VPX%20File%20Layout.md) — Per-table file organization, config paths, companion-file search priority
- [VPX Nixie Plugin](concepts/VPX%20Nixie%20Plugin.md) — Script-free DMD window with .nix layout files (formerly ScoreView)
- [VPX Software Setup](concepts/VPX%20Software%20Setup.md) — Author-side installs: 32/64-bit VPX, PinMAME, B2S, PUP, FlexDMD, toolchain pinning
- [VPX Standalone](concepts/VPX%20Standalone.md) — Cross-platform VPX builds: Linux, macOS, iOS, Android, Batocera

### Table authoring (VPW)

- [VPX 3D Art Pipeline](concepts/VPX%203D%20Art%20Pipeline.md) — Blender-to-VPX pipeline: VLM lightmapper, bake/nestmaps, EXR HDR workflow, render probes
- [VPX Authoring Best Practices](concepts/VPX%20Authoring%20Best%20Practices.md) — Naming, layer maps, versioning, performance rules, testing, DOF safety, modding ethics
- [VPX Authoring Tools](concepts/VPX%20Authoring%20Tools.md) — Community toolchain directory: scanning, textures, Blender add-ons, parts libraries, utilities
- [VPX Example Table](concepts/VPX%20Example%20Table.md) — Canonical community "bag of tricks" reference implementation; not a starter template
- [VPX Game Rules Design](concepts/VPX%20Game%20Rules%20Design.md) — Mode state machines, wizard-mode principles, multiball/locks, scoring verification
- [VPX GI and Flashers](concepts/VPX%20GI%20and%20Flashers.md) — GI string tracing, per-era GI behavior, flasher decay curve, solenoid PWM migration
- [VPX Insert Lighting](concepts/VPX%20Insert%20Lighting.md) — Skitso, Flupper 3-layer, and VLM toolkit insert systems; depth bias and z-fighting mechanics
- [VPX Light State Controller](concepts/VPX%20Light%20State%20Controller.md) — flux5009's VBScript class: stacked light states, blink groups, color palettes
- [VPX Physics Tuning](concepts/VPX%20Physics%20Tuning.md) — nFozzy flipper/rubber physics, rubber separation, era constants, calibration method
- [VPX Playfield Scanning](concepts/VPX%20Playfield%20Scanning.md) — Distortion-free scanning, DPI verification, VP-unit conversion, AI upscaling
- [VPX Scripting Patterns](concepts/VPX%20Scripting%20Patterns.md) — Timer architecture, ROM integration, ball tracking, sound, troughs, VBScript traps
- [VPX Table Build Workflow](concepts/VPX%20Table%20Build%20Workflow.md) — Lite vs Premium scope, build order, team roles, version control, release checklist
- [VPX Table Troubleshooting](concepts/VPX%20Table%20Troubleshooting.md) — Symptom → cause → fix cookbook: rendering, physics, scripting, sound, ROM, VR
- [VPX Transparent Elements](concepts/VPX%20Transparent%20Elements.md) — Ramps, plastics, glass: refraction probes, ramp baking, wire ramps, glass effects
- [VPX VR Authoring](concepts/VPX%20VR%20Authoring.md) — Shipping VR support: VR rooms, VRRoom variable, VR rendering bugs, frame budget

### Scripting (reference)

- [VPX Scripting](concepts/VPX%20Scripting.md) — VBScript API reference for VPX table programming

## Sources

- [B2S Wiki](sources/B2S%20Wiki.md) — Summary of 31 B2S Backglass Server wiki source files
- [DMD Extensions Docs](sources/DMD%20Extensions%20Docs.md) — Summary of 6 DMD Extensions documentation files
- [DOF Documentation](sources/DOF%20Documentation.md) — Summary of 25 DirectOutput Framework documentation files
- [FlexDMD Docs](sources/FlexDMD%20Docs.md) — Summary of 5 FlexDMD documentation files
- [Pinscape Build Guide](sources/Pinscape%20Build%20Guide.md) — Summary of 133 AsciiDoc files covering cabinet construction and the Pinscape platform
- [PinUp Popper Docs](sources/PinUp%20Popper%20Docs.md) — Summary of 80 mirrored PinUp Popper wiki HTML pages
- [SSFImpactor Guide](sources/SSFImpactor%20Guide.md) — Summary of the 15-page SSFImpactor user guide PDF
- [Unofficial Visual Pinball Wiki](sources/Unofficial%20Visual%20Pinball%20Wiki.md) — Summary of 48 community wiki files covering VPX, platforms, DOF, and PuP (secondary source)
- [VPW Knowledge Base](sources/VPW%20Knowledge%20Base.md) — Distilled Virtual Pinball Workshop Discord knowledge: 13 authoring guides, 83 table case studies, 5 references (secondary source)
- [VPX Docs](sources/VPX%20Docs.md) — Summary of 39 Visual Pinball X documentation files

## Meta

- [AGENTS.md](AGENTS.md) — Agent instructions, wiki conventions, structure, and maintenance workflows
