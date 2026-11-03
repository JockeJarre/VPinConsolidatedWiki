# FETCH — dekay-vpinball-wiki (Unofficial Visual Pinball Wiki)

**Upstream:** the GitHub wiki of [dekay/vpinball-wiki](https://github.com/dekay/vpinball-wiki) — GitHub wikis are their own git repos, at `*.wiki.git`.

**What is fetched:** the entire wiki repo (48 flat `.md` files — full; the wiki repo is small).

**Initial fetch** (from repo root):

```powershell
git clone --depth 1 https://github.com/dekay/vpinball-wiki.wiki.git raw/ExternalWikis/dekay-vpinball-wiki/repo
```

**Refresh:** `git -C raw/ExternalWikis/dekay-vpinball-wiki/repo pull --depth 1`

**Notes:**
- Covered by `update-raw.ps1` and `update-raw.sh` (step "Unofficial Visual Pinball Wiki").
- Several page filenames legitimately contain the **U+2010 HYPHEN** (e.g. `PAL-‐-4-Colors.md`), not ASCII `-`. Keep filenames as-is; percent-encode as `%E2%80%90` when building page URLs.
- `Home.md` is the wiki root page.
