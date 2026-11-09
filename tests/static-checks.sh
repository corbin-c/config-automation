#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"
for f in install.sh scripts/*.sh \
  dotfiles/local-bin/.local/bin/clipboard-menu \
  dotfiles/local-bin/.local/bin/record-screen \
  dotfiles/local-bin/.local/bin/rofi-spotlight \
  dotfiles/local-bin/.local/bin/screenshot \
  dotfiles/local-bin/.local/bin/sway-power-menu; do
  bash -n "$f"
done
python3 - <<'PY'
import json
from pathlib import Path
p = Path('dotfiles/waybar/.config/waybar/config.jsonc')
data = json.loads(p.read_text())
assert 'custom/recording' in data
assert data['pulseaudio']['format-muted'] == ''
compile(Path('dotfiles/local-bin/.local/bin/sway-smart-resize').read_text(), 'sway-smart-resize', 'exec')
for manifest in Path('packages').glob('*.apt'):
    entries = [x.strip() for x in manifest.read_text().splitlines()
               if x.strip() and not x.lstrip().startswith('#')]
    assert len(entries) == len(set(entries)), f'duplicate package in {manifest}'
assert Path('dotfiles/sway/.config/swaylock/config').is_file()
assert Path('dotfiles/local-bin/.local/bin/record-screen').stat().st_mode & 0o111
PY
if grep -RIlE '󰝟|󰋎' dotfiles/waybar; then
  echo 'Unsupported Nerd Font-only glyph remains in Waybar.' >&2
  exit 1
fi
printf '%s\n' 'Static checks passed.'
printf '%s\n' 'Not checked: Sway parser, Waybar runtime schema, APT install, real Stow binary, graphical session, portals, PolicyKit, audio, recording, rollback.'
