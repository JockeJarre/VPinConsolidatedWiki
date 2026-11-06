#!/usr/bin/env bash
#
# nightly.sh — VPXwiki nightly maintenance pipeline
#
#   1. update-raw.sh --pup   refresh all raw/ source snapshots
#   2. change detection      compare git HEADs + file checksums vs last run
#   3. pi --print            headless LLM re-ingest of changed sources into wiki/
#   4. git commit + push     push wiki/ changes to origin
#   4b. source proposals     new-source candidates found by the scan go to a
#      separate rolling SourceProposals branch + PR (no auto-merge; human
#      registers sources via update-raw scripts + raw/FETCH.md)
#
# Run once per night from cron (pi has no scheduler; cron/systemd-timer is the
# durable runner):
#
#   0 3 * * * /home/jrl/git/VPinWiki/nightly.sh
#
# Options via env:
#   SKIP_PI=1        fetch + manifest only, no ingest, no push (dry run)
#   PI_MODEL=x       pass --model x to pi
#   PI_TIMEOUT=s     seconds allowed for the ingest step (default 10800 = 3h)
#   PR_AUTO_MERGE_DAYS=n  auto squash-merge the NightlyUpdates PR after n days
#                         unmerged (default 7; 0 disables, PR grows until merged)
#
set -uo pipefail
cd "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Ensure node is on PATH for pi (nvm-managed node)
NODE_BIN="$(dirname "$(ls -t "$HOME"/.nvm/versions/node/*/bin/node 2>/dev/null | head -1)" 2>/dev/null)"
[ -n "$NODE_BIN" ] && PATH="$NODE_BIN:$PATH"
export PATH
PATH="$HOME/.local/bin:$PATH"
export PATH

# gh authentication: prefer gh's own login; fall back to token file
if ! gh auth status >/dev/null 2>&1; then
    if [ -f "$HOME/.config/gh_token" ]; then
        GH_TOKEN="$(cat "$HOME/.config/gh_token")"
        export GH_TOKEN
    fi
fi

# Single-instance lock
mkdir -p .nightly
touch .nightly.lock
exec 9>.nightly.lock
if command -v flock >/dev/null 2>&1; then
    flock -n 9 || { echo "nightly.sh: another run is active; exiting"; exit 0; }
fi

LOG_DIR=".nightly"; mkdir -p "$LOG_DIR"
RAW_RC=0; INGEST_RC=0; PUSH_RC=0; PR_RC=0

# Run at most once per day (OnSuccess chain is primary; 05:30 timer is fallback)
TODAY="$(date +%F)"
if [ "$(cat "$LOG_DIR/last-run" 2>/dev/null)" = "$TODAY" ]; then
    echo "Already ran today; skipping."
    exit 0
fi
LOG="$LOG_DIR/nightly-$(date +%F).log"
exec >>"$LOG" 2>&1
START_EPOCH=$(date +%s)
BRANCH_USED="-"; COMMIT_STAT="0 files"; PROP_RC=0; PROP_STAT="no"
echo "===== $(date -Is) nightly run start (pid $$)"

# --- 1. fetch raw sources ---------------------------------------------------
./update-raw.sh --pup
RAW_RC=$?
echo "update-raw.sh exit=$RAW_RC"

# --- 2. change detection -----------------------------------------------------
manifest() {
    local r
    for r in raw/B2S/b2s-backglass.wiki \
             raw/DOF/repo \
             raw/FlexDMD/repo \
             raw/VPX/repo \
             raw/DMD-Extensions/repo \
             raw/pinscape-build-guide/repo \
             raw/ExternalWikis/dekay-vpinball-wiki/repo \
             raw/VPinballX-Starter/repo; do
        [ -d "$r" ] && printf '%s %s\n' "$r" "$(git -C "$r" rev-parse HEAD 2>/dev/null)"
    done
    # Non-git collections: stable fingerprints only.
    # PUP pages are crawled HTML with volatile embedded timestamps; fingerprint
    # the page list + sizes (new/removed/grown pages) to avoid false changes.
    [ -d raw/PUP/site ] && printf '%s %s\n' raw/PUP/site \
        "$(find raw/PUP/site -type f -printf '%P %s\n' | sort | md5sum)"
    [ -f raw/vpxtool/README.md ] && printf '%s %s\n' raw/vpxtool/README.md \
        "$(md5sum < raw/vpxtool/README.md | cut -d' ' -f1)"
    [ -d raw/pinscape-build-guide/markdown ] && printf '%s %s\n' raw/pinscape-build-guide/markdown \
        "$(find raw/pinscape-build-guide/markdown -type f -printf '%P %s\n' | sort | md5sum)"
}

NEW_MANIFEST="$(manifest)"
OLD_MANIFEST="$(cat "$LOG_DIR/manifest" 2>/dev/null || true)"
CHANGED=1
[ "$NEW_MANIFEST" = "$OLD_MANIFEST" ] && CHANGED=0

if [ "$CHANGED" -eq 0 ]; then
    echo "No upstream changes detected; skipping ingest."
fi

# --- 3. headless ingest ------------------------------------------------------
if [ "$CHANGED" -eq 1 ]; then
    if [ "${SKIP_PI:-0}" = "1" ]; then
        echo "SKIP_PI=1; ingest and push skipped."
    else
        PI_ARGS=(--print --approve --no-session)
        [ -n "${PI_MODEL:-}" ] && PI_ARGS+=(--model "$PI_MODEL")
        echo "Running pi ingest ($(date -Is))..."
        timeout "${PI_TIMEOUT:-10800}" pi "${PI_ARGS[@]}" "Nightly ingest for this VPXwiki repository. Follow AGENTS.md conventions exactly.

Context: raw/ snapshots were just refreshed by update-raw.sh; upstream git collections changed since the last run. Last ingests are recorded in wiki/log.md (grep '^## \[' wiki/log.md | tail -10).

Do this:
1. For each raw/ collection whose upstream moved, identify the changed upstream files: inside each git clone under raw/ (e.g. raw/VPX/repo, raw/DOF/repo, raw/B2S/b2s-backglass.wiki, raw/ExternalWikis/*/repo) use 'git -C <clone> log --name-status --since=\"14 days ago\"' and 'git -C <clone> diff HEAD~5 --name-only' to list recent upstream changes; for raw/PUP/site and raw/pinscape-build-guide/markdown diff content against the wiki source pages.
2. Re-ingest only the changed/affected material: update the matching wiki/sources/ page, the relevant wiki/projects/ and wiki/concepts/ pages, and wiki/index.md. Respect the source-priority tiers and the raw-citation link rules in AGENTS.md. Do not create redundant pages; merge into existing pages when they exist.
3. Append one 'ingest' entry (and 'update' entries if significant) to wiki/log.md per the log format.
4. Append-only rule: never edit past log.md entries.
5. Verify every link you added: spaces encoded as %20 in targets, never in labels; citations point to upstream URLs, never local raw/ paths.
6. New-source discovery: if you encounter authoritative documentation sources (project docs, guides, tools) that are NOT in raw/ (registered list: raw/FETCH.md), append proposals to SOURCE-PROPOSALS.md at the repo root — never modify existing lines there. Strict one-line format per proposal:
   - [NEW-SOURCE] <Project Name> | <upstream docs URL> | raw/<ProposedCollection>/ | <one-line reason>
   Dedup before proposing: skip names already present in SOURCE-PROPOSALS.md, and skip slugs already used by proposal PRs — check with: gh pr list --repo JockeJarre/VPinConsolidatedWiki --state all --limit 200 --json headRefName (proposal branches are named source/<slug>; slug = project name lowercased, non-alphanumerics collapsed to single hyphens, leading/trailing hyphens removed). Do NOT fetch, register, or ingest proposed sources yourself — humans decide.

Finish by printing a short summary: collections processed, pages created/updated, new source proposals appended, and anything skipped or flagged as a conflict." 
        INGEST_RC=$?
        echo "pi ingest exit=$INGEST_RC"
    fi
fi

# --- 3b. capture new-source proposals (pi appends SOURCE-PROPOSALS.md) -------
PROP_NEW=""
if [ -f SOURCE-PROPOSALS.md ]; then
    PROP_NEW="$LOG_DIR/proposal-new.md"
    cp SOURCE-PROPOSALS.md "$PROP_NEW"
fi

# --- 4. single NightlyUpdates branch + commit + push + PR (create if none) ---
if [ "${SKIP_PI:-0}" != "1" ]; then
    BASE="$(git rev-parse --abbrev-ref origin/HEAD)"   # e.g. origin/main
    BASE="${BASE#origin/}"                              # -> main
    git fetch origin
    git update-ref "refs/remotes/origin/$BASE" "$(git rev-parse origin/$BASE)"

    BRANCH="NightlyUpdates"

    git add wiki/
    if ! git diff --cached --quiet -- wiki/; then
        TMP="nightly-tmp-$(date +%s)"
        git switch -c "$TMP" >/dev/null
        git commit -m "Nightly ingest $(date +%F): wiki updates from refreshed raw sources" >/dev/null
        COMMIT_STAT="$(git show --shortstat --format= HEAD | tail -1 | sed 's/^ *//')"
        BRANCH_USED="$BRANCH"
        echo "Committed wiki/ changes ($(echo "$COMMIT_STAT" | awk '{print $1, $2}'))."

        if git ls-remote --exit-code --heads origin "$BRANCH" >/dev/null 2>&1; then
            git fetch origin "$BRANCH" --quiet 2>/dev/null || true
            git update-ref "refs/remotes/origin/$BRANCH" "$(git rev-parse "origin/$BRANCH")"
            TIP="$(git rev-parse "origin/$BRANCH")"
            KEEP_TMP=0
            if git merge-base --is-ancestor "$TIP" "origin/$BASE" 2>/dev/null; then
                # Branch fully merged (squash-merge rewrites history on main):
                # restart the rolling branch from base with today's commit only.
                echo "Branch fully merged; restarting $BRANCH from $BASE with today's commit."
                git branch -f "$BRANCH" "$TIP"
                git switch "$BRANCH" >/dev/null
                git reset --hard "origin/$BASE" >/dev/null
                if ! git cherry-pick "$TMP" >/dev/null 2>&1; then
                    git cherry-pick --abort 2>/dev/null || true
                    git cherry-pick --skip 2>/dev/null || true
                fi
                git push --force-with-lease origin "$BRANCH"
                PUSH_RC=$?
            else
                # Unmerged commits on branch: rebase them onto base (git drops
                # squash-applied patches automatically), then stack today's.
                git branch -f "$BRANCH" "$TIP"
                if git rebase "origin/$BASE" "$BRANCH" >/dev/null 2>&1; then
                    git switch "$BRANCH" >/dev/null
                    if git cherry-pick "$TMP" >/dev/null 2>&1; then
                        git push --force-with-lease origin "$BRANCH"
                        PUSH_RC=$?
                    else
                        git cherry-pick --abort 2>/dev/null
                        git switch "$BASE" >/dev/null
                        KEEP_TMP=1
                        echo "Cherry-pick of today's commit conflicted; kept on $TMP, not pushed."
                        PUSH_RC=1
                    fi
                else
                    git rebase --abort 2>/dev/null
                    git switch "$BASE" >/dev/null
                    KEEP_TMP=1
                    echo "Rebase of unmerged $BRANCH commits conflicted; today's commit kept on $TMP."
                    PUSH_RC=1
                fi
            fi
            if [ "$KEEP_TMP" -eq 0 ]; then
                git branch -D "$TMP" >/dev/null 2>&1
            fi
        else
            # First night: the new branch is the single updates branch
            git branch -m "$TMP" "$BRANCH"
            git push -u origin "$BRANCH"
            PUSH_RC=$?
        fi
        BRANCH_USED="$BRANCH"

        if [ "$PUSH_RC" -eq 0 ]; then
            # Growth guard: if the open PR has sat unmerged past the grace
            # window, merge it (squash + delete branch); next run starts fresh.
            GRACE="${PR_AUTO_MERGE_DAYS:-7}"
            PR_INFO="$(gh pr list --head "$BRANCH" --state open --json number,createdAt \
                -q 'if .[0] == null then "" else "\(.number) \(.createdAt)" end' 2>/dev/null || true)"
            if [ -n "$PR_INFO" ] && [ "$GRACE" -gt 0 ]; then
                PR_NUM="${PR_INFO%% *}"; PR_CREATED="${PR_INFO#* }"
                PR_EPOCH="$(date -d "$PR_CREATED" +%s 2>/dev/null || echo 0)"
                PR_AGE=$(( ( $(date +%s) - PR_EPOCH ) / 86400 ))
                if [ "$PR_EPOCH" -gt 0 ] && [ "$PR_AGE" -ge "$GRACE" ]; then
                    echo "PR #$PR_NUM unmerged for ${PR_AGE}d (grace ${GRACE}d); auto-merging."
                    gh pr merge "$PR_NUM" --squash --delete-branch
                    PR_RC=$?
                    PR_INFO=""
                fi
            fi

            # Build PR description: aggregate diff vs base + latest commit summary
            BODY_FILE="$(mktemp)"
            {
                echo "Automated nightly wiki updates (rolling branch of pi re-ingests)."
                echo "Auto-merges after ${GRACE}d unmerged."
                echo
                echo "## Total vs $BASE"
                git diff --shortstat "origin/$BASE...$BRANCH" | sed 's/^ */- /'
                git diff --name-only "origin/$BASE...$BRANCH" | head -40 | sed 's/^/- /'
                echo
                echo "## Latest run $(date +%F)"
                git log -1 --format='- %s' "$BRANCH"
                git show --shortstat --format= "$BRANCH" | tail -1 | sed 's/^ */- /'
                git show --name-status --format= "$BRANCH" | head -25 | sed 's/^/- /'
            } > "$BODY_FILE"

            OPEN_PR="$(gh pr list --head "$BRANCH" --state open --json number -q '.[0].number' 2>/dev/null || true)"
            if [ -n "$OPEN_PR" ] && [ "$OPEN_PR" != "null" ]; then
                gh pr edit "$OPEN_PR" --body-file "$BODY_FILE"
                PR_RC=$?
                echo "Open PR #$OPEN_PR for $BRANCH updated (body refreshed, exit=$PR_RC)."
            else
                gh pr create --base "$BASE" --head "$BRANCH" \
                    --title "Nightly wiki updates" --body-file "$BODY_FILE"
                PR_RC=$?
                echo "PR created (exit=$PR_RC)"
            fi
            rm -f "$BODY_FILE"
        fi
        # Return main to pristine upstream state for the next run
        git switch "$BASE" >/dev/null 2>&1 || true
        git reset --hard "origin/$BASE" >/dev/null
    else
        echo "No wiki/ changes; branch/PR untouched."
    fi
fi

# --- 4b. source proposals: ONE branch + PR per proposal (each mergeable /
#      closable independently; no auto-merge). Accepted proposals land in the
#      registry SOURCE-PROPOSALS.md on main. ------------------------------------
if [ -n "$PROP_NEW" ] && [ "${SKIP_PI:-0}" != "1" ]; then
    REG="SOURCE-PROPOSALS.md"
    git show "origin/$BASE:$REG" > "$LOG_DIR/registry-main.md" 2>/dev/null || : > "$LOG_DIR/registry-main.md"
    touch "$LOG_DIR/proposed.log"
    NEW_LINES="$(grep '^\- \[NEW-SOURCE\]' "$PROP_NEW" 2>/dev/null \
        | grep -F -x -v -f "$LOG_DIR/registry-main.md" \
        | grep -F -x -v -f "$LOG_DIR/proposed.log" || true)"
    PROP_OK=0
    while IFS= read -r line; do
        [ -z "$line" ] && continue
        git switch "$BASE" >/dev/null 2>&1 || true
        git reset --hard "origin/$BASE" >/dev/null
        NAME="$(printf '%s\n' "$line" | sed -E 's/^- \[NEW-SOURCE\] ([^|]+)\|.*/\1/' | sed -E 's/[[:space:]]+$//')"
        SLUG="$(printf '%s' "$NAME" | tr '[:upper:]' '[:lower:]' | sed -E 's/[^a-z0-9]+/-/g; s/^-+//; s/-+$//')"
        PBRANCH="source/$SLUG"
        if [ -z "$SLUG" ] || git ls-remote --exit-code --heads origin "$PBRANCH" >/dev/null 2>&1; then
            printf '%s\n' "$line" >> "$LOG_DIR/proposed.log"
            echo "Proposal '$NAME': slug empty or branch $PBRANCH already on origin; skipped."
            continue
        fi
        if [ ! -f "$REG" ]; then
            echo "Registry $REG missing on $BASE; cannot propose."
            PROP_RC=1
            continue
        fi
        git switch -C "$PBRANCH" "origin/$BASE" >/dev/null
        printf '%s\n' "$line" >> "$REG"
        git add "$REG"
        git commit -m "Propose new source: $NAME" >/dev/null
        git push -u origin "$PBRANCH" >/dev/null; push1=$?
        BODY_FILE="$(mktemp)"
        {
            echo "## New source proposal (nightly scan)"
            echo
            echo "$line"
            echo
            echo "**Accept:** merge this PR (squash + delete branch) — the proposal enters the registry on main. Then register the collection: update-raw.sh/.ps1 fetch step, raw/<Name>/FETCH.md + raw/FETCH.md table row, AGENTS.md tier + upstream URL mapping (the assistant can do this on request)."
            echo
            echo "**Reject:** close the PR and delete the branch — nothing lands on main."
        } > "$BODY_FILE"
        gh pr create --base "$BASE" --head "$PBRANCH" \
            --title "New source: $NAME" --body-file "$BODY_FILE" >/dev/null
        prc2=$?
        rm -f "$BODY_FILE"
        if [ "$push1" -eq 0 ] && [ "$prc2" -eq 0 ]; then
            PROP_OK=$((PROP_OK+1))
        else
            PROP_RC=1
        fi
        printf '%s\n' "$line" >> "$LOG_DIR/proposed.log"
        echo "Proposal '$NAME' -> $PBRANCH (push=$push1 pr=$prc2)"
        git switch "$BASE" >/dev/null 2>&1 || true
        git reset --hard "origin/$BASE" >/dev/null
    done <<< "$NEW_LINES"
    PROP_STAT="$PROP_OK proposal PR(s)"
    rm -f "$PROP_NEW"
fi

# Persist manifest only when the pipeline succeeded (retry on failure next night)
if [ "$INGEST_RC" -eq 0 ] && [ "$PUSH_RC" -eq 0 ] && [ "$PR_RC" -eq 0 ] && [ "$PROP_RC" -eq 0 ]; then
    printf '%s\n' "$NEW_MANIFEST" > "$LOG_DIR/manifest"
    printf '%s\n' "$TODAY" > "$LOG_DIR/last-run"
    echo "Manifest updated."
else
    echo "Pipeline incomplete; manifest NOT updated (will re-ingest next run)."
fi

# Keep 14 days of logs
find "$LOG_DIR" -name 'nightly-*.log' -mtime +14 -delete 2>/dev/null

# Uncommitted run metrics: files changed + total duration (.nightly/ is gitignored)
DURATION=$(( $(date +%s) - START_EPOCH ))
printf '%s | duration=%ss | %s | branch=%s | proposals=%s | rc raw/ingest/push/pr/prop=%s/%s/%s/%s/%s\n' \
    "$(date -Is)" "$DURATION" "$COMMIT_STAT" "$BRANCH_USED" "$PROP_STAT" \
    "$RAW_RC" "$INGEST_RC" "$PUSH_RC" "$PR_RC" "$PROP_RC" >> "$LOG_DIR/metrics.log"

echo "===== $(date -Is) nightly run done"
