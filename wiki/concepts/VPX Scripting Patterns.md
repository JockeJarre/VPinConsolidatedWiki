# VPX Scripting Patterns

Community table-scripting patterns for VPX VBScript: the three-tier timer architecture, ROM integration (SolCallback guards, SetLamp, FastFlips), ball tracking (gBOT vs GetBalls), sound integration, physical troughs, and the language-level traps.

> ⚠️ Priority: Secondary — from the [VPW Knowledge Base](../sources/VPW%20Knowledge%20Base.md) (authoring community); Primary sources win on conflicts. Raw: `[raw/ExternalWikis/vpw-wiki/repo/docs/guides/vbscript-patterns.md](https://vpw-wiki.skirmishofwit.com/guides/vbscript-patterns/) The API surface itself is on [VPX Scripting](VPX%20Scripting.md).

## Timer Architecture

Three tiers (raw §Timer Management):

| Timer | Interval | Role |
|-------|----------|------|
| **GameTimer** | 10 ms | game logic; **must contain `Cor.Update`** or ball velocity goes out of range (CorTracker error) |
| **FrameTimer** | −1 (per frame) | visuals: flipper anims, shadows, rolling sounds |
| **LampTimer** | fixed 6–16 ms | light fading — **never −1** (frame-rate dependent) |

Pitfalls:

- interval = 1 fires every 1 ms (Goldeneye doubled FPS 80→150 by fixing a 1 ms timer to −1)
- **a timer set to −1 executes one extra time after being disabled** (the disable lands on the next refresh; worse at 90 Hz VR)
- Set `Interval` **before** `TimerEnabled = 1`
- Catch-up spiral: many timers starving each other → consolidate into one FrameTimer (moving `Cor.Update` into the FrameTimer recovered 20–30 FPS)

## ROM Integration

From raw §ROM Integration:

- `SolCallback(n) = "SubName"` maps ROM solenoids to subs; **fires with both True and False** — always guard `If Enabled Then`
- Flashers sharing lamp numbers use a +100 offset: `SolCallback(17) = "SetLamp 117,"` with `Lampz.MassAssign(117) = F17`; ROM+Lampz tables need a hand-written `SetLamp(aNr, aOn)` sub (absent from the Example Table)
- `controller.changedsolenoids` loop for solenoid hunting
- Stepper-mechanism tables: set `HandleMech = 0`
- Constants `cSingleLFlip` / `cSingleRFlip` must never be removed — the system VBS references them
- **FastFlips**: SAM tables need `InitVpmFFlipsSAM` in `table_init` (`UseSolenoids = 2` alone is not enough); DE/Sega tables need `vpmFlips.FlipperSolNumber(2) = 47` (Williams uses 22); a ROM-bypass alternative fires flippers directly on keypress while still sending the ROM command

## Ball Tracking: gBOT vs GetBalls

- VPW best practice: create all balls at init, never destroy; keep a global `gBOT` array — per-frame `GetBalls` is expensive
- ⚠️ CONFLICT (secondary source): **`gBOT` in `Cor.Update`/CorTracker segfaults standalone VPX — use `GetBalls` there** ([raw/guides/vbscript-patterns.md](https://vpw-wiki.skirmishofwit.com/guides/vbscript-patterns/), §Ball Tracking) — same stance on [VPX Example Table](VPX%20Example%20Table.md); the dominant cause of standalone flipper crashes; see [VPX Standalone](VPX%20Standalone.md)
- Ball IDs change if balls are destroyed → ball-ID-dependent shadow tracking breaks
- Ball-on-kicker beats `cvpmBallStack` for locks; "Narnia balls" (balls out of the world) are detected by z ≪ 0 and recovered by a catcher trigger → VUK

## State Machines and Multi-Player

- **FlexMode pattern**: FlexDMD scenes initialized once in `Flex_Init` into an array, shown via a `ShowScene` wrapper — recreating scenes on show throws errors; no control logic inside the FlexDMD timer; auto-detect FlexDMD by wrapping `CreateObject` in `On Error Resume Next` (filesystem checks fail on standalone) — see [FlexDMD](../projects/FlexDMD.md)
- Multi-player original tables need explicit `SavePlayerState` / `RestorePlayerState` at drain and turn start

## Sound Integration

- Positional audio (`AudioPan`) needs an object with X/Y — walls crash it (pass primitives/kickers/targets)
- **Pan law: Left 100% / Middle 200% / Right 100%** — engine-level, not scriptable
- VPX volume hard-caps at 1.0 → ship only the loudest sample and scale down; keep Fleep VolumeDial insensitive-safe with the `min()` pre-saturation (defined in the ZMAT section of Fleep's example — see [Fleep Sound Packages](Fleep%20Sound%20Packages.md))
- **All mechanical sounds route through `VolumeDial`**; playfield/SSF sounds mono (10.8.1 validation warning); preload MP3s at volume 0.001 at init to avoid first-playback frame drops

## Physical Troughs, Kickbacks, Drop Targets

From raw §Physical Trough:

- Physical kicker troughs, not `cvpmBallStack`; GTS3 trough = 2 switches only
- `KickZ(angle, speed, inclination, heightz)` semantics; the kicker's KickZ differs from cvpmBallStack's; `KickoutVariance` rnd-jitter helper
- Drop-target/standup primitives: RotZ = 0 must face the drain; backstop "o"-suffix primitives are collidable-but-unscripted; target→primitive conversion via VPX OBJ export + threejs.org/editor (no Blender needed)

## Debugging Workflow

- **Visual Studio 2010 Isolated Shell** attaches for breakpoints with full call stacks (the built-in debugger lacks stacks)
- Press **D** in-game → live expression evaluation: `debug.print 30+rnd*10`, `prim.blenddisablelighting = 4`, `modlampz.state(1) = 0`
- F5 solid-color-texture pass isolates depth-bias/UV issues (F6 realtime depth bias broken 10.7.0–10.7.3; use F5 + D)
- See [VPX Table Troubleshooting](VPX%20Table%20Troubleshooting.md), [VPX Debugging](VPX%20Debugging.md)

## Language and Engine Traps

From raw §Common Bugs, §Debugger/Error Handling:

- **`Not 1 = -2`** in VBScript — compare `= 0`, never `Not x`
- Duplicate subs silently override (two `LeftFlipper_Collide` definitions kill nFozzy physics)
- `vpmTimer.Add` is broken — never use. (Primary note: `core.vbs` 3.62 fixed several `cvpmTimer` failure modes — the `GetRef` queue copy, object IDs in `AddTimer2`, remove-before-call on `Update` — so `AddTimer2` is less catastrophic than before, but the VPW guidance to avoid `vpmTimer.Add` stands ([raw/VPX/repo/docs/Changelog_Scripts.txt](https://github.com/vpinball/vpinball/blob/master/docs/Changelog_Scripts.txt)))
- `globalplugin.vbs` shares the namespace and silently overrides table subs — prefix names
- 31-char object-name limit truncates; special characters in primitive names break generated VBS arrays
- Pure black RGB(0,0,0) breaks rendering — minimum #111111
- VPX saves tilted-table bumper/sling thresholds = 100 permanently → set thresholds at init
- Flasher `.filter` strings are case-sensitive
- **`IsNull()` does not detect destroyed ball references** — set `Nothing` after `DestroyBall` and check `Is Nothing`, or use an alive-flag ([raw/guides/game-rules-mechanics.md](https://vpw-wiki.skirmishofwit.com/guides/game-rules-mechanics/) §Gotchas)
- `Const` must precede its first reference on standalone
- VPX 10.7 locale bug: comma decimal separators corrupt physics — fixed in 10.8 (`CNCDbl()` workaround)
- `vpmMapLights` + TimerInterval = ROM lamp index + an AllLamps collection replaces manual Lampz; 10.8 `light_animate` subs (`l86_Animate` + `GetInPlayIntensity`) replace Lampz for insert blend control (legacy timeline: [VPX Example Table](VPX%20Example%20Table.md))

## See Also

- [VPX Scripting](VPX%20Scripting.md) — the VPX VBScript API reference
- [VPX Physics Tuning](VPX%20Physics%20Tuning.md) — the physics code these patterns call
- [VPX GI and Flashers](VPX%20GI%20and%20Flashers.md) — SolCallback/PWM details
- [VPX Table Troubleshooting](VPX%20Table%20Troubleshooting.md) — symptom-indexed fixes
- [VPW Knowledge Base](../sources/VPW%20Knowledge%20Base.md) — source collection (secondary)
