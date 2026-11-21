# Zapsh

> We believe in saving time. **Although in seconds, but matters!**
 
This repository containing necessary & useful shell scripts & bash aliases which we use on day to day life as software engineer & 
developers.

## Installation

```bash
curl -fsSL https://raw.githubusercontent.com/letscooee/zapsh/main/install.sh | bash
```

This clones zapsh into `~/.zapsh` and adds one `source` line to your `~/.zshrc` or `~/.bashrc`. Open a new terminal and run
`all` to list every alias.

```bash
zapsh version     # installed version
zapsh update      # pull the latest and reload
zapsh uninstall   # remove zapsh and its rc line
```

To install somewhere else, set `ZAPSH_DIR`:

```bash
curl -fsSL https://raw.githubusercontent.com/letscooee/zapsh/main/install.sh | ZAPSH_DIR=~/code/zapsh bash
```

### oh-my-zsh

```bash
git clone https://github.com/letscooee/zapsh.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zapsh
```

Then add `zapsh` to `plugins=(...)` in `~/.zshrc`.

### Manual

Clone the repo anywhere and add `source /path/to/zapsh/zapsh.sh` to your shell rc file.

### Optional

Set `WORK_DIRECTORY` to the folder holding all your git repositories. Database dumps then go to
`$WORK_DIRECTORY/database-backups`; set `DB_BACKUP_DIRECTORY` to choose another folder.

## Layout

| Path | What's in it |
|---|---|
| `zapsh.sh` | Entry point you source from your shell rc |
| `zapsh.plugin.zsh` | Entry point for oh-my-zsh and other zsh plugin managers |
| `install.sh` | The curl installer |
| `CHANGELOG.md` | Release notes for each version |
| `aliases/` | One file of aliases per tool, all loaded automatically (`mac.sh` only on macOS) |
| `bin/` | Commands added to your `PATH` |
| `libexec/` | Helper scripts called by aliases, not meant to be run directly |
| `docs/` | Usage docs for the commands |

Run `all` to print every alias. See [docs/commands.md](docs/commands.md) for the commands that do more than one thing (`gc`, `gpush`, `sqld` and others).

## Releasing

Releases are automated with [release-please](https://github.com/googleapis/release-please). Write commit messages as
[Conventional Commits](https://www.conventionalcommits.org/): `fix:` bumps the patch version, `feat:` the minor version,
and `feat!:` or a `BREAKING CHANGE:` footer the major version. release-please keeps a release PR open with the next
version and its `CHANGELOG.md` entry; merging it tags the release and publishes it on GitHub.

The workflow publishes releases with a `RELEASE_PLEASE_TOKEN` repository secret, because the organization's rules stop
the built-in Actions token from creating tags. Use a fine-grained personal access token scoped to this repository with
**Contents** and **Pull requests** set to read and write, owned by someone the tag rule lets through.
