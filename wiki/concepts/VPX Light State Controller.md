# VPX Light State Controller

The VPX Light State Controller is a VBScript class by **flux5009 (mpcarr)** that manages complex light behavior for original (non-ROM) VPX tables — stacked simultaneous states per light, blink groups, color palettes, and coordinate-driven sequences that plain lamp mapping cannot express.

> ⚠️ Priority: Secondary — from the [VPW Knowledge Base](../sources/VPW%20Knowledge%20Base.md) (authoring community); Primary sources win on conflicts. Raw: `[raw/vpw-wiki/docs/reference/light-state-controller.md](https://vpw-wiki.skirmishofwit.com/reference/light-state-controller/)

## Overview

- Source: `github.com/mpcarr/vpx-light-controller`
- Target: original tables with full light control (RGB inserts with multiple simultaneous flashing states, light-bank sequences, spatial effects)
- FrameTimer-driven — **LampTimer must be enabled in VPX**; the most common setup mistake

## Architecture

The class stores multiple stacked states per light and, on each FrameTimer tick, regenerates the current-state array — one light can be solid green **and** flashing red simultaneously, with priority and transition management (raw §Architecture).

- v0.9+ removed the Lampz dependency: fading, callbacks, and lightmap sync are built in
- ⚠️ CONFLICT (secondary source, internal to VPW): this page's source says "ROM-based tables should still use Lampz/vpmMapLights" ([raw/reference/light-state-controller.md](https://vpw-wiki.skirmishofwit.com/reference/light-state-controller/) — [raw/reference/example-table.md](https://vpw-wiki.skirmishofwit.com/reference/example-table/) v1.5.15 (March 2024): "Lampz is no longer needed for either ROM or original tables." Treat Lampz advice as pre-10.8 legacy; see [VPX Example Table](VPX%20Example%20Table.md)
- Works alongside VPX 10.8+ `light_animate` for toolkit insert control

## Features

From raw §Core Features:

- **Multi-state cycling** per light with priority handling
- **Color palettes** (v0.9+; originated on the Die Hard table) with timed fades computing intermediate colors
- **Blink groups** (v0.9.1+): `AddLightToBlinkGroup` / `RemoveLightFromBlinkGroup`, `UpdateBlinkGroupPattern`, `UpdateBlinkGroupInterval`, `StartBlinkGroup` / `StopBlinkGroup`
- **Lightmap color sync** — color changes propagate to attached lightmaps when the lightmap primitive name contains the light name (`_l01_`) or the light name is in the light's `UserValue`; enables RGB on toolkit-baked inserts
- **Panlandia** — coordinate-based sequence system: XY-mapped light positions generate sweeps, waves, and falling-block sequences "in 5–10 minutes"
- Interval-based light mapping: lights sharing a `TimerInterval` number act as one group

## Integration Notes

- End attract mode with `lightCtrl.StopSyncWithVpxLights()`
- Video-file animation maps (After Effects authored) are planned, not yet supported
- Also referenced for attract-mode light shows in [raw/guides/game-rules-mechanics.md](https://vpw-wiki.skirmishofwit.com/guides/game-rules-mechanics/)

## See Also

- [VPX Lights and Rendering](VPX%20Lights%20and%20Rendering.md) — engine light system and lightmaps
- [VPX Insert Lighting](VPX%20Insert%20Lighting.md) — insert techniques the class drives
- [VPX Example Table](VPX%20Example%20Table.md) — reference implementation
- [VPX Scripting Patterns](VPX%20Scripting%20Patterns.md) — timer architecture the class needs
- [VPW Knowledge Base](../sources/VPW%20Knowledge%20Base.md) — source collection (secondary)
