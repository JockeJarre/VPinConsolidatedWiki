# FETCH — FlexDMD

**Upstream:** [vbousquet/flexdmd](https://github.com/vbousquet/flexdmd) (branch `master`).

**What is fetched:** only `docs/` (4 `.md` files + `docs/media/architecture.svg` + 2 PNG demos) — a small fraction of the repo.

**Initial fetch** (from repo root):

```powershell
git clone --depth 1 --filter=blob:none --sparse https://github.com/vbousquet/flexdmd.git raw/FlexDMD/repo
git -C raw/FlexDMD/repo sparse-checkout set docs
```

**Refresh:** `git -C raw/FlexDMD/repo pull --depth 1` — or run `update-raw.ps1` (step "FlexDMD").

**Resulting layout:** `raw/FlexDMD/repo/docs/`
