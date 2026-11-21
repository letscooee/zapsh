#!/usr/bin/env bash
# Check out a branch or tag, fetching from the remote when it isn't known locally.
# If the branch is already checked out in another worktree, report that worktree's path instead.
#
# Usage: gc [-f|--force] <branch-or-tag> [remote]
#   -f, --force  Delete the local branch and its remote-tracking ref, then fetch it fresh
#
# The path of a worktree to switch to is written to fd 3 when it is open (the gc shell function cds there).
set -eo pipefail

usage() { echo "Usage: gc [-f|--force] <branch-or-tag> [remote]"; }
info() { echo -e "${BLUE:-}$*${NONE:-}"; }
fail() { echo -e "${RED:-}$*${NONE:-}" >&2; exit 1; }

name=""
remote=origin
force=false
fetched=false

while [[ $# -gt 0 ]]; do
    case $1 in
        -f|--force) force=true ;;
        -h|--help) usage; exit 0 ;;
        -*) usage >&2; exit 1 ;;
        *) if [[ -z $name ]]; then name=$1; else remote=$1; fi ;;
    esac
    shift
done

[[ -n $name ]] || { usage >&2; exit 1; }
git rev-parse --git-dir >/dev/null 2>&1 || fail "Not inside a git repository"

fetch() {
    info "Fetching from [$remote]..."
    git fetch --quiet --tags "$remote"
    fetched=true
}

# Path of the worktree that has branch $1 checked out, if any
worktree_of() {
    git worktree list --porcelain | awk -v ref="refs/heads/$1" '
        /^worktree / { path = substr($0, 10) }
        $0 == "branch " ref { print path; exit }'
}

here=$(git rev-parse --show-toplevel)
worktree=$(worktree_of "$name")

if [[ $force == true ]]; then
    echo -e "${YELLOW:-}Force flag set. Cleaning up existing references for [$name]...${NONE:-}"

    if [[ -n $worktree && $worktree != "$here" ]]; then
        fail "[$name] is checked out in worktree $worktree. Remove it first: git worktree remove \"$worktree\""
    fi

    if [[ $(git branch --show-current) == "$name" ]]; then
        info "Currently on [$name]. Switching to main/master first..."
        git checkout --quiet main 2>/dev/null || git checkout --quiet master 2>/dev/null ||
            fail "Cannot switch away from [$name]. Check out a different branch first."
    fi

    if git show-ref --quiet --verify "refs/heads/$name"; then
        info "Deleting local branch [$name]..."
        git branch --quiet -D "$name"
    fi

    if git show-ref --quiet --verify "refs/remotes/$remote/$name"; then
        info "Deleting remote-tracking ref [$remote/$name]..."
        git branch --quiet -rd "$remote/$name"
    fi

    fetch
    worktree=""
fi

# Branch already checked out in another worktree: git can't check it out here, so point there instead
if [[ -n $worktree ]]; then
    if [[ $worktree == "$here" ]]; then
        info "Already on [$name]"
    else
        echo -e "${GREEN:-}[$name] is checked out in worktree: $worktree${NONE:-}"
        { echo "$worktree" >&3; } 2>/dev/null || echo "cd \"$worktree\""
    fi
    exit 0
fi

has_local() { git rev-parse --quiet --verify "$name^{commit}" >/dev/null; }
has_remote() { git show-ref --quiet --verify "refs/remotes/$remote/$name"; }

if ! has_local && ! has_remote && [[ $fetched == false ]]; then
    info "[$name] not found locally"
    fetch
fi

if git show-ref --quiet --verify "refs/heads/$name" || git show-ref --quiet --verify "refs/tags/$name"; then
    echo -e "${GREEN:-}Checking out [$name]${NONE:-}"
    git checkout "$name"
elif has_remote; then
    info "Creating [$name] from [$remote/$name]"
    git checkout --track -b "$name" "$remote/$name"
elif has_local; then
    # A commit SHA or another ref git can resolve
    git checkout "$name"
else
    fail "No branch or tag named [$name] locally or on [$remote]"
fi
