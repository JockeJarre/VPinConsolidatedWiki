# FETCH — PUP (PinUp / PinUp Popper)

**Upstream:** the PinUp DokuWiki at <https://www.nailbuster.com/wikipinup/doku.php?id=start>. No git repo exists for this content — it is a live website.

**What is fetched:** a breadth-first crawl of the public DokuWiki pages (≤250 pages, skipping `playground:`/`wiki:` namespaces), saved as HTML snapshots under `raw/PUP/site/`, with a page map in `raw/PUP/site/site-index.json`. Only the PinUp pages are crawled — the site also hosts other content that is not fetched.

**Initial fetch:** run the `Invoke-PinUpMirror` step in `update-raw.ps1`. The step is currently **commented out** (the mirror is stable); uncomment it to re-fetch. In `update-raw.sh` the same crawl is implemented as `pinup_mirror` and runs only when the script is invoked with `--pup`:

```powershell
Invoke-PinUpMirror -Label 'PinUp Popper' `
    -StartUri 'https://www.nailbuster.com/wikipinup/doku.php?id=start' `
    -OutputRoot 'raw/PUP/site'
```

The crawl uses `curl.exe -L --fail --silent` per page (`doku.php?id=<pageId>`) and regenerates the whole `site/` tree on each run.

**Notes:** `raw/PUP/site/` contains ~78 pages (e.g. `start.html`, `popper.html`, `pinup_display.html`). Because there is no raw-export feed, these HTML snapshots are the only local source; wiki citations point at the live DokuWiki URLs.
