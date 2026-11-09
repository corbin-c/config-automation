#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
PROFILE=desktop DRY_RUN=0 INSTALL_PACKAGES=1 INSTALL_OMZ=1 SET_DEFAULT_SHELL=0

usage() {
  cat <<'USAGE'
Usage: ./install.sh [options]
  --profile desktop|development|all  Package/config profile (default: desktop)
  --dry-run                           Show planned actions only
  --no-packages                       Skip APT package installation
  --no-oh-my-zsh                      Do not clone Oh My Zsh
  --set-default-shell                 Make Zsh the login shell (opt-in)
  -h, --help                          Show this help
USAGE
}
while (($#)); do
  case "$1" in
    --profile) PROFILE="${2:?Missing profile}"; shift 2 ;;
    --dry-run) DRY_RUN=1; shift ;;
    --no-packages) INSTALL_PACKAGES=0; shift ;;
    --no-oh-my-zsh) INSTALL_OMZ=0; shift ;;
    --set-default-shell) SET_DEFAULT_SHELL=1; shift ;;
    -h|--help) usage; exit 0 ;;
    *) echo "Unknown option: $1" >&2; usage >&2; exit 2 ;;
  esac
done
case "$PROFILE" in desktop|development|all) ;; *) echo "Invalid profile: $PROFILE" >&2; exit 2 ;; esac

[[ -r /etc/os-release ]] || { echo "Cannot identify operating system (/etc/os-release missing)." >&2; exit 1; }
# shellcheck disable=SC1091
. /etc/os-release
[[ "${ID:-}" == ubuntu && "${VERSION_ID:-}" == 24.04 ]] || {
  echo "This bootstrap targets Ubuntu 24.04 LTS; detected ${PRETTY_NAME:-unknown}." >&2; exit 1;
}
if ((INSTALL_PACKAGES)); then
  command -v apt-get >/dev/null || { echo "apt-get is required." >&2; exit 1; }
  command -v sudo >/dev/null || { echo "sudo is required for package installation." >&2; exit 1; }
fi

manifests=()
case "$PROFILE" in
  desktop) manifests+=("$ROOT/packages/desktop.apt") ;;
  development) manifests+=("$ROOT/packages/development.apt") ;;
  all) manifests+=("$ROOT/packages/desktop.apt" "$ROOT/packages/development.apt") ;;
esac
case "$PROFILE" in
  desktop) stow_packages=(sway waybar rofi foot mako zsh local-bin kanshi) ;;
  development) stow_packages=(zsh neovim btop) ;;
  all) stow_packages=(sway waybar rofi foot mako zsh local-bin kanshi neovim btop) ;;
esac

if ((DRY_RUN)); then
  echo "[dry-run] Ubuntu check passed: ${PRETTY_NAME}"
  if ((INSTALL_PACKAGES)); then
    for manifest in "${manifests[@]}"; do
      echo "[dry-run] APT packages from $(basename "$manifest"):"
      sed -E '/^[[:space:]]*(#|$)/d' "$manifest" | sed 's/^/  /'
    done
  fi
  printf '[dry-run] Stow packages: %s\n' "${stow_packages[*]}"
  ((INSTALL_OMZ)) && echo "[dry-run] Clone Oh My Zsh if absent: ~/.local/share/oh-my-zsh"
  if ((SET_DEFAULT_SHELL)); then echo "[dry-run] Change passwd login shell to Zsh (if different)"; fi
  [[ "$PROFILE" == development || "$PROFILE" == all ]] && echo "[dry-run] Install upstream Neovim Snap if absent; reject an existing version older than 0.11.2"
  exit 0
fi

install_manifest() {
  local manifest="$1"
  mapfile -t packages < <(sed -E '/^[[:space:]]*(#|$)/d' "$manifest")
  ((${#packages[@]})) || return 0
  echo "Installing packages from $(basename "$manifest")..."
  sudo apt-get install -y --no-install-recommends "${packages[@]}"
}
if ((INSTALL_PACKAGES)); then
  sudo apt-get update
  for manifest in "${manifests[@]}"; do install_manifest "$manifest"; done
fi

if ((INSTALL_OMZ)); then "$ROOT/scripts/install-oh-my-zsh.sh"; fi
if ((SET_DEFAULT_SHELL)); then
  zsh_path="$(command -v zsh)" || { echo "zsh is not installed; cannot change the login shell." >&2; exit 1; }
  passwd_shell="$(getent passwd "${USER:-$(id -un)}" | cut -d: -f7)"
  if [[ "$passwd_shell" != "$zsh_path" ]]; then chsh -s "$zsh_path"; else echo "Zsh is already the login shell."; fi
fi

if [[ "$PROFILE" == development || "$PROFILE" == all ]]; then
  if ((INSTALL_PACKAGES)); then "$ROOT/scripts/install-neovim.sh"; fi
fi
"$ROOT/scripts/deploy-dotfiles.sh" "${stow_packages[@]}"

echo
echo "Bootstrap completed. No display-manager or system-session defaults were changed."
if [[ "$PROFILE" == desktop || "$PROFILE" == all ]]; then
  echo "Log out and choose Sway from GDM's session menu."
  echo "Run ./scripts/verify.sh --profile desktop after logging into Sway."
fi
