# Changelog

## 0.1.0 — minimal Sway session

- Replaced the broad workstation bootstrap with a Sway-only session setup.
- Kept Ubuntu GNOME and GDM intact as the fallback.
- Added automatic split orientation, focus-follows-mouse, Flashfocus, directional navigation/movement/resizing, and ten AZERTY-aware workspaces.
- Added a custom Rofi window picker backed by Sway IPC so native Wayland windows are included.
- Added Cliphist listeners for text and images plus MIME-aware clipboard restoration.
- Reduced Waybar to a 30px vertical bar with essential modules.
- Removed Foot, Neovim, Zsh, Oh My Zsh, development profile and unrelated personal utilities from the installer.
- Installer does not alter system configuration, GDM defaults, GNOME settings or system services.
