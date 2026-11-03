# VPX Example Table

The VPW Example Table is the community's canonical "bag of tricks" reference implementation for VPX table authoring — a demonstration table showing every current best-practice system, explicitly **not** a starter template.

> ⚠️ Priority: Secondary — from the [VPW Knowledge Base](../sources/VPW%20Knowledge%20Base.md) (authoring community); Primary sources win on conflicts. Raw: `[raw/vpw-wiki/docs/reference/example-table.md](https://vpw-wiki.skirmishofwit.com/reference/example-table/), `[raw/vpw-wiki/docs/guides/physics-tuning.md](https://vpw-wiki.skirmishofwit.com/guides/physics-tuning/)

## What It Demonstrates

From [raw/vpw-wiki/docs/reference/example-table.md](https://vpw-wiki.skirmishofwit.com/reference/example-table/), §Systems Demonstrated:

- Dynamic ball shadows (array-based; shadow size ∝ `(Z + BallSize)/80`; update only on Z-threshold transitions)
- nFozzy flipper physics — trajectory/polarity/velocity curves per era (see [VPX Physics Tuning](VPX%20Physics%20Tuning.md))
- nFozzy rubber separation (dPosts/dSleeves), TargetBouncer, FlipperCradleCollision
- Inlane live catch, slingshot angle correction
- [Fleep sound packages](Fleep%20Sound%20Packages.md) and ZRRL ramp-rolling sounds
- Flupper dome flashers and bumpers; 2-prim and 3-prim inserts
- Roth drop targets; physical trough (balls are never destroyed)
- VR cabinet/room; FlexDMD scoreboard

**Distributed on VPUniverse**; extracted source at `github.com/francisdb/vpw-example-table-extracted`.

## Conventions It Establishes

- Start new tables **from blank, not from the Example Table** (Apophis79). A stripped-down "Basic" variant (nFozzy + Fleep only) was created in 2026 for people who want a minimal base
- **gBOT pattern**: create all balls once at init, never destroy them — realistic behavior, and ball-ID-dependent shadow code breaks if balls are recreated
  - ⚠️ CONFLICT (secondary source): `gBOT` **segfaults in standalone VPX** inside `Cor.Update`/CorTracker — use `GetBalls` there; this is the stated cause of ~95% of "ball hits flipper → segfault" standalone crashes ([raw/reference/example-table.md](https://vpw-wiki.skirmishofwit.com/reference/example-table/), §Ball Management) — Primary: none; complements the [VPX Standalone](VPX%20Standalone.md) claim that very few tables fail out of the box by naming the dominant in-table failure mode
- 3-prim inserts look better but are very hard to tune; **2-prim recommended** for general adoption
- **Never use VPX Global Physics Sets with nFozzy** — the sets silently override nFozzy values and the editor does not grey them out (see [VPX Physics Tuning](VPX%20Physics%20Tuning.md))

## Lighting Timeline: Lampz → Native

Dated notes on Lampz relevance (raw §VPX 10.8+ Lighting, §Version History):

- **Lampz was removed from the Example Table at v1.5.15 (March 2024)** in favor of native VPX light handling; `light_animate` replaced Lampz for 3D insert primitives
- For non-ROM tables: set `light.state = 1/0` and the built-in Incandescent fader does the rest; benefits are simpler scripts, native performance, PWM fading, lightmap sync
- VPW's 10.8-era verdict: "Lampz is no longer needed for either ROM or original tables"
- ⚠️ CONFLICT (secondary source, internal to VPW): the Light State Controller page says "ROM-based tables should still use Lampz/vpmMapLights" ([raw/reference/light-state-controller.md](https://vpw-wiki.skirmishofwit.com/reference/light-state-controller/) — [raw/reference/example-table.md](https://vpw-wiki.skirmishofwit.com/reference/example-table/) (newer, v1.5.15, March 2024): "Lampz is no longer needed for either ROM or original tables." Treat Lampz as pre-10.8 legacy; present `light_animate`/native faders as current

## Key Reference Values

From raw §Flipper Physics Reference (mirrored on [VPX Physics Tuning](VPX%20Physics%20Tuning.md)): 27 VP-unit flipper triggers, EOSTorque 0.375, EOSReturn 0.4, FlipperMass (SOSRampup) 2.5, BaseDampen 0.55, LiveDistanceMin 5, per-era flipper strengths 2300–3300.

Other subsystem notes (raw §Subsystem Notes):

- Slingshot angle correction +4–7° in `_Slingshot` subs with `dsin`/`dcos` helpers
- TargetBouncer: Enabled=1, Factor=0.7; `TargetBounce_Hit(idx)` must include `(idx)`
- FlexDMD: init scenes once into an array in `Flex_Init`, show via `ShowScene`; detect FlexDMD with `On Error Resume Next` + `CreateObject` (filesystem checks fail on Android/Linux/macOS standalone) — see [FlexDMD](../projects/FlexDMD.md)
- VPX 10.8.1 changed `DisableStaticPreRendering` to an enable/disable **count** — set True once entering the options menu, False once leaving; the old per-change toggling breaks it

## Version History

| Version | Content |
|---------|---------|
| v1.0–1.4 | nFozzy, Fleep, Lampz, inserts, shadows |
| v1.5.15 (Mar 2024) | Lampz removed for native VPX lighting |
| v1.6+ | FlipperCradleCollision, 27-unit triggers, inlane live catch |
| v1.7+ | "Basic" example-table variant |

## See Also

- [VPX Physics Tuning](VPX%20Physics%20Tuning.md) — the nFozzy values the table demonstrates
- [VPX Scripting Patterns](VPX%20Scripting%20Patterns.md) — script idioms distilled from it
- [VPX Light State Controller](VPX%20Light%20State%20Controller.md) — light class for original tables
- [VPX Authoring Tools](VPX%20Authoring%20Tools.md) — surrounding toolchain
- [VPW Knowledge Base](../sources/VPW%20Knowledge%20Base.md) — source collection (secondary)
