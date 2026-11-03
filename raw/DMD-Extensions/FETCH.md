# FETCH — DMD Extensions

**Upstream:** [freezy/dmd-extensions](https://github.com/freezy/dmd-extensions) (branch `master`).

**What is fetched:** the root `README.md` plus four docs-bearing subfolders — a fraction of the repo (no C#/C++ sources beyond those folders):

- `/README.md`
- `/LibDmd/`
- `/PinMameDevice/`
- `/Console/Server/`
- `/ProPinballBridge/`

**Initial fetch** (from repo root; **non-cone** mode is required to mix root files with subdirectories):

```powershell
git clone --depth 1 --filter=blob:none --sparse https://github.com/freezy/dmd-extensions.git raw/DMD-Extensions/repo
git -C raw/DMD-Extensions/repo sparse-checkout init --no-cone
git -C raw/DMD-Extensions/repo sparse-checkout set /README.md /LibDmd/ /PinMameDevice/ /Console/Server/ /ProPinballBridge/
```

**Refresh:** `git -C raw/DMD-Extensions/repo pull --depth 1` — or run `update-raw.ps1` (step "DMD Extensions").

**Resulting layout:** `raw/DMD-Extensions/repo/`
