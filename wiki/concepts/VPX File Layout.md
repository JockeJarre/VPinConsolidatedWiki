# VPX File Layout

File organization for [Visual Pinball X](../projects/Visual%20Pinball%20X.md): where the application, configuration, and table data live on each platform, and how companion files are discovered. The **per-table, self-contained layout** was introduced during the 10.8.1 development cycle and supersedes the legacy global folders of the Baller era.

> Source: community wiki (secondary). Core layout claims match the official upstream File Layout doc; where community pages disagree with each other, this page follows the newest collection page (File-Layout.md).

## Three-Part Structure

VPinball data splits into three parts, each with a platform-specific location ([raw/ExternalWikis/dekay-vpinball-wiki/repo/File-Layout.md](https://github.com/dekay/vpinball-wiki/wiki/File-Layout), §VPinball's Structure):

| Part | Windows | macOS | Linux | Android / Meta Quest | iOS |
|------|---------|-------|-------|----------------------|-----|
| Application | `C:\Program Files\...` | `/Applications/VPinballX_BGFX.app/` | distro-dependent | system app folder | system app folder |
| Config + log | `%APPDATA%\VPinballX\<version>` | `~/Library/Application Support/VPinballX/<version>` | `~/.local/share/VPinballX/<version>` | `/data/data/org.vpinball.vpinball_bgfx/files/<version>` | app Documents dir |
| Tables | user choice (often Documents) | user choice | user choice | `/data/data/org.vpinball.vpinball_bgfx/files/` | app Documents dir |

- Since VPX 10.8.1, configuration lives in a **subdirectory per minor version** (e.g. `10.8`), so multiple minor versions coexist without settings conflicts
- The config directory can be relocated with the `-PrefPath [path]` command-line option; most frontends support passing it
- The configuration folder holds `VPinballX.ini`, `vpinball.log`, and the `directoutputconfig/` subdirectory for all [DOF](../projects/DirectOutput%20Framework.md) files
- The `~/.config/VPinball` and `~/vpinball` paths quoted by older community pages ([raw/ExternalWikis/dekay-vpinball-wiki/repo/Backing-Up.md](https://github.com/dekay/vpinball-wiki/wiki/Backing-Up) are **stale** — superseded by the XDG path above

## Settings Model: INI, not Registry

`VPinballX.ini` replaced the Windows Registry as the settings store. The ini model enables per-table overrides, third-party editing, custom ini files on the command line, and identical settings across all platforms ([raw/ExternalWikis/dekay-vpinball-wiki/repo/File-Layout.md](https://github.com/dekay/vpinball-wiki/wiki/File-Layout), §The VPinballX.ini Settings File). As of 10.8, **Windows uses the ini file too** — registry-era advice (regsvr32, registry edits) in the community FAQ/Windows pages is VP9-legacy.

- ⚠️ CONFLICT (secondary source): global registry-key settings storage and DLL re-registration guidance
  ([raw/ExternalWikis/dekay-vpinball-wiki/repo/FAQ.md](https://github.com/dekay/vpinball-wiki/wiki/FAQ), Windows.md) — Primary: ini-file model ([raw/VPX docs](https://github.com/vpinball/vpinball/tree/master/docs)); scoped as legacy

Settings can be adjusted in-game via **F12 LiveUI**; saving asks whether to store as global preferences or as a per-table override.

## Table File Formats

- **`.vpx`** — the original format, a Windows Compound Binary Format file; non-Windows platforms load it via the **POLE** structured-storage library (see [VPX Standalone](VPX%20Standalone.md))
- **`.vpz`** — open zip-based alternative holding the full table and assets in editable formats (JSON documents + scene assets), meant for diffing and DCC interoperability; can also run unzipped; the full spec is in the official docs ([raw/VPX/repo/docs/VPZ File Format.md](https://github.com/vpinball/vpinball/blob/master/docs/VPZ%20File%20Format.md)), marked preliminary/not yet production-ready
- **`.vpxz`** — zip archive of table **plus ROMs, scripts, and all assets**; mobile-only transfer convenience (ROMs must stay zipped inside)
- Conversions between formats: **[vpxtool](../projects/Vpxtool.md)** (francisdb)

## Companion File Search Priority

Companion files are resolved in three steps ([raw/ExternalWikis/dekay-vpinball-wiki/repo/File-Layout.md](https://github.com/dekay/vpinball-wiki/wiki/File-Layout), §Table Folder Organization):

1. Next to the table file, named after the **table file**
2. Next to the table file, named after the **containing folder**
3. In a component-specific legacy folder

Game-driven content (DMD colorizations, PuP videos) is bound to a controller id of the form `namespace::gameId` (e.g. `pinmame::afm_113`). Plugins search `base/namespace/gameId/…` first, then `base/gameId/…` — e.g. `serum/pinmame/afm_113/` before `serum/afm_113/`. The legacy `pinmame/altcolor/` folder is inherently pinmame-scoped and only searched for `pinmame::` games.

## Per-Table Folder Tree

```
Table Name (Manufacturer Year)/
├── Table Name.vpx                 <= the table
├── Table Name.ini                 <= per-table settings override
├── Table Name.vbs                 <= external script override (wins over embedded script)
├── Table Name.directb2s           <= backglass file, shared across table versions
├── Table Name.nix                 <= Nixie plugin layout file (see VPX Nixie Plugin; historically .scv)
├── Table Name.info                <= frontend metadata, not read by VPX
├── altsound/                      <= AltSound plugin audio
├── cache/                         <= VPX rendering cache
├── medias/                        <= frontend media (mp4/apng)
├── music/                         <= files loaded by the PlayMusic script command
├── pinmame/
│   ├── roms/                      <= per-table ROM (zip, name = cGameName)
│   ├── nvram/                     <= per-table NVRAM
│   ├── cfg/                       <= PinMAME config files
│   ├── altcolor/                  <= legacy pinmame-scoped DMD colorization
│   └── altsound/                  <= pinmame-scoped alt sound
├── pupvideos/                     <= PinUp Player videos (see PuP Packs)
├── scripts/                       <= extra scripts, searched with the core script folder
├── serum/<rom>/                   <= Serum DMD colorization (see Altcolor)
├── vni/<rom>/                     <= PAL+VNI colorization (see Altcolor)
├── Table Name.UltraDMD/           <= FlexDMD/UltraDMD content (folder name set in the table script)
└── user/                          <= script-saved values (VPReg.stg)
```

(File-Layout.md, §Table Folder Organization; layout tree also mirrored in Serum-Plugin.md / VNI-Plugin.md)

- Basenames of `.ini` / `.vbs` / `.vpx` must match **exactly** (case and special characters) to associate; ROM filenames lowercase on disk (`TAF_L7` → `taf_l7.zip`) ([raw/ExternalWikis/dekay-vpinball-wiki/repo/Optimizations-For-iOS-Etc.md](https://github.com/dekay/vpinball-wiki/wiki/Optimizations-For-iOS-Etc), §Scenario 2)
- ROM name comes from `Const cGameName` in the table script, or from `vpinball.log` after a failed load
- A legacy file layout is still supported for migration ease but **discouraged**; upstream may drop it

## Legacy Global Layout (Baller Era)

Before 10.8.1, the ecosystem used one global folder tree — `Tables\`, `B2S Tables\`, `VPinMAME\roms\`, a shared config folder — typically owned by the **Baller** installer ([raw/ExternalWikis/dekay-vpinball-wiki/repo/Windows.md](https://github.com/dekay/vpinball-wiki/wiki/Windows), Windows-Baller-Installer.md).

- Baller bundles **stable pinned releases** (e.g. 10.8.0) and does not track development builds like 10.8.1 — check the Baller docs for the version it installs; Baller-managed installs therefore stay on the legacy-layout-era engine until upgraded ([raw/ExternalWikis/dekay-vpinball-wiki/repo/Windows-Baller-Installer.md](https://github.com/dekay/vpinball-wiki/wiki/Windows-Baller-Installer))
- The 10.8.0 Windows build supports **all files within a single directory only** — the per-table layout above requires 10.8.1+; the Standalone build is more flexible ([raw/ExternalWikis/dekay-vpinball-wiki/repo/FAQ.md](https://github.com/dekay/vpinball-wiki/wiki/FAQ))

- PUP media in this layout resolves to a single global `Tables\pupvideos\<romname>\` folder (every `.vpx` shares the tables folder); PinUp Player's native global `C:\PinUpSystem\PuPVideos\` folder is independent of the VPX layout change — see [PuP Packs](PuP%20Packs.md), §Placement in the Legacy (Baller-Era) Layout

- ⚠️ CONFLICT (secondary source): global `VPinMAME\roms\` placement ("Where do I put ROMs?")
  ([raw/ExternalWikis/dekay-vpinball-wiki/repo/FAQ.md](https://github.com/dekay/vpinball-wiki/wiki/FAQ) — Primary: per-table `pinmame/roms/` layout ([raw/ExternalWikis/dekay-vpinball-wiki/repo/File-Layout.md](https://github.com/dekay/vpinball-wiki/wiki/File-Layout), mirroring the official upstream File Layout doc, which the community page itself defers to)

## Mobile File Management

All mobile platforms ship a **built-in web server** (off by default) for uploading tables and editing extracted files from a browser on the same network. Android imports tables into UUID folders (not directly browsable); iOS exposes the Documents folder via the Files app and Finder ([raw/ExternalWikis/dekay-vpinball-wiki/repo/File-Layout.md](https://github.com/dekay/vpinball-wiki/wiki/File-Layout), §File Management on Mobile Platforms). See [VPX Standalone](VPX%20Standalone.md) for mobile specifics.

## See Also

- [Visual Pinball X](../projects/Visual%20Pinball%20X.md) — the engine these files belong to
- [VPX Standalone](VPX%20Standalone.md) — cross-platform builds and their paths
- [Altcolor](Altcolor.md) — serum/ and vni/ colorization placement
- [PuP Packs](PuP%20Packs.md) — pupvideos/ media packs
- [VPX Nixie Plugin](VPX%20Nixie%20Plugin.md) — .nix layout files (formerly .scv)
- [Pincab Setup](Pincab%20Setup.md) — cabinet-wide installation ordering
- [Unofficial Visual Pinball Wiki](../sources/Unofficial%20Visual%20Pinball%20Wiki.md) — source collection (secondary)
