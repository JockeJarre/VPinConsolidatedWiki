# DMD Extensions

DMD Extensions (dmdext / freezy) is a toolbox that routes DMD frames from digital pinball games to physical and virtual DMD displays. It provides `DmdDevice.dll` — the standard output library used by Visual PinMAME, [FlexDMD](FlexDMD.md), and many other pinball tools.

## Overview

DMD Extensions bridges game outputs (frame sources) to display outputs (destinations) via a typed **RenderGraph** pipeline. It ships as both a command-line tool (`dmdext.exe`) and a drop-in DLL (`DmdDevice.dll` / `DmdDevice64.dll`).

### Supported Game Sources

| Game | Integration Method |
|------|--------------------|
| Visual PinMAME | `DmdDevice.dll` API |
| Pinball FX2 | Screen frame grabbing |
| Pinball FX3 | DMD texture read from memory |
| Pinball FX | Official `DmdDevice.dll` support |
| The Pinball Arcade | DMD texture from memory |
| Pro Pinball Timeshock | Boost message queue (IPC) |
| Future Pinball | FP Intercept pipe |

### Supported Hardware Displays

| Display | Color Depth |
|---------|-------------|
| PinDMD v1 | 2-bit (4 shades) |
| PinDMD v2 | 4-bit (16 shades) |
| PinDMD v3 / v3.1 | Full RGB |
| PIN2DMD | Full RGB |
| Pixelcade | Full RGB |
| ZeDMD | Full RGB |

Virtual DMD output for monitor users is also included, with a pixel-shader rendering pipeline for high-resolution dot effects.

## Architecture: RenderGraph

![FlexDMD/DMD Extensions architecture in the VPX ecosystem](https://raw.githubusercontent.com/vbousquet/flexdmd/master/docs/media/architecture.svg)

The core library (`LibDmd`) routes frames through a `RenderGraph`. Each graph has one source and one or more destinations. The graph inspects the source/destination interface pair and selects the most efficient frame conversion.

### Frame Formats

| Format | Data | Typical Source |
|--------|------|----------------|
| 2-bit grayscale | `byte[]` values 0–3 | Visual PinMAME |
| 4-bit grayscale | `byte[]` values 0–15 | VPM, Pinball Arcade |
| 2-bit colored | bit planes + 4-color palette | Colorizer output |
| 4-bit colored | bit planes + 16-color palette | Colorizer output |
| RGB24 | `byte[]` 3 bytes/pixel | Full color sources |
| Bitmap | .NET `BitmapSource` | Screen grabber, file sources |

Conversion between formats is automatic and cheap. The graph always tries to send the minimum data needed by the destination (e.g. a PinDMD3 gets a 1kb palette frame instead of a 96kb RGB24 frame when the source is only 2-bit).

### Dynamic Resolution

Destinations that can resize implement `IResizableDestination` (e.g. virtual DMD). Fixed-size hardware displays implement `IFixedSizeDestination` and receive pre-scaled frames. VPM can switch between 128×32, 192×64, and 256×64 at runtime without reinitializing.

## DmdDevice.dll API

`DmdDevice.dll` is the C plug-in interface originally created for Visual PinMAME. Any C/C++ host application can include the header and call into it. Key entry points:

```c
PM_GameSettings(char* gameName, UINT64 hardwareGeneration, tPMoptions* options);
PM_GameStart();
PM_GameEnd();
Render_2_Shades(int width, int height, UINT8* currbuffer);
Render_4_Shades(int width, int height, UINT8* currbuffer);
Render_RGB24(int width, int height, rgb24* currbuffer);
Render_16_Shades_with_Rs_and_Gs(int width, int height, UINT8* currbuffer, ...);
```

The 64-bit version must be named `DmdDevice64.dll` and placed alongside the 32-bit version.

## Colorization

Frame-by-frame colorization converts grayscale DMD frames to color using pre-made color palettes. Two formats are supported:

- **Serum** (`.cRZ` files) — modern colorization format
- **VNI/PAL/PAC** — originally from PIN2DMD

Colorization works for VPM, Pinball FX(3), and The Pinball Arcade.

## Network Streaming

DMD frames can be sent and received over a WebSocket, allowing a game on one machine to drive a display on another.

**Server** (run where the display is connected):
```
dmdext server -d pindmdv3 --ip=127.0.0.1 --port=80 --path=/dmd
```

**Client** (run where the game is):
```
dmdext mirror -s pinballfx3 -d network --url=ws://127.0.0.1/dmd
```

Or via `DmdDevice.ini`:
```ini
[networkstream]
enabled = true
url = ws://127.0.0.1/dmd
```

## Configuration

Behavior is controlled via `DmdDevice.ini`. Per-game overrides are possible for Pinball FX using the game's numeric ID (see [PinballFX_IDs reference](https://github.com/freezy/dmd-extensions/blob/master/PinMameDevice/PinballFX_IDs.md)).

Example per-game override:
```ini
[135]
pindmd3 enabled = false
virtualdmd enabled = false
alphanumeric enabled = true
```

## See Also

- [DMD](../concepts/DMD.md) — What DMDs are and how virtual pinball uses them
- [FlexDMD](FlexDMD.md) — In-process COM renderer that uses `DmdDevice.dll` for output
- [DMD Extensions Docs](../sources/DMD%20Extensions%20Docs.md)


