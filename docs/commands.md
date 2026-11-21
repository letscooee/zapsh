# Commands

Plain aliases are self-explanatory; run `all` to list them. This page covers the commands that do more than expand to
one other command.

## `gc`: check out a branch or tag

```bash
gc [-f|--force] <branch-or-tag> [remote]
```

Checks out a branch or tag, fetching from the remote (default `origin`) when it isn't known locally.

| Situation | What `gc` does |
|---|---|
| Local branch or tag exists | Checks it out |
| Only `remote/branch` exists | Creates a local branch tracking it |
| Not found anywhere locally | Fetches the remote (with tags) once, then tries again |
| Branch is checked out in another worktree | `cd`s into that worktree, since git won't check out one branch twice |
| Already on the branch in this worktree | Does nothing |

`-f`, `--force` throws away your local copy of the branch and gets a fresh one from the remote: it switches to
`main`/`master` if you're on the branch, deletes the local branch and its remote-tracking ref, fetches, and checks it out
again. It refuses if the branch is checked out in another worktree.

```bash
gc feature/login          # check out, fetching if needed
gc v1.2.0                 # check out a tag (detached HEAD)
gc feature/login upstream # use the "upstream" remote
gc -f feature/login       # reset to the remote's version
```

`gc` is a shell function so it can change your directory. Run `libexec/git-checkout.sh` directly and it prints the
`cd` command instead.

> zapsh's `gc` replaces oh-my-zsh's `gc` (`git commit --verbose`). Use `git commit -v` or another alias for that.

## `gbprune`: delete merged branches, worktrees included

```bash
gbprune [-n|--dry-run] [base-branch]
```

Deletes every local branch already merged into the base branch (default `main`, else `master`), whether it was merged
normally or squash-merged.

- Never touches the base branch, `main`, `master`, `develop`, `dev` or the branch you're on.
- A merged branch checked out in another worktree has that worktree removed first. If the worktree has uncommitted or
  untracked changes, the branch is skipped and reported.
- Unmerged branches are kept and listed with how many of their commits aren't in the base branch.
- Worktrees whose folders were already deleted are pruned first, so they no longer block branch deletion.
- `-n`, `--dry-run` lists what would be deleted without changing anything.

```bash
gbprune -n        # preview
gbprune           # delete branches merged into main
gbprune develop   # delete branches merged into develop
```

> A branch with no commits of its own (for example, one just created for a new worktree) counts as merged. Preview
> with `-n` if you have fresh worktrees you're about to use.

Unlike oh-my-zsh's `gbda` and `gbds`, it handles both kinds of merge in one pass and doesn't stop at branches checked
out in worktrees.

## `gpush` / `gpull`: push or pull the current branch

```bash
gpush [remote] [-f]
gpull [remote] [-f]
```

Runs `git push|pull <remote> <current-branch>`. The remote defaults to `origin`; `-f` adds `--force`.

## `gtd`: delete a tag everywhere

```bash
gtd <tag>
```

Deletes the tag locally and on `origin`.

## `sqld`: dump a MySQL database

```bash
sqld <database>
```

Writes `<database>-<date>_<time>.sql` into `$DB_BACKUP_DIRECTORY` (default `$WORK_DIRECTORY/database-backups`).

## `rnab`: build a React Native Android debug APK

```bash
rnab      # build, then open the APK folder
rnab i    # build, then install with adb
```

Run from the React Native project root. Cleans the drawable folders, bundles JS and runs `./gradlew assembleDebug`.

## `grails`: use the project's Grails version

`bin/grails` sits ahead of SDKMAN's `grails` on your `PATH`. Inside a project with a `gradle.properties`, it runs the
`grailsVersion` set there from `~/.sdkman/candidates/grails/<version>`; elsewhere it runs SDKMAN's current Grails.

## `zapsh`: manage zapsh

```bash
zapsh version     # installed version
zapsh update      # pull the latest and reload
zapsh uninstall   # remove zapsh and its rc line
```

## `all`: list every alias

Prints each file in `aliases/`, using [bat](https://github.com/sharkdp/bat) when installed.
