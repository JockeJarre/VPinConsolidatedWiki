# FETCH — vpw-wiki (VPW Knowledge Base)

**Upstream:** [dcbenji/vpw-wiki](https://github.com/dcbenji/vpw-wiki) — the MkDocs content repo behind the live site <https://vpw-wiki.skirmishofwit.com/>.

**What is fetched:** the full repo (default branch). Content lives in `docs/`:

- `docs/guides/` — 13 authoring guides
- `docs/tables/` — 84 per-table case studies (incl. `index.md`)
- `docs/reference/` — 5 references

`mkdocs.yml` drives the site build; `wiki-manifest.json` records the Discord extraction manifest (108 extractions, 3136 nuggets, dated 2026-02-12).

**Initial fetch** (from repo root):

```powershell
git clone https://github.com/dcbenji/vpw-wiki.git raw/ExternalWikis/vpw-wiki/repo
```

**Refresh:** `git -C raw/ExternalWikis/vpw-wiki/repo pull`

**Notes:** covered by `update-raw.ps1` and `update-raw.sh` (step "VPW Knowledge Base"). Secondary-priority source; see the Priority callout on the wiki source page.
