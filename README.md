# Zapsh

> We believe in saving time. **Although in seconds, but matters!**
 
This repository containing necessary & useful shell scripts & bash aliases which we use on day to day life as software engineer & 
developers.

This shell tool assumes that you keep all your repositories in a common directory which is termed as **your work directory**

## Installation

Before using zapsh for the first time, you need to set it up, **which is a few liner**:

```bash
git clone https://github.com/letscooee/zapsh.git ${WORK_DIRECTORY}/zapsh
```

```bash
export WORK_DIRECTORY=/path/to/all/git/repositories
source ${WORK_DIRECTORY}/zapsh/zapsh.sh
```

Add the above line either in your `~/.bashrc` or `~/.zshrc` file and reload it by `source ~/.bashrc` or `source ~/.zshrc` or open a new 
terminal to put the zapsh in effect.

## Layout

| Path | What's in it |
|---|---|
| `zapsh.sh` | Entry point you source from your shell rc |
| `aliases/` | One file of aliases per tool, all loaded automatically (`mac.sh` only on macOS) |
| `bin/` | Commands added to your `PATH` |
| `libexec/` | Helper scripts called by aliases, not meant to be run directly |

Run `all` to print every alias.
