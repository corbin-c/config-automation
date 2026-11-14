#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
for f in "$ROOT/install.sh" "$ROOT/scripts/"*.sh "$ROOT/dotfiles/local-bin/.local/bin/clipboard-menu"; do
  bash -n "$f"
done
python3 - "$ROOT/dotfiles/local-bin/.local/bin/sway-window-switcher" "$ROOT/dotfiles/local-bin/.local/bin/sway-smart-resize" <<'PY'
import pathlib, sys
for filename in sys.argv[1:]:
    compile(pathlib.Path(filename).read_text(encoding="utf-8"), filename, "exec")
print("Python scripts: syntax valid")
PY
python3 - "$ROOT/dotfiles/waybar/.config/waybar/config" <<'PY'
import json, sys
with open(sys.argv[1], encoding="utf-8") as f:
    json.load(f)
print("Waybar JSON: valid")
PY
if command -v sway >/dev/null 2>&1; then
  sway -C -c "$ROOT/dotfiles/sway/.config/sway/config"
else
  echo "Sway config parser: SKIPPED (sway binary is not installed in this test environment)"
fi
printf 'Static checks passed.\n'
