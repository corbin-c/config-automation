# Changelog

## 0.1.6

- Replaced the Ubuntu repository Rofi dependency with an upstream Rofi 2.1.0 source build installed under `/usr/local`. The Meson configuration explicitly requires both native Wayland and XCB backends; the Ubuntu `/usr/bin/rofi` package is not installed or modified.
- Added the Rofi build dependencies and an idempotent build/install script. Existing `/usr/local/bin/rofi` 2.1.0 builds are reused only when both backends are reported.
- Updated the Sway session wrapper to put `/usr/local/bin` first in `PATH`, ensuring the upstream Rofi is selected by launchers and scripts.
- Removed the unsupported `--clock` argument from all three Swaylock invocation paths: idle lock, direct lock shortcut, and Super+Delete then `l`. The commands now use Ubuntu's standard Swaylock options.
- Updated installation documentation and static checks for the upstream Rofi build and standard Swaylock command.

## 0.1.5

- Restored the exact original Rofi `config.rasi`, `Manjaro.rasi` and `Arc-dark.rasi` files from the supplied workstation archive. Removed the unintended Catppuccin palette substitutions in Rofi; the original layout and colors are preserved.
- Fixed the Waybar clipboard icon's click action to invoke `~/.local/bin/clipboard-menu` by absolute home-relative path instead of relying on the GDM session `PATH`.
- Improved clipboard picker feedback: empty history is reported, errors are logged, and image entries are restored with their recorded MIME type.
- Updated README and static checks to cover the restored Rofi configuration and clipboard launcher path.

## 0.1.4

- Fixed the Rofi theme parser issue and window-picker invocation/diagnostics.
