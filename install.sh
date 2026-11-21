#!/usr/bin/env bash
# Install or update zapsh:
#   curl -fsSL https://raw.githubusercontent.com/letscooee/zapsh/main/install.sh | bash
# Env overrides: ZAPSH_DIR (install location), ZAPSH_REPO (git URL to clone)
set -euo pipefail

ZAPSH_DIR="${ZAPSH_DIR:-$HOME/.zapsh}"
ZAPSH_REPO="${ZAPSH_REPO:-https://github.com/letscooee/zapsh.git}"

command -v git >/dev/null || { echo "zapsh: git is required" >&2; exit 1; }

if [[ -d "$ZAPSH_DIR/.git" ]]; then
    echo "Updating zapsh in $ZAPSH_DIR"
    git -C "$ZAPSH_DIR" pull --ff-only --quiet
else
    echo "Installing zapsh into $ZAPSH_DIR"
    git clone --quiet "$ZAPSH_REPO" "$ZAPSH_DIR"
fi

case "$(basename "${SHELL:-}")" in
    zsh) rc="$HOME/.zshrc" ;;
    bash) rc="$HOME/.bashrc" ;;
    *) echo "zapsh supports bash and zsh. From either, run: source \"$ZAPSH_DIR/zapsh.sh\""; exit 0 ;;
esac

# ponytail: any existing zapsh.sh line counts as installed (covers custom paths and the oh-my-zsh plugin)
if grep -qs "zapsh" "$rc"; then
    echo "$rc already loads zapsh"
else
    printf '\n# zapsh\nsource "%s/zapsh.sh"\n' "${ZAPSH_DIR/#$HOME/\$HOME}" >> "$rc"
    echo "Added zapsh to $rc"
fi

echo "Done. Open a new terminal, then run 'all' to list every alias."
