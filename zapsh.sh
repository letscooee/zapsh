# shellcheck shell=bash
# zapsh entry point. Source it from ~/.bashrc or ~/.zshrc; don't execute it.

# Colors, exported for the scripts in bin/ and libexec/
export NONE='\033[00m'
export RED='\033[01;31m'
export GREEN='\033[01;32m'
export YELLOW='\033[01;33m'
export BLUE='\033[0;36m'
export BOLD='\033[1m'
export UNDERLINE='\033[4m'

# Resolve from this file's location so the clone folder can have any name (bash: BASH_SOURCE, zsh: %x)
export ZAPSH_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-${(%):-%x}}")" && pwd)"
export DB_BACKUP_DIRECTORY="${DB_BACKUP_DIRECTORY:-$WORK_DIRECTORY/database-backups}"

# Prepend bin/ once, even if this file is sourced again
case ":$PATH:" in
    *":$ZAPSH_DIR/bin:"*) ;;
    *) export PATH="$ZAPSH_DIR/bin:$PATH" ;;
esac

# Load every alias file; mac.sh only on macOS
for _zapsh_file in "$ZAPSH_DIR"/aliases/*.sh; do
    [[ $_zapsh_file == */mac.sh && $OSTYPE != darwin* ]] && continue
    . "$_zapsh_file"
done
unset _zapsh_file

# Print all aliases (uses https://github.com/sharkdp/bat when installed)
all() {
    local file
    for file in "$ZAPSH_DIR"/aliases/*.sh; do
        echo -e "\n${GREEN}$(basename "$file" .sh) aliases${NONE}"
        if command -v bat >/dev/null; then bat --paging=never "$file"; else cat "$file"; fi
    done
    echo -e "\n${GREEN}https://github.com/ohmyzsh/ohmyzsh/blob/master/plugins/git/README.md${NONE}"
}
