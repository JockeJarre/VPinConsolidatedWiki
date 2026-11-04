# VPX Nixie Plugin

The Nixie plugin (formerly **ScoreView**) displays the DMD **without any table-script modification** — a free-sizeable, movable DMD window used chiefly on [VPX Standalone](VPX%20Standalone.md) mobile and multi-screen setups. Its appearance is controlled by per-table `.nix` layout files.

> Sources: official VPX File Layout doc (primary) for the rename and layout extension; community wiki (secondary) for the feature details.

## Rename Note (2026-10)

The plugin shipped as "ScoreView" with `.scv` layout files through 2026-04. Upstream renamed it to **Nixie** in October 2026, and layouts switched from `.scv` to `.nix` with target-display sections ([raw/VPX/repo/docs/FileLayout.md](https://github.com/vpinball/vpinball/blob/master/docs/FileLayout.md): *"Table file v1.1.nix — Nixie plugin will use this layout file if present (otherwise defaulting to its bundled layouts folder)"*). The community wiki page still documents the plugin under its old ScoreView name — the feature details below carry over.

- ⚠️ CONFLICT (secondary source): plugin named ScoreView, layout extension `.scv`
  ([raw/ExternalWikis/dekay-vpinball-wiki/repo/ScoreView-Plugin.md](https://github.com/dekay/vpinball-wiki/wiki/ScoreView-Plugin)) — Primary: plugin renamed to Nixie, layouts `.nix` ([raw/VPX/repo/docs/FileLayout.md](https://github.com/vpinball/vpinball/blob/master/docs/FileLayout.md))

## Activation

([raw/ExternalWikis/dekay-vpinball-wiki/repo/ScoreView-Plugin.md](https://github.com/dekay/vpinball-wiki/wiki/ScoreView-Plugin))

1. Load the table
2. Open the options menu by **tapping the top-right edge** of the screen
3. **Display Settings → ScoreView/Nixie Display** → enable the display

When active, the window is freely sizeable and movable. Settings save **per table** or **globally as the default for all tables**.

## Form Factors

Recommended presets follow the original hardware form factors:

| Form factor | Resolution |
|-------------|-----------|
| Usual DMD (4:1) | **128×32** |
| Hi-res DMD | 256×64 |
| Wide (8:1) | 128×16 |
| Sega (3:1) | 192×64 |

These match the resolutions [DMD Extensions](../projects/DMD%20Extensions.md) documents, with 128×16 added.

## `.nix` Layout Files

The file **must be named exactly like the table with the `.nix` extension** (historically `.scv`), placed in the table's folder — the [VPX File Layout](VPX%20File%20Layout.md) search finds `<table>.nix` beside the `.vpx`; otherwise Nixie falls back to its global layouts folder. A layout file defines rendering — dot size, glass characteristics in front of the DMD, and (since the rename) target-display sections:

```
#Default layout for 128x32 DMD
Width: 128
Height: 32
Fit: Contain
Visuals:
  - DMD:
      Rect: [0,0,128,32]
      Style: Neon Plasma
      Size: [128, 32]
      Glass:
        Roughness: 0.1
        Image:
        Area: [0,0,1024,256]
        Ambient: [0.4,0.4,0.4]
```

- **Styles**: Neon Plasma, Red LED, Green LED, Yellow LED, Generic LED, Generic Plasma — the same family as the alpha/DMD display profiles in [DMD](DMD.md)
- **Glass overlays**: Glass-Dirty-1/-2, Glass-Cracked-1/-2; an empty `Image:` line means clean glass
- On Android/iOS, preset layout files ship in the repo at `vpinball/vpinball/plugins/scoreview/layouts`

**Limitation**: there is no global default for layout appearance — to remove the default "dirty/scratched glass", a layout file must be added to **every table** (upstream feature request vpinball issue #3112, open).

## PuP Integration

Nixie is one of the displays a [PuP Pack](PuP%20Packs.md) can render onto in standalone mode (Rev 4837+ VR-table flasher injection).

## See Also

- [DMD](DMD.md) — the display Nixie renders, and its style profiles
- [VPX Standalone](VPX%20Standalone.md) — primary platform for Nixie
- [VPX File Layout](VPX%20File%20Layout.md) — `.nix` placement rules
- [Altcolor](Altcolor.md) — coloring the DMD content itself
- [Unofficial Visual Pinball Wiki](../sources/Unofficial%20Visual%20Pinball%20Wiki.md) — source collection (secondary)
