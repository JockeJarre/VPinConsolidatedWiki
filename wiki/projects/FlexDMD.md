# FlexDMD

FlexDMD is an in-process COM DMD renderer for Visual Pinball X and pinball front-ends. It is a drop-in replacement for UltraDMD and adds a flexible scene-based scripting API, embedded playfield DMD support, and active maintenance.

## Overview

FlexDMD is registered as a COM server (`FlexDMD.FlexDMD`) and loaded in-process from VBScript table scripts. It renders dot-matrix content via [DMD Extensions](DMD%20Extensions.md) (`DmdDevice.dll` / `DmdDevice64.dll`), which handle output to virtual DMDs, real hardware DMDs, and network targets.

![FlexDMD Architecture — where FlexDMD sits in the Visual Pinball ecosystem](https://raw.githubusercontent.com/vbousquet/flexdmd/master/docs/media/architecture.svg)

Key files installed:

| File | Purpose |
|------|---------|
| `FlexDMD.dll` | Core renderer, registered as `FlexDMD.FlexDMD` |
| `FlexUDMD.dll` | UltraDMD-compatible bridge, registered as `UltraDMD.DMDObject` |
| `FlexDMDUI.exe` | Installer, test tool, and configuration UI |
| `DmdDevice.dll` / `DmdDevice64.dll` | Freezy DMD output (not included, from separate release) |

## Installation

1. Download the latest release from [GitHub Releases](https://github.com/vbousquet/flexdmd/releases).
2. Place `FlexDMD.dll`, `FlexUDMD.dll`, `FlexDMDUI.exe`, and Freezy's `DmdDevice.dll`/`DmdDevice64.dll` in the same folder (e.g., `C:\Visual Pinball\VPinMAME`).
3. Run `FlexDMDUI.exe`, register `FlexDMD.dll` on the Installer tab.
4. Optionally register `FlexUDMD.dll` to replace UltraDMD system-wide.

## Render Modes

| Value | Mode |
|-------|------|
| `0` | Monochrome, 4 shades |
| `1` | Monochrome, 16 shades |
| `2` | Full color |

Set via `FlexDMD.RenderMode = 2` before calling `Run = True`.

## API

FlexDMD uses a scene-graph model inspired by LibGDX Scene2D:

- **Stage** (`IGroupActor`) — the root DMD canvas
- **Actors** — `IImageActor`, `IVideoActor`, `ILabelActor`, `IFrameActor`, `IGroupActor`
- **Actions** — animations attached via `actor.AddAction(...)` using `actor.ActionFactory`

All rendering runs on a separate thread. Wrap scene modifications with:

```vbscript
FlexDMD.LockRenderThread
' ... modify actors ...
FlexDMD.UnlockRenderThread
```

### Minimal setup

```vbscript
Dim FlexDMD
Set FlexDMD = CreateObject("FlexDMD.FlexDMD")
FlexDMD.GameName = cGameName
FlexDMD.Width = 128
FlexDMD.Height = 32
FlexDMD.RenderMode = 2
FlexDMD.Run = True
```

## UltraDMD Compatibility

FlexDMD ships `FlexUDMD.dll` which registers itself as `UltraDMD.DMDObject`. When registered, all existing UltraDMD tables work without any script changes.

To convert a table manually and gain FlexDMD features, replace:

```vbscript
Set UltraDMD = CreateObject("UltraDMD.DMDObject")
```

with:

```vbscript
Dim FlexDMD
Set FlexDMD = CreateObject("FlexDMD.FlexDMD")
FlexDMD.GameName = cGameName
FlexDMD.RenderMode = 2
Set UltraDMD = FlexDMD.NewUltraDMD()
UltraDMD.Init
```

## Embedded DMD Inside VPX

FlexDMD can render the DMD directly onto the VPX playfield (useful for FSS/desktop layouts). This avoids requiring a separate DMD window.

Steps:
1. Add a **Flasher** object with *Use Script DMD* checked.
2. Add a **Timer** named `FlexDMDTimer`, enabled, interval `-1`.
3. Set `UseDMD = true` (monochrome) or `UseColoredDMD = true` (color) in the script.
4. Add a timer sub to feed pixels back to VPX:

```vbscript
Sub FlexDMDTimer_Timer
    Dim DMDp
    If UseColoredDMD Then
        DMDp = FlexDMD.DmdColoredPixels
        If Not IsEmpty(DMDp) Then
            DMDWidth = FlexDMD.Width
            DMDHeight = FlexDMD.Height
            DMDColoredPixels = DMDp
        End If
    End If
End Sub
```

## Script Detection and Portability

FlexDMD is a Windows COM server, so it is **unavailable on [VPX Standalone](../concepts/VPX%20Standalone.md)**. Tables that must run on both platforms detect it in script instead of assuming it exists ([raw/vpw-wiki/docs/guides/vbscript-patterns.md](https://vpw-wiki.skirmishofwit.com/guides/vbscript-patterns/), 2026 extraction):

```vbscript
Dim FlexDMD
On Error Resume Next
Set FlexDMD = CreateObject("FlexDMD.FlexDMD")
On Error GoTo 0
If Not IsEmpty(FlexDMD) Then
    ' FlexDMD available (Windows) — set up scenes
End If
```

With `On Error Resume Next` guarding the `CreateObject`, the table degrades gracefully on Standalone/mobile builds.

## See Also

- [DMD](../concepts/DMD.md)
- [DMD Extensions](DMD%20Extensions.md) — provides DmdDevice.dll used by FlexDMD for output
- [VPX Scripting](../concepts/VPX%20Scripting.md)
- [Visual Pinball X](Visual%20Pinball%20X.md)
- [FlexDMD Docs](../sources/FlexDMD%20Docs.md)


