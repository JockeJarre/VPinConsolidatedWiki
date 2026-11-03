# VPX Game Rules Design

Design and scripting reference for VPX game rules and mechanisms: mode state machines, wizard-mode design principles (from the Blood Machines discussion), multiball and lock implementations, scoring verification, and mechanism scripting patterns.

> ⚠️ Priority: Secondary — from the [VPW Knowledge Base](../sources/VPW%20Knowledge%20Base.md) (authoring community); Primary sources win on conflicts. Raw: `[raw/ExternalWikis/vpw-wiki/repo/docs/guides/game-rules-mechanics.md](https://vpw-wiki.skirmishofwit.com/guides/game-rules-mechanics/), `[raw/ExternalWikis/vpw-wiki/repo/docs/reference/bm-rules.md](https://vpw-wiki.skirmishofwit.com/reference/bm-rules/)

## Mode State Machines

- Three-phase mode lifecycle: **Start / Active / Complete**
- Tilt must **force-reset all modes and flipper-disable flags** (the "slam-tilt on the next ball" bug)

## Wizard Mode Design Principles

From [raw/reference/bm-rules.md](https://vpw-wiki.skirmishofwit.com/reference/bm-rules/) (Blood Machines "Final Chapter" — the collection's deepest rules discussion):

- Ball saver of **8–10 s is mandatory**
- Wizard only starts from single-ball play — queue it if qualified during multiball (disable flippers so extra balls drain to single ball)
- **Reset ALL progress after a wizard pass or fail** — "the thing people forget to do"
- Extra-ball stacking bookkeeping: earn 2 → have 2
- Turn off unrelated shot lights — "avoid the Christmas tree"
- "Don't hide all the fun stuff" — distribute spectacle across the skill range
- Start sequence: ball trapped → GI off → DMD intro → character lighting → walls drop ~5 s → ball saver
- Balancing: kicker-adds-time vs adds-ball (time removes pressure); the combo-shot mission was the most frustrating (timer resets too fast; left orb geometrically tighter than right) — **test shot geometry with average players**

"Final Chapter" structure: 3 phases — under-playfield orb shots with ball saver → main-playfield objectives → **15-ball multiball finale**; under-playfield drains kick back to the scoop rather than failing.

## Multiball and Ball Management

- gBOT global ball array, never destroy balls (see [VPX Scripting Patterns](VPX%20Scripting%20Patterns.md)); GetBalls in ball-rolling subs is the bottleneck
- The 15-ball multiball needed performance limits: ball saver returns max 10 balls, ball shadows limited during high-count multiball; Apollo 13's 13-ball multiball ships with no saver (sheer ball count acts as natural ball save)
- Lock implementations: physical-trough replacement (`CreateSizedBallWithMass` at trough-switch kickers + ROM switches); invisible-kicker visual lock with the real ball; captive "Newton ball" — an oversized 57-unit ball for raised mechanisms (Breakshot, AC/DC, JWPS)
- Ball-ball collision dampening on a held flipper: `FlipperCradleCollision`, COR 0.4, from `OnBallBallCollision` (validated against PAPA footage)
- Ball-ball sound spam filter: 50–100 ms pair timer

## Scoring

- Multi-player original tables: per-player state arrays
- Billions-scale score display needs real-game fonts
- Deriving ROM scoring can stay incomplete (Game of Thrones disassembled Spike 1)
- Verification method: record camera on table + DMD, hit each switch out-of-mode, then per mode

## Attract Mode

- The FlexDMD update timer must stay enabled all session — disabling it after the intro breaks the next game
- End attract with `lightCtrl.StopSyncWithVpxLights()`
- Coordinate-based light sequencers (center/radius/speed/color/pattern) and the [VPX Light State Controller](VPX%20Light%20State%20Controller.md) power attract shows

## Tilt and Free Play

- Script tilt: `MechanicalTilt` keycode → `CheckTilt`; Stern behavior = 2 warnings, tilt on the 3rd, 1000 ms debounce; VPX sends 'T' when the analog nudge limit is exceeded; the tilt switch must not collide with cabinet buttons
- 10.8.1 native plumb tilt: see [VPX Physics Tuning](VPX%20Physics%20Tuning.md)
- Free-play bypass for original tables with credit systems: comment out `Credits = Credits - 1` lines

## Mechanism Scripting Patterns

From raw §Mechanisms:

- Scoops/VUKs kick on the Y axis, not Z; **release the ball variable after kickball** (floating-ball bugs during ball search)
- Stacked-ball-in-scoop fix: InRect test + reposition to highest z
- Magnet toys: a 1 ms follow-timer, not destroy/create; VPX magnets cannot simulate multi-ball magnet physics (raw tables/index.md, Twilight Zone)
- Motor sounds via `PlaySoundAtLevelStaticLoop`; motor-stop detection on the SolCallback False edge
- Raising-ramp collision: sequential collidable primitives (Jokerz cantilever)
- **Collidable primitives cannot move at runtime** — animated mechanisms use arrays of flippers as a rotating collision boundary (Indiana Jones carousel)
- Ball rolling sounds: playfield gate `BallVel > 1 AND BOT(b).z < 30`; ramps need separate ZRRL handling (see [Fleep Sound Packages](Fleep%20Sound%20Packages.md))

## Original-Table Design Process

Paper → walls/kickers prototype → **fun before art**; build order rules/physics → artwork → Blender last (see [VPX Table Build Workflow](VPX%20Table%20Build%20Workflow.md)). Difficulty = slope + scatter, **never ball mass**. Use PAPA/IFPA video as the rules reference. DIP init via script or shipped `.nv` (Gottlieb conservative/liberal posts as an F12 option).

Light shows: Lampz/ModLampz are legacy — `light.state = 1/0` + the Incandescent fader for non-ROM tables from VPX 10.8 (timeline on [VPX Example Table](VPX%20Example%20Table.md)); LED vs incandescent fade ratios and the flasher cubic decay on [VPX GI and Flashers](VPX%20GI%20and%20Flashers.md).

## See Also

- [VPX Scripting Patterns](VPX%20Scripting%20Patterns.md) — timer/state machinery these rules run on
- [VPX Light State Controller](VPX%20Light%20State%20Controller.md) — attract/light-show engine
- [FlexDMD](../projects/FlexDMD.md) — DMD scenes for mode intros
- [VPW Knowledge Base](../sources/VPW%20Knowledge%20Base.md) — source collection (secondary)
