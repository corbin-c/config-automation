# Ubuntu 24.04 VM acceptance checklist

Use a clean Ubuntu 24.04 Desktop VM with GNOME/GDM. Take a VM snapshot first.

## Before installation

- [ ] Confirm the login screen currently offers the normal Ubuntu/GNOME session.
- [ ] Extract the repository into a stable path in the test user's home directory.
- [ ] Run `./install.sh --dry-run` and review the package list.
- [ ] Run `./tests/static-checks.sh`.

## Installation and login

- [ ] Run `./install.sh` as the normal user, not with `sudo`.
- [ ] Confirm the installer did not change GDM defaults or GNOME settings.
- [ ] Log out; select Sway from GDM's session chooser.
- [ ] Confirm Waybar, Mako, NetworkManager applet and PolicyKit agent start.
- [ ] Log out and select Ubuntu/GNOME; confirm the original GNOME session still works.

## Window management

- [ ] Open one application: it fills the workspace.
- [ ] Open a second and third application: Sway automatically chooses split orientation based on available space.
- [ ] Move the pointer over each window: focus follows the pointer.
- [ ] Confirm Flashfocus visibly indicates focus changes.
- [ ] Test Super+arrow focus in all four directions.
- [ ] Test Super+Shift+arrow movement in all four directions.
- [ ] Test Super+Ctrl+arrow resize in all four directions.
- [ ] Test all ten workspaces using the French AZERTY number row.
- [ ] Move windows with Super+Shift+number and return with Super+number.
- [ ] Confirm no unexpected scratchpad, tabbed or floating-window workflow is required.

## Launchers and clipboard

- [ ] Super+D opens the application launcher.
- [ ] Super+Space opens command search.
- [ ] Super+Tab lists both native Wayland and XWayland windows; selecting an item focuses it.
- [ ] Copy several text snippets; Super+V lists them and pastes the selected entry.
- [ ] Copy a PNG image; Super+V restores it as `image/png`.
- [ ] If available, repeat with JPEG and WebP images.
- [ ] Clear clipboard history from Waybar's right-click action and verify the history is empty.

## Integration and fallback

- [ ] Wi-Fi/Ethernet can be managed from the NetworkManager applet.
- [ ] Trigger a PolicyKit prompt and confirm it is visible and usable.
- [ ] Test screen sharing and file chooser portal behavior in applications that use portals.
- [ ] Test audio output, volume keys, media keys and brightness keys.
- [ ] Test lock screen, suspend and resume.
- [ ] Log back into GNOME and verify its appearance and settings were not changed.

## Recovery

- [ ] From GNOME, run `./scripts/unlink.sh` if you want to remove the Sway config links.
- [ ] Use `./scripts/rollback.sh list` and restore a backup if needed.
- [ ] Confirm GDM still offers GNOME even if the Sway session is not working.
