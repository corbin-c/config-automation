#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
DOTFILES="$ROOT/dotfiles"
if (($# == 0)); then echo "Usage: $0 stow-package [stow-package ...]" >&2; exit 2; fi
command -v stow >/dev/null || { echo "GNU Stow is not installed. Install package 'stow' first." >&2; exit 1; }

BACKUP_BASE="${XDG_STATE_HOME:-$HOME/.local/state}/workstation-backups"
BACKUP_ROOT=""
BACKED_UP=0

backup_path() {
  local path="$1" rel="$2"
  [[ -e "$path" || -L "$path" ]] || return 0
  if [[ -z "$BACKUP_ROOT" ]]; then
    mkdir -p "$BACKUP_BASE"
    BACKUP_ROOT="$(mktemp -d "$BACKUP_BASE/$(date +%Y%m%d-%H%M%S)-XXXXXX")"
  fi
  local destination="$BACKUP_ROOT/$rel"
  mkdir -p "$(dirname "$destination")"
  mv -- "$path" "$destination"
  printf 'Backed up conflict: %s -> %s\n' "$path" "$destination"
  BACKED_UP=1
}

for package in "$@"; do
  source_dir="$DOTFILES/$package"
  [[ -d "$source_dir" ]] || { echo "Unknown Stow package: $package" >&2; exit 1; }

  # Retire the previous Manjaro Zsh indirection without touching /etc/zsh.
  if [[ "$package" == zsh ]]; then
    for legacy in "$HOME/.zshrc" "$HOME/.config/.zshrc"; do
      if [[ -e "$legacy" || -L "$legacy" ]]; then
        backup_path "$legacy" "${legacy#"$HOME"/}"
      fi
    done
  fi

  # Back up only exact file/link collisions. Existing directories and unrelated
  # files remain in place; repeated installs therefore do not move app state.
  while IFS= read -r -d '' source_file; do
    rel="${source_file#"$source_dir"/}"
    target="$HOME/$rel"
    parent="$(dirname "$target")"
    while [[ "$parent" != "$HOME" && "$parent" == "$HOME"/* ]]; do
      if { [[ -e "$parent" ]] || [[ -L "$parent" ]]; } && { [[ ! -d "$parent" ]] || [[ -L "$parent" ]]; }; then
        backup_path "$parent" "${parent#"$HOME"/}"
      fi
      parent="$(dirname "$parent")"
    done
    if [[ -e "$target" || -L "$target" ]]; then
      if [[ -L "$target" ]] && [[ "$(readlink -f -- "$target" 2>/dev/null || true)" == "$(readlink -f -- "$source_file")" ]]; then
        continue
      fi
      backup_path "$target" "$rel"
    fi
  done < <(find "$source_dir" \( -type f -o -type l \) -print0)

  stow --no-folding --restow --dir="$DOTFILES" --target="$HOME" "$package"
done

if ((BACKED_UP)); then echo "Conflicting files were preserved under: $BACKUP_ROOT"; fi
