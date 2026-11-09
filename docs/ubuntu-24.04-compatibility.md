# Ubuntu 24.04 package compatibility notes

Package names and version notes checked against the Ubuntu Noble package archive on 2026-11-04. APT installs the currently published Noble security/update revision; the versions below are archive references, not pinning rules.

| Component | Ubuntu package | Noble archive version observed | Notes |
|---|---|---:|---|
| Sway | `sway` | 1.9 | Ubuntu package also ships the GDM session entry, `sway-portals.conf`, and `/etc/sway/config.d/50-systemd-user.conf`; the personal config does not include `/etc/sway` fragments |
| Waybar | `waybar` | 0.9.24 | Older than current upstream releases; config uses basic modules |
| Rofi | `rofi` | 1.7.5 | X11 application; runs through XWayland in Sway |
| Foot | `foot` | 1.16.2 | Native Wayland terminal |
| Mako | `mako-notifier` | 1.8.0 | Notification daemon |
| Clipboard history | `cliphist` | 0.4.0 | Ubuntu package depends on `wl-clipboard` |
| Kanshi | `kanshi` | 1.5.1 | Installed, but not started until a real user profile exists |
| PolicyKit agent | `policykit-1-gnome` | 0.105 | Ubuntu-packaged GNOME authentication agent |
| JetBrains Mono | `fonts-jetbrains-mono` | 2.304 | Standard font, not Nerd Font patched |
| Font Awesome | `fonts-font-awesome` | 5.0.10 | Provides a baseline icon font |
| Neovim (APT) | `neovim` | 0.9.5 | Not used by the development profile because current LazyVim requires >= 0.11.2 |

## Consequences

- No PPA or third-party Sway repository is added.
- Current LazyVim is installed with upstream Neovim Snap in the optional development profile. An existing Neovim binary is not replaced automatically; the installer stops if it detects an incompatible version.
- The standard JetBrains Mono package does not include Nerd Font glyph patches. The basic Waybar/Rofi UI uses standard Font Awesome glyphs where practical; Neovim dashboard/plugin glyphs may need a Nerd Font.
- Portal packages are installed, but actual backend selection is left to Ubuntu's portal metadata until VM tests establish whether a user override is required.
- Screen recording is not included in the first package set. The source Manjaro workflow relied on a recorder script and package combination not verified for Noble in this pass.

## Ubuntu package references

- Sway: https://packages.ubuntu.com/noble/sway
- Waybar: https://packages.ubuntu.com/noble/waybar
- Rofi: https://packages.ubuntu.com/noble/rofi
- Foot: https://packages.ubuntu.com/noble/foot
- Mako: https://packages.ubuntu.com/noble/mako-notifier
- Cliphist: https://packages.ubuntu.com/noble/cliphist
- Kanshi: https://packages.ubuntu.com/noble/kanshi
- PolicyKit agent: https://packages.ubuntu.com/noble/policykit-1-gnome
- Neovim: https://packages.ubuntu.com/noble/neovim
- Current LazyVim requirements: https://www.lazyvim.org/
