# FETCH — pinscape-build-guide

**Upstream:** [concurrent-recursion/pinscape-build-guide](https://github.com/concurrent-recursion/pinscape-build-guide) (branch **`main`** — the only collection not on `master`).

**What is fetched:** only the `book/` subtree (~133 AsciiDoc files). The repo also holds site-build tooling that is not fetched.

**Initial fetch** (from repo root; the script uses non-cone sparse mode):

```powershell
git clone --depth 1 --filter=blob:none --sparse https://github.com/concurrent-recursion/pinscape-build-guide.git raw/pinscape-build-guide/repo
git -C raw/pinscape-build-guide/repo sparse-checkout init --no-cone
git -C raw/pinscape-build-guide/repo sparse-checkout set book
```

**Derived snapshot (second step):** `raw/pinscape-build-guide/markdown/` is **generated**, not fetched — `update-raw.ps1` converts every `repo/book/**/*.adoc` to `.md` with an embedded converter script (requires Python). Re-generate it by running `update-raw.ps1` (step "pinscape-build-guide"); never edit `markdown/` by hand.

**Refresh:** `git -C raw/pinscape-build-guide/repo pull --depth 1` then re-run the conversion.

**Resulting layout:** `raw/pinscape-build-guide/repo/book/` (AsciiDoc, source of truth) and `raw/pinscape-build-guide/markdown/` (generated Markdown).
