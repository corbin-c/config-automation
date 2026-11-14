#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
DRY_RUN=0
NO_PACKAGES=0
WITH_FLASHFOCUS=1

usage() {
  cat <<'USAGE'
Ubuntu Sway session bootstrap

Usage: ./install.sh [options]
  --dry-run             Show planned package and file operations; change nothing
  --no-packages         Skip APT and Flashfocus installation
  --without-flashfocus  Do not install Flashfocus (focus-following still works)
  -h, --help            Show this help

This installs a separate Sway session. It does not remove GNOME, change GDM,
change the default session, alter GNOME settings, or replace Neovim.
USAGE
}
while (($#)); do
  case "$1" in
    --dry-run) DRY_RUN=1 ;;
    --no-packages) NO_PACKAGES=1 ;;
    --without-flashfocus) WITH_FLASHFOCUS=0 ;;
    -h|--help) usage; exit 0 ;;
    *) echo "Unknown option: $1" >&2; usage >&2; exit 2 ;;
  esac
  shift
done

if [[ "$EUID" -eq 0 ]]; then
  echo "Run this installer as your normal desktop user, not as root; it invokes sudo only for APT." >&2
  exit 1
fi
if [[ ! -r /etc/os-release ]]; then echo "Cannot identify operating system." >&2; exit 1; fi
# shellcheck disable=SC1091
. /etc/os-release
if [[ "${ID:-}" != ubuntu || "${VERSION_ID:-}" != 24.04 ]]; then
  echo "This bootstrap targets Ubuntu 24.04 LTS only; detected ${PRETTY_NAME:-unknown}." >&2
  exit 1
fi

mapfile -t packages < <(grep -Ev '^[[:space:]]*(#|$)' "$ROOT/packages/desktop.apt")
if ((DRY_RUN)); then
  printf 'Target: %s\n' "$PRETTY_NAME"
  printf 'APT packages:\n'; printf '  %s\n' "${packages[@]}"
  if ((WITH_FLASHFOCUS)); then
    printf 'Flashfocus: pipx install flashfocus==2.9.0 (with native build dependencies)\n'
  else
    printf 'Flashfocus: skipped\n'
  fi
  printf 'Dotfiles: link files from %s into $HOME, backing up exact conflicts.\n' "$ROOT/dotfiles"
  printf 'No changes will be made.\n'
  exit 0
fi

if (( ! NO_PACKAGES )); then
  SUDO=()
  if [[ "$EUID" -ne 0 ]]; then
    command -v sudo >/dev/null 2>&1 || { echo "sudo is required to install APT packages." >&2; exit 1; }
    SUDO=(sudo)
  fi
  "${SUDO[@]}" apt-get update
  "${SUDO[@]}" apt-get install -y --no-install-recommends "${packages[@]}"

  if ((WITH_FLASHFOCUS)); then
    flashfocus_packages=(pipx libxcb-render0-dev libffi-dev python3-dev python3-cffi)
    "${SUDO[@]}" apt-get install -y --no-install-recommends "${flashfocus_packages[@]}"
    pipx_packages="$(pipx list 2>/dev/null || true)"
    if grep -Fq 'package flashfocus 2.9.0,' <<<"$pipx_packages"; then
      echo "Flashfocus 2.9.0 is already installed with pipx."
    else
      legacy_flashfocus="$HOME/.local/bin/flashfocus"
      if [[ ( -e "$legacy_flashfocus" || -L "$legacy_flashfocus" ) ]] && ! grep -Fq 'package flashfocus ' <<<"$pipx_packages"; then
        backup_dir="${XDG_STATE_HOME:-$HOME/.local/state}/sway-workstation-backups/$(date +%Y%m%d-%H%M%S)-flashfocus"
        mkdir -p "$backup_dir"
        mv -- "$legacy_flashfocus" "$backup_dir/flashfocus"
        echo "Moved a pre-existing Flashfocus launcher to $backup_dir/flashfocus"
      fi
      pipx install --force --python python3 'flashfocus==2.9.0'
    fi
  fi
else
  echo "Skipping package installation (--no-packages)."
fi

"$ROOT/scripts/deploy.sh"
cat <<'DONE'

Installation files deployed.

Next steps:
  1. Log out.
  2. At GDM, select your user, open the session chooser, and choose Sway.
  3. Log in. GNOME remains available from the same chooser.

Do not change GDM or the default session. If Sway does not start, choose GNOME
again at GDM; the installer has not changed the GNOME session.
DONE
