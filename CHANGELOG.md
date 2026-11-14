# Changelog

## 0.1.4

- Removed the `@theme` directive from `config.rasi`, which caused Rofi to reject the file at line 1. The original Manjaro palette values are now applied directly to the user's original layout.
- Made Super+Tab and Alt+Space invoke the window picker explicitly without startup notification.
- Added persistent window-picker diagnostics at `~/.local/state/sway-workstation/window-switcher.log`, including Sway IPC errors, Rofi parse/launch errors, cancellation and selected window IDs.
- Hardened the picker: use the system Python interpreter, disable Rofi custom actions, and report Rofi stderr instead of discarding it.

## 0.1.3

- Restored the user's application shortcuts and Rofi/Waybar configuration.
- Added a Sway IPC-backed Rofi window picker.
- Made the autotiling launcher use the absolute pipx executable path and log startup diagnostics.

## 0.1.2

- Restored the original exit and screen-recording modes.
