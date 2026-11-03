# VPW Knowledge Base

> ⚠️ Priority: Secondary — community-maintained; Primary sources win on conflicts.

The VPW Knowledge Base is the distilled knowledge of the **Virtual Pinball Workshop** Discord — the most active VPX table-authoring community. Its focus is **table authoring**: physics tuning, insert/GI/flasher lighting, the Blender lightmapper art pipeline, VBScript patterns, VR development, and release practice. This complements the player/pincab-oriented collections already in the wiki.

Raw: `

## Provenance

- Live site: `https://vpw-wiki.skirmishofwit.com/` ("VPW Knowledge Base")
- Content extracted and synthesized from VPW Discord build channels (2020–2026 history) by Opus agents, March 2026
- ` generated 2026-02-12, 108 extractions, 3,136 knowledge "nuggets"
- ` site navigation structure

## Collection Structure

| Area | Files | Role |
|------|-------|------|
| `docs/guides/` | 13 | Generalized, reusable authoring knowledge |
| `docs/tables/` | 83 + index.md | Per-table build case studies |
| `docs/reference/` | 5 | Tool, package, and design references |

Design principle (stated in the collection): **guides hold generic knowledge; table pages document only what is unique to that table.** Every table page's "Techniques Developed Here" section cites the guide section where the generalized rule lives — table pages are provenance, not primary knowledge.

### Guides (with manifest nugget counts)

| Guide | Nuggets | Wiki filing |
|-------|---------|-------------|
| `vbscript-patterns.md` | 555 | [VPX Scripting Patterns](../concepts/VPX%20Scripting%20Patterns.md) |
| `3d-art-pipeline.md` | 535 | [VPX 3D Art Pipeline](../concepts/VPX%203D%20Art%20Pipeline.md) |
| `build-workflow.md` | 412 | [VPX Table Build Workflow](../concepts/VPX%20Table%20Build%20Workflow.md) |
| `troubleshooting.md` | 374 | [VPX Table Troubleshooting](../concepts/VPX%20Table%20Troubleshooting.md) |
| `best-practices.md` | 217 | [VPX Authoring Best Practices](../concepts/VPX%20Authoring%20Best%20Practices.md) |
| `game-rules-mechanics.md` | 130 | [VPX Game Rules Design](../concepts/VPX%20Game%20Rules%20Design.md) |
| `software-setup.md` | 72 | [VPX Software Setup](../concepts/VPX%20Software%20Setup.md) |
| `hardware-cabinet.md` | 49 | Swept into [Pincab Setup](../concepts/Pincab%20Setup.md), [VPX Latency](../concepts/VPX%20Latency.md), [VPX Physics Tuning](../concepts/VPX%20Physics%20Tuning.md) |
| `physics-tuning.md` | 10 (late addition) | [VPX Physics Tuning](../concepts/VPX%20Physics%20Tuning.md) |
| `insert-lighting.md` | — | [VPX Insert Lighting](../concepts/VPX%20Insert%20Lighting.md) |
| `gi-and-flashers.md` | — | [VPX GI and Flashers](../concepts/VPX%20GI%20and%20Flashers.md) |
| `transparent-elements.md` | — | [VPX Transparent Elements](../concepts/VPX%20Transparent%20Elements.md) |
| `vr-development.md` | — | [VPX VR Authoring](../concepts/VPX%20VR%20Authoring.md) |

Cross-cutting material also feeds [VPX Playfield Scanning](../concepts/VPX%20Playfield%20Scanning.md) and [VPX Example Table](../concepts/VPX%20Example%20Table.md).

### Reference Pages

| Page | Subject | Wiki filing |
|------|---------|-------------|
| `reference/example-table.md` | The VPW Example Table reference implementation | [VPX Example Table](../concepts/VPX%20Example%20Table.md) |
| `reference/tools-resources.md` | Community tool directory | [VPX Authoring Tools](../concepts/VPX%20Authoring%20Tools.md) |
| `reference/fleep-sounds.md` | Fleep real-machine sound packages | [Fleep Sound Packages](../concepts/Fleep%20Sound%20Packages.md) |
| `reference/light-state-controller.md` | flux5009/mpcarr light state class | [VPX Light State Controller](../concepts/VPX%20Light%20State%20Controller.md) |
| `reference/bm-rules.md` | Blood Machines wizard-mode rules design | [VPX Game Rules Design](../concepts/VPX%20Game%20Rules%20Design.md) |

## Count and Label Errata

Note once; do not propagate these as facts:

- `docs/tables/index.md` says "All 81 VPW table pages" — the directory contains **83** table pages (the A–Z catalog below is complete)
- The site navigation labels `tables/theatre-of-magic.md` as "Theatre of Magic" — the file is **Total Nuclear Annihilation** (TNA); the page title is correct, the nav label is not
- `wiki-manifest.json` marks `goldeneye` and `hook` as "extraction pending" while `tables/index.md` has rich entries for both — the extractions completed
- `tables/index.md` references 88 extractions; the manifest records 108 — the manifest is authoritative for counts
- `tables/cirqus-voltaire.md` and the index blurb state the **23 VP-unit** flipper trigger margin as "the standard" — superseded in 2024 by 27 units (see [VPX Physics Tuning](../concepts/VPX%20Physics%20Tuning.md))

## Table Catalog

Build case studies in ` (file name in parentheses). One line each; specialties are the techniques each build contributed to the guides.

### A–C

- **Austin Powers** (`austin-powers.md`) — live-catch PC compensation, flipper nudge/fanning physics, cannon mechanism, VR switching
- **Bad Cats** (`bad-cats.md`) — System 11; complete vector art redraw; pre-toolkit → 10.8 toolkit transition
- **Batman DE** (`batman-de.md`) — VPX layer-organization standard; playfield-mesh loop-cut ball sticking; depth-bias inversion rule
- **Beat the Clock** (`beat-the-clock.md`) — first-timer toolkit build; lightmap influence pruning on dark playfields; DOF addressable-LED clock
- **Big Bang Bar** (`big-bang-bar.md`) — Capcom; requires 64-bit VPX; first Capcom PinMAME PWM; dynamic RGB VR room
- **Black Rose** (`black-rose.md`) — Bally widebody; dual-color GI cross-dimming; per-element flasher variation; dark-environment LUT
- **Blood Machines** (`blood-machines.md`) — original table (director IP permission); under-playfield mini-game; 15-ball multiball; wizard-mode rules
- **Bram Stoker's Dracula** (`bram-stokers-dracula.md`) — FastFlips upper-flipper workaround; VP unit conversion formula documented
- **Breakshot** (`breakshot.md`) — Capcom; Tony McMapFace developed here; Newton-ball mechanics; flipper-bat measurement campaign
- **Bride of Pinbot** (`bop.md`) — 13-option GI color mod system; polygon reduction workflow; era-based coil calibration
- **Cactus Canyon** (`cactus-canyon.md`) — Quick Mod; drop-target glancing hits; flasher texture preloading; dual-ROM support
- **Cirqus Voltaire** (`cirqus-voltaire.md`) — 12-point physics review checklist; metal wall hit threshold 2; (23-unit trigger margin — superseded)
- **Congo** (`congo.md`) — canonical flasher exponential decay pattern; POV calibration workflow; VPW Bot checkout adoption after version-loss disasters
- **Countdown** (`countdown.md`) — 5-day Gottlieb build; modern collaborative workflow; Roth drop targets via toolkit
- **Creature from the Black Lagoon** (`creature-from-the-black-lagoon.md`) — 5-year build; ramp transparency single-digit-percentage tuning; Chase Light II emulation in PinMAME 3.6

### D–G

- **Defender** (`defender.md`) — ON_Prims black-playfield bug; duplicate playfield_mesh kills reflections; gBOT standalone segfault; LoadVPM version enforcement
- **Die Hard Trilogy** (`diehard-trilogy.md`) — original table; full design lifecycle; codified the VPW build order; modding-ethics precedent
- **Diner** (`diner.md`) — DisableLighting parameter documentation; shadow-layer separation; nestmap packing optimization
- **Dr. Who** (`dr-who.md`) — insert bloom "1/3 of natural" rule; frame pacing vs raw FPS; GI ball-reflection lights at Z≈52
- **Earthshaker** (`earthshaker.md`) — collidable-prims vs VPX-walls debate (walls won); nestmap resolution research; analog plunger VPX bug
- **F-14 Tomcat** (`f14-tomcat.md`) — clear flasher dome technique; BDL filament meshes; UseVPMModSol=2 DOF stuck-solenoid bug
- **Fish Tales** (`fish-tales.md`) — probe roughness 40% FPS finding; EXR HDR pipeline; rubber-band 5-object rig; lightning-flipper AddPt indexing
- **Flash Gordon** (`flash-gordon.md`) — VLM segment-display baking for VR backglass; Bally 6803 PulseTimer requirement
- **Game of Thrones** (`game-of-thrones.md`) — complex original table; DOF safety standards after a fire-hazard bug; Stern Node Board LED architecture
- **Ghostbusters** (`ghostbusters.md`) — VPinSPA emulation; RGB inserts from ROM lamp states; bass.dll sound-corruption documentation
- **Godzilla** (`godzilla.md`) — Blender bake→VPX reference implementation; PWM migration; "mayo" glass reflection technique
- **GoldenEye** (`goldeneye.md`) — timer interval 1→−1 doubled FPS 80→150+; GI ramp texture differencing; altsound-in-table
- **Goonies** (`goonies.md`) — deepest FlexDMD integration; multi-player state management; coordinate-based light sequencer; VR as geometry validation
- **Guns N' Roses** (`guns-n-roses.md`) — landmark playfield dimension validation (stated 25″×51.75″, real 23″×46″); stuck-ball velocity nudge; scoop ball-stack fix

### H–J

- **Hang Glider** (`hang-glider.md`) — Cinema 4D ray-traced EM table; drop-target/standup pivot orientation rules
- **Harlem Globetrotters** (`harlem-globetrotters.md`) — spinner dual-bakemap cross-fade with size offset; trigonometric rod animation
- **Haunted House** (`haunted-house.md`) — 3-playfield, 8-flipper Gottlieb; Blender collection-organization standard; batch export settings; multi-playfield architecture
- **Hook** (`hook.md`) — 1 ms timer performance lessons; per-material GI fade architecture; DE flasher-solenoid discovery method
- **Indiana Jones** (`indiana-jones.md`) — VPW's most documented build (100+ WIPs, 22 contributors); ON/OFF primitive fading; modulated-flasher averaging
- **Iron Maiden** (`iron-maiden.md`) — systematic real-machine reference methodology; 5° flipper over-travel; staged flippers; WEBP driving 64-bit adoption
- **Iron Man** (`iron-man.md`) — 3D scan-to-game pipeline (2.5M→8K tris); transparent plastic shadow fix; Lampz FadeSpeed LED vs incandescent
- **Johnny Mnemonic** (`johnny-mnemonic.md`) — 70+ versions documenting VLM toolkit evolution; `_BM/_LM/_BL` naming; pure-black-texture rendering breakage
- **Jokerz!** (`jokerz.md`) — raising-ramp motor modeling; flasher dome fade-up; GI-aware flasher opacity; VPX saves table state on exit (corruption risk)
- **Judge Dredd** (`judge-dredd.md`) — Deadworld rotating disc; 6-state GI+flasher texture swap; standup backstop prim pattern
- **Jurassic Park** (`jurassic-park.md`) — T-Rex mech (hardest VPW element); Tony McMapFace/AGX color work; unofficial mod-ROM integration

### L–M

- **Last Action Hero** (`last-action-hero.md`) — crane-mech lightmap fading; transparent-ramp dual material; complete DE flasher mapping; LED-conversion ROM anti-pattern
- **Lethal Weapon 3** (`lethal-weapon-3.md`) — v1.x→v2.0 lifecycle; table modernization checklist; wire-ramp polygon optimization
- **Lord of the Rings** (`lord-of-the-rings.md`) — fantasy reimagining with custom mechs; Instant Meshes decimation; ball-glow tracking lights
- **Maverick** (`maverick.md`) — rubberizer tuning on slow tables; InRotRect triggers; RTX ball shadows; competitive-play testing
- **Medieval Madness** (`medieval-madness.md`) — first AI-generated 3D models; HandleMech stepper fix; PAPA-video flipper calibration
- **Metallica** (`metallica.md`) — flasher fadedown stacking catastrophe; SAM GI via lamp matrix; magnet GrabCenter timing; Stern playfield 45″ (measured)

### N–S

- **No Fear** (`no-fear.md`) — FlipperCradleCollision first use (now a VPW standard); mayo-light placement methodology
- **Police Force** (`police-force.md`) — full System 11 teardown-to-toolkit build; flasher naming conventions; niwak top-3 performance rules
- **Quicksilver** (`quicksilver.md`) — physical kicker via mesh hole; community custom ROM with modified rules
- **Radical!** (`radical.md`) — pure-black material avoidance; Flupper bumper sizing; VR flasher-dome z-fighting (unfixable at table level)
- **Ripley's Believe It or Not!** (`ripleys.md`) — pop bumper radius = rubber skirt standard; dSleeves vs dPosts distinction
- **Road Show** (`road-show.md`) — scoop 45° impact-angle physics; gBOT standalone crash fix; Skitso's iterative GI methodology
- **RollerCoaster Tycoon** (`rollercoaster-tycoon.md`) — Whitestar toolkit build; standalone VBScript strictness; lightmap reflection optimization
- **Scared Stiff** (`scared-stiff.md`) — only WPC table with a flasher on a flipper output; PinMAME flipper PWM added because of it
- **Simpsons Pinball Party** (`simpsons-pinball-party.md`) — flasher sum limiter; SVG plastics from Illustrator; locale-dependent physics corruption
- **Skateball** (`skateball.md`) — clear insert rendering with visible bulbs; first-timer Blender troubleshooting
- **Space Station** (`space-station.md`) — two-layer toolkit insert technique; dual-color GI relay switching; AgX red-hotspot fix
- **Special Force** (`special-force.md`) — Bally 6803 solenoid multiplexing; physics tuning order (ball-roll speed first)
- **Spectrum** (`spectrum.md`) — halftone-dot artwork technique; insert Split mode; max-lights GPU OOM setting
- **Spider-Man** (`spider-man.md`) — SAM single-relay GI; RGB mixing from lamp states; wire-ramp 70K→17K tris
- **SpongeBob** (`spongebob.md`) — Lampz control-lights for original tables; Flupper remesh pipeline; cross-platform high-score files
- **Star Trek: TNG** (`star-trek-tng.md`) — upper-flipper correction limitation; rubber sleeve 20×20×20 standard; TargetBouncer scoop exclusion
- **Star Wars DE** (`star-wars-de.md`) — pre-toolkit C4D/Octane pipeline; double-sided decal-plane refraction bake; GI color temperature ≈2700K
- **Stargate** (`stargate.md`) — GTS3 platform reference: 2-switch trough, coil service bulletins, HDRI selection, physics methodology
- **Starship Troopers** (`starship-troopers.md`) — Whitestar rescale mod; light-falloff rescale methodology; glass height must not be scaled
- **Street Fighter II** (`street-fighter-2.md`) — System 3 Piledriver spiral ramp; 3-zone skillshot target; GTS3 NVRAM requirement

### T–X

- **T2: Judgment Day** (`t2.md`) — real-machine GI string mapping; niwak PWM integration; GI-off flasher overlay hack
- **Tales from the Crypt** (`tales-from-the-crypt.md`) — invented the 3-layer insert technique, GI doubled primitives, per-material fade curves, RTX ball shadows
- **Taxi** (`taxi.md`) — RTX ball-shadow Z-ordering; GI-off flasher color gotcha; GI-shaped lights via flasher objects
- **Team One** (`team-one.md`) — ground-up Gottlieb EM from fresh scans; Loserman's EM script framework
- **Time Fantasy** (`time-fantasy.md`) — System 7 insert baking; lens-top-as-bake-target; layer-separator placement guidance
- **Tommy** (`tommy.md`) — DE FastFlips solenoid 47; slingshot correction in `_Slingshot` subs; backglass power-draw dimming
- **Total Nuclear Annihilation** (`theatre-of-magic.md`) — first official-designer collaboration (Scott Danesi); real-machine lampshow system; glass-height physics barrier discovery (nav mislabels this page "Theatre of Magic")
- **Transporter the Rescue** (`transporter.md`) — insert text border technique; Lampz migration from vpmMapLights; VPX ramps lack BlendDisableLighting
- **Tron Legacy** (`tron.md`) — SAM FastFlips InitVpmFFlipsSAM; ROM-bypass flippers; Skitso's GI strip-and-rebuild
- **Twilight Zone** (`twilight-zone.md`) — powerball 0.8× mass; KickoutVariance; under-playfield blocker-wall first discovery; VPX magnet physics limits
- **Warlok** (`warlok.md`) — common VLM first-timer pitfalls; VR segment displays via backbox camera
- **World Cup Soccer** (`world-cup-soccer.md`) — scratch rebuild after VP-scale bug; spinning-ball glass dome; non-linear mech position arrays
- **X-Men** (`x-men.md`) — VLM toolkit's first real project; GI-baked-white tinting; physical VUK pattern; playfield_mesh rendering semantics

## Filing Summary

All 13 guides and all 5 reference pages are ingested into the concept pages listed above. Table pages are **not** filed per-table — they are provenance case studies whose generalized knowledge already lives in the guides (catalog above preserves searchability).

Selective table-only facts kept during ingest (not on concept pages): the GnR circularity dimension-validation method ([VPX Playfield Scanning](../concepts/VPX%20Playfield%20Scanning.md)), CFTBL Chase Light II emulation and Starship Troopers rescale notes (this page's catalog lines), Die Hard build-order codification ([VPX Table Build Workflow](../concepts/VPX%20Table%20Build%20Workflow.md)).

## See Also

- [Overviews](../overview.md) — ecosystem synthesis across all collections
- [Unofficial Visual Pinball Wiki](Unofficial%20Visual%20Pinball%20Wiki.md) — the other secondary collection (community usage/repair focus)
- [Visual Pinball X](../projects/Visual%20Pinball%20X.md) — the table editor these authors target
- [VPX Example Table](../concepts/VPX%20Example%20Table.md) — canonical reference implementation
