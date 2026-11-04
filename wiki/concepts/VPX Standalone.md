# VPX Standalone

VPX Standalone is the cross-platform build of [Visual Pinball X](../projects/Visual%20Pinball%20X.md) for Linux, macOS, iOS, Android, Meta Quest, and Raspberry Pi. "Standalone" denotes the build **without the table editor and preferences GUI** that the Windows version has; it has been shipped in official releases since VPX 10.8, with per-commit beta builds via GitHub Actions.

> Source: community wiki (secondary). Platform scope wording conflicts with the primary project page — see the note under §Terminology.

## Terminology and Platforms

- Supported platforms: **Linux x64, macOS (ARM + x64), iOS, Android (ARM + legacy ARM), Raspberry Pi 64-bit** ([raw/ExternalWikis/dekay-vpinball-wiki/repo/Running-On-Other-OSs.md](https://github.com/dekay/vpinball-wiki/wiki/Running-On-Other-OSs)
- Since 10.8.1, most Standalone development happens on the main `master` branch; `#ifdef __STANDALONE__` wrappers remain required
- Android/Meta Quest builds are **beta-only via GitHub Actions** (login required), numbered by revision (e.g. Rev.4711) outside the release model; not every Actions build works — the OpenGLES backend broke for ~2 weeks between Rev.4315 and Rev.4385 ([raw/ExternalWikis/dekay-vpinball-wiki/repo/Android.md](https://github.com/dekay/vpinball-wiki/wiki/Android)
- iOS ships on the **App Store** ("Visual Pinball", app id 6547859926); iPhone-only target, iPad planned
- ⚠️ CONFLICT (secondary source): "VPX is supported only on Windows, while VPX Standalone runs on other operating systems"
  ([raw/ExternalWikis/dekay-vpinball-wiki/repo/Home.md](https://github.com/dekay/vpinball-wiki/wiki) — Primary: [Visual Pinball X](../projects/Visual%20Pinball%20X.md) describes VPX itself as cross-platform via BGFX. Reconciliation: BGFX builds run on all platforms, but the **full editor/preferences GUI is the Windows build**; the other-OS builds are the feature-reduced Standalone derivative

## Architecture

The port embeds "only *just enough* of Wine's source" — it is not running under Wine ([raw/ExternalWikis/dekay-vpinball-wiki/repo/Running-On-Other-OSs.md](https://github.com/dekay/vpinball-wiki/wiki/Running-On-Other-OSs), §How Visual Pinball Standalone Works):

| Windows dependency | Standalone replacement |
|--------------------|------------------------|
| `.vpx` structured storage (COM/IStorage) | **POLE** library + PoleStorage/PoleStream wrappers |
| Registry settings | `ENABLE_INI` + RapidXML settings file (Windows uses ini as of 10.8) — see [VPX File Layout](VPX%20File%20Layout.md) |
| VBScript engine | **Wine vbscript** engine; scrrun adds FileSystemObject/Dictionary; Execute/ExecuteGlobal/Eval/GetRef implemented |
| COM/ATL | Wine + ReactOS atl stubs; typelibs replaced by idlparser-generated classes |
| DirectSound + BASS | `ONLY_USE_BASS` → **SDL3 Audio + SDL Mixer** (PR #2213), bringing SSF to non-Windows |
| PinMAME | libpinmame embedded |
| OpenGL 4.6 / OpenGLES 3.0 | **BGFX** (VPX 10.8): DirectX on Windows, Vulkan on Linux, Metal on macOS/iOS |
| Input | SDL with a `SDLK_TO_DIK` translation table |

Script-compatibility bugs are tracked in `standalone/docs/vbscript.md`; the **jsm174/vpx-standalone-scripts** patch repo fixes most remaining tables ("very few non-PUP tables won't run on Standalone, out of the box or with a patch").

Two script portability rules from the authoring community ([raw/ExternalWikis/vpw-wiki/repo/docs/guides/vbscript-patterns.md](https://vpw-wiki.skirmishofwit.com/guides/vbscript-patterns/), 2026 extraction):

- Use **`GetBalls` (not `gBOT`) inside the `Cor.Update`/CorTracker callback** — `gBOT` is the stated root cause of ~95% of "ball hits flipper → segfault" crashes on Standalone; see [VPX Example Table](VPX%20Example%20Table.md)
- Guard COM-only objects like [FlexDMD](../projects/FlexDMD.md) with `On Error Resume Next` + `CreateObject` checks — COM is unavailable on Standalone, so unguarded `CreateObject` calls crash the table there; see [FlexDMD §Script Detection and Portability](../projects/FlexDMD.md#script-detection-and-portability)

## Input Mapping

- **Gamepads**: Standalone uses the **SDL Game Controller** layer — add an entry to `gamecontrollerdb.txt` (community SDL_GameControllerDB), then set INI keys. **Button indexes in VPinballX.ini are 1-based.** Xbox example: JoyLFlipKey=10, JoyRFlipKey=11, JoyLMagnaSave=8, JoyRMagnaSave=9, JoyCTiltKey=12, JoyPlungerKey=13, JoyAddCreditKey=1, JoyStartGameKey=2
- **Keyboard INI values are decimal DirectInput `DIK_` codes** (Wine dinput.h): ESCAPE=1, digits 1–0 = 2–11, RETURN=28, SPACE=57, Z=44, LSHIFT=42, F1=59…F12=88, END=207, NUMPADENTER=156
- Mobile in-app remap: tap top-right → Table Options → Input Settings → select row, press controller button; hardware-sensor plunger under Plunger Settings → Hardware Sensor Settings ([raw/ExternalWikis/dekay-vpinball-wiki/repo/map-external-Gamecontroller.md](https://github.com/dekay/vpinball-wiki/wiki/map-external-Gamecontroller)
- VPX merges all joystick inputs — route each sensor to only one emulated device (mjr, quoted in the PINPAD page)

## Mobile Specifics

- **`.vpxz` packaging** (table + zipped ROM + sidecar scripts in one zip) with the **built-in web server** for file transfer — see [VPX File Layout](VPX%20File%20Layout.md)
- Touch controls: coin, menu, magna-save, nudge, flippers, start, plunger (long-press); keyboard map: 5=Coin, End=coin door, Return=plunger; gamepad: shoulders=flippers, sticks=magna
- Settings of note: **Graphics backend** (Vulkan/OpenGLES), **Max Texture Dimensions** (lower on low-RAM devices — out-of-memory protection), Force VR Rendering Mode, display modes (FullSingleScreen/Cabinet/Desktop)
- Android storage: tables on **internal memory** — external copies import at start and delete on exit (minutes per VPXZ). App data creep is real: fresh install ≈200 MB, >10 GB after cycling 100+ tables; a delete+reinstall is recommended after major updates (missing ini keys can crash)
- ROM audio UI: the PinMAME `~` channel-volume and Tab dip-switch keys are **not supported in Standalone**; on Linux, run the `xpinmame-linux-x64` GitHub Actions artifact (`XLIB_SKIP_ARGB_VISUALS=1 ./xpinmame -rompath … -dsp-plugin oss <rom>`; OSS audio via `osspd`/`padsp`), edit with `~`/Tab, then copy the produced `.cfg` files into the table's `pinmame/cfg/` ([raw/ExternalWikis/dekay-vpinball-wiki/repo/Linux.md](https://github.com/dekay/vpinball-wiki/wiki/Linux)
- **iOS renders one window at a time** (SDL limitation): B2S backglass and PuP overlays unsupported; Linux/macOS multi-window works via window managers (see [Screen Configuration](Screen%20Configuration.md), [VPinFE](../projects/VPinFE.md))
- External DMD: **ZeDMD / ZeDMD-WiFi / Pixelcade**, via DMDServer (libdmdutil; easiest as ZeDMDOS on a Raspberry Pi) or direct WiFi on Android
- Haptics (iOS/Android), iOS 18 Game Mode, Serum [Altcolor](Altcolor.md), AltSound supported on iOS

## Batocera

Batocera 42 (beta channel **BUTTERFLY** for current builds) packages VPinball as a system: multi-screen assignment in System Settings, per-table `pinmame/roms|nvram|ini|cfg|altcolor|altsound` folders over SMB, and `batocera.conf` keys translated to `VPinballX.ini` by configgen. Known traps ([raw/ExternalWikis/dekay-vpinball-wiki/repo/Batocera.md](https://github.com/dekay/vpinball-wiki/wiki/Batocera)

- Settings reset every reboot unless `vpinball.vpinball_customphysicalsetup=1` exists in batocera.conf (configgen bug)
- Gamepad: `GamepadOverride = 0`; joystick numbers from `sdl2-jstest -t 0` **plus one**; neutralize Batocera's evmap with a gameStart script writing `{}` to the `vpinball.keys` files
- `jsm174/batocera-vpx-upgrade.sh` fetches the latest master build (GitHub PAT with `repo` scope; default backend BGFX); on trouble, delete `VPinballX.ini` to regenerate

## Desktop / Linux Windowing

Pure Wayland forbids the multi-screen placement a pincab needs; **KDE KWin is recommended** (window rules, layers, cursor/taskbar hiding, "Focus under mouse" — VPX pauses the table until the Playfield window has focus). Concrete rule coordinates and window-title strings for a 2-screen cab, plus Sway/Hyprland setups, are documented on the community Linux page ([raw/ExternalWikis/dekay-vpinball-wiki/repo/Linux.md](https://github.com/dekay/vpinball-wiki/wiki/Linux) **Do not rotate the playfield display** on Linux — VPinFE assumes unrotated output; Cabinet Mode rotates the table.

## Community Tools

- **vpxtool** (francisdb) — inspect `.vpx`, list ROM requirements, extract/patch scripts, format conversion; `optimize` compacts `.vpx` size (`--mono --flac`, `--max-image-size=768` — see [VPX Debugging](VPX%20Debugging.md) §Table-Level Repair)
- **vpx-gui-tools** (surtarso) — Linux GUI launcher/ini editor; **vpx-settings-editor** (herrMirto) — Windows-like settings GUI
- **dmd-config** (Le-Syl21) — FullDMD analysis → DMD placement configs
- **docker-vpxtool-resize** (jsm174) — batch image downscaling inside `.vpx`
- **vpxbct** (jsm174) — backglass/playfield capture on Batocera
- **vpx-standalone-scripts** (jsm174) — per-table/`.vbs`/`.ini` patch collection

Help channels: Virtual Pinball Discord `#vpx-standalone` / `#vpx-standalone-mobile`; iOS support via email/Discord, **not GitHub issues**.

## See Also

- [Visual Pinball X](../projects/Visual%20Pinball%20X.md) — the Windows original and build flavors
- [VPX File Layout](VPX%20File%20Layout.md) — per-OS paths, `.vpxz`/`.vpz` formats
- [VPinFE](../projects/VPinFE.md) — the frontend used with Standalone cab setups
- [Altcolor](Altcolor.md) — Serum-only colorization on mobile
- [PuP Packs](PuP%20Packs.md) — PuP status on Standalone
- [Pinscape Pico](Pinscape%20Pico.md) — matching controller platform
- [Unofficial Visual Pinball Wiki](../sources/Unofficial%20Visual%20Pinball%20Wiki.md) — source collection (secondary)
