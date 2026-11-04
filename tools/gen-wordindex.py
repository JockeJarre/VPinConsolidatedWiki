#!/usr/bin/env python3
"""Generate wiki/word-index.md — a concordance of the most common words.

Scans every markdown page under wiki/ (excluding log.md, the generated
word-index itself, and the copied AGENTS.md schema page), strips markdown
syntax, counts content words, and writes an alphabetized index of the
TOP_N most frequent words with per-page occurrence links.

Run before tools/gen-nav.py on every site build (see
.github/workflows/pages.yml); the generated file is gitignored.
"""
import os
import re
from collections import Counter, defaultdict

REPO = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
DOCS = "wiki"

TOP_N = 300              # words in the static alphabetic listing
MIN_GLOBAL = 3           # words in the searchable data set (JSON)
MIN_LEN = 3
MAX_PAGES_PER_WORD = 4

# English function words + wiki-meta noise; everything else counts.
STOP = set("""
the and for with that this from they them their there these those what when
where which who whom whose will would could should have has had been being
into onto over under about above after before between both each few more most
other some such not only own same than too very can due but here then once
also again such very much many need want using used use per via vs etc you
your yours our ours its his her she him he we us them it's don't i'm i've
page pages file files source sources raw wiki wikis docs document documents
index link links see also first second third new old big small high low
""".split())

SKIP_FILES = {"log.md", "word-index.md", "AGENTS.md"}

FENCE = re.compile(r"^```.*$")
INLINE_CODE = re.compile(r"`[^`]*`")
LINK = re.compile(r"\[([^\]]*)\]\([^)]*\)")     # keep label, drop target
IMAGE = re.compile(r"!\[[^\]]*\]\([^)]*\)")     # drop images entirely
URL = re.compile(r"https?://\S+|www\.\S+")
HTML = re.compile(r"<[^>]+>")
WORD = re.compile(r"[a-z0-9][a-z0-9+\-]*")


def clean_text(text):
    lines = [l for l in text.splitlines() if not FENCE.match(l.strip())]
    text = "\n".join(lines)
    text = IMAGE.sub(" ", text)
    text = LINK.sub(r"\1 ", text)
    text = INLINE_CODE.sub(" ", text)
    text = URL.sub(" ", text)
    text = HTML.sub(" ", text)
    return text


def title_for(rel_path):
    stem = os.path.basename(rel_path)[:-3]
    return stem


def link_for(rel_path):
    return rel_path.replace(" ", "%20")


def main():
    total_words = 0
    pages_scanned = 0
    global_counts = Counter()
    per_page = defaultdict(Counter)
    page_words = defaultdict(int)

    for root, _dirs, files in os.walk(os.path.join(REPO, DOCS)):
        for fname in sorted(files):
            if not fname.endswith(".md"):
                continue
            if fname in SKIP_FILES:
                continue
            fpath = os.path.join(root, fname)
            rel = os.path.relpath(fpath, os.path.join(REPO, DOCS))
            with open(fpath, encoding="utf-8") as fh:
                text = clean_text(fh.read())
            words = [w for w in WORD.findall(text.lower())
                     if len(w) >= MIN_LEN and w not in STOP and not w.isdigit()]
            counts = Counter(words)
            pages_scanned += 1
            page_words[rel] += sum(counts.values())
            for w, c in counts.items():
                global_counts[w] += c
                per_page[w][rel] += c
            total_words += sum(counts.values())

    top = [w for w, _ in global_counts.most_common()][:TOP_N]
    search_words = [w for w, _ in global_counts.most_common()
                    if global_counts[w] >= MIN_GLOBAL]

    # Search dataset: word -> total count + top pages (HTML targets, since
    # the site uses use_directory_urls: False)
    import json
    dataset = []
    for w in search_words:
        ranked = sorted(per_page[w].items(), key=lambda kv: (-kv[1], kv[0]))[:MAX_PAGES_PER_WORD]
        dataset.append({"w": w, "n": global_counts[w],
                        "p": [[title_for(rel), rel.replace(" ", "%20").replace(".md", ".html"), c]
                              for rel, c in ranked]})
    assets_dir = os.path.join(REPO, DOCS, "assets")
    os.makedirs(assets_dir, exist_ok=True)
    with open(os.path.join(assets_dir, "word-index-data.json"), "w", encoding="utf-8") as fh:
        json.dump(dataset, fh, ensure_ascii=False, separators=(",", ":"))

    out = []
    out.append("# Word Index")
    out.append("")
    out.append("Auto-generated concordance of the most common content words across all wiki pages. "
               "Rebuilt on every site build; counts are per-word occurrences and the four pages "
               "where each word appears most.")
    out.append("")
    out.append(f"Scanned {pages_scanned} pages · {total_words:,} content-word occurrences · "
               f"showing the {len(top)} most frequent in the listing below; the search box covers "
               f"all {len(search_words):,} indexed words.")
    out.append("")
    out.append("## Word Search")
    out.append("")
    out.append("Type a word (or a fragment) to find where it is used and which pages mention it most — "
               "a word-first lookup that complements the full-text search in the header.")
    out.append("")
    out.append('''<div id="wordsearch" style="margin:0.5em 0 1.5em 0">
  <input id="ws-input" type="text" autocomplete="off" placeholder="Search words, e.g. plunger, dmd, accelerometer…"
         style="width:100%;max-width:34em;font-size:1em;padding:0.5em 0.8em;border-radius:6px;border:1px solid #9994;background:var(--md-default-bg-color);color:inherit">
  <div id="ws-stats" style="font-size:0.85em;opacity:0.75;margin:0.4em 0"></div>
  <div id="ws-results" style="margin-top:0.4em"></div>
</div>
<script>
(function () {
  var data = null;
  fetch("assets/word-index-data.json").then(function (r) { return r.json(); })
    .then(function (d) { data = d; update(); });
  function esc(s) { return s.replace(/[&<>]/g, function (c) { return { "&": "&amp;", "<": "&lt;", ">": "&gt;" }[c]; }); }
  function render(list) {
    var box = document.getElementById("ws-results");
    var stats = document.getElementById("ws-stats");
    if (!list.length) { box.innerHTML = ""; stats.textContent = data ? "no matching words" : "loading…"; return; }
    stats.textContent = list.length + " matching words" + (list.length >= 30 ? " (top 30 shown)" : "");
    box.innerHTML = list.map(function (e) {
      var pages = e.p.map(function (p) { return '<a href="' + p[1] + '">' + esc(p[0]) + '</a> (' + p[2] + ')'; }).join(" · ");
      return '<div style="margin:0.35em 0"><strong>' + esc(e.w) + '</strong> — ' + e.n + ' \u00d7 ' + pages + '</div>';
    }).join("");
  }
  function update() {
    if (!data) return;
    var q = document.getElementById("ws-input").value.trim().toLowerCase();
    if (!q) { render(data.slice(0, 30)); return; }
    var starts = [], contains = [];
    for (var i = 0; i < data.length; i++) {
      var w = data[i].w;
      if (w === q || w.indexOf(q) === 0) starts.push(data[i]);
      else if (w.indexOf(q) !== -1) contains.push(data[i]);
    }
    render(starts.concat(contains).slice(0, 30));
  }
  document.getElementById("ws-input").addEventListener("input", update);
})();
</script>''')
    out.append("")
    out.append("## Alphabetic Listing")
    out.append("")

    current_letter = None
    for w in sorted(top):
        letter = w[0].upper()
        if letter != current_letter:
            current_letter = letter
            out.append(f"## {letter}")
            out.append("")
        ranked = sorted(per_page[w].items(), key=lambda kv: (-kv[1], kv[0]))[:MAX_PAGES_PER_WORD]
        links = ", ".join(f"[{title_for(rel)}]({link_for(rel)})" for rel, _ in ranked)
        out.append(f"- **{w}** — {global_counts[w]} × {links}")
        out.append("")

    out.append("## See Also")
    out.append("")
    out.append("- [index](index.md)")
    out.append("")

    dest = os.path.join(REPO, DOCS, "word-index.md")
    with open(dest, "w", encoding="utf-8") as fh:
        fh.write("\n".join(out))
    print(f"wrote {dest} ({len(top)} listed, {len(search_words)} searchable, {pages_scanned} pages, {total_words:,} occurrences)")


if __name__ == "__main__":
    main()
