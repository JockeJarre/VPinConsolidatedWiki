# VPX VR Setup

Operational setup for running [Visual Pinball X](../projects/Visual%20Pinball%20X.md) tables in VR: enabling per-table VR rooms, the OpenComposite performance mod, disabling Asynchronous Spacewarp, and ROM chores that bite in VR cabinets. For the rendering/stereo theory see [VPX Stereo 3D](VPX%20Stereo%203D.md).

> Source: community wiki (secondary), largely from a Reddit write-up by SuperFromND (site: superfromnd.gitlab.io/vpx/). Discord has VR General/Software/Hardware/Tables channels.

## Platform Support

- ⚠️ CONFLICT (secondary source): "At time of writing, only the Windows version of VPinball supports VR… work is currently underway to port VPinball to the cross-platform OpenXR API"
  ([raw/ExternalWikis/dekay-vpinball-wiki/repo/VR.md](https://github.com/dekay/vpinball-wiki/wiki/VR), opening NOTE) — Primary: [VPX Stereo 3D](VPX%20Stereo%203D.md) lists **VR headsets via OpenXR (BGFX build)** as shipping, and the same community collection's About-Visual-Pinball.md describes BGFX with OpenXR VR cross-platform. Dated snapshot (2025) — keep the primary claim

## Enabling VR Mode per Table

Newer tables (especially **VPinWorkshop**) auto-detect VR. For others ([raw/ExternalWikis/dekay-vpinball-wiki/repo/VR.md](https://github.com/dekay/vpinball-wiki/wiki/VR), §Manually enabling VR mode):

1. Open the `.vpx` in the VPX Editor → **View → Script**
2. Ctrl-F for **`VRRoom`** (VPinWorkshop standard) or `VR` / `VROn`
3. Set the value: **0 = VR off, 1 = VR on**; other numbers select multiple VR rooms

The authoring-side convention is `VRRoom = 0` (desktop/cabinet, no room loaded), `1` (standard VR room), `2` (VR room with backglass positioning) ([raw/ExternalWikis/vpw-wiki/repo/docs/guides/vr-development.md](https://vpw-wiki.skirmishofwit.com/guides/vr-development/), 2026 extraction). This is also a stutter-isolation diagnostic: VR-room primitives loaded in desktop mode (`VRRoom = 1`) cost 20–40 FPS even when the room is not visible, so if a "desktop" table stutters, check the `VRRoom` value first.

Tables with no VR support still run as "a floating playfield in a black void without a backglass or DMD."

## Oculus / Quest Performance: OpenComposite

Stock Quest Link requires **both** Quest Link and SteamVR running — a performance hit. The fix (GitLab **znixian/OpenOVR**):

1. Per-Game Installation → download the 64-bit DLL (usually the right one)
2. Rename `openvr_api64.dll` in the VPX folder (e.g. `openvr_api64_steamvr.dll`)
3. Drop in the downloaded DLL
4. In **Preferences → VR Settings**, VR Mode must **NOT be "VR autodetect"** — with OpenComposite installed, autodetect crashes VPX on table start

## Asynchronous Spacewarp ("Why did my FPS cut in half!?")

ASW (Oculus) / Motion Smoothing (SteamVR) renders half the frames and fakes the rest — very visible in pinball because the eyes track the fast silver ball ([raw/ExternalWikis/dekay-vpinball-wiki/repo/VR.md](https://github.com/dekay/vpinball-wiki/wiki/VR)

- **Oculus**: open Oculus Debug Tool (`C:\Program Files\Oculus\Support\oculus-diagnostics\`) → Service → **(PC) Asynchronous Spacewarp → Disabled**
- **SteamVR**: Video Settings → uncheck **Motion Smoothing**
- Recommended to disable both unless deliberately using the frame-rate features

## VR Cabinet ROM Chores

- **PinMAME splash screen**: every ROM start shows a click-to-close splash. Disable via VPinMAME **Setup.exe / Setup64.exe → Setup Defaults… → enable Cabinet Mode → OK → exit**
- **Bally (mpu38) / Gottlieb-Premier (mpu37) NVRAM**: many later ROMs "will not accept coins or even really function without initialized NVRAM". Service-menu init is slow; a pre-initialized pack exists (VPForums download #1362, `bally_6803_gts3_nvram.zip`) — drop the `.nv` files into VPinMAME's **nvram** folder

## See Also

- [VPX Stereo 3D](VPX%20Stereo%203D.md) — stereo rendering and output modes
- [VPX VR Authoring](VPX%20VR%20Authoring.md) — building VR rooms in tables (VRAM budgets, lighting, refraction)
- [VPX View Setup](VPX%20View%20Setup.md) — non-VR camera setup
- [VPX Latency](VPX%20Latency.md) — frame pacing concerns shared with VR
- [Pinscape Pico](Pinscape%20Pico.md) — Android-Quest builds see VR tables via Force VR Rendering Mode ([VPX Standalone](VPX%20Standalone.md))
- [Unofficial Visual Pinball Wiki](../sources/Unofficial%20Visual%20Pinball%20Wiki.md) — source collection (secondary)
