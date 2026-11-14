#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT
mkdir -p "$TMP/bin" "$TMP/state"
export XDG_STATE_HOME="$TMP/state" MOCK_MODE=text MOCK_MIME=text/plain
export MOCK_COPY_ARGS="$TMP/copy-args" MOCK_COPY_DATA="$TMP/copy-data" MOCK_DECODE_INPUT="$TMP/decode-input"
cat > "$TMP/bin/cliphist" <<'MOCK'
#!/usr/bin/env bash
case "${1:-}" in
  list)
    if [[ "${2:-}" == "-fields" ]]; then
      [[ "${4:-}" == "42" ]] || exit 3
      printf '%s\n' "$MOCK_MIME"
    elif [[ "${MOCK_MODE:-text}" == "empty" ]]; then
      exit 0
    else
      printf '42\tclipboard preview\n'
      printf '41\tolder preview\n'
    fi
    ;;
  decode)
    cat > "$MOCK_DECODE_INPUT"
    printf 'decoded clipboard bytes'
    ;;
  wipe) exit 0 ;;
  *) exit 2 ;;
esac
MOCK
cat > "$TMP/bin/rofi" <<'MOCK'
#!/usr/bin/env bash
printf '42\tclipboard preview\n'
MOCK
cat > "$TMP/bin/wl-copy" <<'MOCK'
#!/usr/bin/env bash
printf '%s\n' "$*" > "$MOCK_COPY_ARGS"
cat > "$MOCK_COPY_DATA"
MOCK
cat > "$TMP/bin/notify-send" <<'MOCK'
#!/usr/bin/env bash
exit 0
MOCK
cat > "$TMP/bin/date" <<'MOCK'
#!/usr/bin/env bash
printf '2026-01-01T00:00:00+00:00\n'
MOCK
chmod +x "$TMP/bin/"*
export PATH="$TMP/bin:/usr/bin:/bin"
SCRIPT="$ROOT/dotfiles/local-bin/.local/bin/clipboard-menu"

MOCK_MODE=text MOCK_MIME=text/plain "$SCRIPT"
grep -q '^42' "$MOCK_DECODE_INPUT"
[[ "$(cat "$MOCK_COPY_ARGS")" == "" ]]
grep -q 'decoded clipboard bytes' "$MOCK_COPY_DATA"

MOCK_MODE=text MOCK_MIME=image/png "$SCRIPT"
grep -q -- '--type image/png' "$MOCK_COPY_ARGS"

MOCK_MODE=empty "$SCRIPT"
grep -q 'empty history' "$XDG_STATE_HOME/sway-workstation/clipboard-menu.log"
printf 'Clipboard picker smoke test passed.\n'
