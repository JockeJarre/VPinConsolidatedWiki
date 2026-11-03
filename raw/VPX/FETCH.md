# FETCH — VPX (Visual Pinball X)

**Upstream:** [vpinball/vpinball](https://github.com/vpinball/vpinball) (branch `master`).

**What is fetched:** only `docs/` (~78 files) — a tiny fraction; the full repo is very large (C++ sources, media), so never clone it whole.

**Initial fetch** (from repo root):

```powershell
git clone --depth 1 --filter=blob:none --sparse https://github.com/vpinball/vpinball.git raw/VPX/repo
git -C raw/VPX/repo sparse-checkout set docs
```

**Refresh:** `git -C raw/VPX/repo pull --depth 1` — or run `update-raw.ps1` (step "Visual Pinball X").

**Resulting layout:** `raw/VPX/repo/docs/`
