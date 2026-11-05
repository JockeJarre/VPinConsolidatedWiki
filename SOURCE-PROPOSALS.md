# SOURCE-PROPOSALS — registry of accepted new-source proposals

Registry of new raw-source proposals **accepted** into the wiki pipeline.
Each accepted proposal landed here via its own `source/<slug>` branch + merged PR.
After a merge, the collection still needs registration: `update-raw.sh` /
`update-raw.ps1` fetch step, `raw/<Name>/FETCH.md` + `raw/FETCH.md` table row,
AGENTS.md tier + upstream URL mapping.

Proposed (not accepted) entries never appear on this file — they live only on
their open `source/<slug>` proposal branches/PRs. Rejected proposals are closed
and never enter this registry.

Proposal line format (one line per source, appended by the nightly scan):

```
- [NEW-SOURCE] <Project Name> | <upstream docs URL> | raw/<ProposedCollection>/ | <one-line reason>
```

## Accepted proposals

_(none yet — the section grows as proposal PRs are merged)_
- [NEW-SOURCE] Pinscape Pico | https://github.com/mjrgh/PinscapePico/tree/main/GUIConfigTool/Help | raw/PinscapePico/ | Primary mjr GUI Config Tool help (PlungerCal, config templates) cited by the secondary dekay guide; only the KL25Z-era build guide is registered
- [NEW-SOURCE] VPinFE | https://github.com/vpinfe/vpinfe/wiki | raw/VPinFE/ | The frontend's own upstream GitHub wiki — the community "First Steps" page was retired in its favor (2026-10-24); the VPinFE project page currently rests only on secondary sources
