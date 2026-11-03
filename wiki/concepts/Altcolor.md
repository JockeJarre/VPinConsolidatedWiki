# Altcolor

Altcolor is the alternate/multicolor DMD display for a table whose original machine had a monochrome, fixed-color display. Five colorization formats exist, in order from oldest to most modern; only the open formats are supported by VPinball's built-in plugin system.

> Source: community wiki (secondary). See [DMD](DMD.md) for the display itself, [VPX File Layout](VPX%20File%20Layout.md) for folder placement.

## Format Ladder

([raw/dekay-vpinball-wiki/Altcolor.md](https://github.com/dekay/vpinball-wiki/wiki/Altcolor), §Introduction)

| # | Format | What it is | Built-in support |
|---|--------|-----------|------------------|
| 1 | **PAL** | 4-color palette applied to the ROM's DMD output | Yes |
| 2 | **Patched ROM + PAL** | ROM patched for color (SAM), needs its matching PAL | Yes |
| 3 | **PAL & VNI pair** | Two files providing the colorization | Yes (unencrypted only) |
| 4 | **PAC** | Encrypted PAL+VNI, closed source | **No** — decrypt, or Windows-only third-party plugin |
| 5 | **Serum** | `.crz` / `.cromc`; open source; actively produced | Yes |

## PAL

- A PAL is a **four-color palette** that recolors the ROM's DMD output
- **Manufacturer-dependent**: a Stern PAL on a Bally ROM yields wrong colors ([raw/dekay-vpinball-wiki/PAL-‐-4-Colors.md](https://github.com/dekay/vpinball-wiki/wiki/PAL-%E2%80%90-4-Colors)
- Patched ROMs are identified by a **trailing `c`** in the filename: `st_161hc.zip` is the patched form of `st_161h.zip`; SAM color patches use trailing `c` **or** `hc` ([raw/dekay-vpinball-wiki/PAL-with-patched-ROM.md](https://github.com/dekay/vpinball-wiki/wiki/PAL-with-patched-ROM), PAL-with-patched-ROMs-(SAM-Color).md)
- **Without its matching PAL, a patched ROM behaves exactly like the unpatched ROM**
- DIY SAM path: original ROM + diff file + PAL; pre-patched ROM + PAL also works. Placement: ROM in `pinmame/roms/`, PAL as `pinmame/altcolor/<romname>/pin2dmd.pal`
- Known patch authors recorded on the source wiki: pinballmike (AC/DC, Metallica), sharkky (Avengers, Big Buck Hunter, Mustang, Spiderman VE, Star Trek), Toon (Shrek)

## VNI

- Pair of files (`<rom>.pal` + `<rom>.vni`) named after the ROM, in `vni/<rom>/` next to the `.vpx` file; the legacy names `pin2dmd.vni` / `pin2dmd.pal` and the `pinmame/altcolor/<romname>/` folder are also accepted ([raw/dekay-vpinball-wiki/VNI-Plugin.md](https://github.com/dekay/vpinball-wiki/wiki/VNI-Plugin)
- **"Only unencrypted colorization files are supported by VPinball's built-in plugin system"**

## PAC

- PAC is an encrypted, closed-source release: shipped with a hardware DMD holding the decryption key, under a license whose fee went to children's charities; once decrypted a PAC is simply a PAL + VNI set ([raw/dekay-vpinball-wiki/PAC-‐-not-‐(official)-supported.md](https://github.com/dekay/vpinball-wiki/wiki/PAC-%E2%80%90-not-%28official%29-supported)
- The VPinball developers declined to support it; paths are decrypt-to-PAL+VNI, or a **Windows-only** community PAC plugin
- ⚠️ CONFLICT (secondary source): PAC not supported by VPinball's built-in plugin system
  ([raw/dekay-vpinball-wiki/Altcolor.md](https://github.com/dekay/vpinball-wiki/wiki/Altcolor), §Introduction/§VNI Plugin) — Primary: [DMD Extensions](../projects/DMD%20Extensions.md) lists VNI/PAL/PAC as supported by *freezy's colorizer* — scopes differ: the DMD Extensions device colorizer accepts PAC; VPX's built-in plugin system does not

## Serum

- Open format, natively supported; "the most modern version of Altcolor for which new colorizations are being actively created" ([raw/dekay-vpinball-wiki/Altcolor.md](https://github.com/dekay/vpinball-wiki/wiki/Altcolor)
- Placement: `serum/<rom>/<rom>.cromc` next to the `.vpx` file ([raw/dekay-vpinball-wiki/Serum-Plugin.md](https://github.com/dekay/vpinball-wiki/wiki/Serum-Plugin), e.g. `serum/twenty4_150/twenty4_150.cROMc`)
- **`.crz` → `.cromc` migration**: `.crz` is the original, memory- and disk-hungry format; the newer `.cromc` is much more efficient, and **VPinball auto-generates a `.cromc` for any older `.crz` it finds at runtime**
- ⚠️ CONFLICT (secondary source): `.crz` is the legacy format, superseded by auto-generated `.cromc`
  ([raw/dekay-vpinball-wiki/Altcolor.md](https://github.com/dekay/vpinball-wiki/wiki/Altcolor), §Serum Plugin) — Primary: [DMD Extensions](../projects/DMD%20Extensions.md) describes Serum (`.cRZ`) as the modern colorization format; the primary docs do not mention `.cromc`
- Colorizations distributed on VPUniverse file category 173, "Serum DMD Colorizations"
- On [VPX Standalone](VPX%20Standalone.md) mobile, Serum (`.cRZ` at `pinmame/altcolor/<name>/<name>.cRZ`, enabled via `UseVPMColoredDMD = True` before `LoadVPM`) is the **only** working DMD color format — all others are closed/unsupported there ([raw/dekay-vpinball-wiki/Optimizations-For-iOS-Etc.md](https://github.com/dekay/vpinball-wiki/wiki/Optimizations-For-iOS-Etc), §Intermission)

## Choosing a Format

The community wiki's guidance: "an Altcolor available in the newer Serum format might be a better choice than PAL & VNI" ([raw/dekay-vpinball-wiki/Altcolor.md](https://github.com/dekay/vpinball-wiki/wiki/Altcolor) Its ~50-game tested PAL & VNI list (Addams Family, Cactus Canyon, Medieval Madness, Monster Bash, Terminator 2, X-Men LE, …) was tested on VPinball Standalone 10.8.1 mobile, "at least partially working."

## See Also

- [DMD](DMD.md) — the dot-matrix display being colorized
- [DMD Extensions](../projects/DMD%20Extensions.md) — hardware/display colorizer with its own format support
- [VPX File Layout](VPX%20File%20Layout.md) — serum/, vni/, pinmame/altcolor/ placement
- [FlexDMD](../projects/FlexDMD.md) — scriptable DMD rendering, an alternative to ROM colorization
- [Unofficial Visual Pinball Wiki](../sources/Unofficial%20Visual%20Pinball%20Wiki.md) — source collection (secondary)
