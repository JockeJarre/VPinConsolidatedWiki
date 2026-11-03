# Fleep Sound Packages

Fleep sound packages replace VPX's default mechanical sound effects with recordings from real pinball machines: recording procedure, VPX collection integration, era-based cartridge matching, naming conventions, and troubleshooting.

> ⚠️ Priority: Secondary — from the [VPW Knowledge Base](../sources/VPW%20Knowledge%20Base.md) (authoring community); Primary sources win on conflicts. Raw: `[raw/vpw-wiki/docs/reference/fleep-sounds.md](https://vpw-wiki.skirmishofwit.com/reference/fleep-sounds/)

## What They Are

Real-machine mechanical SFX packs ("Fleep sounds" after their creator) wired into VPX's collision collections, replacing the default metal/wood/rubber sounds. Demonstrated on the [VPX Example Table](VPX%20Example%20Table.md). Resources: Fleep Sound Functions VBS (updated), Fleep Sounds Dropbox folder, "Adding Fleep Sound Package" tutorial, AudioPan/AudioFade v2 (fixes the Csng error) — live third-party links, volatile as of the 2026 snapshot.

## Recording Procedure

Equipment priority (raw §Recording Equipment): 1) large-diaphragm cardioid condenser (a Blue Yeti at gain 0 is OK) → 2) small-diaphragm → 3) cardioid dynamic → 4) X/Y stereo (Zoom recorders) → 5) electret/MEMS (phones, GoPro — last resort). **Record synced video; never deliver via YouTube (compression)** — use Drive/Dropbox.

Procedure (raw §Recording Procedure):

- Room quiet; SFX/music off; **playfield glass ON** (true acoustics, prevents clipping); coin door closed; quilted blankets for best acoustics
- Mic on a tripod slightly above the lockdown bar, never resting on the cabinet
- Record: ~10 min gameplay (avoid flippers while slings fire), solenoid test 5 cycles (SAM/Spike: single-coil mode, not cycling), 7× flipper coils (press-hold 2 s-release), plus unique toys/mechanisms

## VPX Integration

Collections need "Fire events for this collection" enabled. Standard set (raw §Integration): `dPost`, `dSleeve` (nFozzy separation — see [VPX Physics Tuning](VPX%20Physics%20Tuning.md)), `GatesWire` (not "Gates"), `Apron`, `Metals` (hit threshold 2 on guide rails), `Woods`, `Rubbers`, `Rollovers`, `Walls`.

Frequently missing: `Rubber_4` (a duplicate of Rubber_3), plunger-pull SFX, and the `min()` function under the **ZMAT** section of the Fleep example table. `core.vbs` must be current (PlaySoundAtLevelStatic) — update from the VPW repo.

## Cartridge Selection by Era

- Match packs **by ear, by era and system — not by manufacturer**: BOP (early WPC) used the Pinbot cartridge over Whirlwind; Bad Cats 3.0 used the Bride of Pinbot package; System 11 cartridges are not standardized
- Newer packs need **TriggerBallNearLF/RF** triggers near the flippers to switch dampened vs full-stroke flipper sounds (introduced in the TNA and Whirlwind packs)

## Sound File Conventions

- **No leading zeros in filenames** — a missing zero caused 30+ minutes of mismatch debugging
- Ship only the loudest sample plus a volume parameter — **VPX PlaySound volume saturates at 1.0 and cannot amplify**
- Strip `_amp9` suffixes
- All mechanical sounds **WAV** (MP3 routes through the bass engine and breaks SSF positional audio — [raw/guides/build-workflow.md](https://vpw-wiki.skirmishofwit.com/guides/build-workflow/)
- Pan law: **Left 100% / Middle 200% / Right 100%** — fixed engine-level behavior (see [VPX Scripting Patterns](VPX%20Scripting%20Patterns.md))

## Ball Rolling Sounds

From raw §Ball Rolling Sounds:

- Playfield gate: `BallVel > 1 AND BOT(b).z < 30`
- Ramps need separate **ZRRL** sounds: timer loop + ramp triggers; half volume and +50000 pitch above z = 30
- Direction from the sign of `ActiveBall.vely` (negative = moving up-ramp)

## Troubleshooting

From raw §Troubleshooting:

- "Variable is undefined: 'min'" → copy the ZMAT section from the Fleep example
- AudioPan crash on Walls — the function needs an object with an `x` property; walls lack position
- Rolling sound persists after ball destruction → add cleanup
- Disable collision sounds below Z = 0 (phantom trough sounds)
- Duplicate SolCallback fires flipper subs twice

## See Also

- [VPX Physics Tuning](VPX%20Physics%20Tuning.md) — dPosts/dSleeves collections the packs hook into
- [VPX Scripting Patterns](VPX%20Scripting%20Patterns.md) — VolumeDial and pan mechanics
- [VPX Table Build Workflow](VPX%20Table%20Build%20Workflow.md) — sound step in the build order
- [VPW Knowledge Base](../sources/VPW%20Knowledge%20Base.md) — source collection (secondary)
