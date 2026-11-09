# Ubuntu 24.04 VM acceptance checklist

## Before install

- [ ] Snapshot a clean Ubuntu 24.04 LTS VM with GNOME/GDM.
- [ ] Confirm GDM offers both GNOME and Sway after installation.
- [ ] Run `./install.sh --dry-run --profile all` and inspect package/profile output.
- [ ] Confirm Ubuntu Universe is enabled (Sway and related utilities are in Universe).

## Install and repeatability

- [ ] Run `./install.sh --profile all`.
- [ ] Confirm no `/etc` files, GDM defaults, systemd units or login-shell setting changed.
- [ ] Inspect Stow links and the backup directory.
- [ ] Run the installer a second time; confirm no whole config directories move and no app state is displaced.
- [ ] Create an unrelated file in `~/.config/sway/` and repeat; confirm it remains.
- [ ] Test `scripts/rollback.sh list` and restore on a disposable snapshot.

## Sway session

- [ ] Log into Sway from GDM; confirm GNOME remains selectable and still works.
- [ ] Run `swaymsg -t get_version` and `swaymsg -t get_outputs`.
- [ ] Confirm Waybar, Mako, NetworkManager applet and the Ubuntu PolicyKit agent start once.
- [ ] Confirm no `/etc/sway` include is required.
- [ ] Test French AZERTY layout and workspace bindings.
- [ ] Test generic touchpad settings and Super+F9 toggle on real touchpad hardware.
- [ ] Test floating drag/resize with Super+mouse buttons.
- [ ] Test Alt+Tab, resize mode, smart resize helper and power menu.
- [ ] Confirm the five-minute lock and lock-before-sleep behavior; verify Ubuntu still owns suspend/display power policy.

## Desktop workflows

- [ ] Test Foot, Rofi app launcher, Rofi spotlight and Nautilus.
- [ ] Test Waybar battery/network/audio/clock/tray and recording indicator.
- [ ] Copy text to clipboard history, open menu, paste and clear history.
- [ ] Copy full screenshot and selected region; verify clipboard MIME is `image/png` in a target application.
- [ ] Save full and region PNGs under `~/Pictures/Screenshots/`.
- [ ] Start/stop `wf-recorder`; confirm MP4 appears under `~/Videos/Recordings/` and Waybar indicator updates.
- [ ] Test Swaylock appearance and suspend/resume.
- [ ] Test external display hotplug; add Kanshi profile only after recording actual output names.

## Ubuntu integration

- [ ] Launch a graphical privileged app and confirm the PolicyKit dialog appears.
- [ ] Confirm no duplicate PolicyKit agent.
- [ ] Test Flatpak/Snap file chooser and screen sharing through XDG portals.
- [ ] Confirm PipeWire/WirePlumber audio, microphone and Bluetooth/network integration.
- [ ] Confirm GNOME GTK/cursor/icon settings are unchanged after Sway login/logout.
- [ ] Log back into GNOME and confirm normal operation.

## Known untested areas

- [ ] Test Waybar module schema against Noble's installed Waybar version.
- [ ] Test Sway config with Noble's `sway -C` parser before logging into the session.
- [ ] Test screen recording on the actual GPU/driver and multi-monitor setup.
- [ ] Test image clipboard interoperability in Firefox, LibreOffice and the target work applications.
