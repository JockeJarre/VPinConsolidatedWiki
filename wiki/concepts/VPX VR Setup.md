# VPX VR Setup

Operational setup for running [Visual Pinball X](../projects/Visual%20Pinball%20X.md) tables in VR: the OpenXR space-reference and positioning model with its `PlayerVR.*` settings, augmented-reality passthrough, enabling per-table VR rooms, the OpenComposite performance mod, disabling Asynchronous Spacewarp, and ROM chores that bite in VR cabinets. For the rendering/stereo theory see [VPX Stereo 3D](VPX%20Stereo%203D.md).

> Sources: Primary — the official VR doc ([raw/VPX/repo/docs/VR.md](https://github.com/vpinball/vpinball/blob/master/docs/VR.md), added upstream 2026-11-06, scoped to VPX 10.8.1 Beta); secondary — community wiki, largely from a Reddit write-up by SuperFromND (site: superfromnd.gitlab.io/vpx/). Discord has VR General/Software/Hardware/Tables channels.

## Platform Support

- ⚠️ CONFLICT (secondary source): "At time of writing, only the Windows version of VPinball supports VR… work is currently underway to port VPinball to the cross-platform OpenXR API"
  ([raw/ExternalWikis/dekay-vpinball-wiki/repo/VR.md](https://github.com/dekay/vpinball-wiki/wiki/VR), opening NOTE) — Primary: [VPX Stereo 3D](VPX%20Stereo%203D.md) lists **VR headsets via OpenXR (BGFX build)** as shipping, and the same community collection's About-Visual-Pinball.md describes BGFX with OpenXR VR cross-platform. Dated snapshot (2025) — keep the primary claim

## Space References (Primary)

VPX renders the virtual world in **4 nested space references** used by table parts and groups (`PartGroupData::SpaceReference`) ([raw/VPX/repo/docs/VR.md](https://github.com/vpinball/vpinball/blob/master/docs/VR.md)):

- **Room** — the real-world room, unscaled; VR room environment models must be modeled at real-world scale
- **Cabinet feet** — the cabinet legs/body, scaled with the cabinet and stretched so the feet always touch the room ground
- **Cabinet** — uniformly scaled so its lockbar matches the target lockbar width, positioned so the lockbar lands at the target lockbar height
- **Playfield** — the simulation space, following the cabinet and applying the playfield slope; **the only space that supports physics** (balls, flippers, … are simulated in table coordinates)

Table files store cabinet-size information (glass height, playfield position inside the cabinet) which must match the cabinet model in the VR scene ([raw/VPX/repo/docs/Changelog.txt](https://github.com/vpinball/vpinball/blob/master/docs/Changelog.txt)).

## Positioning Parameters (Primary)

Transforms are computed from the *headset room positioning* plus the *target lockbar dimensions*; distances in cm, angles in degrees ([raw/VPX/repo/docs/VR.md](https://github.com/vpinball/vpinball/blob/master/docs/VR.md)):

- **Room positioning** (global, auto-saved session calibration): `PlayerVR.RoomYaw`, `PlayerVR.RoomOffsetX/Y/Z` — shift the whole anchored assembly to correct tracking drift, wrong floor height, or chosen standing spot; written back to app settings when a game exits
- **Lockbar dimensions** (global): `PlayerVR.OverrideLockbarWidth` / `PlayerVR.OverrideLockbarHeight` scale/position the cabinet to the custom `Player.LockbarWidth` / `Player.LockbarHeight` measured on your real cabinet; when disabled the table-authored values are used. These also drive the non-VR cabinet layout preview
- **Per-table offsets**: `PlayerVR.TableOffsetY` (playfield-end → lockbar distance), `PlayerVR.TableOffsetZ` (glass height correction) — saved per table, never globally
- **Adjusting while playing**: view move keys (numpad 8/2 up/down plus bindable front/back/left/right) nudge the room offset; **Align VR view** (numpad 5) recenters the room on the current head pose to the standing position defined by `Player.ScreenPlayerX/Y`; **controller recentering** — hold both controllers on the physical lockbar and enable the action, with `PlayerVR.ControllerCabYOffset` / `PlayerVR.ControllerCabZOffset` correcting controller-stand placement
- **Seated play**: `PlayerVR.SeatedTilt` tilts the whole cabinet toward the player (view only, physics unchanged; non-zero disables LockFeetToGround); `PlayerVR.LockFeetToGround` stretches the feet to the floor — disable for e.g. a mini cabinet on a desk

## Augmented Reality (Primary)

With PCVR, VPX supports augmented reality (passthrough) via **colorkeyed rendering**: use a VR streamer that supports colorkeyed passthrough (e.g. **Virtual Desktop**), set the keyed color to full black (all channels 0) with the lowest possible tolerance, enable the augmented-reality mode in VPX's in-game UI, and play tables that do not cover the whole environment with a virtual room ([raw/VPX/repo/docs/VR.md](https://github.com/vpinball/vpinball/blob/master/docs/VR.md) — documented for 10.8.1 Beta)

## Enabling VR Mode per Table

Newer tables (especially **VPinWorkshop**) auto-detect VR. For others ([raw/ExternalWikis/dekay-vpinball-wiki/repo/VR.md](https://github.com/dekay/vpinball-wiki/wiki/VR), §Manually enabling VR mode):

1. Open the `.vpx` in the VPX Editor → **View → Script**
2. Ctrl-F for **`VRRoom`** (VPinWorkshop standard) or `VR` / `VROn`
3. Set the value: **0 = VR off, 1 = VR on**; other numbers select multiple VR rooms

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
- [VPX View Setup](VPX%20View%20Setup.md) — non-VR camera setup
- [VPX Latency](VPX%20Latency.md) — frame pacing concerns shared with VR
- [Pinscape Pico](Pinscape%20Pico.md) — Android-Quest builds see VR tables via Force VR Rendering Mode ([VPX Standalone](VPX%20Standalone.md))
- [Unofficial Visual Pinball Wiki](../sources/Unofficial%20Visual%20Pinball%20Wiki.md) — source collection (secondary)
