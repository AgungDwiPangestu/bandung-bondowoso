#!/bin/bash

# Auto Git Push - Per File, 1 commit per file
# Usage: ./push.sh "commit message"

COMMIT_MSG="${1:-auto update}"
BRANCH=$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo "main")

echo "🚀 Auto Git Push"
echo "=========================================="
echo " Branch  : $BRANCH"
echo " Message : $COMMIT_MSG"
echo "=========================================="

if ! git rev-parse --git-dir > /dev/null 2>&1; then
    echo "❌ Not a git repository!"
    exit 1
fi

echo "🔍 Repository status:"
git status --short
echo ""

COUNT=0

# ── Detect commit type from filename / path ──────────────────────────────────
get_type() {
    local file="$1"
    local status="$2"

    case "$status" in
        D) echo "delete" ; return ;;
    esac

    # Path-based heuristics
    if [[ "$file" == *.sol ]];                        then echo "feat"     ; return; fi
    if [[ "$file" == *test* || "$file" == *spec* ]];  then echo "test"     ; return; fi
    if [[ "$file" == *.md ]];                         then echo "docs"     ; return; fi
    if [[ "$file" == *.env* || "$file" == *.toml || "$file" == *.json || "$file" == *.yaml || "$file" == *.yml ]]; then
                                                       echo "chore"    ; return; fi
    if [[ "$file" == *style* || "$file" == *.css ]];  then echo "style"    ; return; fi
    if [[ "$file" == *config* ]];                     then echo "chore"    ; return; fi
    if [[ "$file" == *refactor* ]];                   then echo "refactor" ; return; fi

    # Status-based fallback
    case "$status" in
        A|"??") echo "feat"   ;;
        M)      echo "refactor" ;;
        *)      echo "chore"  ;;
    esac
}

# ── Process all changed files (no subshell — uses process substitution) ──────
while IFS= read -r line; do
    [[ -z "$line" ]] && continue

    STATUS="${line:0:2}"
    FILE="${line:3}"

    # Trim leading space from status
    STATUS_CLEAN="${STATUS// /}"

    TYPE=$(get_type "$FILE" "$STATUS_CLEAN")

    case "$STATUS_CLEAN" in
        D)
            echo " delete  → $FILE"
            git rm --cached "$FILE" 2>/dev/null || git rm "$FILE" 2>/dev/null
            git commit -m "$TYPE($FILE): $COMMIT_MSG"
            ;;
        M)
            echo " modify  → $FILE"
            git add "$FILE"
            git commit -m "$TYPE($FILE): $COMMIT_MSG"
            ;;
        A|"??")
            echo " add     → $FILE"
            git add "$FILE"
            git commit -m "$TYPE($FILE): $COMMIT_MSG"
            ;;
        R*)
            # Renamed: "old -> new"
            echo " rename  → $FILE"
            git add "$FILE"
            git commit -m "refactor($FILE): rename - $COMMIT_MSG"
            ;;
        *)
            echo " $STATUS_CLEAN → $FILE"
            git add "$FILE"
            git commit -m "chore($FILE): $COMMIT_MSG"
            ;;
    esac

    COUNT=$((COUNT + 1))

done < <(git status --short)

# ── Push ─────────────────────────────────────────────────────────────────────
echo ""

# Check if there are local commits to push
LOCAL_AHEAD=$(git rev-list --count origin/"$BRANCH".."$BRANCH" 2>/dev/null || echo "0")

if [ "$COUNT" -gt 0 ] || [ "$LOCAL_AHEAD" -gt 0 ]; then
    if [ "$LOCAL_AHEAD" -gt 0 ]; then
        echo "📤 Local branch is ahead by $LOCAL_AHEAD commit(s)."
    fi
    echo "📤 Pushing to origin/$BRANCH..."
    if git push origin "$BRANCH"; then
        echo "=========================================="
        echo "✅ Done! $COUNT commit(s) pushed."
        echo "=========================================="
    else
        echo "=========================================="
        echo "❌ Push failed!"
        echo "=========================================="
        exit 1
    fi
else
    echo "=========================================="
    echo " Nothing to commit. Working tree clean."
    echo "=========================================="
fi