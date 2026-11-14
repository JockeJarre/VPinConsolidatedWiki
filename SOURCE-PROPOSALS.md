# SOURCE-PROPOSALS — registry of accepted new-source proposals

Registry of new raw-source proposals **accepted** into the wiki pipeline.
Each accepted proposal landed here via its own `source/<slug>` branch + merged PR.
After a merge, the collection still needs registration: `update-raw.sh` /
`update-raw.ps1` fetch step, `raw/<Name>/FETCH.md` + `raw/FETCH.md` table row,
AGENTS.md tier + upstream URL mapping.

Proposed (not accepted) entries never appear on this file — they live only on
their open `source/<slug>` proposal branches/PRs. Rejected proposals are closed
and never enter this registry.

A proposal accepted as **link-only** (comment `link-only` on its PR) is also
*not* merged into this registry: its PR is closed and the resource is added to
`wiki/references.md` as a Link-only-tier entry instead — never fetched, registered,
or ingested. See AGENTS.md → *Source Proposals — Accept, Reject, or Link-only*.

Proposal line format (one line per source, appended by the nightly scan):

```
- [NEW-SOURCE] <Project Name> | <upstream docs URL> | raw/<ProposedCollection>/ | <one-line reason>
```

## Accepted proposals

_(none yet — the section grows as proposal PRs are merged)_
- [NEW-SOURCE] Pinscape Pico | https://github.com/mjrgh/PinscapePico/tree/main/GUIConfigTool/Help | raw/PinscapePico/ | Primary mjr GUI Config Tool help (PlungerCal, config templates) cited by the secondary dekay guide; only the KL25Z-era build guide is registered
- [NEW-SOURCE] VPinFE | https://github.com/vpinfe/vpinfe/wiki | raw/VPinFE/ | The frontend's own upstream GitHub wiki — the community "First Steps" page was retired in its favor (2026-10-24); the VPinFE project page currently rests only on secondary sources
- [NEW-SOURCE] VPinMAME | https://github.com/vpinball/pinmame/blob/master/README.md | raw/VPinMAME/ | Primary docs of the ROM emulator VPX integrates (controller cores, ROM naming/paths, nvram, altcolor, Cabinet Mode) — heavily relied on across the wiki, currently unregistered
- [NEW-SOURCE] libserum | https://raw.githubusercontent.com/PPUC/libserum/refs/heads/master/README.md | raw/libserum/ | Upstream docs of the Serum .crz/.cromc DMD-colorizer library bundled by DMD Extensions (v2.8.2) and used by the VPX Serum plugin; format/version details on Altcolor rest on secondary sources
- [NEW-SOURCE] VPin Studio | https://github.com/syd711/vpin-studio | raw/VPinStudio/ | Modern table/player/competition management frontend (Rust, cross-platform) listed in vpxtool's related-projects; currently unregistered, wiki coverage none
