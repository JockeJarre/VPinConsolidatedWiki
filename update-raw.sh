#!/usr/bin/env bash
#
# SYNOPSIS
#     Fetches documentation source material from upstream repositories and
#     sites into raw/ — Linux port of update-raw.ps1. Same sources, same
#     sparse paths, same resulting layout.
#
# DESCRIPTION
#     Uses git sparse checkout (depth 1) to fetch only the docs subfolders
#     needed. For PinUp Popper, mirrors public DokuWiki HTML pages into
#     raw/PUP/site/ (opt-in: --pup). For pinscape-build-guide, also generates
#     a Markdown snapshot from the downloaded AsciiDoc files.
#     Run this before asking Copilot to re-ingest changed pages and
#     regenerate wiki/.
#
#     Sources fetched:
#       B2S wiki   https://github.com/vpinball/b2s-backglass (wiki)   -> raw/B2S/b2s-backglass.wiki/
#       DOF        https://github.com/DirectOutput/DirectOutput       -> raw/DOF/repo/Documentation/
#       FlexDMD    https://github.com/vbousquet/flexdmd               -> raw/FlexDMD/repo/docs/
#       VPX        https://github.com/vpinball/vpinball               -> raw/VPX/repo/docs/
#       DMD-Ext    https://github.com/freezy/dmd-extensions           -> raw/DMD-Extensions/repo/
#       Pinscape   https://github.com/concurrent-recursion/pinscape-build-guide
#                                                                      -> raw/pinscape-build-guide/repo/book/
#                                                                      -> raw/pinscape-build-guide/markdown/
#       PinUP      https://www.nailbuster.com/wikipinup/              -> raw/PUP/site/   (--pup only)
#       Dekay      https://github.com/dekay/vpinball-wiki (wiki)      -> raw/ExternalWikis/dekay-vpinball-wiki/repo/
#       Starter    https://github.com/JockeJarre/VPinballX.starter    -> raw/VPinballX-Starter/repo/  (depth 100)
#       vpxtool    https://github.com/francisdb/vpxtool               -> raw/vpxtool/README.md  (file download)
#
# NOTES
#     Requires git 2.25+ (sparse-checkout), python3, curl.
#     First run clones; subsequent runs pull the latest changes.
#     PinUp Popper pages are stored as HTML snapshots because the public site
#     does not expose a stable raw-export or repository-based source feed.
#
set -uo pipefail

cd "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

REFRESH_PINUP=0
for arg in "$@"; do
    case "$arg" in
        --pup) REFRESH_PINUP=1 ;;
        *) echo "Unknown option: $arg (supported: --pup)" >&2; exit 2 ;;
    esac
done

SOURCE_FAILURES=()

fail() {
    SOURCE_FAILURES+=("$1: $2")
    echo "    Failed: $1: $2" >&2
}

# run_step LABEL ACTION_FN [args...] — prints header, reports Done on success.
run_step() {
    local label="$1"; shift
    echo
    echo "==> $label"
    if "$@"; then
        echo "    Done."
    fi
}

# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------

# wiki_clone LABEL REPO_URL LOCAL_PATH — full (shallow) clone of a small repo
wiki_clone() {
    local label="$1" url="$2" path="$3" depth="${4:-1}"
    if [[ -d "$path/.git" ]]; then
        echo "    Pulling latest..."
        if ! git -C "$path" pull --depth "$depth"; then
            echo "    Pull failed; re-cloning mirror..."
            rm -rf -- "$path"
            echo "    Cloning wiki (full, small repo)..."
            git clone --depth "$depth" "$url" "$path" \
                || { fail "$label" "git clone failed ($url)"; return 1; }
        fi
    else
        echo "    Cloning wiki (full, small repo)..."
        git clone --depth "$depth" "$url" "$path" \
            || { fail "$label" "git clone failed ($url)"; return 1; }
    fi
}

# fetch_file LABEL URL LOCAL_PATH — single-file download collection
fetch_file() {
    local label="$1" url="$2" path="$3"
    mkdir -p "$(dirname "$path")"
    echo "    Downloading $url ..."
    if ! curl -fsSL "$url" -o "$path"; then
        rm -f -- "$path"
        fail "$label" "download failed ($url)"
        return 1
    fi
}

# sparse_clone LABEL REPO_URL LOCAL_PATH [--no-cone] PATH [PATH...]
sparse_clone() {
    local label="$1" url="$2" path="$3"; shift 3
    local nocone=0
    if [[ "${1:-}" == "--no-cone" ]]; then nocone=1; shift; fi
    local paths=("$@")
    local need_clone=1
    if [[ -d "$path/.git" ]]; then
        echo "    Pulling latest..."
        if git -C "$path" pull --depth 1; then
            need_clone=0
        else
            echo "    Pull failed; re-cloning mirror..."
            rm -rf -- "$path"
        fi
    fi
    if [[ $need_clone -eq 1 ]]; then
        echo "    Sparse-cloning (depth 1, blobs deferred)..."
        git clone --depth 1 --filter=blob:none --sparse "$url" "$path" \
            || { fail "$label" "git clone failed ($url)"; return 1; }
        if ! (
            cd "$path" &&
            { [[ $nocone -eq 0 ]] || git sparse-checkout init --no-cone; } &&
            git sparse-checkout set "${paths[@]}"
        ); then
            fail "$label" "sparse-checkout setup failed ($path)"
            return 1
        fi
    fi
}

# asciidoc_markdown_snapshot LABEL SOURCE_ROOT OUTPUT_ROOT
asciidoc_markdown_snapshot() {
    local label="$1" src="$2" out="$3"
    if ! command -v python3 >/dev/null 2>&1; then
        fail "$label" "python3 is required to convert AsciiDoc files to Markdown"
        return 1
    fi
    local converter
    converter="$(mktemp "${TMPDIR:-/tmp}/vpxwiki-convert-asciidoc.XXXXXX")"
    cat > "$converter" <<'PYEOF'
from pathlib import Path
import re
import shutil
import sys


def convert_inline(text: str) -> str:
    def replace_xref(match: re.Match) -> str:
        path = match.group(1)
        anchor = match.group(2) or ''
        label = (match.group(3) or '').strip() or Path(path).stem
        target = Path(path).with_suffix('.md').as_posix()
        if anchor:
            target += f'#{anchor}'
        return f'[{label}]({target})'

    def replace_link(match: re.Match) -> str:
        target = match.group(1)
        label = (match.group(2) or '').strip() or target
        return f'[{label}]({target})'

    text = re.sub(r'xref:([^\[#\s]+)\.adoc(?:#([^\[]+))?\[([^\]]*)\]', replace_xref, text)
    text = re.sub(r'link:(\S+?)\[([^\]]*)\]', replace_link, text)
    text = re.sub(r'<<([^,>]+),\s*([^>]+)>>', r'[\2](#\1)', text)
    text = text.replace('.adoc#', '.md#')
    text = text.replace('.adoc)', '.md)')
    text = text.replace('.adoc"', '.md"')
    return text


def convert_asciidoc(source_text: str) -> str:
    output_lines = []
    pending_source_language = None
    in_code_block = False
    in_table_block = False

    for raw_line in source_text.splitlines():
        line = raw_line.rstrip('\n')
        stripped = line.strip()

        if stripped.startswith(':') and ':' in stripped[1:]:
            continue

        anchor_match = re.match(r'^\[#([^\]]+)\]\s*$', stripped)
        if anchor_match:
            output_lines.append(f'<a id="{anchor_match.group(1)}"></a>')
            continue

        heading_match = re.match(r'^(=+)\s+(.*)$', line)
        if heading_match and len(heading_match.group(1)) <= 6:
            output_lines.append(f"{'#' * len(heading_match.group(1))} {convert_inline(heading_match.group(2))}")
            continue

        source_match = re.match(r'^\[source(?:,([^\],]+))?.*\]\s*$', stripped)
        if source_match:
            pending_source_language = source_match.group(1) or ''
            continue

        if stripped == '----':
            if in_code_block:
                output_lines.append('```')
            else:
                fence = f'```{pending_source_language}'.rstrip()
                output_lines.append(fence)
            in_code_block = not in_code_block
            pending_source_language = None
            continue

        if stripped == '|===':
            output_lines.append('```text' if not in_table_block else '```')
            in_table_block = not in_table_block
            continue

        if in_code_block or in_table_block:
            output_lines.append(line)
            continue

        image_match = re.match(r'^image::(.+?)\[(.*?)\]\s*$', stripped)
        if image_match:
            image_path = image_match.group(1)
            image_alt = image_match.group(2).strip('"')
            output_lines.append(f'![{image_alt}]({image_path})')
            continue

        include_match = re.match(r'^include::(.+?)\[\]\s*$', stripped)
        if include_match:
            include_target = Path(include_match.group(1)).with_suffix('.md').as_posix()
            output_lines.append(f'[Included from {include_target}]({include_target})')
            continue

        if stripped == "'''":
            output_lines.append('---')
            continue

        output_lines.append(convert_inline(line))

    return '\n'.join(output_lines).rstrip() + '\n'


source_root = Path(sys.argv[1]).resolve()
output_root = Path(sys.argv[2]).resolve()

if output_root.exists():
    shutil.rmtree(output_root)
output_root.mkdir(parents=True, exist_ok=True)

converted_count = 0
copied_count = 0

for source_path in source_root.rglob('*'):
    if source_path.is_dir():
        continue

    relative_path = source_path.relative_to(source_root)
    if source_path.suffix.lower() == '.adoc':
        destination_path = (output_root / relative_path).with_suffix('.md')
        destination_path.parent.mkdir(parents=True, exist_ok=True)
        markdown_text = convert_asciidoc(source_path.read_text(encoding='utf-8'))
        destination_path.write_text(markdown_text, encoding='utf-8')
        converted_count += 1
    else:
        destination_path = output_root / relative_path
        destination_path.parent.mkdir(parents=True, exist_ok=True)
        shutil.copy2(source_path, destination_path)
        copied_count += 1

print(f'Converted {converted_count} AsciiDoc file(s); copied {copied_count} asset file(s).')
PYEOF
    echo "    Converting AsciiDoc snapshot to Markdown..."
    if ! python3 "$converter" "$src" "$out"; then
        rm -f -- "$converter"
        fail "$label" "AsciiDoc-to-Markdown conversion failed"
        return 1
    fi
    rm -f -- "$converter"
}

# pinup_mirror LABEL OUTPUT_ROOT — crawl the public DokuWiki as HTML snapshots
pinup_mirror() {
    local label="$1" out="$2"
    if ! command -v python3 >/dev/null 2>&1; then
        fail "$label" "python3 is required for the PinUp mirror crawl"
        return 1
    fi
    if ! command -v curl >/dev/null 2>&1; then
        fail "$label" "curl is required for the PinUp mirror crawl"
        return 1
    fi
    local script
    script="$(mktemp "${TMPDIR:-/tmp}/vpxwiki-pinup-mirror.XXXXXX")"
    cat > "$script" <<'PYEOF'
import json
import re
import shutil
import subprocess
import sys
import urllib.parse
from collections import deque
from pathlib import Path
from urllib.parse import parse_qs, urljoin, urlparse

BASE = 'https://www.nailbuster.com/wikipinup/'
MAX_PAGES = 250
out_root = Path(sys.argv[1]).resolve()

if out_root.exists():
    shutil.rmtree(out_root)
out_root.mkdir(parents=True, exist_ok=True)


def page_id_from_href(href: str):
    if not href:
        return None
    parsed = urlparse(urljoin(BASE, href))
    if parsed.netloc != 'www.nailbuster.com':
        return None
    if not parsed.path.startswith('/wikipinup/doku.php'):
        return None
    query = parse_qs(parsed.query)
    page_id = (query.get('id') or [''])[0].strip()
    action = (query.get('do') or [''])[0]
    if not page_id:
        return None
    if action and action not in ('show', 'export_xhtml'):
        return None
    if page_id.startswith('playground:') or page_id.startswith('wiki:'):
        return None
    return page_id


def snapshot_path(page_id: str) -> Path:
    segments = [re.sub(r'[^A-Za-z0-9._-]', '_', s) for s in page_id.split(':') if s]
    if not segments:
        segments = ['start']
    if len(segments) == 1:
        return out_root / (segments[0] + '.html')
    return out_root.joinpath(*segments[:-1]) / (segments[-1] + '.html')


def fetch(page_id: str) -> str:
    url = BASE + 'doku.php?id=' + urllib.parse.quote(page_id, safe=':')
    result = subprocess.run(
        ['curl', '-L', '--fail', '--silent', '--show-error', url],
        capture_output=True, text=True)
    if result.returncode != 0:
        raise RuntimeError(result.stderr.strip() or f'curl exit {result.returncode}')
    return result.stdout


queue = deque(['start'])
queued = {'start'}
visited = set()
pages = []

while queue:
    if len(visited) >= MAX_PAGES:
        print(f'    Reached PinUp mirror limit of {MAX_PAGES} pages; stopping crawl early.')
        break
    page_id = queue.popleft()
    if page_id in visited:
        continue
    visited.add(page_id)
    url = BASE + 'doku.php?id=' + urllib.parse.quote(page_id, safe=':')
    print(f'    Fetching {page_id}')
    try:
        html = fetch(page_id)
    except Exception as exc:
        print(f'    Fetch failed: {page_id}: {exc}')
        continue
    path = snapshot_path(page_id)
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(html, encoding='utf-8')
    pages.append({'id': page_id, 'url': url, 'path': str(path).replace('\\', '/')})
    for match in re.finditer(r'href="([^"]+)"', html, re.IGNORECASE):
        next_id = page_id_from_href(match.group(1))
        if next_id and next_id not in visited and next_id not in queued:
            queue.append(next_id)
            queued.add(next_id)

pages.sort(key=lambda page: page['id'])
(out_root / 'site-index.json').write_text(json.dumps(pages, indent=2), encoding='utf-8')
print(f'    Mirrored {len(pages)} page(s) to {out_root}')
PYEOF
    echo "    Mirroring public wiki pages as HTML snapshots..."
    if ! python3 "$script" "$out"; then
        rm -f -- "$script"
        fail "$label" "PinUp mirror crawl failed"
        return 1
    fi
    rm -f -- "$script"
}

# ---------------------------------------------------------------------------
# Composite steps
# ---------------------------------------------------------------------------

pinscape_step() {
    sparse_clone 'pinscape-build-guide' \
        'https://github.com/concurrent-recursion/pinscape-build-guide.git' \
        'raw/pinscape-build-guide/repo' --no-cone book || return 1
    asciidoc_markdown_snapshot 'pinscape-build-guide' \
        'raw/pinscape-build-guide/repo/book' \
        'raw/pinscape-build-guide/markdown'
}

# ---------------------------------------------------------------------------
# Sources (same order as update-raw.ps1)
# ---------------------------------------------------------------------------

run_step 'B2S Backglass Server wiki' wiki_clone 'B2S Backglass Server wiki' \
    'https://github.com/vpinball/b2s-backglass.wiki.git' 'raw/B2S/b2s-backglass.wiki'

run_step 'DirectOutput Framework' sparse_clone 'DirectOutput Framework' \
    'https://github.com/DirectOutput/DirectOutput.git' 'raw/DOF/repo' Documentation

run_step 'FlexDMD' sparse_clone 'FlexDMD' \
    'https://github.com/vbousquet/flexdmd.git' 'raw/FlexDMD/repo' docs

run_step 'Visual Pinball X' sparse_clone 'Visual Pinball X' \
    'https://github.com/vpinball/vpinball.git' 'raw/VPX/repo' docs

run_step 'DMD Extensions' sparse_clone 'DMD Extensions' \
    'https://github.com/freezy/dmd-extensions.git' 'raw/DMD-Extensions/repo' \
    --no-cone /README.md /LibDmd/ /PinMameDevice/ /Console/Server/ /ProPinballBridge/

run_step 'pinscape-build-guide' pinscape_step

if [[ $REFRESH_PINUP -eq 1 ]]; then
    run_step 'PinUp Popper' pinup_mirror 'PinUp Popper' 'raw/PUP/site'
else
    echo
    echo "==> PinUp Popper (skipped; the mirror crawl is opt-in — pass --pup to refresh it)"
fi

run_step 'Unofficial Visual Pinball Wiki' wiki_clone 'Unofficial Visual Pinball Wiki' \
    'https://github.com/dekay/vpinball-wiki.wiki.git' 'raw/ExternalWikis/dekay-vpinball-wiki/repo'

# VPinballX Starter — version-routing launcher; history kept (commit messages are source material)
run_step 'VPinballX Starter' wiki_clone 'VPinballX Starter' \
    'https://github.com/JockeJarre/VPinballX.starter.git' 'raw/VPinballX-Starter/repo' 100

# vpxtool — README.md only (usage docs; builds are out of wiki scope)
run_step 'vpxtool README' fetch_file 'vpxtool README' \
    'https://raw.githubusercontent.com/francisdb/vpxtool/main/README.md' 'raw/vpxtool/README.md'

# ---------------------------------------------------------------------------

echo
if [[ ${#SOURCE_FAILURES[@]} -eq 0 ]]; then
    echo 'All sources updated.'
else
    echo 'Completed with source update failures:'
    for failure in "${SOURCE_FAILURES[@]}"; do
        echo "  - $failure"
    done
fi
echo 'Local paths after update:'
echo '  raw/B2S/b2s-backglass.wiki/'
echo '  raw/DOF/repo/Documentation/'
echo '  raw/FlexDMD/repo/docs/'
echo '  raw/VPX/repo/docs/'
echo '  raw/DMD-Extensions/repo/'
echo '  raw/pinscape-build-guide/repo/book/'
echo '  raw/pinscape-build-guide/markdown/'
echo '  raw/PUP/site/'
echo '  raw/ExternalWikis/dekay-vpinball-wiki/repo/'
echo '  raw/VPinballX-Starter/repo/
  raw/vpxtool/README.md'
echo
echo 'Ask Copilot to re-ingest any changed files and regenerate wiki/ pages.'

if [[ ${#SOURCE_FAILURES[@]} -gt 0 ]]; then
    exit 1
fi
