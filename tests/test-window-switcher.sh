#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT
mkdir -p "$TMP/bin" "$TMP/home"
cat > "$TMP/bin/swaymsg" <<'STUB'
#!/usr/bin/env bash
if [[ "$*" == "-r -t get_tree" ]]; then
  cat <<'JSON'
{"type":"root","nodes":[{"type":"output","nodes":[{"type":"workspace","name":"1","nodes":[{"type":"con","id":101,"name":"Terminal","app_id":"org.gnome.Terminal","nodes":[],"floating_nodes":[],"focused":false},{"type":"con","id":202,"name":"Browser","app_id":"firefox","nodes":[],"floating_nodes":[],"focused":true}]}]}]}
JSON
elif [[ "$*" == "-q [con_id=101] focus" ]]; then
  echo focused-101 > "$TEST_CAPTURE"
else
  echo "unexpected swaymsg args: $*" >&2
  exit 2
fi
STUB
cat > "$TMP/bin/rofi" <<'STUB'
#!/usr/bin/env bash
cat > "$TEST_ROFI_INPUT"
printf '0\n'
STUB
chmod +x "$TMP/bin/swaymsg" "$TMP/bin/rofi"
TEST_CAPTURE="$TMP/focus" TEST_ROFI_INPUT="$TMP/rofi-input" PATH="$TMP/bin:/usr/bin:/bin" HOME="$TMP/home" XDG_STATE_HOME="$TMP/state" \
  "$ROOT/dotfiles/local-bin/.local/bin/sway-window-switcher"
grep -qx 'focused-101' "$TMP/focus"
grep -q 'Terminal' "$TMP/rofi-input"
grep -q 'Browser' "$TMP/rofi-input"
grep -q '^invoked$' "$TMP/state/sway-workstation/window-switcher.log"
grep -q 'Focused con_id=101' "$TMP/state/sway-workstation/window-switcher.log"
printf 'Sway window-switcher smoke test passed.\n'
