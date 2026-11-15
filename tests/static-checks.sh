#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
for f in "$ROOT/install.sh" "$ROOT/scripts/"*.sh "$ROOT/system/sway-workstation-session" "$ROOT/dotfiles/local-bin/.local/bin/clipboard-menu" "$ROOT/dotfiles/local-bin/.local/bin/rofi-spotlight" "$ROOT/dotfiles/local-bin/.local/bin/record-screen" "$ROOT/dotfiles/local-bin/.local/bin/start-autotiling"; do
  bash -n "$f"
done
bash -n "$ROOT/tests/test-record-screen.sh"
bash -n "$ROOT/tests/test-start-autotiling.sh"
bash -n "$ROOT/tests/test-window-switcher.sh"
bash -n "$ROOT/tests/test-clipboard-menu.sh"
"$ROOT/tests/test-record-screen.sh"
"$ROOT/tests/test-start-autotiling.sh"
"$ROOT/tests/test-window-switcher.sh"
"$ROOT/tests/test-clipboard-menu.sh"
python3 - "$ROOT/dotfiles/local-bin/.local/bin/sway-window-switcher" "$ROOT/dotfiles/local-bin/.local/bin/sway-smart-resize" <<'PY'
import pathlib, sys
for filename in sys.argv[1:]:
    compile(pathlib.Path(filename).read_text(encoding="utf-8"), filename, "exec")
print("Python scripts: syntax valid")
PY
python3 - "$ROOT/dotfiles/waybar/.config/waybar/config" <<'PY'
import json, sys
with open(sys.argv[1], encoding="utf-8") as f:
    data = json.load(f)
assert data["width"] == 12
assert "custom/sunset" not in data["modules-right"]
assert "custom/wf-recorder" in data["modules-center"]
print("Waybar JSON and 12px layout: valid")
assert data["custom/clipboard"]["on-click"] == '\"$HOME/.local/bin/clipboard-menu\"'
PY
grep -q 'cliphist list -fields mime' "$ROOT/dotfiles/local-bin/.local/bin/clipboard-menu"
grep -q 'clipboard-menu.log' "$ROOT/dotfiles/local-bin/.local/bin/clipboard-menu"
# Rofi must match the exact original user config, not the temporary Catppuccin substitutions.
[[ "$(sha256sum "$ROOT/dotfiles/rofi/.config/rofi/config.rasi" | awk '{print $1}')" == "8128ad55837fecf31ffe1abaf40b96a3e99d7124c6bce5e53bbcc147a608eba5" ]]
grep -q 'foreground:.*rgba ( 196, 203, 212, 100 % );' "$ROOT/dotfiles/rofi/.config/rofi/config.rasi"
grep -q 'background:.*rgba ( 45, 48, 59, 95 % );' "$ROOT/dotfiles/rofi/.config/rofi/config.rasi"
grep -q 'font: "JetBrainsMono Nerd Font 10"' "$ROOT/dotfiles/rofi/.config/rofi/config.rasi"
if command -v rofi >/dev/null 2>&1; then
  rofi -no-config -theme "$ROOT/dotfiles/rofi/.config/rofi/config.rasi" -dump-theme >/dev/null
else
  echo "Rofi theme parser: SKIPPED (rofi is not installed in this test environment)"
fi
grep -q 'background: #1e1e2e;' "$ROOT/dotfiles/rofi/.config/rofi/Manjaro.rasi"
grep -q '^exec \$HOME/.local/bin/start-autotiling$' "$ROOT/dotfiles/sway/.config/sway/config"
grep -q 'AUTOTILING="\$HOME/.local/bin/autotiling"' "$ROOT/dotfiles/local-bin/.local/bin/start-autotiling"
grep -q 'xcursor_theme breeze_cursors 24' "$ROOT/dotfiles/sway/.config/sway/config"
grep -q 'XCURSOR_THEME=breeze_cursors' "$ROOT/system/sway-workstation-session"
grep -qx 'breeze-cursor-theme' "$ROOT/packages/desktop.apt"
grep -qx 'wf-recorder' "$ROOT/packages/desktop.apt"
grep -qx 'fd-find' "$ROOT/packages/desktop.apt"
grep -qx 'pipx' "$ROOT/packages/desktop.apt"
grep -qx 'python3-venv' "$ROOT/packages/desktop.apt"
grep -q 'set \$command_launcher \$HOME/.local/bin/rofi-spotlight' "$ROOT/dotfiles/sway/.config/sway/config"
grep -q 'set \$window_switcher \$HOME/.local/bin/sway-window-switcher' "$ROOT/dotfiles/sway/.config/sway/config"
grep -q '^bindsym \$mod+t exec \$terminal$' "$ROOT/dotfiles/sway/.config/sway/config"
grep -q '^bindsym \$mod+Return exec \$terminal$' "$ROOT/dotfiles/sway/.config/sway/config"
grep -q '^bindsym \$mod+w exec firefox$' "$ROOT/dotfiles/sway/.config/sway/config"
grep -q '^bindsym \$mod+f exec thunar$' "$ROOT/dotfiles/sway/.config/sway/config"
grep -q '^bindsym \$mod+g exec gnome-terminal -- nvim$' "$ROOT/dotfiles/sway/.config/sway/config"
grep -q '^bindsym \$mod+space exec \$command_launcher$' "$ROOT/dotfiles/sway/.config/sway/config"
grep -q '^bindsym \$mod+Tab exec --no-startup-id \$HOME/.local/bin/sway-window-switcher$' "$ROOT/dotfiles/sway/.config/sway/config"
grep -qx 'thunar' "$ROOT/packages/desktop.apt"
grep -q '^bindsym \$mod+Delete mode \$mode_exit$' "$ROOT/dotfiles/sway/.config/sway/config"
grep -q '^bindsym \$mod+Shift+r mode \$mode_recording$' "$ROOT/dotfiles/sway/.config/sway/config"
grep -q 'bindsym Shift+r exec record-screen --audio' "$ROOT/dotfiles/sway/.config/sway/config"
grep -q 'wf-recorder --audio -g' "$ROOT/dotfiles/local-bin/.local/bin/record-screen"
grep -qx 'jq' "$ROOT/packages/desktop.apt"
grep -qx 'xdg-user-dirs' "$ROOT/packages/desktop.apt"
! grep -qx 'rofi' "$ROOT/packages/desktop.apt"
grep -qx 'wayland-protocols' "$ROOT/packages/rofi-build.apt"
grep -q 'ROFI_VERSION=\"2.1.0\"' "$ROOT/scripts/install-rofi.sh"
grep -q -- '-Dwayland=enabled -Dxcb=enabled' "$ROOT/scripts/install-rofi.sh"
grep -q 'export PATH=\"/usr/local/bin:' "$ROOT/system/sway-workstation-session"
grep -q 'bindsym Shift+r exec record-screen --audio' "$ROOT/dotfiles/sway/.config/sway/config"
grep -q 'bindsym l mode \"default\", exec swaylock' "$ROOT/dotfiles/sway/.config/sway/config"
! grep -q -- '--clock' "$ROOT/dotfiles/sway/.config/sway/config"
grep -q 'swaylock --config .*--show-failed-attempts' "$ROOT/dotfiles/sway/.config/sway/config"
grep -q 'bindsym e exec swaymsg exit' "$ROOT/dotfiles/sway/.config/sway/config"
grep -q 'bindsym u mode \"default\", exec systemctl suspend' "$ROOT/dotfiles/sway/.config/sway/config"
grep -q 'bindsym r exec systemctl reboot' "$ROOT/dotfiles/sway/.config/sway/config"
grep -q 'bindsym s exec systemctl poweroff' "$ROOT/dotfiles/sway/.config/sway/config"
if command -v sway >/dev/null 2>&1; then
  sway -C -c "$ROOT/dotfiles/sway/.config/sway/config"
else
  echo "Sway config parser: SKIPPED (sway binary is not installed in this test environment)"
fi
printf 'Static checks passed.\n'
