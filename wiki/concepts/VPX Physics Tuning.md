# VPX Physics Tuning

Community table-authoring physics guidance centered on the nFozzy flipper/rubber physics system: rubber separation collections, era-specific flipper constants, trigger sizing, slingshot and target behavior, and calibration methodology.

> ⚠️ Priority: Secondary — from the [VPW Knowledge Base](../sources/VPW%20Knowledge%20Base.md) (authoring community); Primary sources win on conflicts. Raw: `[raw/ExternalWikis/vpw-wiki/repo/docs/guides/physics-tuning.md](https://vpw-wiki.skirmishofwit.com/guides/physics-tuning/), `[raw/ExternalWikis/vpw-wiki/repo/docs/reference/example-table.md](https://vpw-wiki.skirmishofwit.com/reference/example-table/)

## nFozzy Rubber Separation

Each real rubber is split into multiple objects (raw physics-tuning.md, §Rubber Separation):

- Invisible post cylinders in a **`dPosts`** collection — material `z_col_rubberposts`
- Sleeve-covered posts in **`dSleeves`** (more damping; sleeves ≈ 20×20×20 VP units — oversized sleeves make the table play harder)
- Rubber band between the posts — material `z_col_rubberbands`, **not** in any dampening collection
- The original visible rubber mesh stays non-collidable
- Short-rubber variant adds a second elasticity material between post and band; import the `.vpp` materials file when the material dropdown is empty

Implementation order (raw §Implementation Checklist): flipper meshes → key down/up code → LF/RF Fire → paste nFozzy script chunk → check for duplicate flipper `Collide` subs (they silently override) → rubbers → import 90s-era physics `.vpp` → test. The old `rdampen` timer is obsolete.

- ⚠️ CONFLICT (secondary source): VPX **Global Physics Sets must never be used with nFozzy** — the sets silently override the tuned per-object values and the editor gives no indication ([raw/reference/example-table.md](https://vpw-wiki.skirmishofwit.com/reference/example-table/), §Physics Sets) — Primary: [VPX Scripting](VPX%20Scripting.md) lists the table physics properties neutrally as normal configuration. The caveat applies specifically to nFozzy-style tables

## Flipper Tuning

`AddPt` polarity/velocity curves are **era-specific** (70s / 80s / 90s); the [VPX Example Table](VPX%20Example%20Table.md) ships all variants. If backhand shot angles feel wrong, swap the polarity curve set before touching strengths (raw §Flipper Tuning by Era).

Flipper strength by era (raw §Flipper Tuning, §Flipper Strength):

| Era | Coil / example | Strength |
|-----|----------------|----------|
| System 11 | — | 2300–2600 |
| Early WPC (1991) | medium red FL-11630 | 2400 |
| Mid WPC (1992+) | strong blue FL-11629 | 2600 |
| Late WPC / 90s baseline | — | 2600–3300 (≈2800–3000) |
| Indiana Jones (11629 coil) | | 3250–3500 |
| Upper/lower upper flippers | | 2400–2500 |

Gottlieb System 3: check which coil the machine has — A-25959 (3.85 Ω) vs the service-bulletin upgrade A-29876 (2.36 Ω).

Key constants (raw §Flipper Constants, §Example Table):

- **EOSTorque** 0.375 (raised from 0.275; improves ball-hop tap passes — Fish Tales). Do not tune it together with flipper strength
- **EOSReturn** 0.4 (raised from 0.35; strengthens backhands; interacts with EOSTorque)
- **SOSRampup / FlipperMass** 2.5 = VPW standard: reliable shots, no tap passes. 8.5 gives tap passes and slow flippers (timer-behavior bug); do not reduce below 2.5. ≈0.5 compensates input latency (see [VPX Latency](VPX%20Latency.md))
- Flipper return strength 0.04–0.05 (vs default 0.11) for Stern feel
- Overswing 3° past the end angle is by design (per-flipper `Dir` sign variable)
- Lightning flippers are 2.875″ (~73 mm) vs standard 3″ (~76 mm)
- `AddPt` second parameter must be sequentially indexed (base/middle/tip)

### Flipper Trigger Sizing

Triggers must sit **27 VP units** from the flipper (2024 update; the old 23-unit margin was below the 25-unit ball radius, so cradle velocity correction was silently broken). Sizing trick: temporarily set the end angle 3° beyond actual (overswing), build the trigger, restore the angle. Trigger hit height 150. `drain_hit` must call `RF.PolarityCorrect Activeball` / `LF.PolarityCorrect Activeball`, or multiball drains corrupt the correction tracking (raw §Flipper Trigger Sizing).

### Cradle Collision and Upper Flippers

- `FlipperCradleCollision` (driven from `OnBallBallCollision`): when a ball hits another ball resting on a fully-raised flipper, apply `DesiredBallCOR = 0.4` to both balls (raw §Flipper Cradle)
- Upper flippers: keep the nFozzy object properties and tricks, but **remove the trajectory-correction call from the upper flipper's solenoid callback** — the correction is table-X-axis based and points the wrong way on angled flippers

### Inlane Live Catch

Mini live-catch constants (raw §Inlane Live Catch): `LiveDistanceMin = 5`, `LiveDistanceMax = 114`, `BaseDampen = 0.55`. When `LiveDist < 30` and the ball moves toward the tip, dampen all velocity/angmom.

## Slingshots, Targets, Bumpers

- Slingshot deflection correction: **+4–7°** rotational force (the initial 10° was too high), applied in the `_Slingshot` event subs (solenoid callbacks suppress rapid re-fires) with `dsin`/`dcos` helpers. "Nibble" variation near the sling-arm center. Dead zone near the top post is authentic. Sling threshold and object hit threshold must match — Monster Bash sweet spot **1.5** (1 too sensitive, 2 too insensitive)
- **TargetBouncer**: `TargetBouncerEnabled = 1`, `TargetBouncerFactor = 0.7`, random 0.2–0.5 multiplier, only when `ball.z < 30`, `TargetBounce` collection. The sub signature **must** be `TargetBounce_Hit(idx)` — without `(idx)` it fails silently. Never place near pop bumpers (velocity compounds through the geometry); exclude scoop-adjacent sleeves. Its energy-adding behavior is an acknowledged unresolved tradeoff in the community
- Drop targets: layback **4–7°**
- Pop bumpers: strength **13–15** (VPW tables generally too weak); collision radius = the rubber skirt, not the plastic cap (RBION 45→38). Game of Thrones nFozzy reference: Force 9.5–10.5, hit threshold 1.6–2, scatter 2

## Difficulty Slider and Slope

The difficulty slider interpolates slope (SlopeMin→SlopeMax) and scatter, **never ball mass** (mass must stay constant at 1; 1.3 "throws all the flipper stuff off"). Flipper scaling via difficulty is nonfunctional in the nFozzy code review. VPX's default difficulty 20 ≠ the intended 50–56 range — **set the default to the intended midpoint (~56) before tuning**, or all slope tuning is invalidated (raw §Difficulty Slider).

## Collidable Geometry

- Inlanes: walls only, never primitives — walls have optimized collision; every triangle of a collidable primitive is a physics calculation
- Ramps: high-poly visual mesh + simple invisible collidable mesh
- Duplicate overlapping collidables cause ball stutter
- Physics uses backface culling: normals face outward, and meshes need thickness for two-sided hits
- VPX's glass-height setting is **not** a physical barrier — add an invisible wall at glass height (real Firepower II: ≈2″ bottom-to-glass)
- Under-playfield blocker wall at z −0.01 is mandatory over the shooter lane and flippers (a 0.8×-mass powerball in Twilight Zone sinks through the mesh)
- Playfield-mesh loop cuts in the flipper area trap stopped balls (thin 0.01 wall as patch) but are needed along long edges for texture alignment — balance (raw §Collidable Geometry)

## Misc Settings

- Spinner damping: invisible trigger capturing velx/vely, or `gametime` timing between `_Spin` calls with a `4000 / spintime` threshold
- `metalfo`: metal elasticity fall-off at high speed (deader hard hits) — apply to ramps, guides, posts
- Ramp exit spin: reduce the global max from the default 70 to 50 (not per-ramp)
- Ramp friction: unify to a single material at **~0.2** (0.8 is a "velcro ramp")
- Playfield friction: the default 0.02 is far too low; Stern-era calibrated **0.15–0.25**. Set SlopeMin = SlopeMax during testing

## Calibration Methodology

Order (raw §Calibration Methodology): measure the real-machine slope (phone level app) → calibrate ball-roll speed against real-machine video → flipper strength → ramp friction last. VP unit conversion: **50 VP = 1.0625″ (ball diameter); `VP = inches × 800 / 17`**; 47.059 px/inch (the Dimension Manager's 47 is imprecise). Standard playfields: WPC standard 20.25″×46″ (952 VP wide), widebody 23″×46″, Gottlieb System 1 20.25″×42″.

Mini playfields: no trajectory correction — mass and flipper strength are the key variables; lighter balls imply lower mass.

## Native Tilt Simulator (10.8.1)

VPX 10.8.1 adds a native tilt plumb simulator in the core physics at 1 kHz: a 3D mass-on-bar hitting the ring, with three nudge models — legacy force, acceleration-based cabinet spring-mass, and velocity-based (best; needs Pinscape Pico-class firmware) — plus inertia factor, tilt threshold, and a LiveUI plumb overlay (raw §Tilt Bob). See [VPX Accelerometer Input](VPX%20Accelerometer%20Input.md).

- ⚠️ CONFLICT (secondary source): hit detection is inconsistent for low-elasticity objects — hit events can be missed (GitHub issue #1266, reproduced across 10.6/10.7); the 10.8.1 fix improved but did not fully resolve it ([raw/guides/physics-tuning.md](https://vpw-wiki.skirmishofwit.com/guides/physics-tuning/), §Hit Detection) — Primary: the Script API reference documents `Collide`/`Hit` events without this caveat

## Input Latency Notes

KL25Z leaf switches: ~20 ms floor (8 ms debounce); PS/2 keyboard hack: 5–8 ms with zero misses; 60 Hz players are disadvantaged by 16.7 ms input sampling (raw §Input Latency). See [VPX Latency](VPX%20Latency.md), [Pinscape Controller](../projects/Pinscape%20Controller.md).

## See Also

- [VPX Example Table](VPX%20Example%20Table.md) — canonical reference implementation of all these systems
- [VPX Scripting](VPX%20Scripting.md) — physics object API and table properties
- [VPX Latency](VPX%20Latency.md) — input-to-display latency optimization
- [VPX Accelerometer Input](VPX%20Accelerometer%20Input.md) — nudge sensing models
- [VPX Table Build Workflow](VPX%20Table%20Build%20Workflow.md) — where physics fits in the build order
- [VPW Knowledge Base](../sources/VPW%20Knowledge%20Base.md) — source collection (secondary)
