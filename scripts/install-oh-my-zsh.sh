#!/usr/bin/env bash
set -euo pipefail
DEST="${XDG_DATA_HOME:-$HOME/.local/share}/oh-my-zsh"
if [[ -d "$DEST/.git" ]]; then
  echo "Oh My Zsh already present at $DEST (not updating it automatically)."
  exit 0
fi
if [[ -e "$DEST" ]]; then
  echo "Refusing to overwrite existing non-Git path: $DEST" >&2
  exit 1
fi
command -v git >/dev/null || { echo "git is required to install Oh My Zsh." >&2; exit 1; }
mkdir -p "$(dirname "$DEST")"
git clone --depth=1 https://github.com/ohmyzsh/ohmyzsh.git "$DEST"
echo "Installed Oh My Zsh at $DEST"
