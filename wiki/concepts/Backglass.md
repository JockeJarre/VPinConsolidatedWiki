# Backglass

A backglass is the decorative panel behind a physical pinball machine containing artwork and illuminated areas (lamps) that light up during gameplay. In virtual pinball, [B2S Backglass Server](../projects/B2S%20Backglass%20Server.md) renders digital backglasses on a secondary monitor.

## Physical Backglasses

On real pinball machines, the backglass is a translucent panel with painted artwork. Behind it sit colored lamps that illuminate specific areas during gameplay — player indicators, score displays, decorative scenes. The bottom portion (the "grill") typically contains speakers.

## Digital Backglasses (.directb2s Files)

In the virtual pinball ecosystem, backglasses are defined by `.directb2s` files — XML documents containing:

- **Full backglass artwork** (base image)
- **Lamp definitions** with positions and triggering conditions
- **Animations** for dynamic visual effects
- **[DMD](DMD.md) placement** information
- **Translating discs** — visual elements simulating player number or game state indicators
- **Grill** definition — the bottom portion, which can be hidden or replaced with a background image

These files are created with **B2S Backglass Designer**, a WYSIWYG editor.

## How It Works

1. A [VPX](../projects/Visual%20Pinball%20X.md) table launches and calls B2S Server via Windows COM
2. B2S Server loads the matching `.directb2s` file
3. Lamp data from VPinMAME ROMs or direct [VBScript](VPX%20Scripting.md) commands triggers visual updates
4. The backglass window renders on the secondary monitor per [Screen Configuration](Screen%20Configuration.md)

## Matching Rules

Since v2.0.2, B2S Server uses **exact filename matching** by default. The `.directb2s` file must have the same name as the `.vpx` file (e.g., `Medieval Madness.vpx` → `Medieval Madness.directb2s`). This can be toggled off in Settings.

## Randomizing Backglasses

B2SRandom allows picking from multiple variants per session. Name variants as `table-1.directb2s` through `table-9.directb2s` and call `B2SRandom.cmd` from your frontend launch script.

## Display Modes

Many backglasses support two modes:
- **Authentic** — Matches the original machine artwork
- **Fantasy** — Alternative artistic interpretation

Switchable via right-click Settings on the backglass window.

## See Also

- [B2S Backglass Server](../projects/B2S%20Backglass%20Server.md) — The server that renders backglasses
- [DMD](DMD.md) — Digital Message Display shown within or alongside the backglass
- [Screen Configuration](Screen%20Configuration.md) — How backglass position and size are configured
- [Pincab Setup](Pincab%20Setup.md) — Physical cabinet with dedicated backglass monitor


