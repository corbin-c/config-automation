# Architecture and ownership

## Configuration precedence and ownership

| Concern | Repository / user layer | Ubuntu-owned layer |
|---|---|---|
| Sway behavior | `~/.config/sway/**` | Sway executable and GDM session entry |
| Waybar / Rofi / Foot / Mako | User dotfiles | Packaged applications |
| Zsh interactive shell | `~/.config/zsh/.zshrc` | `/etc/zsh` and `/etc/profile` remain unmodified |
| Oh My Zsh | `~/.local/share/oh-my-zsh` | Git package and upstream source |
| GTK/cursor/icons | GNOME Settings | GNOME settings schemas/services |
| PolicyKit | No custom daemon; packaged agent launched in Sway | Ubuntu `polkitd` and `policykit-1-gnome` |
| XDG portals | No custom backend | Ubuntu portal, GTK and wlroots backend packages |
| D-Bus | Existing user bus; compositor environment imported | Ubuntu user/session bus |
| Audio | No custom audio stack | Ubuntu PipeWire/WirePlumber session |
| Network | No custom network service | NetworkManager |
| Suspend/display power | Sway requests lock before sleep | Ubuntu power management |

## Session lifecycle

GDM starts the selected Sway session. Sway starts Waybar, Mako, NetworkManager applet, Swayidle, optional clipboard history and optional Kanshi. No custom systemd target or system service is installed. The repository does not change GDM's default session or remove GNOME.

## Stow and data safety

Stow runs with `--no-folding`; individual files are symlinked into existing user directories. Deployment backs up exact path conflicts only. It does not replace entire application config directories or delete untracked files. This is intentionally non-destructive, but unknown files in Sway/Zsh include directories can still be loaded by the applications and should be reviewed during migration.

## Machine-specific configuration

Do not hardcode output names, hardware device IDs, or USB keyboard identifiers in the shared baseline. Use `swaymsg -t get_outputs` and `swaymsg -t get_inputs`, then add local overrides to `~/.config/sway/config.d/local.conf`.

## Neovim version track

Ubuntu 24.04's archive Neovim is older than the retained LazyVim configuration requires. The optional development profile installs the upstream Neovim Snap only when no `nvim` is present; it refuses to replace an existing older build. The Snap uses classic confinement.
