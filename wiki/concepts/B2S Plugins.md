# B2S Plugins

Plugins extend the functionality of [B2S Backglass Server](../projects/B2S%20Backglass%20Server.md) by receiving table element updates and performing additional actions — driving hardware, playing media, or controlling external systems.

## B2S Plugin Architecture

B2S Server loads plugins from:
- `Plugins/` — 32-bit plugin shortcuts/DLLs
- `Plugins64/` — 64-bit plugin shortcuts/DLLs

Plugins implement the `IDirectPlugin` and optionally `IDirectPluginFrontend` interfaces. They are activated via:
- B2S Settings → "Active Plugins" checkbox
- Or `<ArePluginsOn>1</ArePluginsOn>` in `B2STableSettings.xml`

## Major Plugins

### DirectOutput Framework (DOF)

The [DirectOutput Framework](../projects/DirectOutput%20Framework.md) receives table element state changes and drives physical [DOF Output Controllers](Output%20Controllers.md) to trigger [toys](Toys%20and%20Effects.md) (contactors, LEDs, motors, shakers).

- **DLL**: `DirectOutput_B2SServer_Plugin.dll`
- **Data flow**: B2S forwards `Controller.B2SSetData(ElementID, Value)` calls from table scripts
- Supports both 32-bit and 64-bit operation

### PinUP Player

Controls and triggers playback of various media types using "PuP Packs" — video, audio, and image content synchronized with gameplay events. Provides [DMD](DMD.md) display, topper screen content, and attract-mode media.

## Enabling Plugins

1. Place plugin DLLs or shortcuts in the appropriate `Plugins/` or `Plugins64/` directory
2. Enable via B2S Settings right-click menu or edit `B2STableSettings.xml`
3. Verify with a table that uses the plugin

For DOF specifically, `VPinMAME.Controller` must be replaced with `B2S.Server` in table scripts to route data through B2S to DOF.

## PinballX Plugin

DOF also provides a separate `DirectOutput PinballX Plugin.dll` for frontend integration. This is loaded via PinballX Plugin Manager (not B2S) and provides named triggers like `$PBXWheel`, `$PBXMenu`, `$RomName` for frontend-driven effects.

## Troubleshooting

- **Plugins not loading**: Verify DLLs are unblocked (right-click → Properties → Unblock)
- **Wrong architecture**: Ensure 64-bit VPX uses `Plugins64/`, 32-bit uses `Plugins/`
- **DOF not receiving data**: Check that table script uses `B2S.Server` instead of `VPinMAME.Controller`

## See Also

- [B2S Backglass Server](../projects/B2S%20Backglass%20Server.md) — Host application for plugins
- [DirectOutput Framework](../projects/DirectOutput%20Framework.md) — The hardware feedback plugin
- [DOF Table Configuration](DOF%20Table%20Configuration.md) — Configuring DOF per table



