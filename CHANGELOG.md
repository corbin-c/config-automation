# Changelog

## 0.2.0 — 2026-11-08

### Fixed
- Restored the Catppuccin Swaylock configuration that the Sway config invokes.
- Replaced whole-directory backups with exact-conflict backups. Existing application state and unrelated files remain in place on repeat deployment.
- Added a conservative rollback helper for deployment backups.
- Corrected screenshot clipboard MIME to `image/png` and added persistent screenshot-to-file commands.
- Restored floating-window mouse modifier, generic touchpad settings, touchpad toggle, a confirmation-based power menu, and Alt+Tab window cycling.
- Added Ubuntu Noble `wf-recorder` support and a Waybar recording indicator.
- Replaced Nerd Font-only Waybar symbols with Font Awesome glyphs.
- Added explicit `xdg-utils` and `python3` dependencies.
- Made verification profile-aware and removed the undeclared NVM Oh My Zsh plugin.

### Changed
- Sway uses a solid Catppuccin background by default rather than depending on a missing wallpaper file.
- Sway idle lock is set to five minutes; suspend and display power policy remain owned by Ubuntu.
- Development-only profile no longer deploys desktop helper scripts.
- `--set-default-shell` checks the passwd database rather than the `$SHELL` environment variable.

### Deliberately not included
- Swappy annotation: it is not available in Ubuntu 24.04 Noble's package archive. Screenshot capture/save is included; an optional `swappy` binary is used if the user installs one separately.
- Nerd Font download/installation: regular JetBrains Mono, Fira Code and Font Awesome are installed; no Nerd Font is assumed.
- Machine-specific display profiles, output names, or device IDs.
- Automatic suspend, output-off and brightness-dimming timers: Ubuntu's power-management policy remains authoritative.

### Validation status
- Shell syntax, Python compilation, JSON parsing, static repository checks and dry-run command structure are checked in the build environment.
- No Ubuntu 24.04 VM installation, APT transaction, Sway parser run, real Stow deployment, graphical session, portal, PolicyKit prompt, audio, recording or rollback test has been performed. These remain required VM acceptance tests.
