#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT
mkdir -p "$TMP/home/.local/bin"
cat > "$TMP/home/.local/bin/autotiling" <<'STUB'
#!/usr/bin/env bash
printf 'args=%s\n' "$*"
printf 'started\n'
STUB
chmod +x "$TMP/home/.local/bin/autotiling"
HOME="$TMP/home" XDG_STATE_HOME="$TMP/state" "$ROOT/dotfiles/local-bin/.local/bin/start-autotiling"
grep -qx 'args=--debug' "$TMP/state/sway-workstation/autotiling.log"
grep -qx 'started' "$TMP/state/sway-workstation/autotiling.log"
printf 'Autotiling startup wrapper smoke test passed.\n'
