# VPX ScoreView Plugin

The ScoreView Plugin displays the DMD **without any table-script modification** — a free-sizeable, movable DMD window used chiefly on [VPX Standalone](VPX%20Standalone.md) mobile and multi-screen setups. Its appearance is controlled by per-table `.scv` layout files.

> Source: community wiki (secondary).

## Activation

([raw/ExternalWikis/dekay-vpinball-wiki/repo/ScoreView-Plugin.md](https://github.com/dekay/vpinball-wiki/wiki/ScoreView-Plugin)

1. Load the table
2. Open the options menu by **tapping the top-right edge** of the screen
3. **Display Settings → ScoreView Display** → enable ScoreView

When active, the ScoreView window is freely sizeable and movable. Settings save **per table** or **globally as the default for all tables**.

## Form Factors

Recommended presets follow the original hardware form factors:

| Form factor | Resolution |
|-------------|-----------|
| Usual DMD (4:1) | **128×32** |
| Hi-res DMD | 256×64 |
| Wide (8:1) | 128×16 |
| Sega (3:1) | 192×64 |

These match the resolutions [DMD Extensions](../projects/DMD%20Extensions.md) documents, with 128×16 added.

## `.scv` Layout Files

The file **must be named exactly like the table with the `.scv` extension**, placed in the table's folder (the [VPX File Layout](VPX%20File%20Layout.md) search finds `<table>.scv` beside the `.vpx`; otherwise ScoreView falls back to its global scoreview folder). An SCV defines rendering — dot size, glass characteristics in front of the DMD:

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
- On Android/iOS, preset SCVs ship in the repo at `vpinball/vpinball/plugins/scoreview/layouts`

**Limitation**: there is no global default for SCV appearance — to remove the default "dirty/scratched glass", an SCV must be added to **every table** (upstream feature request vpinball issue #3112, open).

## PuP Integration

ScoreView is one of the displays a [PuP Pack](PuP%20Packs.md) can render onto in standalone mode (Rev 4837+ VR-table flasher injection).

## See Also

- [DMD](DMD.md) — the display ScoreView renders, and its style profiles
- [VPX Standalone](VPX%20Standalone.md) — primary platform for ScoreView
- [VPX File Layout](VPX%20File%20Layout.md) — `.scv` placement rules
- [Altcolor](Altcolor.md) — coloring the DMD content itself
- [Unofficial Visual Pinball Wiki](../sources/Unofficial%20Visual%20Pinball%20Wiki.md) — source collection (secondary)
