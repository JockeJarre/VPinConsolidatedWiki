# Pinscape Build Guide

This source collection is a large build guide about planning, building, wiring, and configuring a virtual pinball cabinet, with special emphasis on the Pinscape controller platform. The current local snapshot contains 133 converted Markdown files under `[raw/pinscape-build-guide/markdown/`.](https://github.com/concurrent-recursion/pinscape-build-guide/blob/main/book/%60.)

## Canonical Upstream

- [pinscape-build-guide book](https://github.com/concurrent-recursion/pinscape-build-guide/tree/main/book)

## Source Scope

The main entry point is [main.md](https://github.com/concurrent-recursion/pinscape-build-guide/blob/main/book/main.adoc), which assembles the full guide and identifies five major parts:

1. Preliminaries
2. Planning and Building the Cabinet
3. Feedback Devices
4. A Crash Course in Electronics
5. The Pinscape Controller

## Key Entry Points

| File | Contents |
|------|----------|
| [main.md](https://github.com/concurrent-recursion/pinscape-build-guide/blob/main/book/main.adoc) | Guide structure, metadata, and chapter include map |
| [whatIs.md](https://github.com/concurrent-recursion/pinscape-build-guide/blob/main/book/whatIs.adoc) | High-level definition of a virtual pincab and why physical controls matter |
| [ioControllers.md](https://github.com/concurrent-recursion/pinscape-build-guide/blob/main/book/ioControllers.adoc) | Comparison of cabinet input/output controller options |
| [plunger.md](https://github.com/concurrent-recursion/pinscape-build-guide/blob/main/book/plunger.adoc) | Plunger tradeoffs, device options, and setup considerations |
| [nudge.md](https://github.com/concurrent-recursion/pinscape-build-guide/blob/main/book/nudge.adoc) | KL25Z accelerometer mounting, tuning, and VP integration |
| [pscOverview.md](https://github.com/concurrent-recursion/pinscape-build-guide/blob/main/book/pscOverview.adoc) | Pinscape controller hardware variants and build paths |
| [psOutputsStandalone.md](https://github.com/concurrent-recursion/pinscape-build-guide/blob/main/book/psOutputsStandalone.adoc) | Standalone KL25Z output wiring approach |
| [psOutputsExp.md](https://github.com/concurrent-recursion/pinscape-build-guide/blob/main/book/psOutputsExp.adoc) | Expansion-board output system |

## Key Facts

- Revision metadata in [main.md](https://github.com/concurrent-recursion/pinscape-build-guide/blob/main/book/main.adoc): version 2.1.0, dated October 31, 2023
- Frames a pincab as a full hardware-and-software system, not just a VPX installation
- Covers cabinet woodworking, monitor mounting, wiring, power, audio, feedback devices, and Windows/software setup
- Treats Pinscape as a multifunction cabinet controller spanning buttons, nudging, plunger input, and feedback outputs
- Includes detailed practical guidance on controller tradeoffs, such as LedWiz, SainSmart relays, VirtuaPin, and Zeb's Boards alternatives

## Related Wiki Pages

- [Pinscape Controller](../projects/Pinscape%20Controller.md) — Project page synthesized from the controller chapters
- [Pincab Setup](../concepts/Pincab%20Setup.md) — Cabinet-level planning and installation context
- [VPX Plunger Input](../concepts/VPX%20Plunger%20Input.md) — Plunger device behavior and VPX setup
- [VPX Accelerometer Input](../concepts/VPX%20Accelerometer%20Input.md) — Nudge sensor setup and axis behavior
- [DOF Output Controllers](../concepts/DOF%20Output%20Controllers.md) — Output controller options compared in the guide

## See Also

- [Pinscape Controller](../projects/Pinscape%20Controller.md)
- [Pincab Setup](../concepts/Pincab%20Setup.md)
- [DirectOutput Framework](../projects/DirectOutput%20Framework.md)
- [Visual Pinball X](../projects/Visual%20Pinball%20X.md)