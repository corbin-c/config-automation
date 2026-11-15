#!/usr/bin/env bash
set -euo pipefail

ROFI_VERSION="2.1.0"
ROFI_PREFIX="/usr/local"
ROFI_BIN="$ROFI_PREFIX/bin/rofi"
ROFI_URL="https://github.com/davatorium/rofi/releases/download/${ROFI_VERSION}/rofi-${ROFI_VERSION}.tar.xz"

if [[ -x "$ROFI_BIN" ]] && "$ROFI_BIN" -version 2>&1 | grep -Fq "Version: ${ROFI_VERSION}"; then
  info="$($ROFI_BIN -info 2>&1 || true)"
  if grep -qi 'wayland' <<<"$info" && grep -qi 'xcb' <<<"$info"; then
    echo "Upstream Rofi ${ROFI_VERSION} is already installed in $ROFI_PREFIX with Wayland and XCB support."
    exit 0
  fi
  echo "Rofi ${ROFI_VERSION} exists but does not report both backends; rebuilding it."
fi

for cmd in meson ninja wget tar python3 sudo; do
  command -v "$cmd" >/dev/null 2>&1 || {
    echo "Missing build command: $cmd. Install packages from packages/rofi-build.apt first." >&2
    exit 1
  }
done

build_root="$(mktemp -d "${TMPDIR:-/tmp}/sway-workstation-rofi.XXXXXX")"
trap 'rm -rf "$build_root"' EXIT
archive="$build_root/rofi-${ROFI_VERSION}.tar.xz"

echo "Downloading upstream Rofi ${ROFI_VERSION} release archive..."
wget --https-only --secure-protocol=TLSv1_2 -O "$archive" "$ROFI_URL"

echo "Extracting and configuring Rofi with both Wayland and XCB backends..."
tar -xJf "$archive" -C "$build_root"
cd "$build_root/rofi-${ROFI_VERSION}"
meson setup build --prefix="$ROFI_PREFIX" -Dwayland=enabled -Dxcb=enabled

# Fail closed if Meson did not enable both display backends.
meson introspect --buildoptions build | python3 -c '
import json, sys
options = {item.get("name"): item.get("value") for item in json.load(sys.stdin)}
missing = [name for name in ("wayland", "xcb") if options.get(name) != "enabled"]
if missing:
    raise SystemExit("Rofi build is missing required enabled backend(s): " + ", ".join(missing))
'

ninja -C build
sudo ninja -C build install
sudo ldconfig

if [[ ! -x "$ROFI_BIN" ]] || ! "$ROFI_BIN" -version 2>&1 | grep -Fq "Version: ${ROFI_VERSION}"; then
  echo "Rofi installation did not produce the expected ${ROFI_VERSION} binary at $ROFI_BIN." >&2
  exit 1
fi
info="$($ROFI_BIN -info 2>&1 || true)"
if ! grep -qi 'wayland' <<<"$info" || ! grep -qi 'xcb' <<<"$info"; then
  echo "Installed Rofi does not report both Wayland and XCB backends:" >&2
  printf '%s\n' "$info" >&2
  exit 1
fi

echo "Installed upstream Rofi ${ROFI_VERSION} with Wayland and XCB backends at $ROFI_BIN."
