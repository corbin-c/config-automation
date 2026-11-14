# Changelog

## 0.1.5

- Restored the exact original Rofi `config.rasi`, `Manjaro.rasi` and `Arc-dark.rasi` files from the supplied workstation archive. Removed the unintended Catppuccin palette substitutions in Rofi; the original layout and colors are preserved.
- Fixed the Waybar clipboard icon's click action to invoke `~/.local/bin/clipboard-menu` by absolute home-relative path instead of relying on the GDM session `PATH`.
- Improved clipboard picker feedback: empty history is reported, errors are logged, and image entries are restored with their recorded MIME type.
- Updated README and static checks to cover the restored Rofi configuration and clipboard launcher path.

## 0.1.4

- Fixed the Rofi theme parser issue and window-picker invocation/diagnostics.
