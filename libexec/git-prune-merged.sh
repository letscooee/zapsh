#!/usr/bin/env bash
# Delete local branches already merged into the base branch, by merge or squash merge.
# A merged branch checked out in another worktree has that worktree removed first, unless it has local changes.
#
# Usage: gbprune [-n|--dry-run] [base-branch]
set -eo pipefail

usage() { echo "Usage: gbprune [-n|--dry-run] [base-branch]"; }

dry=false
base=""

while [[ $# -gt 0 ]]; do
    case $1 in
        -n|--dry-run) dry=true ;;
        -h|--help) usage; exit 0 ;;
        -*) usage >&2; exit 1 ;;
        *) base=$1 ;;
    esac
    shift
done

git rev-parse --git-dir >/dev/null 2>&1 || { echo "Not inside a git repository" >&2; exit 1; }

if [[ -z $base ]]; then
    for candidate in main master; do
        git show-ref --quiet --verify "refs/heads/$candidate" && { base=$candidate; break; }
    done
fi
git show-ref --quiet --verify "refs/heads/$base" 2>/dev/null || { echo "Base branch [$base] not found; pass one explicitly" >&2; exit 1; }

# Forget worktrees whose folders no longer exist; they block branch deletion
[[ $dry == true ]] || git worktree prune

current=$(git branch --show-current)
here=$(git rev-parse --show-toplevel)

worktree_of() {
    git worktree list --porcelain | awk -v ref="refs/heads/$1" '
        /^worktree / { path = substr($0, 10) }
        $0 == "branch " ref { print path; exit }'
}

is_merged() {
    git merge-base --is-ancestor "$1" "$base" && return 0
    # Squash merge: a single commit with the branch's full diff is already in base
    local merge_base squashed
    merge_base=$(git merge-base "$base" "$1") || return 1
    squashed=$(git commit-tree "$1^{tree}" -p "$merge_base" -m _)
    [[ $(git cherry "$base" "$squashed") == -* ]]
}

deleted=0
skipped=0
kept=0

while read -r branch; do
    case $branch in "$base"|main|master|develop|dev|"$current") continue ;; esac
    if ! is_merged "$branch"; then
        echo -e "${BLUE:-}keep   $branch ($(git rev-list --count "$base..$branch") commit(s) not in $base)${NONE:-}"
        kept=$((kept + 1))
        continue
    fi

    worktree=$(worktree_of "$branch")
    if [[ -n $worktree && $worktree != "$here" ]]; then
        if [[ -n $(git -C "$worktree" status --porcelain 2>/dev/null) ]]; then
            echo -e "${YELLOW:-}skip   $branch (worktree $worktree has local changes)${NONE:-}"
            skipped=$((skipped + 1))
            continue
        fi
        if [[ $dry == true ]]; then
            echo "would delete $branch and its worktree $worktree"
            deleted=$((deleted + 1))
            continue
        fi
        if ! git worktree remove "$worktree" 2>/dev/null; then
            echo -e "${YELLOW:-}skip   $branch (couldn't remove worktree $worktree)${NONE:-}"
            skipped=$((skipped + 1))
            continue
        fi
        echo "removed worktree $worktree"
    fi

    if [[ $dry == true ]]; then
        echo "would delete $branch"
    else
        git branch --quiet -D "$branch" && echo -e "${GREEN:-}delete $branch${NONE:-}"
    fi
    deleted=$((deleted + 1))
done < <(git for-each-ref refs/heads/ --format='%(refname:short)')

verb=$([[ $dry == true ]] && echo "Would delete" || echo "Deleted")
echo "$verb $deleted branch(es) merged into [$base]; skipped $skipped with local changes; kept $kept unmerged."
