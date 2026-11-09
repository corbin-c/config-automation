#!/usr/bin/env bash
set -u
check() {
  local label="$1" command_name="$2"
  if command -v "$command_name" >/dev/null 2>&1; then
    printf '[ok]   %-30s %s\n' "$label" "$(command -v "$command_name")"
  else
    printf '[miss] %-30s %s not found\n' "$label" "$command_name"
  fi
}

printf '%s\n' 'Workstation verification'
printf '%s\n' '------------------------'
printf 'OS: %s\n' "$(. /etc/os-release 2>/dev/null; echo "${PRETTY_NAME:-unknown}")"
printf 'Session: %s / %s\n' "${XDG_SESSION_TYPE:-unset}" "${XDG_CURRENT_DESKTOP:-unset}"

for pair in \
  'Sway:sway' 'Waybar:waybar' 'Rofi:rofi' 'Foot:foot' 'Mako:mako' \
  'Swaylock:swaylock' 'Swayidle:swayidle' 'Clipboard:wl-paste' \
  'Clipboard history:cliphist' 'PolicyKit tool:pkexec' \
  'Neovim:nvim' 'Stow:stow' 'Zsh:zsh'; do
  label="${pair%%:*}"; cmd="${pair#*:}"
  check "$label" "$cmd"
done

for package in xdg-desktop-portal xdg-desktop-portal-gtk xdg-desktop-portal-wlr policykit-1-gnome; do
  if dpkg-query -W -f='${Status}' "$package" 2>/dev/null | grep -q 'install ok installed'; then
    printf '[ok]   package %-26s installed\n' "$package"
  else
    printf '[miss] package %-26s not installed\n' "$package"
  fi
done

if [[ -n "${SWAYSOCK:-}" ]]; then
  echo "Sway IPC socket: $SWAYSOCK"
  swaymsg -t get_version 2>/dev/null || true
  echo "PolicyKit agent processes:"
  pgrep -af 'polkit.*authentication.*agent|polkit-gnome' || echo "No matching agent process found"
  echo "Portal services (user):"
  systemctl --user --no-pager --type=service --state=running 2>/dev/null | grep -E 'xdg-desktop-portal|pipewire|wireplumber' || true
else
  echo "Not currently inside a Sway session; session-specific checks skipped."
fi

printf '\n%s\n' 'Manual checks still required: graphical PolicyKit prompt, screen sharing, screenshot portal, audio, suspend/resume, and GNOME login.'
