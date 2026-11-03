# PuP Packs

PuP Packs are the media packs consumed by [PinUp Player](../projects/PinUp%20Player.md): video/animation content plus metadata that add dynamic backglass, DMD, topper, and playfield media to [Visual Pinball X](../projects/Visual%20Pinball%20X.md) tables.

> Source: community wiki (secondary). Upstream author is NailBuster (wikipinup).

## Installation Mechanics

([raw/dekay-vpinball-wiki/PUP-Packs.md](https://github.com/dekay/vpinball-wiki/wiki/PUP-Packs), §Add PuP Packs to an Existing Table)

- VPinball searches a **`pupvideos` folder beside the `*.vpx` file** — see [VPX File Layout](VPX%20File%20Layout.md)
- The pack root is the folder containing the `*.bat` option files; extract `puppack/<rom>` **into** `pupvideos/`
- **The option `.bat` files are the configuration**: copy `PuP-Pack_Options/<option>/*` over the pack root, then delete `PuPDesktopPunch.exe` / `PuPInit.bat`. Non-Windows users read the `.bat` files and apply the settings manually; after that the default `VPinballX.ini` suffices (Futurama example in the source)
- Pack anatomy (screens.pup, playlists.pup, triggers.pup, PinUpPlayer.ini) is covered on [PinUp Player](../projects/PinUp%20Player.md)

## Placement in the Legacy (Baller-Era) Layout

VPX 10.8.1 still runs tables from the legacy global folders, and PUP media has two valid placements there ([VPX File Layout](VPX%20File%20Layout.md), §Legacy Global Layout):

- **PinUp Player's own global folder (standard Windows pincab way)**: the rom-named pack folder goes to `C:\PinUpSystem\PuPVideos\<romname>\`; media lives **directly** in the rom folder — double-nesting (`PuPVideos\trn_174h\trn_174h`) is the classic install error ([raw/PUP/site/puppack_troubleshoot.html](https://www.nailbuster.com/wikipinup/doku.php?id=puppack_troubleshoot), [raw/PUP/site/pinup_player_tables.html](https://www.nailbuster.com/wikipinup/doku.php?id=pinup_player_tables))
- **`pupvideos` beside the `.vpx`**: in the legacy layout every table shares the one tables folder (`C:\pinball\tables\`), so the beside-the-table search resolves to a single global `C:\pinball\tables\pupvideos\<romname>\`, keyed by the game id (`namespace::gameId`) — see [VPX File Layout](VPX%20File%20Layout.md), §Companion File Search Priority
- The pack folder name must match the ROM name (`Const cGameName`); the PuPCapture framework stores it in the table script as `cPuPPack` ([raw/PUP/site/pup_capture.html](https://www.nailbuster.com/wikipinup/doku.php?id=pup_capture))
- The option `.bat` files configure the pack exactly as in §Installation Mechanics — layout-independent
- The Windows legacy integration stack must be complete: PinUPPlayerB2SDriver active in the B2S plugin settings, Freezy `dmddevice.dll` ≥ 1.7.1 with `dmddevice.ini` in the vpinmame root, and **Use External** enabled (F1 ROM dialog) for PuPCapture packs ([raw/PUP/site/puppack_troubleshoot.html](https://www.nailbuster.com/wikipinup/doku.php?id=puppack_troubleshoot))
- No `*.directb2s` backglass may stay enabled for a PuP table — B2S layers over the pack; renaming it must also change its **first 6 characters**, because the B2S server auto-matches files on that prefix
- Clean pack exit needs `Controller.Stop` in `Table_Exit` — see [VPX Scripting](VPX%20Scripting.md)
- Per-pack display layout: a `PinUPPlayer.ini` in the pack root overrides the global one in the PinUpSystem root ([raw/PUP/site/pinup_pack_layout.html](https://www.nailbuster.com/wikipinup/doku.php?id=pinup_pack_layout))

## Status on VPX Standalone / Mobile

Two claims coexist on the community wiki and must be dated:

- ❗ PUP-Packs.md NOTE: "PuP Packs **do not work at all** on the iOS or Android builds of Visual Pinball at this time"; "partially implemented in the Standalone versions"
- ✅ Standalone-(Mobile)-using-VR-Table-with-Puppack.md: with **Rev. 4837+**, PuP Packs can render on **Backglass, ScoreView, or Topper displays** when running a **VR table** on Standalone (mobile)

Reconciliation: the blanket "do not work" statement predates the Rev 4837+ display-rendering path; the scoped claim is the current one, and overlays/alpha/audio remain limited (see §Standalone Gaps in [PinUp Player](../projects/PinUp%20Player.md)).

### VR-Table Display Injection

The Rev 4837+ trick edits **the `.vpx` file itself** via the **vpx-editor** web tool (jsm174.github.io/vpx-editor) — not the table's VBS script:

1. The table must have a `PinCab_Backglass` primitive referencing a `BackglassImage` file
2. VPX injects a flasher (`BackglassImage001`) with the target display as external render device
3. A PuP Pack configured for the Backglass screen then renders onto it; FullDMD flashers can be re-pointed to e.g. ScoreView
4. If the backglass primitive is named differently, rename/reassign it

## Platform Notes

- iOS renders one window at a time, so PuP overlays over B2S are unsupported there — see [VPX Standalone](VPX%20Standalone.md)
- [Altcolor](Altcolor.md), AltSound, and haptics are the supported mobile enhancement paths on iOS

## See Also

- [PinUp Player](../projects/PinUp%20Player.md) — the rendering engine and pack file anatomy
- [VPX File Layout](VPX%20File%20Layout.md) — pupvideos/ placement
- [VPX Standalone](VPX%20Standalone.md) — cross-platform status
- [B2S Backglass Server](../projects/B2S%20Backglass%20Server.md) — the Windows backglass server PuP layers onto
- [Unofficial Visual Pinball Wiki](../sources/Unofficial%20Visual%20Pinball%20Wiki.md) — source collection (secondary)
