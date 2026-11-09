# Architecture and ownership

## Configuration precedence and ownership

The previous machine's behavior was assembled from home-directory files, Manjaro `/etc/sway` fragments, `/usr/share/sway` templates/scripts, and system-installed Zsh configuration. That coupling is intentionally removed.

| Concern | Owner in this repository | Ubuntu-owned layer |
|---|---|---|
| Sway behavior | `~/.config/sway/**` | Sway executable/session desktop file |
| Waybar | `~/.config/waybar/**` | Waybar package |
| Rofi | `~/.config/rofi/**` | Rofi package |
| Foot | `~/.config/foot/**` | Foot package/terminfo |
| Zsh interactive shell | `~/.config/zsh/.zshrc` | `/etc/zsh` and `/etc/profile` remain unmodified |
| Oh My Zsh | `~/.local/share/oh-my-zsh` | Git package and upstream repository |
| GTK/cursor/icons | GNOME Settings | GNOME settings schemas/services |
| PolicyKit | No custom service/unit | Ubuntu `polkitd` plus packaged `policykit-1-gnome` authentication agent |
| XDG portals | No custom backend implementation | Ubuntu `xdg-desktop-portal`, GTK and wlroots backend packages |
| D-Bus | No custom bus/session | Existing user bus; Sway imports compositor environment |
| Audio | No custom audio stack | Ubuntu PipeWire/WirePlumber session |
| Network | No custom network service | NetworkManager |

## Session lifecycle

GDM starts the selected Sway session. Sway starts only the session applications required by this configuration (Waybar, Mako, optional clipboard listener, optional Kanshi profile). There are no custom systemd user targets in this baseline. The repository does not change GDM's default session or remove GNOME.

## Why the PolicyKit agent is launched explicitly

Ubuntu's `policykit-1-gnome` package installs the standard agent binary and an XDG autostart desktop file. A Sway session does not necessarily run GNOME Shell's autostart machinery, so the Sway config launches the Ubuntu-packaged agent binary. This is not a locally implemented agent or custom service.

## Portal selection

The Ubuntu Noble `sway` package ships `/usr/share/xdg-desktop-portal/sway-portals.conf`, alongside its Sway session desktop file. The baseline installs Ubuntu's generic portal, GTK backend, and wlroots backend, and deliberately does not add a user-level portal override. Ubuntu's Sway-specific portal selection should route general interfaces to GTK and screenshot/screencast to wlroots; screen sharing and screenshot portal flows must still be tested in the VM.

The Noble Sway package also ships `/etc/sway/config.d/50-systemd-user.conf`. The personal config does not include `/etc/sway` fragments, so it imports `DISPLAY`, `WAYLAND_DISPLAY`, `SWAYSOCK`, and `XDG_CURRENT_DESKTOP` into the existing user/systemd D-Bus activation environment itself. This avoids coupling the personal config to that system fragment while retaining the same session-environment behavior.

## Machine-specific configuration

Do not hardcode output names, touchpad IDs, or USB keyboard identifiers in the shared baseline. Use `swaymsg -t get_outputs` and `swaymsg -t get_inputs`, then add local overrides to `~/.config/sway/config.d/local.conf` (created from the example if needed). Do not commit workstation-specific paths or credentials.

## Neovim version track

Ubuntu 24.04's archive package is Neovim 0.9.5. Current LazyVim 15.x requires Neovim 0.11.2 or newer, so the optional development profile uses the upstream Neovim Snap on a clean VM rather than installing the older APT build. If a Neovim executable is already installed, the helper reports its version and does not replace it automatically.
