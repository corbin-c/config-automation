# Ubuntu 24.04 VM acceptance checklist

## Before install

- [ ] Snapshot a clean Ubuntu 24.04 LTS VM with GNOME/GDM.
- [ ] Confirm `echo "$XDG_CURRENT_DESKTOP"` and GDM session chooser behavior.
- [ ] Run `./install.sh --dry-run` and inspect the package list.

## Install and session

- [ ] Run `./install.sh --profile all`.
- [ ] Confirm GDM remains enabled and GNOME is still selectable.
- [ ] Log into Sway from GDM; confirm no `/etc/sway` include is required.
- [ ] Confirm `swaymsg -t get_version` and `swaymsg -t get_outputs` work.
- [ ] Reload Sway; confirm Waybar/Mako/clipboard listener are not duplicated.
- [ ] Confirm Sway's user environment is visible to D-Bus/systemd-activated apps.

## Desktop behavior

- [ ] Test French keyboard layout and workspace bindings.
- [ ] Test Foot, Rofi app launcher, Rofi spotlight, and Nautilus.
- [ ] Test smart resize helper and resize mode.
- [ ] Test Waybar battery/network/audio/clock/tray modules.
- [ ] Test clipboard history: copy text, open clipboard menu, paste; clear history.
- [ ] Test screenshot to clipboard and region screenshot.
- [ ] Test Swaylock and suspend/resume.
- [ ] Test external display hotplug; only then add Kanshi profiles.

## Ubuntu integration

- [ ] Launch a graphical privileged app and confirm a PolicyKit authentication dialog appears.
- [ ] Confirm no second PolicyKit agent is running.
- [ ] Test Flatpak/Snap file chooser and screen sharing through XDG portals.
- [ ] Confirm PipeWire/WirePlumber audio and Bluetooth/network integration.
- [ ] Confirm GNOME GTK/cursor/icon settings are unchanged after Sway login and logout.
- [ ] Log back into GNOME and confirm the session still works normally.

## Installer safety

- [ ] Re-run installer; confirm idempotency.
- [ ] Confirm conflicting user files were backed up under `~/.local/state/workstation-backups/`.
- [ ] Test rollback from backup on a disposable VM snapshot.
