# DMD Extensions Docs

Summary of 6 DMD Extensions documentation files from the local snapshot in [raw/DMD-Extensions/repo](https://github.com/freezy/dmd-extensions) (refreshed 2026-11-04). Run `update-raw.ps1` to refresh it before re-ingesting.

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

## Late-2026 Changes (re-ingested 2026-11-04)

- **Bundled libserum updated to v2.8.2** (Nov 2026): the embedded x64/x86 `serum.dll` binaries replace 2.6.0 and the NuGet native package default moves 2.5.2 → 2.8.2; frame struct and return flags unchanged, 2.8.2 only adds functions ([commit 9387c66](https://github.com/freezy/dmd-extensions/commit/9387c66046a1390cd81170c4defe3710f59ec8cd)); the README's libserum troubleshooting section (manual DLL drop-in alongside `DmdDevice.dll`) is unchanged ([raw/DMD-Extensions/repo/README.md](https://github.com/freezy/dmd-extensions/blob/master/README.md))
- **`PinMameDevice/DmdDevice.ini` and the Pinball FX numeric game-ID list refreshed** (Jun 2026), alongside flipper-strength-related solenoid behavior changes on the VPM side ([raw/DMD-Extensions/repo/PinMameDevice/PinballFX_IDs.md](https://github.com/freezy/dmd-extensions/blob/master/PinMameDevice/PinballFX_IDs.md))
- Heavy upstream engineering activity (cross-platform `LibDmd.Core` work, FSQ animation-format decoding, macOS/Linux native packaging) lives mostly **outside the fetched documentation folders** — no documented feature changes to file beyond the above; monitor upstream before citing these as features

## See Also

- [DMD Extensions](../projects/DMD%20Extensions.md)
- [DMD](../concepts/DMD.md)
- [FlexDMD Docs](FlexDMD%20Docs.md)


