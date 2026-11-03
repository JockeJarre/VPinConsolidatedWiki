# FETCH — B2S

**Upstream:** GitHub wiki of [vpinball/b2s-backglass](https://github.com/vpinball/b2s-backglass) (a GitHub wiki is its own git repo).

**What is fetched:** the entire wiki repo (31 `.md` files — full; the wiki repo is small).

**Initial fetch** (from repo root):

```powershell
git clone --depth 1 https://github.com/vpinball/b2s-backglass.wiki.git raw/B2S/b2s-backglass.wiki
```

**Refresh:** `git -C raw/B2S/b2s-backglass.wiki pull --depth 1` — or run `update-raw.ps1` (this collection is step "B2S Backglass Server wiki").

**Notes:** do not add this as a submodule/gitlink; `raw/` is not committed.
