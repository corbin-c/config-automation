#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
DOTFILES="$ROOT/dotfiles"
removed=0
for package_dir in "$DOTFILES"/*; do
  [[ -d "$package_dir" ]] || continue
  while IFS= read -r -d '' source_file; do
    rel="${source_file#"$package_dir"/}"
    target="$HOME/$rel"
    if [[ -L "$target" ]] && [[ "$(readlink -f -- "$target" 2>/dev/null || true)" == "$(readlink -f -- "$source_file")" ]]; then
      rm -- "$target"
      printf 'Removed managed link: %s\n' "$target"
      removed=$((removed + 1))
    fi
  done < <(find "$package_dir" -type f -print0)
done
printf 'Removed %d managed links. Existing files and directories were not deleted.\n' "$removed"
