# DOF Documentation (Source Summary)

Summary of 25 markdown files in the local DirectOutput Framework documentation snapshot at [raw/DOF/repo/Documentation](../../raw/DOF/repo/Documentation/). Run `update-raw.ps1` to refresh it before re-ingesting.

## Canonical Upstream

- [DirectOutput Framework Documentation](https://github.com/DirectOutput/DirectOutput/tree/master/Documentation)

## Source Files

Current snapshot file count: 26 markdown files.

| File | Topic |
|------|-------|
| [README.md](../../raw/DOF/repo/README.md) | DirectOutput Framework overview and installation |
| [99_MainpageAndAbout.md](../../raw/DOF/repo/Documentation/99_MainpageAndAbout.md) | Overview and about |
| [10_Installation and configuration.md](../../raw/DOF/repo/Documentation/10_Installation%20and%20configuration.md) | Installation guide |
| [15_Table configuration.md](../../raw/DOF/repo/Documentation/15_Table%20configuration.md) | Table config workflow |
| [16_Pinballx.md](../../raw/DOF/repo/Documentation/16_Pinballx.md) | PinballX plugin |
| [17_Supported Hardware.md](../../raw/DOF/repo/Documentation/17_Supported%20Hardware.md) | Hardware catalog |
| [20_GlobalConfig.md](../../raw/DOF/repo/Documentation/20_GlobalConfig.md) | Global configuration |
| [25_CabinetConfig.md](../../raw/DOF/repo/Documentation/25_CabinetConfig.md) | Cabinet configuration |
| [27_TableConfig.md](../../raw/DOF/repo/Documentation/27_TableConfig.md) | XML table configuration |
| [29_ConfigExamples.md](../../raw/DOF/repo/Documentation/29_ConfigExamples.md) | Configuration examples |
| [30_IniFiles.md](../../raw/DOF/repo/Documentation/30_IniFiles.md) | Legacy INI format |
| [40_Troubleshooting.md](../../raw/DOF/repo/Documentation/40_Troubleshooting.md) | Troubleshooting |
| [50_Architecture.md](../../raw/DOF/repo/Documentation/50_Architecture.md) | Software architecture |
| [55_B2SServerPlugin.md](../../raw/DOF/repo/Documentation/55_B2SServerPlugin.md) | B2S plugin details |
| [60_FX.md](../../raw/DOF/repo/Documentation/60_FX.md) | Effects overview |
| [61_FX_BuiltIn.md](../../raw/DOF/repo/Documentation/61_FX_BuiltIn.md) | Built-in effects |
| [63_Toys.md](../../raw/DOF/repo/Documentation/63_Toys.md) | Toys overview |
| [64_Toys_BuiltIn.md](../../raw/DOF/repo/Documentation/64_Toys_BuiltIn.md) | Built-in toys |
| [65_Output Controllers.md](../../raw/DOF/repo/Documentation/65_Output%20Controllers.md) | Output controller overview |
| [66_OutputControllers_BuiltIn.md](../../raw/DOF/repo/Documentation/66_OutputControllers_BuiltIn.md) | Built-in controllers |
| [77_Source Code.md](../../raw/DOF/repo/Documentation/77_Source%20Code.md) | Source code info |
| [79_Support.md](../../raw/DOF/repo/Documentation/79_Support.md) | Support resources |
| [80_Contribute.md](../../raw/DOF/repo/Documentation/80_Contribute.md) | Contributing |
| [85_Downloads.md](../../raw/DOF/repo/Documentation/85_Downloads.md) | Download links |
| [87_DOFHistory.md](../../raw/DOF/repo/Documentation/87_DOFHistory.md) | Version history |
| [90_Credits.md](../../raw/DOF/repo/Documentation/90_Credits.md) | Credits |

## Key Takeaways

- DOF is a C# framework with multithreaded architecture for non-blocking hardware communication
- Three-layer model: Table (events) → Cabinet (toys on controllers) → Effects (behaviors)
- Supports 12+ output controller types from simple USB relays to Ethernet DMX
- Effect chaining enables complex behaviors (delay → blink → fade)
- Legacy INI config coexists with modern XML config
- Operates as B2S Server plugin — all data flows through B2S
- Separate PinballX plugin for frontend-driven effects

## Wiki Pages Generated

- [DirectOutput Framework](../projects/DirectOutput%20Framework.md) — Project page
- [DOF Output Controllers](../concepts/DOF%20Output%20Controllers.md) — Concept page
- [DOF Toys and Effects](../concepts/DOF%20Toys%20and%20Effects.md) — Concept page
- [DOF Table Configuration](../concepts/DOF%20Table%20Configuration.md) — Concept page


