# Ubuntu Sway Workstation Bootstrap

**Version:** 0.2.0

**Target:** Ubuntu 24.04 LTS (Noble), GNOME/GDM installation retained.

This repository is a conservative migration of a customized Manjaro/Sway workstation. It is not a copy of the old system configuration. Ubuntu remains the owner of system services and session infrastructure; this repository manages user dotfiles and a small set of user scripts.

## Decisions and ownership

- GDM remains the display manager; GNOME remains installed and selectable.
- Sway comes from Ubuntu 24.04 repositories. No PPA or upstream compositor build is added.
- GNU Stow deploys user configuration from `dotfiles/` into `$HOME`.
- Ubuntu owns PolicyKit, XDG portals, D-Bus, PipeWire/WirePlumber, NetworkManager and system power management.
- GNOME owns GTK, cursor and icon preferences. Foot and Neovim have independent Catppuccin Mocha themes.
- No `/etc` configuration, systemd units, system services, GDM defaults or default session are changed.
- Zsh remains an opt-in login-shell change; the installer does not call `chsh` unless explicitly asked.

## Profiles

| Profile | Installs | Deploys |
|---|---|---|
| `desktop` (default) | Sway session tools, Waybar, Rofi, Foot, Mako, clipboard, screenshots, `wf-recorder`, portals, PolicyKit agent, fonts and dependencies | Sway, Waybar, Rofi, Foot, Mako, Zsh, local scripts, optional Kanshi example |
| `development` | btop, ripgrep, fzf, build tools, Python venv support | Zsh, Neovim config, btop |
| `all` | Both package manifests | Both dotfile sets |

The development profile installs upstream Neovim via Snap only when no `nvim` is already present. An existing Neovim older than 0.11.2 causes a clear stop; it is not silently replaced. Snap's classic confinement is an explicit trade-off. If you do not want Snap, install a compatible Neovim yourself and run `--no-packages`.

## Install

On a clean Ubuntu 24.04 LTS installation, obtain this repository from your own Git remote or extract the release archive. From its root:

```bash
./install.sh --dry-run
./install.sh --profile desktop
# or: ./install.sh --profile all
```

For an actual Git checkout, initialize/attach your own remote as appropriate. The release archive does not invent or embed a remote URL.

Useful options:

```bash
./install.sh --profile development
./install.sh --profile all --dry-run
./install.sh --no-packages                 # requires dependencies already installed
./install.sh --no-oh-my-zsh
./install.sh --set-default-shell           # explicit, opt-in passwd shell change
```

The installer validates that the host is Ubuntu 24.04. It does not remove packages, edit `/etc`, change GDM, change GNOME settings or change the default session.

## Deployment and backups

Stow uses `--no-folding`, so config directories remain real directories and individual managed files are symlinks into this checkout. This allows applications to keep writing their state under `$HOME` rather than into the Git working tree.

Before deployment, the script backs up only exact conflicting files/links. Existing config directories, unrelated files and generated application state are preserved. Re-running the installer does not move the entire config directory into backups. Unknown pre-existing files in include directories are deliberately not deleted; inspect `~/.config/sway/config.d/` and `~/.config/zsh/config.d/` if migrating from another setup.

Backups are stored under:

```text
~/.local/state/workstation-backups/<timestamp>-<random>/
```

List backups and restore files only when their destination is absent:

```bash
./scripts/rollback.sh list
./scripts/rollback.sh restore <backup-directory-name>
```

The rollback helper never overwrites a currently existing path. It retains the backup directory after restore. Review its output; this is a file-level restore, not a full system snapshot.

## Sway behavior

- French AZERTY layout; generic touchpad settings (`natural_scroll disabled`, `dwt`, `dwtp`, `tap` enabled).
- Vim-style focus/movement, resize mode, workspaces, floating drag modifier and built-in Alt+Tab cycling.
- Five-minute lock timeout and lock-before-sleep. Ubuntu retains ownership of suspend and display power policy.
- `Super+Shift+E` opens a confirmation-based power menu; `Super+Shift+Q` locks.
- Print copies a full screenshot; Super+Print copies a selected region. Shift+Print and Super+Shift+Print save PNGs under `~/Pictures/Screenshots/`.
- Super+Shift+R toggles screen recording; active recording appears in Waybar and can be stopped by clicking the indicator. Videos go to `~/Videos/Recordings/`.
- A solid Catppuccin background is set by default. Machine-specific output layout belongs in `~/.config/sway/config.d/local.conf`.

The screenshot workflow saves/copies PNGs. Clipboard history is text-only in this version. Annotation through Swappy is optional and only activated if a compatible `swappy` command is installed separately; Swappy is not in Noble's package archive. No screenshot upload is included.

## Oh My Zsh

Oh My Zsh is cloned to `~/.local/share/oh-my-zsh`; the interactive config is `~/.config/zsh/.zshrc`, selected by `~/.zshenv`. Manjaro Zsh snippets, pyenv initialization and the old nested Zsh indirection are not used. The installer shallow-clones the upstream default branch if absent and records no automatic update policy; for reproducible environments, pin a reviewed commit in your own deployment process.

## Neovim and language tooling

The retained LazyVim configuration includes language extras for JSON, Markdown, PHP, Prisma, Python, Tailwind, TOML, TypeScript, Vue and YAML, plus ESLint and Prettier. The bootstrap does not install every language runtime, package manager or formatter. Install the relevant toolchains only for languages you use. The OpenSCAD formatter configured in `conform.lua` requires `openscad-format` to be installed separately; formatting will not work until it is available.

## Verification

```bash
./scripts/verify.sh --profile desktop
./scripts/verify.sh --profile development
```

Run `./tests/static-checks.sh` for the local static checks. Static checks are not a substitute for a clean Ubuntu 24.04 VM. Follow `tests/vm-checklist.md` before using this on a work machine.

## Layout

- `packages/`: APT package manifests.
- `dotfiles/`: GNU Stow packages.
- `scripts/`: installer, deployment, rollback, verification and session helpers.
- `docs/`: architecture, migration notes, compatibility and font notes.
- `tests/`: VM acceptance checklist.
