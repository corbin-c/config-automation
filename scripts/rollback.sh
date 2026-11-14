#!/usr/bin/env bash
set -euo pipefail
BASE="${XDG_STATE_HOME:-$HOME/.local/state}/sway-workstation-backups"
ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
usage() { echo "Usage: $0 list | restore BACKUP-DIRECTORY" >&2; exit 2; }
[[ $# -ge 1 ]] || usage
case "$1" in
  list)
    if [[ -d "$BASE" ]]; then find "$BASE" -mindepth 1 -maxdepth 1 -type d -printf '%f\n' | sort; else echo "No backups found."; fi
    ;;
  restore)
    [[ $# -eq 2 ]] || usage
    name="$2"
    [[ "$name" != */* && "$name" != .* ]] || { echo "Invalid backup name." >&2; exit 2; }
    backup="$BASE/$name"
    [[ -d "$backup" ]] || { echo "Backup not found: $backup" >&2; exit 1; }
    restored=0 skipped=0
    while IFS= read -r -d '' item; do
      rel="${item#"$backup"/}"
      target="$HOME/$rel"
      if [[ -L "$target" ]] && [[ "$(readlink -f -- "$target" 2>/dev/null || true)" == "$ROOT"/dotfiles/* ]]; then
        rm -- "$target"
      fi
      if [[ -e "$target" || -L "$target" ]]; then
        printf 'SKIP (destination exists): %s\n' "$target"
        skipped=$((skipped + 1))
        continue
      fi
      mkdir -p "$(dirname "$target")"
      mv -- "$item" "$target"
      printf 'RESTORED: %s\n' "$target"
      restored=$((restored + 1))
    done < <(find "$backup" -mindepth 1 \( -type f -o -type l \) -print0)
    printf 'Restore complete: %d restored, %d skipped. Backup retained at %s\n' "$restored" "$skipped" "$backup"
    ;;
  *) usage ;;
esac
