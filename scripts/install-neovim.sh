#!/usr/bin/env bash
set -euo pipefail
if command -v nvim >/dev/null 2>&1; then
  version="$(nvim --version | head -n1)"
  echo "Neovim already installed: $version"
  if [[ "$(printf '%s\n%s\n' 'NVIM v0.11.2' "$version" | sort -V | head -n1)" != "NVIM v0.11.2" ]]; then
    echo "The installed version is older than the current LazyVim requirement (>= 0.11.2)." >&2
    echo "No replacement was installed automatically; resolve the existing Neovim package first." >&2
    exit 1
  fi
  exit 0
fi
if ! command -v snap >/dev/null 2>&1; then
  echo "snap is unavailable. Install a Neovim build >= 0.11.2, then rerun the dotfile deployment." >&2
  exit 1
fi
sudo snap install nvim --classic
