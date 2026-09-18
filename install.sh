#!/usr/bin/env bash
# Installs the sudo-timer command into ~/.local/bin.
set -euo pipefail

src=$(dirname "$(realpath "$0")")
dest=${XDG_BIN_HOME:-$HOME/.local/bin}

mkdir -p "$dest"
install -m 755 "$src/bin/sudo-timer" "$dest/sudo-timer"
echo "Installed $dest/sudo-timer"

case ":$PATH:" in
  *":$dest:"*) ;;
  *) echo "Note: $dest is not on your PATH." >&2 ;;
esac

cat <<'TXT'

Optional Omarchy integration (not applied automatically):
  integration/menu.jsonc     -> ~/.config/omarchy/extensions/omarchy-menu.jsonc
  integration/bindings.lua   -> ~/.config/hypr/bindings.lua
TXT
