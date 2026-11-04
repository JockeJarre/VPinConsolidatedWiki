#!/usr/bin/env python3
"""Transform wiki/ content into a GitHub-wiki-publishable tree (flat pages).

GitHub wiki notes:
  - The wiki sidebar presents all pages flat; directory URLs
    (/wiki/projects/X) do not reliably resolve, so pages are published as
    flat page names (basenames, spaces -> hyphens, GitHub convention).
  - Links between pages must point at wiki URLs
    (https://github.com/JockeJarre/VPinConsolidatedWiki/wiki/<Page-Name>).
  - Local image assets are not served by the GitHub wiki; image links are
    rewritten to the GitHub Pages site URLs.

Usage: publish-ghwiki.py <src wiki dir> <staging out dir>
  - index.md is published as Home.md (the wiki landing page)
  - basename collisions (same page name in two dirs) get a "<dir>-" prefix
"""
import os
import posixpath
import re
import shutil
import sys
import urllib.parse

WIKI_BASE = "https://github.com/JockeJarre/VPinConsolidatedWiki/wiki"
PAGES_BASE = "https://jockejarre.github.io/VPinConsolidatedWiki"

LINK_RE = re.compile(r"\]\(([^)\s]+)(?:\s+\"[^\"]*\")?\)")


def page_name(rel: str) -> str:
    stem = rel[:-3] if rel.endswith(".md") else rel
    if stem == "index":
        return "Home"
    base = posixpath.basename(stem).replace(" ", "-")
    return base


def build_page_map(src: str) -> dict:
    """rel path -> unique page name (collisions prefixed with their dir)."""
    rels = []
    for root, _, files in os.walk(src):
        for fn in sorted(files):
            if fn.endswith(".md"):
                rels.append(os.path.relpath(os.path.join(root, fn), src).replace(os.sep, "/"))
    counts = {}
    for rel in rels:
        counts[page_name(rel)] = counts.get(page_name(rel), 0) + 1
    mapping = {}
    for rel in rels:
        name = page_name(rel)
        if counts[name] > 1 and name != "Home":
            name = f"{posixpath.dirname(rel).replace('/', '-')}-{name}"
        mapping[rel] = name
    return mapping


def rewrite_target(target: str, page_rel: str, pages: dict) -> str:
    if target.startswith(("http://", "https://", "mailto:", "#")):
        return target
    frag = ""
    if "#" in target:
        target, frag = target.split("#", 1)
        frag = "#" + frag
    if not target:
        return target + frag
    page_dir = posixpath.dirname(page_rel)
    rel = posixpath.normpath(posixpath.join(page_dir, urllib.parse.unquote(target)))
    if rel.startswith(".."):
        return target + frag  # outside wiki tree; leave as-is
    if rel.endswith(".md"):
        return f"{WIKI_BASE}/{pages.get(rel, page_name(rel))}{frag}"
    # assets and everything non-markdown -> GitHub Pages site URL
    return f"{PAGES_BASE}/{urllib.parse.quote(rel)}{frag}"


def transform(text: str, page_rel: str, pages: dict) -> str:
    return LINK_RE.sub(lambda m: "](" + rewrite_target(m.group(1), page_rel, pages) + ")", text)


def main() -> int:
    src, out = sys.argv[1], sys.argv[2]
    if os.path.isdir(out):
        shutil.rmtree(out)
    os.makedirs(out)
    pages = build_page_map(src)
    used = {}
    count = 0
    for root, _, files in os.walk(src):
        for fn in files:
            if not fn.endswith(".md"):
                continue
            rel = os.path.relpath(os.path.join(root, fn), src).replace(os.sep, "/")
            with open(os.path.join(root, fn), encoding="utf-8") as fh:
                body = transform(fh.read(), rel, pages)
            name = pages[rel]
            if rel == "index.md":
                body = ("> 🌐 This wiki is auto-published from the repo's `wiki/` by the nightly "
                        "pipeline. The full site version (Material theme, live search, Word Index) "
                        "is at <https://jockejarre.github.io/VPinConsolidatedWiki/>.\n\n") + body
            if name in used:
                print(f"WARNING collision: {name} from {used[name]} and {rel}", file=sys.stderr)
            used[name] = rel
            dest = os.path.join(out, name + ".md")
            with open(dest, "w", encoding="utf-8") as fh:
                fh.write(body)
            count += 1
    print(f"ghwiki: generated {count} flat pages")
    return 0


if __name__ == "__main__":
    sys.exit(main())
