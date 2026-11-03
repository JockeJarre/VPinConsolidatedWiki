# FlexDMD Docs

Summary of 5 FlexDMD documentation files from the local snapshot in [raw/FlexDMD/repo/docs](https://github.com/vbousquet/flexdmd/tree/master/docs). Run `update-raw.ps1` to refresh it before re-ingesting.

## Canonical Upstream

- [FlexDMD Docs](https://github.com/vbousquet/flexdmd/tree/master/docs)

## Source Files

| File | Contents |
|------|----------|
| [README.md](https://github.com/vbousquet/flexdmd/blob/master/docs/README.md) | Overview, features, installation, configuration, architecture |
| [FlexDMD_API.md](https://github.com/vbousquet/flexdmd/blob/master/docs/FlexDMD_API.md) | Full COM API reference: Stage, Actors, Actions, threading |
| [UltraDMD.md](https://github.com/vbousquet/flexdmd/blob/master/docs/UltraDMD.md) | Drop-in UltraDMD replacement guide and table conversion steps |
| [VPXDMD.md](https://github.com/vbousquet/flexdmd/blob/master/docs/VPXDMD.md) | Embedding the DMD directly on the VPX playfield |
| [JPSalas.md](https://github.com/vbousquet/flexdmd/blob/master/docs/JPSalas.md) | Adding FlexDMD to JPSalas tables that lack UltraDMD support |

## Key Facts

- FlexDMD is an in-process COM server (`FlexDMD.FlexDMD`) registered via `FlexDMD.dll`
- Renders to real or virtual DMD via `DmdDevice.dll` / `DmdDevice64.dll` (Freezy's DMD Extensions)
- API based on LibGDX Scene2D: Stage → Group/Image/Video/Label Actors → Actions
- Supports three render modes: monochrome 4-shade (0), monochrome 16-shade (1), full color (2)
- Ships `FlexUDMD.dll` as a drop-in UltraDMD replacement — no table script changes needed
- Supports embedded DMD inside VPX playfield via `DmdPixels` / `DmdColoredPixels` + a timer
- Companion app `FlexDMDUI.exe` handles installation, registration, and testing

## See Also

- [FlexDMD](../projects/FlexDMD.md)
- [DMD](../concepts/DMD.md)
- [VPX Docs](VPX%20Docs.md)


