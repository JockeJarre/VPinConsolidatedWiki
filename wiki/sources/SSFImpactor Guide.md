# SSFImpactor Guide

Summary of the SSFImpactor user guide PDF at [raw/SSFImpactor Guide.pdf](https://www.mjrnet.org/pinscape/BuildGuideV2/BuildGuide.php?sec=downloads) (15 pages, Rev 1.1, March 23 2019).

## Source Files

| File | Contents |
|------|----------|
| [SSFImpactor Guide.pdf](https://www.mjrnet.org/pinscape/BuildGuideV2/BuildGuide.php?sec=downloads) | Full SSFImpactor user guide: concept, installation, Cabinet.xml tuning, audio routing, DOF integration, port appendix, canonical Cabinet.xml, reference-cabinet wiring |

## Key Facts

- SSFImpactor is a software-based LEDWiz-alike [DOF output controller](../concepts/DOF%20Output%20Controllers.md) that emulates solenoids, shakers, and gear motors via synthesized tactile audio (BASS library), with no output board required
- SSF adds physical impact sensation; it does not replace table sounds, and its signals are for tactile exciters — playing them on speakers "sound terrible and could damage them"
- Ships inside DirectOutput Framework R3++ Grand Unified Edition from the Pinscape resources site; beta features arrive via a group zip (`DirectOutput.dll`, `B2SServerDirectOutputPlugin.dll`, guide, DOF configs)
- `InstantDOF+SSF.zip` gives SSF-only cabinets a full "Instant DOF" setup; verified with `DirectOutputConfigTester` + `GlobalConfig_B2SServer.xml` (Activate All → solenoid clicks, gear run, shaker vibration)
- Tuning lives in `<SSFImpactController>` in Cabinet.xml: `ImpactFactor` (global 0–100%) scales `FlipperLevel`/`BumperLevel`/`SlingsLevel`, while `ShakerImpactFactor` and `GearLevel` are independent of it
- 15 fixed output ports: flippers, slings, six 10-bumpers, knocker, shaker, gear, hellball motor, bell
- Audio device selection via `<DeviceNumber>` from BASS enumeration in `DirectOutput.log`; exciters target speaker pairs (`Front`/`Rear`/`CenterLFE`/`RearCenter`), shakers may target single channels
- Existing DOF users integrate SSFImpactor as a LedWiz-equivalent device: Config Tool port mapping, port count increase, regenerated `directoutput*.*` files; appendix contains a canonical Cabinet.xml with `LedWizEquivalentOutput` mappings 1–15
- Reference cabinet: one 7.1 card, front = game audio, surrounds = SSF to exciters through 2.1 amps with crossovers; appendix wiring adds car-speaker pair, two shakers (Dayton Audio TCS-8 PICK-UP in front), subwoofer
- Repeated safety instruction: turn amps/volume down before testing

## Notable Quotes

- "The SSFImpactor is a software-based LEDWiz-alike DirectOutput Output driver … emulating the physical characteristic somewhat of solenoids, shakers and gear motors and allowing control via DOF." (p. 2)
- "SSF is not a 'sub thump' and the signals, designed for and tested on tactile exciters sound terrible on speakers and could damage them." (p. 9)
- "Once installed and configured, SSFImpactor adds its effect to any table that responds to DOF commands, just like a LEDWiz would." (p. 2)

## Support Channels

- Surround Sound Feedback Facebook group (primary support venue)
- VPinball.com SSF forum

No official source-code repository is referenced by the guide.

## See Also

- [SSFImpactor](../projects/SSFImpactor.md)
- [DOF Documentation](DOF%20Documentation.md)
- [DirectOutput Framework](../projects/DirectOutput%20Framework.md)
