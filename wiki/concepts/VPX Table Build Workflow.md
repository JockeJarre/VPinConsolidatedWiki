# VPX Table Build Workflow

Community workflow for building VPX tables: scope decision (Lite vs Premium), build order, team roles, version control, Blender collection organization, mechanism wiring conventions, and the pre-release checklist.

> ⚠️ Priority: Secondary — from the [VPW Knowledge Base](../sources/VPW%20Knowledge%20Base.md) (authoring community); Primary sources win on conflicts. Raw: `[raw/ExternalWikis/vpw-wiki/repo/docs/guides/build-workflow.md](https://vpw-wiki.skirmishofwit.com/guides/build-workflow/), `[raw/ExternalWikis/vpw-wiki/repo/docs/guides/best-practices.md](https://vpw-wiki.skirmishofwit.com/guides/best-practices/)

## Scope Decision

- **Lite** build: physics + sound + bugfixes on an existing table — weeks
- **Premium** build: full Blender-toolkit rebuild — months to years (build order derived from Die Hard Trilogy)

Premium build order (raw §Scope Decision): 1) rules and insert layout → 2) physics + Fleep sounds (parallel) → 3) artwork → 4) rules programming → 5) **Blender toolkit last**, after artwork/layout are locked. Roles: table lead, Blender artist, VR specialist, sound integrator, real-machine owner.

## Version Control

- VPX binaries cannot be git-diffed, so sequential version numbers + changelog comments are the only safeguard
- **Never work from cached copies** — whole versions were lost on Congo and Black Rose; the VPW Bot Discord checkout system (one file holder, version + changelog per check-in) grew out of those disasters
- WIP v003–v104 → RC1–RC9 → v1.0 → patches; wait **≥1 week after RC** before publishing (raw §Release Checklist)
- [vpxtool](VPX%20Authoring%20Tools.md) can decompile `.vpx` to JSON/VBS/images for real git diffs

## Collection and Layer Organization

Blender collections (see [VPX 3D Art Pipeline](VPX%203D%20Art%20Pipeline.md)): `VLM.Bake` / `VLM.Lights` / `VLM.Movables`. **At least one light collection must use "Solid" bake mode**, or the export produces only lightmaps and no bakemaps.

VPX layer scheme (Batman DE convention, raw §Layer Organization):

| Layers | Contents |
|--------|----------|
| 1–3 | Collidables |
| 4–6 | Primitives / inserts |
| 7–9 | Lights |
| 10–11 | VR room + playfield flashers |

Timers must live on the Timers layer, not on VLM.Visual (which is deleted on re-bake). Movables must **not** have the static flag.

## Post-Bake Integration

From raw §Bake Workflow: import VLM materials; `VLM.Bake.Solid` on opaque objects, `VLM.Bake.Active` on transparents; `_Animate` suffix for movables; hide collidables and VPX lights; **re-assign render/refraction probes — they are lost on import**.

## Playfield Mesh

- The mesh must be named exactly `playfield_mesh`
- Holes with beveled edges let balls fall through — cut rollover "holes" as texture transparency, not geometry
- Nudging the mesh from 0,0 misaligns everything
- Loop cuts in the flipper area trap balls (see [VPX Physics Tuning](VPX%20Physics%20Tuning.md))

## Mechanism Wiring Conventions

From raw §Mechanism Wiring:

- Scoops/VUKs: kick on the **Y axis, not Z**; `KickZ(angle, speed, inclination, heightz)` — a small non-zero `heightz` is sometimes required
- Physical kickers beat the legacy VUK (proper acceleration curve)
- Roth drop targets must face the drain at RotZ=0 (ObjRotZ breaks the hit-angle brick check); layback 4–7°
- Spinners: two baked positions (0°/180°) with opacity cross-fade; the 180° version scaled slightly larger (0.575 vs 0.570) to avoid z-fighting
- Multi-playfield: main PF at Z=0 (10.8 resolved the raised-PF limitation); angled sub-PF flippers need local + global two-axis rotation; drop-target animation code resets RotX → add the playfield-angle offset in the animate sub

## Sound and Display Setup

- Fleep collections need VPX collections with "Fire events for this collection" — `Metals`, `Rollovers`, `Apron`, `Walls` (see [Fleep Sound Packages](Fleep%20Sound%20Packages.md))
- **Always WAV for mechanical sounds — MP3 routes through the bass engine and breaks SSF positional audio**
- Wrap B2S calls in `If B2SOn Then`; run B2S in exe mode to prevent framerate spikes
- FlexDMD log level **Warn, not Trace** (Trace logs to disk → stutters); the FlexDMD update timer must stay enabled all session
- PUP videos must be 1920×1080; `Set PuPlayer = Nothing` in `Table_Exit` (see [PinUp Player](../projects/PinUp%20Player.md))

## Release Checklist

Pre-release validation (raw §Release Checklist, corroborated by best-practices.md §Table Validation Checklist):

- BallSize = 50 (not legacy 25); ball mass = 1 (even widebodies)
- VRRoom = 0 for desktop releases (VR-room primitives cost 20–40 FPS)
- Remove all `debug.print` (file I/O frame drops); no 1 ms visual timers
- VSync override −1 in table User properties, not 1
- Re-verify insert depth bias after any VPX crash or version change
- Flipper trigger margin 27 VP units; metal wall hit threshold 2; pop bumper radius = rubber skirt not plastic cap
- Playfield physical sounds mono, not stereo (stereo degrades SSF)
- Cabinet Mode checkbox in VPinMAME ROM settings; tilt implemented
- Solenoids `DOFPulse` only (see [VPX Authoring Best Practices](VPX%20Authoring%20Best%20Practices.md))

- ⚠️ CONFLICT (secondary source): "VSync override set to −1 (not 1) in table User properties" is author-side shipping guidance
  ([raw/ExternalWikis/vpw-wiki/repo/docs/guides/build-workflow.md](https://vpw-wiki.skirmishofwit.com/guides/build-workflow/), §Release Checklist) — Primary: [VPX Latency](VPX%20Latency.md) tells players to disable V-Sync. Complementary scopes: −1 = application-controlled sync shipped in the table; player-side disable is the low-latency override

## Multi-Playfield and Dimension Discipline

Dimension errors propagate into Blender and are expensive to fix later — verify playfield dimensions by pixel count ÷ DPI early (see [VPX Playfield Scanning](VPX%20Playfield%20Scanning.md)); "internet wisdom" for GnR measured 25″×51.75″ but the real board is 23″×46″.

## See Also

- [VPX 3D Art Pipeline](VPX%203D%20Art%20Pipeline.md) — Blender toolkit side of the workflow
- [VPX Physics Tuning](VPX%20Physics%20Tuning.md) — physics step of the build order
- [VPX Authoring Best Practices](VPX%20Authoring%20Best%20Practices.md) — naming, conventions, anti-patterns
- [VPX Example Table](VPX%20Example%20Table.md) — canonical reference implementation
- [VPW Knowledge Base](../sources/VPW%20Knowledge%20Base.md) — source collection (secondary)
