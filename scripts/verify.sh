#!/usr/bin/env bash
set -u
PROFILE=all
while (($#)); do case "$1" in --profile) PROFILE="${2:?Missing profile}"; shift 2 ;; -h|--help) echo "Usage: $0 [--profile desktop|development|all]"; exit 0 ;; *) echo "Unknown option: $1" >&2; exit 2 ;; esac; done
case "$PROFILE" in desktop|development|all) ;; *) echo "Invalid profile: $PROFILE" >&2; exit 2 ;; esac
check() {
  local label="$1" command_name="$2"
  if command -v "$command_name" >/dev/null 2>&1; then printf '[ok]   %-30s %s\n' "$label" "$(command -v "$command_name")";
  else printf '[miss] %-30s %s not found\n' "$label" "$command_name"; fi
}
printf '%s\n' 'Workstation verification' '------------------------'
printf 'OS: %s\n' "$(. /etc/os-release 2>/dev/null; echo "${PRETTY_NAME:-unknown}")"
printf 'Session: %s / %s\n' "${XDG_SESSION_TYPE:-unset}" "${XDG_CURRENT_DESKTOP:-unset}"
if [[ "$PROFILE" == desktop || "$PROFILE" == all ]]; then
  for pair in 'Sway:sway' 'Waybar:waybar' 'Rofi:rofi' 'Foot:foot' 'Mako:mako' 'Swaylock:swaylock' 'Swayidle:swayidle' 'Clipboard:wl-paste' 'Clipboard history:cliphist' 'Screenshot:grim' 'Selection:slurp' 'Recording:wf-recorder' 'PolicyKit tool:pkexec' 'Stow:stow' 'Zsh:zsh'; do
    label="${pair%%:*}"; cmd="${pair#*:}"; check "$label" "$cmd"
  done
  for package in xdg-desktop-portal xdg-desktop-portal-gtk xdg-desktop-portal-wlr policykit-1-gnome; do
    if dpkg-query -W -f='${Status}' "$package" 2>/dev/null | grep -q 'install ok installed'; then printf '[ok]   package %-26s installed\n' "$package"; else printf '[miss] package %-26s not installed\n' "$package"; fi
  done
fi
if [[ "$PROFILE" == development || "$PROFILE" == all ]]; then
  for pair in 'Neovim:nvim' 'btop:btop' 'ripgrep:rg' 'fzf:fzf'; do label="${pair%%:*}"; cmd="${pair#*:}"; check "$label" "$cmd"; done
  if command -v nvim >/dev/null 2>&1; then nvim --version | head -n1; fi
fi
if [[ -n "${SWAYSOCK:-}" && ( "$PROFILE" == desktop || "$PROFILE" == all ) ]]; then
  echo "Sway IPC socket: $SWAYSOCK"
  swaymsg -t get_version 2>/dev/null || true
  echo "PolicyKit agent processes:"
  pgrep -af 'polkit.*authentication.*agent|polkit-gnome' || echo "No matching agent process found"
  echo "Portal/audio user services:"
  systemctl --user --no-pager --type=service --state=running 2>/dev/null | grep -E 'xdg-desktop-portal|pipewire|wireplumber' || true
else
  echo "Not currently inside a Sway session; session-specific checks skipped."
fi
printf '\n%s\n' 'Manual checks still required: graphical PolicyKit prompt, screen sharing, clipboard image MIME, audio, recording, suspend/resume, GNOME login.'
