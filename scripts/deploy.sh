#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
DOTFILES="$ROOT/dotfiles"
BACKUP_BASE="${XDG_STATE_HOME:-$HOME/.local/state}/sway-workstation-backups"
BACKUP_ROOT=""

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
  printf 'Backed up existing path: %s -> %s\n' "$path" "$destination"
}

for package_dir in "$DOTFILES"/*; do
  [[ -d "$package_dir" ]] || continue
  while IFS= read -r -d '' source_file; do
    rel="${source_file#"$package_dir"/}"
    target="$HOME/$rel"
    parent="$(dirname "$target")"

    # If an ancestor is a file or broken symlink, preserve it before creating a directory.
    while [[ "$parent" != "$HOME" && "$parent" == "$HOME"/* ]]; do
      if { [[ -e "$parent" ]] || [[ -L "$parent" ]]; } && [[ ! -d "$parent" ]]; then
        backup_path "$parent" "${parent#"$HOME"/}"
      fi
      parent="$(dirname "$parent")"
    done
    mkdir -p "$(dirname "$target")"

    if [[ -L "$target" ]] && [[ "$(readlink -f -- "$target" 2>/dev/null || true)" == "$(readlink -f -- "$source_file")" ]]; then
      continue
    fi
    if [[ -e "$target" || -L "$target" ]]; then
      backup_path "$target" "$rel"
    fi
    ln -s -- "$source_file" "$target"
  done < <(find "$package_dir" -type f -print0)
done

if [[ -n "$BACKUP_ROOT" ]]; then
  printf '\nExisting conflicting files were preserved in:\n%s\n' "$BACKUP_ROOT"
fi
printf '\nDotfiles linked from %s\n' "$ROOT"
printf 'Keep this repository at its current path; the links point into it.\n'
