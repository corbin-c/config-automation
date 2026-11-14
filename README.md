# Minimal Ubuntu Sway Session

**Version:** 0.1.0  
**Target:** Ubuntu 24.04 LTS (Noble) with the standard GNOME desktop and GDM already installed.

This repository adds a separate Sway login session. It does not replace GNOME or attempt to turn GNOME Shell into a tiling window manager.

## Scope

Included:

- Ubuntu-packaged Sway, Waybar, Rofi, Mako, Swaylock and Swayidle.
- Automatic tree tiling (`default_orientation auto`).
- Focus follows mouse; Flashfocus 2.9.0 is installed in an isolated `pipx` environment by default.
- Super + arrow focus; Super + Shift + arrow move; Super + Ctrl + arrow resize.
- Ten numbered workspaces, using French AZERTY keysyms for the number row.
- Rofi application launcher (Super+D), command launcher (Super+Space), and a Sway IPC window picker (Super+Tab).
- Cliphist text and image history (Super+V), with MIME-aware restoration.
- A narrow 30px Waybar and 1px inner gaps.
- Generic French keyboard and touchpad configuration.

Not included:

- Foot or terminal configuration. Super+Enter temporarily opens the existing GNOME Terminal.
- Neovim, Zsh, Oh My Zsh, development packages or shell changes.
- Scratchpad, tabbed/stacking layout bindings, floating-window controls, weather, time tracking, sunset controls, or personal application configuration.
- Custom system services, systemd targets, `/etc` edits, GDM changes, default-session changes, or GNOME settings changes.

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

The installer checks for Ubuntu 24.04. It installs APT packages from Ubuntu repositories using `--no-install-recommends`; in particular, this avoids pulling Foot in as Sway's optional recommendation. Flashfocus is installed separately with pipx, pinned to 2.9.0; it is not installed into Ubuntu's system Python. The package's documented native build dependencies are installed through APT.

## GNOME fallback

GDM remains the display manager. GNOME remains installed and selectable. At the login screen, select the Sway session from the session chooser. To return to GNOME, log out and select Ubuntu/GNOME. The installer does not set Sway as the default session.

## Keybindings

| Shortcut | Action |
|---|---|
| Super+Enter | Existing GNOME Terminal |
| Super+D | Rofi application launcher |
| Super+Space | Rofi command launcher |
| Super+Tab | Sway-aware window picker |
| Super+V | Clipboard history |
| Super+Arrows | Focus in direction |
| Super+Shift+Arrows | Move focused window |
| Super+Ctrl+Arrows | Smart resize |
| Super+1…0 | Switch workspace 1…10 |
| Super+Shift+1…0 | Move window to workspace 1…10 |
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

## Verification status

Run:

```bash
./tests/static-checks.sh
```

Static checks do not prove that Sway starts correctly on the target laptop. Before relying on it, test in an Ubuntu 24.04 VM or spare installation:

1. Confirm both Ubuntu/GNOME and Sway appear in GDM.
2. Test automatic split direction with several windows.
3. Test focus-follows-mouse and Flashfocus animation.
4. Test directional focus, move and resize bindings.
5. Test all ten workspaces with the French AZERTY keyboard.
6. Test Rofi app, command and native Wayland window pickers.
7. Copy text and images, select each from cliphist, and verify paste MIME types.
8. Test NetworkManager applet, PolicyKit prompts, screen sharing/portals, audio and suspend/resume.
9. Log out of Sway and confirm GNOME still works normally.

No VM test has been performed as part of producing this archive.
