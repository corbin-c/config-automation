#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
DOTFILES="$ROOT/dotfiles"
if (($# == 0)); then
  echo "Usage: $0 stow-package [stow-package ...]" >&2
  exit 2
fi
command -v stow >/dev/null || { echo "GNU Stow is not installed. Install package 'stow' first." >&2; exit 1; }

BACKUP_BASE="${XDG_STATE_HOME:-$HOME/.local/state}/workstation-backups"
BACKUP_ROOT=""
BACKED_UP=0

backup_path() {
  local path="$1" rel="$2"
  if [[ -z "$BACKUP_ROOT" ]]; then
    mkdir -p "$BACKUP_BASE"
    BACKUP_ROOT="$(mktemp -d "$BACKUP_BASE/$(date +%Y%m%d-%H%M%S)-XXXXXX")"
  fi
  local destination="$BACKUP_ROOT/$rel"
  mkdir -p "$(dirname "$destination")"
  mv -- "$path" "$destination"
  printf 'Backed up %s -> %s\n' "$path" "$destination"
  BACKED_UP=1
}

for package in "$@"; do
  source_dir="$DOTFILES/$package"
  [[ -d "$source_dir" ]] || { echo "Unknown Stow package: $package" >&2; exit 1; }

  # App config directories are exclusively managed by their Stow package.
  # Back up the whole directory first so stale, untracked fragments cannot
  # remain active through application include globs (notably Sway and Zsh).
  case "$package" in
    sway) exclusive_roots=(.config/sway .config/swaylock) ;;
    waybar) exclusive_roots=(.config/waybar) ;;
    rofi) exclusive_roots=(.config/rofi) ;;
    foot) exclusive_roots=(.config/foot) ;;
    mako) exclusive_roots=(.config/mako) ;;
    zsh) exclusive_roots=(.config/zsh) ;;
    neovim) exclusive_roots=(.config/nvim) ;;
    btop) exclusive_roots=(.config/btop) ;;
    *) exclusive_roots=() ;;
  esac

  if [[ "$package" == zsh ]]; then
    # Remove the old home-level symlink and its Manjaro-generated target.
    for legacy in "$HOME/.zshrc" "$HOME/.config/.zshrc"; do
      if [[ -e "$legacy" || -L "$legacy" ]]; then
        rel="${legacy#"$HOME"/}"
        backup_path "$legacy" "$rel"
      fi
    done
  fi

  for rel in "${exclusive_roots[@]}"; do
    target="$HOME/$rel"
    if [[ -e "$target" || -L "$target" ]]; then
      expected="$source_dir/$rel"
      if [[ -L "$target" ]] && [[ "$(readlink -f -- "$target" 2>/dev/null || true)" == "$(readlink -f -- "$expected" 2>/dev/null || true)" ]]; then
        continue
      fi
      backup_path "$target" "$rel"
    fi
  done

  # Preserve only exact collisions for shared paths such as ~/.local/bin.
  while IFS= read -r -d '' source_file; do
    rel="${source_file#"$source_dir"/}"
    target="$HOME/$rel"

    parent="$(dirname "$target")"
    while [[ "$parent" != "$HOME" && "$parent" == "$HOME"/* ]]; do
      if { [[ -e "$parent" ]] || [[ -L "$parent" ]]; } && [[ ! -d "$parent" || -L "$parent" ]]; then
        parent_rel="${parent#"$HOME"/}"
        backup_path "$parent" "$parent_rel"
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

  # No-folding keeps application config directories real, so generated state
  # is written in $HOME rather than into the Git checkout.
  stow --no-folding --restow --dir="$DOTFILES" --target="$HOME" "$package"
done

if ((BACKED_UP)); then
  echo "Existing files were preserved under: $BACKUP_ROOT"
fi
