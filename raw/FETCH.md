# FETCH — raw/ overview

`raw/` holds read-only snapshots of upstream documentation — mainly the **official docs of each tool's vendor/author**. The two folders under `ExternalWikis/` are **external community wikis used to fill gaps** the official docs leave (Secondary priority; official sources win on conflicts). **It is local staging and is never committed.** Each collection folder contains a `FETCH.md` with its exact initial-clone/wget recipe. Most collections are refreshed in one shot by the repo-root scripts — `update-raw.ps1` (Windows) or `update-raw.sh` (Linux, `--pup` to enable the PinUp crawl):

```powershell
.\update-raw.ps1    # Windows; git 2.25+; first run clones, later runs pull
```

```bash
./update-raw.sh     # Linux; git 2.25+, python3, curl; add --pup to refresh the PinUp mirror
```

| Folder | Upstream | Method | Fraction fetched | In update-raw scripts |
|--------|----------|--------|------------------|-----------------------|
| `B2S/` | `vpinball/b2s-backglass.wiki.git` | full clone (small wiki repo) | all 31 pages | ✅ |
| `DOF/` | `DirectOutput/DirectOutput` | sparse `Documentation` | ~102/many files | ✅ |
| `FlexDMD/` | `vbousquet/flexdmd` | sparse `docs` | docs only | ✅ |
| `VPX/` | `vpinball/vpinball` | sparse `docs` | docs only (repo is huge) | ✅ |
| `DMD-Extensions/` | `freezy/dmd-extensions` | sparse, non-cone (README + 4 dirs) | docs dirs only | ✅ |
| `pinscape-build-guide/` | `concurrent-recursion/pinscape-build-guide` (`main`) | sparse `book` + generated Markdown | book only | ✅ (incl. conversion) |
| `PUP/` | nailbuster.com DokuWiki | HTML crawl (`Invoke-PinUpMirror` / `pinup_mirror`, disabled by default) | ≤250 crawled pages | ⚠️ ps1 commented out; sh behind `--pup` |
| `ExternalWikis/dekay-vpinball-wiki/` | `dekay/vpinball-wiki.wiki.git` | full clone into `repo/` (small wiki repo) | all 48 pages | ✅ |
| `ExternalWikis/vpw-wiki/` | `dcbenji/vpw-wiki` | full clone into `repo/` (MkDocs content) | full repo | ✅ |

**No folder — `SSFImpactor Guide.pdf`:** ships inside the DOF R3++ Grand Unified Edition zip from <https://www.mjrnet.org/pinscape/BuildGuideV2/BuildGuide.php?sec=downloads>. Manual fetch, not covered by the update scripts. Currently **not present** in local staging.
