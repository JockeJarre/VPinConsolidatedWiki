# FETCH — DOF (DirectOutput Framework)

**Upstream:** [DirectOutput/DirectOutput](https://github.com/DirectOutput/DirectOutput) (branch `master`).

**What is fetched:** only `Documentation/` (~100 files, incl. nested subfolders) — a fraction of the repo (sources, binaries, config are not fetched).

**Initial fetch** (from repo root):

```powershell
git clone --depth 1 --filter=blob:none --sparse https://github.com/DirectOutput/DirectOutput.git raw/DOF/repo
git -C raw/DOF/repo sparse-checkout set Documentation
```

**Refresh:** `git -C raw/DOF/repo pull --depth 1` — or run `update-raw.ps1` (step "DirectOutput Framework").

**Resulting layout:** `raw/DOF/repo/Documentation/`
