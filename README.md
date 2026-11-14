# Minimal Ubuntu Sway Session

**Version:** 0.1.4  
**Target:** Ubuntu 24.04 LTS (Noble), with the standard GNOME desktop and GDM installed.

This repository adds a separate Sway login session. It does not replace GNOME or attempt to turn GNOME Shell into a tiling window manager.

## Scope

Included:

- Ubuntu-packaged Sway, Waybar, Rofi, Mako, Swaylock and Swayidle.
- Upstream `autotiling` 1.9.3, installed in an isolated `pipx` environment and launched by its absolute path. It chooses split orientation from the focused container dimensions; it is not a fixed alternating-orientation algorithm.
- The user's original Rofi layout and Manjaro palette, applied directly in `config.rasi` without a theme-loader directive (avoids Rofi parser errors).
- The user's original narrow, 12px vertical Waybar layout and Catppuccin Mocha palette. The Manjaro-only Waybar template import was replaced with local CSS; sunset controls were removed as previously requested.
- Focus follows mouse; Flashfocus 2.9.0 is installed in an isolated `pipx` environment by default.
- Super + arrow focus; Super + Shift + arrow move; Super + Ctrl + arrow resize.
- Ten numbered workspaces, using French AZERTY keysyms for the number row.
- Rofi application launcher (Super+D), the original Spotlight file search (Super+Space), and a Sway IPC window picker (Super+Tab), with invocation and error logging under `~/.local/state/sway-workstation/window-switcher.log`.
- Cliphist text and image history (Super+V), with MIME-aware restoration.
- Breeze cursor theme selected by Sway and passed to applications from the dedicated Sway session entry.
- Generic French keyboard and touchpad configuration.
- Screen recording mode restored from the original Sway configuration: Super+Shift+R opens the mode; `r` records a selected region without audio as WebM/VP8; Shift+R records the selected region with audio as MP4; both use a three-second countdown. Escape cancels; Super+Escape stops recording. Files are saved in the XDG Videos directory (falling back to `~/Videos`).
- Exit mode restored from the original user keybindings: Super+Delete opens lock, logout, suspend, reboot and shutdown choices; Escape cancels.

Not included:

- Foot or terminal configuration. Super+T and Super+Enter open the existing GNOME Terminal; Super+G opens GNOME Terminal running Neovim.
- Neovim, Zsh, Oh My Zsh, development packages or shell changes.
- Scratchpad, tabbed/stacking layout bindings, floating-window workflow, weather, time tracking, sunset controls, or personal application configuration.
- Changes to GNOME settings, GDM's default session, the packaged Ubuntu Sway session, or `/etc` configuration.

## Install

Extract or clone the repository to a stable location, then run it as your normal desktop user (not with `sudo`):

```bash
./install.sh --dry-run
./install.sh
```

Options:

```bash
./install.sh --without-flashfocus  # use Sway focus-follows-mouse without animation
./install.sh --no-packages         # deploy files only; dependencies must already exist
```

The installer checks for Ubuntu 24.04. It installs APT packages from Ubuntu repositories using `--no-install-recommends`; this includes `breeze-cursor-theme`, `wf-recorder`, `fd-find`, `thunar`, `pipx` and the existing desktop dependencies. `autotiling` 1.9.3 and Flashfocus 2.9.0 are pinned PyPI applications installed into isolated pipx environments, not Ubuntu's system Python.

The installer adds one session entry and wrapper:

- `/usr/local/share/wayland-sessions/sway-workstation.desktop`
- `/usr/local/bin/sway-workstation-session`

The wrapper sets `XCURSOR_THEME=breeze_cursors` and `XCURSOR_SIZE=24` for the Sway process tree. Sway then propagates those variables to the user D-Bus/systemd activation environment. The standard Ubuntu Sway session entry is left unchanged, and GNOME's GSettings cursor preference is not edited. GTK applications that explicitly prefer the saved GNOME cursor setting may still need separate verification.

`--no-packages` skips APT and pipx installation and does not install the additional GDM entry. Use the full install for the intended cursor behavior.

## GNOME fallback

GDM remains the display manager. GNOME remains installed and selectable. At the login screen, choose **Sway (workstation)** from the session chooser. To return to GNOME, log out and select Ubuntu/GNOME. The installer does not set Sway as the default session.

## Keybindings

| Shortcut | Action |
|---|---|
| Super+T / Super+Enter | Existing GNOME Terminal |
| Super+G | GNOME Terminal running Neovim |
| Super+W | Firefox |
| Super+F | Thunar file manager |
| Super+D | Rofi application launcher |
| Super+Space | Rofi file search (Spotlight) |
| Super+Tab / Alt+Space | Sway-aware window picker |
| Super+V | Clipboard history |
| Super+Arrows | Focus in direction |
| Super+Shift+Arrows | Move focused window |
| Super+Ctrl+Arrows | Smart resize |
| Super+1…0 | Switch workspace 1…10 |
| Super+Shift+1…0 | Move window to workspace 1…10 |
| Super+Delete | Open exit menu (lock, logout, suspend, reboot, shutdown) |
| Super+Shift+R | Open recording mode |
| In recording mode: `r` | Record selected region without audio (WebM/VP8) |
| In recording mode: `Shift+r` | Record selected region with audio (MP4) |
| In recording mode: `Escape` | Cancel recording mode |
| Super+Escape | Stop active recording |
| Super+Shift+Q | Lock screen |
| Super+Shift+C | Reload Sway configuration |
| F11 | Fullscreen toggle |
| Super+F9 | Toggle touchpad events |

On the French AZERTY layout, the unshifted number row is represented by `&`, `é`, `"`, `'`, `(`, `-`, `è`, `_`, `ç`, `à`. The bindings use these symbols so the physical number row works without Shift.

## Clipboard history

`wl-paste` listeners store text plus PNG, JPEG and WebP clipboard images in cliphist. They set `CLIPBOARD_TYPE` explicitly because Ubuntu 24.04's wl-clipboard 2.2.1 predates the newer MIME-type environment support used by current cliphist examples. The picker shows the preview while retaining the entry ID internally. When restoring an image, it reads the recorded MIME type and passes that to `wl-copy`, rather than mislabelling image bytes as plain text. The history is stored under `~/.cache/cliphist/`.

## Deployment and rollback

Files are symlinked individually from this repository into `$HOME`. Existing conflicting files are moved to:

```text
~/.local/state/sway-workstation-backups/<timestamp>-<random>/
```

Unrelated files and application state are left in place. Keep the repository at its current path because the deployed links point into it.

List backups and remove the managed links:

```bash
./scripts/rollback.sh list
./scripts/unlink.sh
./scripts/rollback.sh restore <backup-directory-name>
```

`unlink.sh` removes only symlinks that still point into this repository; it does not delete user files. `rollback.sh restore` also removes a matching managed symlink at a backed-up destination before restoring the original file. Other existing destinations are skipped. This is a file-level rollback, not a full system snapshot.

To remove only the additional GDM entry later:

```bash
sudo rm -f /usr/local/share/wayland-sessions/sway-workstation.desktop
sudo rm -f /usr/local/bin/sway-workstation-session
```

This does not remove Ubuntu's packaged Sway session or GNOME.

## Verification status

Run:

```bash
./tests/static-checks.sh
```

Static checks do not prove that Sway starts correctly on the target laptop. Before relying on it, test in an Ubuntu 24.04 VM or spare installation:

1. Confirm Ubuntu/GNOME, the packaged Sway session, and Sway (workstation) appear in GDM.
2. Open 3–5 windows and confirm split directions alternate as expected; try different window aspect ratios.
3. Confirm Rofi loads the original left-anchored layout with the Manjaro Catppuccin palette and Waybar is the original 12px vertical Catppuccin bar.
4. Test focus-follows-mouse and Flashfocus animation.
5. Test directional focus, move and resize bindings.
6. Test all ten workspaces with the French AZERTY keyboard.
7. Test Super+D app launcher, Super+Space Spotlight search, and Super+Tab native Wayland window picker. If the picker does not appear, inspect `~/.local/state/sway-workstation/window-switcher.log`; it records invocation and Rofi/Sway IPC errors.
8. Copy text and images, select each from cliphist, and verify paste MIME types.
9. Check pointer shape in GTK, Qt, browser and XWayland applications.
10. Test the exit menu (lock, logout, suspend, reboot, shutdown) and confirm Escape cancels it.
11. Test recording mode: `r` selects a region and records WebM/VP8 without audio; Shift+`r` selects a region and records MP4 with audio; confirm the countdown, Escape cancellation, Super+Escape stop, output location and Waybar indicator.
12. Test NetworkManager applet, PolicyKit prompts, screen sharing/portals, audio and suspend/resume.
13. Log out of Sway and confirm GNOME still works normally and retains its cursor preference.

No VM test has been performed as part of producing this archive. This update addresses the reported configuration defects, but should still be validated in the VM.
