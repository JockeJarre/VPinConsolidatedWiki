# DMD Extensions Docs

Summary of 6 DMD Extensions documentation files from the local snapshot in [raw/DMD-Extensions/repo](https://github.com/freezy/dmd-extensions). Run `update-raw.ps1` to refresh it before re-ingesting.

## Canonical Upstream

- [DMD Extensions](https://github.com/freezy/dmd-extensions)

## Source Files

| File | Contents |
|------|----------|
| [README.md](https://github.com/freezy/dmd-extensions/blob/master/README.md) | Overview, supported games/displays, features, install, configuration |
| [LibDmd/README.md](https://github.com/freezy/dmd-extensions/blob/master/LibDmd/README.md) | RenderGraph architecture, frame formats, routing, colorization |
| [PinMameDevice/README.md](https://github.com/freezy/dmd-extensions/blob/master/PinMameDevice/README.md) | `DmdDevice.dll` C API header and history |
| [PinMameDevice/PinballFX_IDs.md](https://github.com/freezy/dmd-extensions/blob/master/PinMameDevice/PinballFX_IDs.md) | Numeric game IDs for per-game `DmdDevice.ini` overrides in Pinball FX |
| [Console/Server/README.md](https://github.com/freezy/dmd-extensions/blob/master/Console/Server/README.md) | Network streaming via WebSocket (server + client modes) |
| [ProPinballBridge/README.md](https://github.com/freezy/dmd-extensions/blob/master/ProPinballBridge/README.md) | Boost message-queue IPC bridge for Pro Pinball Timeshock |

## Key Facts

- Ships as `DmdDevice.dll` (32-bit) and `DmdDevice64.dll` (64-bit); the standard DMD output library used by VPM and FlexDMD
- Core library (`LibDmd`) routes frames via a typed `RenderGraph`: source → optional converter → one or more destinations
- Six frame formats: 2-bit gray, 4-bit gray, 2-bit colored, 4-bit colored, RGB24, Bitmap
- Supports all common real DMD hardware: PinDMD v1/v2/v3, PIN2DMD, Pixelcade, ZeDMD
- Virtual DMD output with pixel-shader dot rendering for monitor setups
- Frame colorization via Serum (`.cRZ`) or VNI/PAL/PAC formats
- Network streaming over WebSocket (dmdext `server` and `network` destination modes)
- Per-game configuration in `DmdDevice.ini`; Pinball FX supports numeric game ID sections

## See Also

- [DMD Extensions](../projects/DMD%20Extensions.md)
- [DMD](../concepts/DMD.md)
- [FlexDMD Docs](FlexDMD%20Docs.md)


