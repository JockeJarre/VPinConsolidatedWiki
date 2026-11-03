# PinUp Player

PinUp Player (PuP) is NailBuster's closed-source Windows media player that renders table-specific video/animation content across the backglass, DMD, topper, and playfield screens of a [pincab](../concepts/Pincab%20Setup.md). It is the engine behind [PuP Packs](../concepts/PuP%20Packs.md), receiving events from [Visual Pinball X](Visual%20Pinball%20X.md) and Future Pinball via table scripts.

> Source: community wiki (secondary), including its archived reverse-engineering page — claims about internal file formats are community observations, pinned to NailBuster quotes where noted.

## Overview

- Definition (community): media + metadata that render backbox screens for VPX and Future Pinball; **Windows PinUp Player is closed source** ([raw/ExternalWikis/dekay-vpinball-wiki/repo/PUP-Reverse-Engineering.md](https://github.com/dekay/vpinball-wiki/wiki/PUP-Reverse-Engineering), §What Are Pup Packs)
- Newer packs ship content as static files; **older packs define screens/playlists/triggers at runtime from the table script**
- Standalone (cross-platform VPX) has partial support — see [PuP Packs](../concepts/PuP%20Packs.md)
- Distinct from [PinUp Popper](../sources/PinUp%20Popper%20Docs.md), the frontend; both are part of the PinUp ecosystem
- Community guidance quotes NailBuster: tables should drive PuP through the PUPDMD/pup framework, not raw SendMSG

## Pack File Anatomy

The four master files at the pack root ([raw/ExternalWikis/dekay-vpinball-wiki/repo/PUP-Reverse-Engineering.md](https://github.com/dekay/vpinball-wiki/wiki/PUP-Reverse-Engineering), §Important files):

| File | Format | Role |
|------|--------|------|
| `PinUpPlayer.ini` | INI | Per-screen master settings: ScreenXPos/Width, volume, hidestopped |
| `screens.pup` | CSV | Screen layout: which windows exist, z-order |
| `playlists.pup` | CSV | Playlists = subfolders of videos under `pupvideos/<rom>` |
| `triggers.pup` | CSV | Triggers; can react to PinMAME events |

Quirks documented by the community:

- **Header/field-name mismatches** in the PuP Pack Editor: `Loopit`↔Transparent, `Active`↔Mode, `Priority`↔Volume %
- **AlphaSort**: confirmed by @nailbuster (2025-03-31) Random=1, AlphaSort=0 — the PuP-Pack Editor v1.4 help text ("OFF=Random, 1=alpha") is **wrong**
- **Z-order** follows `screens.pup` CSV row order on Windows; standalone orders by `#pupid` — the root of per-table fixes for Gilligan's Island, Cactus Canyon, Flintstones, Addams Family packs
- **PuPShapes**: 24-bit BMPs where pixel color (0,0) acts as the transparent mask
- Trigger semantics: priority 1–9 overrides restSeconds, Counter=20 fires every 20th trigger, max 5 checks per trigger, no leading zeros (`S4=1`)

## Screen IDs

The five standalone-renderable physical windows: **Topper=0, DMD=1, Backglass=2, Playfield=3, FullDMD=5**. Standalone config keys `PUP<Name>Screen/Window/WindowX…` in `VPinballX.ini [Standalone]` map them to real windows.

## Scripting API

- Tables create the COM object `PinUpPlayer.PinDisplay`; data flows via `B2SData "E"&n`
- The **SendMSG JSON protocol (`mt:301`)** carries function codes ([raw/ExternalWikis/dekay-vpinball-wiki/repo/PUP-Reverse-Engineering.md](https://github.com/dekay/vpinball-wiki/wiki/PUP-Reverse-Engineering), §Scripting API): FN 22 transparency (`AV` 0–255), FN 30/31 jukebox mode/next/prev, FN 42 audio duck (`DV`, `ALL`), FN 45 slow-PC mode, FN 50 aspect, FN 51 media position ms, FN 16 launch exe, FN 12 stop screen, FN 15 custom position %, FN 6 bring to front, FN 41 safeloop, FN 52 text alignment

## Standalone Gaps

Unimplemented in the standalone renderer ([raw/ExternalWikis/dekay-vpinball-wiki/repo/PUP-Reverse-Engineering.md](https://github.com/dekay/vpinball-wiki/wiki/PUP-Reverse-Engineering), §Missing features and bugs): playlistplay/play/playpause/playresume/setAspect/setVolume/SetLength pindisplay functions; no video alpha; **no transparent background**, so PuP-over-B2S combos (Star Tours, Tom & Jerry) become a "disco screen"; playstop fails to stop looping music; triggers fire on `off` screens; SkipSamePrty skips even when nothing is playing; label font scaling, image labels, and `mt:1` label animations unsupported.

The source wiki's archived-status note (2026-10-11): "most of these issues are fixed in the current PUP Plugin" — treat the gap list as historic.

## See Also

- [PuP Packs](../concepts/PuP%20Packs.md) — pack contents, installation, mobile status
- [PinUp Popper Docs](../sources/PinUp%20Popper%20Docs.md) — the frontend half of the PinUp ecosystem
- [B2S Backglass Server](B2S%20Backglass%20Server.md) — the backglass server PuP renders over
- [VPX Standalone](../concepts/VPX%20Standalone.md) — cross-platform PuP support
- [Unofficial Visual Pinball Wiki](../sources/Unofficial%20Visual%20Pinball%20Wiki.md) — source collection (secondary)
