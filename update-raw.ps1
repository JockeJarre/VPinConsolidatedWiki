<#
.SYNOPSIS
    Fetches documentation source material from upstream repositories and sites into raw/.

.DESCRIPTION
    Uses git sparse checkout (depth 1) to fetch only the docs subfolders needed.
    For PinUp Popper, mirrors public DokuWiki HTML pages into raw/PUP/site/.
    For pinscape-build-guide, also generates a Markdown snapshot from the downloaded AsciiDoc files.
    Run this before asking Copilot to re-ingest changed pages and regenerate wiki/.

    Sources fetched:
      B2S wiki   https://github.com/vpinball/b2s-backglass (wiki)   → raw/B2S/b2s-backglass.wiki/
      DOF        https://github.com/DirectOutput/DirectOutput       → raw/DOF/repo/Documentation/
      FlexDMD    https://github.com/vbousquet/flexdmd               → raw/FlexDMD/repo/docs/
      VPX        https://github.com/vpinball/vpinball               → raw/VPX/repo/docs/
      DMD-Ext    https://github.com/freezy/dmd-extensions           → raw/DMD-Extensions/repo/
    Pinscape   https://github.com/concurrent-recursion/pinscape-build-guide → raw/pinscape-build-guide/repo/book/
                                              → raw/pinscape-build-guide/markdown/
      PinUP      https://www.nailbuster.com/wikipinup/              → raw/PUP/site/
      Dekay    https://github.com/dekay/vpinball-wiki (wiki)        → raw/ExternalWikis/dekay-vpinball-wiki/repo/
      VPW      https://github.com/dcbenji/vpw-wiki                  → raw/ExternalWikis/vpw-wiki/repo/

.NOTES
    Requires git 2.25+ (sparse-checkout support).
    First run clones; subsequent runs pull the latest changes.
    PinUp Popper pages are stored as HTML snapshots because the public site does not expose
    a stable raw-export or repository-based source feed.
#>

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

Push-Location $PSScriptRoot

$pinUpBaseUri = 'https://www.nailbuster.com/wikipinup/'
$pinUpStartUri = $pinUpBaseUri + 'doku.php?id=start'
$sourceFailures = New-Object System.Collections.Generic.List[string]

# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------

function Invoke-WikiClone {
    param(
        [string]$Label,
        [string]$RepoUrl,
        [string]$LocalPath
    )
    Write-Host "`n==> $Label" -ForegroundColor Cyan
    if (Test-Path (Join-Path $LocalPath '.git')) {
        Write-Host "    Pulling latest..." -ForegroundColor Yellow
        Push-Location $LocalPath
        $gitOutput = @(git pull --depth 1 2>&1)
        if ($gitOutput.Count -gt 0) {
            $gitOutput | ForEach-Object { Write-Host "    $_" }
        }
        if ($LASTEXITCODE -ne 0) {
            Pop-Location
            $pullDetails = ($gitOutput -join ' | ')
            Write-Host "    Pull failed; re-cloning mirror..." -ForegroundColor Yellow
            Remove-Item -Path $LocalPath -Recurse -Force
            $gitOutput = @(git clone --depth 1 $RepoUrl $LocalPath 2>&1)
            if ($gitOutput.Count -gt 0) {
                $gitOutput | ForEach-Object { Write-Host "    $_" }
            }
            if ($LASTEXITCODE -ne 0) {
                $details = ($gitOutput -join ' | ')
                throw "git pull failed for $Label ($LocalPath). Details: $pullDetails ; fallback git clone failed. Details: $details"
            }
        }
        else {
            Pop-Location
        }
    } else {
        Write-Host "    Cloning wiki (full, small repo)..." -ForegroundColor Green
        $gitOutput = @(git clone --depth 1 $RepoUrl $LocalPath 2>&1)
        if ($gitOutput.Count -gt 0) {
            $gitOutput | ForEach-Object { Write-Host "    $_" }
        }
        if ($LASTEXITCODE -ne 0) {
            $details = ($gitOutput -join ' | ')
            throw "git clone failed for $Label ($RepoUrl). Details: $details"
        }
    }
    Write-Host "    Done." -ForegroundColor Green
}

function Invoke-SparseClone {
    param(
        [string]$Label,
        [string]$RepoUrl,
        [string]$LocalPath,
        [string[]]$SparsePaths,
        [switch]$NoCone
    )
    Write-Host "`n==> $Label" -ForegroundColor Cyan
    if (Test-Path (Join-Path $LocalPath '.git')) {
        Write-Host "    Pulling latest..." -ForegroundColor Yellow
        Push-Location $LocalPath
        $gitOutput = @(git pull --depth 1 2>&1)
        if ($gitOutput.Count -gt 0) {
            $gitOutput | ForEach-Object { Write-Host "    $_" }
        }
        if ($LASTEXITCODE -ne 0) {
            Pop-Location
            $pullDetails = ($gitOutput -join ' | ')
            Write-Host "    Pull failed; re-cloning mirror..." -ForegroundColor Yellow
            Remove-Item -Path $LocalPath -Recurse -Force
            $gitOutput = @(git clone --depth 1 --filter=blob:none --sparse $RepoUrl $LocalPath 2>&1)
            if ($gitOutput.Count -gt 0) {
                $gitOutput | ForEach-Object { Write-Host "    $_" }
            }
            if ($LASTEXITCODE -ne 0) {
                $details = ($gitOutput -join ' | ')
                throw "git pull failed for $Label ($LocalPath). Details: $pullDetails ; fallback git clone failed. Details: $details"
            }
            Push-Location $LocalPath
            if ($NoCone) {
                $gitOutput = @(git sparse-checkout init --no-cone 2>&1)
                if ($gitOutput.Count -gt 0) {
                    $gitOutput | ForEach-Object { Write-Host "    $_" }
                }
                if ($LASTEXITCODE -ne 0) {
                    Pop-Location
                    $details = ($gitOutput -join ' | ')
                    throw "git sparse-checkout init failed for $Label ($LocalPath). Details: $details"
                }
            }
            $gitOutput = @(git sparse-checkout set @SparsePaths 2>&1)
            if ($gitOutput.Count -gt 0) {
                $gitOutput | ForEach-Object { Write-Host "    $_" }
            }
            if ($LASTEXITCODE -ne 0) {
                Pop-Location
                $details = ($gitOutput -join ' | ')
                throw "git sparse-checkout set failed for $Label ($LocalPath). Details: $details"
            }
            Pop-Location
        }
        else {
            Pop-Location
        }
    } else {
        Write-Host "    Sparse-cloning (depth 1, blobs deferred)..." -ForegroundColor Green
        $gitOutput = @(git clone --depth 1 --filter=blob:none --sparse $RepoUrl $LocalPath 2>&1)
        if ($gitOutput.Count -gt 0) {
            $gitOutput | ForEach-Object { Write-Host "    $_" }
        }
        if ($LASTEXITCODE -ne 0) {
            $details = ($gitOutput -join ' | ')
            throw "git clone failed for $Label ($RepoUrl). Details: $details"
        }
        Push-Location $LocalPath
        if ($NoCone) {
            $gitOutput = @(git sparse-checkout init --no-cone 2>&1)
            if ($gitOutput.Count -gt 0) {
                $gitOutput | ForEach-Object { Write-Host "    $_" }
            }
            if ($LASTEXITCODE -ne 0) {
                Pop-Location
                $details = ($gitOutput -join ' | ')
                throw "git sparse-checkout init failed for $Label ($LocalPath). Details: $details"
            }
        }
        $gitOutput = @(git sparse-checkout set @SparsePaths 2>&1)
        if ($gitOutput.Count -gt 0) {
            $gitOutput | ForEach-Object { Write-Host "    $_" }
        }
        if ($LASTEXITCODE -ne 0) {
            Pop-Location
            $details = ($gitOutput -join ' | ')
            throw "git sparse-checkout set failed for $Label ($LocalPath). Details: $details"
        }
        Pop-Location
    }
    Write-Host "    Done." -ForegroundColor Green
}

function Invoke-SourceStep {
    param(
        [string]$Label,
        [scriptblock]$Action
    )

    try {
        & $Action
    } catch {
        $message = $_.Exception.Message
        Write-Host "    Failed: $message" -ForegroundColor Red
        $script:sourceFailures.Add("${Label}: $message") | Out-Null
    }
}

function Invoke-AsciiDocMarkdownSnapshot {
    param(
        [string]$Label,
        [string]$SourceRoot,
        [string]$OutputRoot
    )

    Write-Host "    Converting AsciiDoc snapshot to Markdown..." -ForegroundColor Green

    $pythonCommand = Get-Command python -ErrorAction SilentlyContinue
    if ($null -eq $pythonCommand) {
        throw "Python is required to convert $Label AsciiDoc files to Markdown. Install Python and rerun update-raw.ps1."
    }

    $converterScriptPath = Join-Path $env:TEMP 'vpxwiki-convert-asciidoc.py'
    $converterScript = @'
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
'@
    Set-Content -Path $converterScriptPath -Value $converterScript -Encoding utf8

    $conversionOutput = @(python $converterScriptPath $SourceRoot $OutputRoot 2>&1)
    if ($conversionOutput.Count -gt 0) {
        $conversionOutput | ForEach-Object { Write-Host "    $_" }
    }
    if ($LASTEXITCODE -ne 0) {
        $details = ($conversionOutput -join ' | ')
        throw "AsciiDoc-to-Markdown conversion failed for $Label. Details: $details"
    }
}

function Get-PinUpPageIdFromHref {
    param(
        [string]$Href
    )

    if ([string]::IsNullOrWhiteSpace($Href)) {
        return $null
    }

    try {
        $absoluteUri = [System.Uri]::new([System.Uri]$pinUpBaseUri, $Href)
    } catch {
        return $null
    }

    if ($absoluteUri.Host -ne 'www.nailbuster.com') {
        return $null
    }

    if (-not $absoluteUri.AbsolutePath.StartsWith('/wikipinup/doku.php')) {
        return $null
    }

    $query = [System.Web.HttpUtility]::ParseQueryString($absoluteUri.Query)
    $pageId = $query['id']
    $action = $query['do']

    if ([string]::IsNullOrWhiteSpace($pageId)) {
        return $null
    }

    if ($action -and $action -notin @('show', 'export_xhtml')) {
        return $null
    }

    if ($pageId.StartsWith('playground:') -or $pageId.StartsWith('wiki:')) {
        return $null
    }

    return $pageId.Trim()
}

function ConvertTo-PinUpSnapshotPath {
    param(
        [string]$OutputRoot,
        [string]$PageId
    )

    $segments = @($PageId -split ':' | Where-Object { $_ -ne '' })
    if ($segments.Count -eq 0) {
        $segments = @('start')
    }

    $safeSegments = @(foreach ($segment in $segments) {
        $segment -replace '[^A-Za-z0-9._-]', '_'
    })

    if ($safeSegments.Count -eq 1) {
        return Join-Path $OutputRoot ($safeSegments[0] + '.html')
    }

    $directory = Join-Path $OutputRoot ([System.IO.Path]::Combine($safeSegments[0..($safeSegments.Count - 2)]))
    return Join-Path $directory ($safeSegments[-1] + '.html')
}

function Invoke-PinUpMirror {
    param(
        [string]$Label,
        [string]$StartUri,
        [string]$OutputRoot,
        [int]$MaxPages = 250
    )

    Write-Host "`n==> $Label" -ForegroundColor Cyan
    Write-Host "    Mirroring public wiki pages as HTML snapshots..." -ForegroundColor Green

    if (Test-Path $OutputRoot) {
        Remove-Item $OutputRoot -Recurse -Force
    }
    New-Item -ItemType Directory -Path $OutputRoot | Out-Null

    $visited = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::OrdinalIgnoreCase)
    $queued = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::OrdinalIgnoreCase)
    $queue = [System.Collections.Generic.Queue[string]]::new()
    $pageIndex = New-Object System.Collections.Generic.List[object]

    $queue.Enqueue('start')
    $queued.Add('start') | Out-Null

    while ($queue.Count -gt 0) {
        if ($visited.Count -ge $MaxPages) {
            Write-Warning "Reached PinUp mirror limit of $MaxPages pages; stopping crawl early."
            break
        }

        $pageId = $queue.Dequeue()
        if (-not $visited.Add($pageId)) {
            continue
        }

        $pageUri = '{0}doku.php?id={1}' -f $pinUpBaseUri, [System.Uri]::EscapeDataString($pageId)
        Write-Host "    Fetching $pageId" -ForegroundColor Yellow
        $html = & curl.exe -L --fail --silent --show-error $pageUri

        $outputPath = ConvertTo-PinUpSnapshotPath -OutputRoot $OutputRoot -PageId $pageId
        $outputDirectory = Split-Path $outputPath -Parent
        if (-not (Test-Path $outputDirectory)) {
            New-Item -ItemType Directory -Path $outputDirectory -Force | Out-Null
        }
        Set-Content -Path $outputPath -Value $html -Encoding utf8

        $pageIndex.Add([pscustomobject]@{
            id = $pageId
            url = $pageUri
            path = ($outputPath -replace '\\', '/')
        }) | Out-Null

        foreach ($match in [regex]::Matches($html, 'href="([^"]+)"', [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)) {
            $nextPageId = Get-PinUpPageIdFromHref -Href $match.Groups[1].Value
            if ($null -eq $nextPageId) {
                continue
            }

            if ($visited.Contains($nextPageId) -or $queued.Contains($nextPageId)) {
                continue
            }

            $queue.Enqueue($nextPageId)
            $queued.Add($nextPageId) | Out-Null
        }
    }

    $indexPath = Join-Path $OutputRoot 'site-index.json'
    $pageIndex
    | Sort-Object id
    | ConvertTo-Json -Depth 3
    | Set-Content -Path $indexPath -Encoding utf8

    Write-Host "    Mirrored $($pageIndex.Count) page(s) to $OutputRoot" -ForegroundColor Green
}

# ---------------------------------------------------------------------------
# Sources
# ---------------------------------------------------------------------------

# B2S Backglass Server wiki (GitHub wiki = its own tiny git repo, plain clone)
Invoke-SourceStep -Label 'B2S Backglass Server wiki' -Action {
    Invoke-WikiClone `
        -Label     'B2S Backglass Server wiki' `
        -RepoUrl   'https://github.com/vpinball/b2s-backglass.wiki.git' `
        -LocalPath 'raw/B2S/b2s-backglass.wiki'
}

# DirectOutput Framework — Documentation/ subfolder only
Invoke-SourceStep -Label 'DirectOutput Framework' -Action {
    Invoke-SparseClone `
        -Label       'DirectOutput Framework' `
        -RepoUrl     'https://github.com/DirectOutput/DirectOutput.git' `
        -LocalPath   'raw/DOF/repo' `
        -SparsePaths 'Documentation'
}

# FlexDMD — docs/ subfolder only
Invoke-SourceStep -Label 'FlexDMD' -Action {
    Invoke-SparseClone `
        -Label       'FlexDMD' `
        -RepoUrl     'https://github.com/vbousquet/flexdmd.git' `
        -LocalPath   'raw/FlexDMD/repo' `
        -SparsePaths 'docs'
}

# Visual Pinball X — docs/ subfolder only (full repo is very large)
Invoke-SourceStep -Label 'Visual Pinball X' -Action {
    Invoke-SparseClone `
        -Label       'Visual Pinball X' `
        -RepoUrl     'https://github.com/vpinball/vpinball.git' `
        -LocalPath   'raw/VPX/repo' `
        -SparsePaths 'docs'
}

# DMD Extensions — root README.md + specific subdirectories
# Uses non-cone mode because we need root-level files alongside subdirectories
Invoke-SourceStep -Label 'DMD Extensions' -Action {
    Invoke-SparseClone `
        -Label       'DMD Extensions' `
        -RepoUrl     'https://github.com/freezy/dmd-extensions.git' `
        -LocalPath   'raw/DMD-Extensions/repo' `
        -SparsePaths '/README.md', '/LibDmd/', '/PinMameDevice/', '/Console/Server/', '/ProPinballBridge/' `
        -NoCone
}

# pinscape-build-guide — book/ subtree only, plus generated Markdown snapshot
Invoke-SourceStep -Label 'pinscape-build-guide' -Action {
    Invoke-SparseClone `
        -Label       'pinscape-build-guide' `
        -RepoUrl     'https://github.com/concurrent-recursion/pinscape-build-guide.git' `
        -LocalPath   'raw/pinscape-build-guide/repo' `
        -SparsePaths 'book' `
        -NoCone

    Invoke-AsciiDocMarkdownSnapshot `
        -Label      'pinscape-build-guide' `
        -SourceRoot 'raw/pinscape-build-guide/repo/book' `
        -OutputRoot 'raw/pinscape-build-guide/markdown'
}

# Unofficial Visual Pinball Wiki (dekay) — GitHub wiki = its own tiny git repo, plain clone
Invoke-SourceStep -Label 'Unofficial Visual Pinball Wiki' -Action {
    Invoke-WikiClone `
        -Label     'Unofficial Visual Pinball Wiki' `
        -RepoUrl   'https://github.com/dekay/vpinball-wiki.wiki.git' `
        -LocalPath 'raw/ExternalWikis/dekay-vpinball-wiki/repo'
}

# VPW Knowledge Base — MkDocs content repo behind vpw-wiki.skirmishofwit.com (full clone, small)
Invoke-SourceStep -Label 'VPW Knowledge Base' -Action {
    Invoke-WikiClone `
        -Label     'VPW Knowledge Base' `
        -RepoUrl   'https://github.com/dcbenji/vpw-wiki.git' `
        -LocalPath 'raw/ExternalWikis/vpw-wiki/repo'
}

# PinUP Popper — public DokuWiki mirrored as local HTML snapshots
<# Invoke-SourceStep -Label 'PinUp Popper' -Action {
    Invoke-PinUpMirror `
        -Label      'PinUp Popper' `
        -StartUri   $pinUpStartUri `
        -OutputRoot 'raw/PUP/site'
}
 #>
# ---------------------------------------------------------------------------

Pop-Location

Write-Host ''
if ($sourceFailures.Count -eq 0) {
    Write-Host 'All sources updated.' -ForegroundColor Green
} else {
    Write-Host 'Completed with source update failures:' -ForegroundColor Yellow
    foreach ($failure in $sourceFailures) {
        Write-Host "  - $failure" -ForegroundColor Yellow
    }
}
Write-Host 'Local paths after update:' -ForegroundColor Cyan
Write-Host '  raw/B2S/b2s-backglass.wiki/'
Write-Host '  raw/DOF/repo/Documentation/'
Write-Host '  raw/FlexDMD/repo/docs/'
Write-Host '  raw/VPX/repo/docs/'
Write-Host '  raw/DMD-Extensions/repo/'
Write-Host '  raw/pinscape-build-guide/repo/book/'
Write-Host '  raw/pinscape-build-guide/markdown/'
Write-Host '  raw/PUP/site/'
Write-Host '  raw/ExternalWikis/dekay-vpinball-wiki/repo/'
Write-Host '  raw/ExternalWikis/vpw-wiki/repo/'
Write-Host ''
Write-Host 'Ask Copilot to re-ingest any changed files and regenerate wiki/ pages.' -ForegroundColor Cyan

if ($sourceFailures.Count -gt 0) {
    exit 1
}
