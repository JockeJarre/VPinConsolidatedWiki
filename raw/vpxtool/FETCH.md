# FETCH — vpxtool

**Upstream:** [francisdb/vpxtool](https://github.com/francisdb/vpxtool) (branch `main`).

**What is fetched:** only `README.md` (the usage documentation). The repo is a large Rust workspace; the wiki only needs the user-facing docs, fetched as a single file. The README's "Building" section is out of wiki scope (usage only).

**Initial & refresh fetch** (from repo root):

```powershell
curl -fsSL https://raw.githubusercontent.com/francisdb/vpxtool/main/README.md -o raw/vpxtool/README.md
```

**Refresh:** re-run the same command — or run `update-raw.ps1` / `update-raw.sh` (step "vpxtool README").

**Resulting layout:** `raw/vpxtool/README.md`
