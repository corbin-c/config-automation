#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
SCRIPT="$ROOT/dotfiles/local-bin/.local/bin/record-screen"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT
mkdir -p "$TMP/bin" "$TMP/home/Videos"

cat > "$TMP/bin/pgrep" <<'STUB'
#!/usr/bin/env bash
[[ "${PGREP_RUNNING:-0}" == 1 ]]
STUB
cat > "$TMP/bin/pkill" <<'STUB'
#!/usr/bin/env bash
printf '%s\n' "$*" > "$PKILL_ARGS"
STUB
cat > "$TMP/bin/notify-send" <<'STUB'
#!/usr/bin/env bash
exit 0
STUB
cat > "$TMP/bin/xdg-user-dir" <<'STUB'
#!/usr/bin/env bash
printf '%s\n' "$XDG_VIDEOS_DIR"
STUB
cat > "$TMP/bin/swaymsg" <<'STUB'
#!/usr/bin/env bash
printf '{}\n'
STUB
cat > "$TMP/bin/jq" <<'STUB'
#!/usr/bin/env bash
cat >/dev/null
printf '0,0 800x600\n'
STUB
cat > "$TMP/bin/slurp" <<'STUB'
#!/usr/bin/env bash
cat >/dev/null
printf '0,0 800x600\n'
STUB
cat > "$TMP/bin/sleep" <<'STUB'
#!/usr/bin/env bash
exit 0
STUB
cat > "$TMP/bin/wf-recorder" <<'STUB'
#!/usr/bin/env bash
printf '%s\n' "$@" > "$WF_RECORDER_ARGS"
STUB
chmod +x "$TMP/bin/"*
export PATH="$TMP/bin:$PATH"
export HOME="$TMP/home"
export XDG_VIDEOS_DIR="$TMP/home/Videos"
export WF_RECORDER_ARGS="$TMP/args"
export PKILL_ARGS="$TMP/pkill-args"

"$SCRIPT"
grep -qx -- '-g' "$WF_RECORDER_ARGS"
grep -qx -- 'libvpx' "$WF_RECORDER_ARGS"
grep -qx -- '-c' "$WF_RECORDER_ARGS"
grep -qx -- '-p' "$WF_RECORDER_ARGS"
grep -qE '^.*\.webm$' "$WF_RECORDER_ARGS"

"$SCRIPT" --audio
grep -qx -- '--audio' "$WF_RECORDER_ARGS"
grep -qx -- '-g' <(sed -n '2p' "$WF_RECORDER_ARGS")
grep -qE '^.*\.mp4$' "$WF_RECORDER_ARGS"

PGREP_RUNNING=1 "$SCRIPT"
grep -q -- '-U .* -INT -x wf-recorder' "$PKILL_ARGS"
printf 'Recording helper smoke test passed.\n'
