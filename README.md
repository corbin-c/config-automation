# Ubuntu Sway Workstation

A first, deliberately conservative Ubuntu 24.04 LTS workstation bootstrap based on an audited Manjaro/Sway setup.

## Design decisions

- GDM remains the display manager; GNOME remains installed and selectable.
- Sway comes from Ubuntu 24.04 repositories. The repository does not add PPAs or replace Ubuntu's Sway package.
- GNU Stow deploys personal configuration from `dotfiles/` into `$HOME`.
- The repository owns personal configuration and user scripts, not Ubuntu's system defaults.
- Ubuntu provides PolicyKit, XDG portals, D-Bus, PipeWire/WirePlumber, NetworkManager, and GNOME settings infrastructure. We install/use their supported packages and do not copy Manjaro's `/etc` definitions.
- GNOME owns GTK, cursor, and icon preferences. Foot and Neovim have their own Catppuccin Mocha theme configuration.
- No custom systemd session targets or system services are installed in this first iteration.

## Included profile

The desktop profile installs Sway, Waybar, Rofi, Foot, Mako, screen locking/idle tools, clipboard utilities, portal backends, the Ubuntu GNOME PolicyKit agent, screenshot tools, and common fonts/utilities.

The development profile is separate and optional. It installs btop, Git tooling, ripgrep, fzf, and basic build tools, and installs upstream Neovim via Snap if no Neovim is already present. Ubuntu 24.04's APT Neovim is too old for the current LazyVim release.

## Install

On a clean Ubuntu 24.04 LTS installation:

```bash
sudo apt update
sudo apt install git
git clone <your-repository-url> ~/src/workstation
cd ~/src/workstation
./install.sh --dry-run
./install.sh
```

The installer does not change the default display manager, default session, GNOME settings, `/etc/sway`, `/etc/zsh`, or `/etc/profile`. It leaves the login shell unchanged unless `--set-default-shell` is explicitly passed. It backs up existing application config directories before Stow creates links, preventing stale untracked fragments from remaining active. Shared directories such as `~/.local/bin` are handled with file-level backups. Existing GNOME files and packages are not removed.

To install only the desktop profile:

```bash
./install.sh --profile desktop
```

To install desktop and development packages:

```bash
./install.sh --profile all
```

To also make Zsh your login shell, opt in explicitly with `--set-default-shell`.

To deploy configuration without installing packages (requires `stow`, `git`, and the target applications to be installed already):

```bash
./install.sh --no-packages
```

The installer clones upstream Oh My Zsh into `~/.local/share/oh-my-zsh` if it is not already present. It does not run the upstream interactive installer or replace your login shell. The development profile uses the upstream Neovim Snap because Ubuntu 24.04 APT ships Neovim 0.9.5 while current LazyVim requires 0.11.2 or newer. If an older Neovim is already installed, the installer stops rather than silently replacing it.

## After installation

1. Log out.
2. At GDM, select the session gear menu and choose **Sway**.
3. Log in. GNOME remains available from the same menu.
4. Check the verification output: `./scripts/verify.sh`.
5. Test PolicyKit authentication with a graphical application that requests authorization. Do not launch graphical applications with `sudo`.
6. Test screen sharing and screenshot/portal flows in the VM before relying on them at work.

## Current limitations / intentional deferrals

- Display output profiles are not configured: the previous profile used machine-specific output names. Add a Kanshi profile only after recording the work machine's actual output names and desired layout.
- `cliphist` is installed from Ubuntu; the clipboard menu and listener start only when the executable is present.
- No custom screenshot-upload workflow is included.
- No Gemini, weather, time-tracking, sunset, scratchpad, pyenv, Pamac, or Manjaro update components are included. Mako is retained as the Sway notification daemon.
- The source archive did not contain the target of all existing symlinks, nor did it contain every referenced Manjaro script. This repository is a clean baseline, not a byte-for-byte migration. Screen recording is deferred in the first Ubuntu package set; the Manjaro `wf-recorder` integration is not carried over.

## Repository layout

- `packages/`: APT package manifests.
- `dotfiles/`: Stow packages. Each package mirrors paths below `$HOME`.
- `scripts/`: installer, safe Stow deployment, and verification.
- `docs/`: architecture, migration notes, package compatibility, and font notes.
- `tests/`: VM acceptance checklist.

## Updating

```bash
git pull --ff-only
./install.sh --no-packages
```

Review changes before deploying them. Stow links individual files (not whole config directories), so applications can still write generated state into their home-directory config folders. Existing app config directories are backed up before the first deployment; restoring them is a manual rollback step.
