# Changelog

## 0.1.2 — restore exit and recording modes

- Restored the user's original `Super+Delete` exit mode, with lock, logout, suspend, reboot and shutdown actions; Escape cancels the menu.
- Restored the original recording-mode interaction: Super+Shift+R enters the mode, `r` records the screen without audio, Shift+`r` records with audio, and Escape cancels.
- Recreated the original Manjaro `recorder.sh` behavior without depending on Manjaro system files: `slurp` region selection, a three-second countdown, WebM/VP8 without audio by default, MP4 with audio when requested, XDG Videos destination, notifications, and toggle-to-stop behavior. Added explicit `jq` and `xdg-user-dirs` dependencies.
- Kept Super+Escape as the stop-recording shortcut and retained the Waybar recording indicator.
- The Manjaro-specific `waybar-signal` helper and icon path were not carried over; the Waybar indicator polls `wf-recorder` directly.

## 0.1.1 — restore user appearance and real autotiling

- Restored the user's original Rofi `config.rasi` theme and Arc-dark theme file; changed only the font name to the APT-installed JetBrains Mono to avoid a missing Nerd Font dependency.
- Restored the user's 12px vertical Waybar geometry and Catppuccin Mocha palette.
- Replaced the Manjaro-specific Waybar stylesheet import with equivalent local CSS; removed the previously rejected sunset module.
- Added upstream autotiling 1.9.3 via pipx. The prior `default_orientation auto` setting was not a substitute for an IPC-driven autotiling helper.
- Added the Breeze cursor theme package, selected `breeze_cursors` in Sway, and added a separate GDM session wrapper that passes XCURSOR_THEME and XCURSOR_SIZE to Sway-launched applications without changing GNOME's GSettings cursor preference.
- Restored the active screen-recording indicator and added start/stop keybindings using Ubuntu Noble's `wf-recorder` package.
- Kept GNOME, GDM's default session, the packaged Ubuntu Sway session, Neovim and GNOME settings unchanged.

## 0.1.0 — minimal Sway session

- Replaced the broad workstation bootstrap with a Sway-only session setup.
- Kept Ubuntu GNOME and GDM intact as the fallback.
- Added focus-follows-mouse, Flashfocus, directional navigation/movement/resizing, and ten AZERTY-aware workspaces.
- Added a custom Rofi window picker backed by Sway IPC so native Wayland windows are included.
- Added Cliphist listeners for text and images plus MIME-aware clipboard restoration.
- Removed Foot, Neovim, Zsh, Oh My Zsh, development profile and unrelated personal utilities from the installer.
