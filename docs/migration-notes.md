# Migration notes from the source audit

## Retained or reworked

- Vim-style focus/move bindings, resize mode, French AZERTY workspace keysyms, smart resize helper.
- Waybar's Sway workspaces/mode, battery, network, audio, idle inhibitor, clock and tray modules.
- Basic idle locking via Ubuntu's packaged `swayidle` and `swaylock`.
- Rofi launcher and file spotlight workflow (rewritten to remove assumptions about `fd` being the executable name and avoid `eval`).
- Foot and Neovim use Catppuccin Mocha independently.
- LazyVim config retained without the nested `.git` directory or disabled example plugin.
- btop config retained in the optional development Stow package.
- Swaylock's Catppuccin color configuration retained.

## Removed by request

- pyenv initialization.
- Pamac update checks and Pamac window rules.
- sunset/wlsunset controls.
- scratchpad status module and Manjaro scratchpad watcher.
- weather module/script.
- `zeit` time-tracking module/service.
- Gemini notification script.

## Removed as distribution-specific or machine-specific

- `/etc/sway/definitions`, `/etc/sway/inputs`, `/etc/sway/modes`, `/etc/sway/config.d`, `/etc/sway/autostart` includes.
- `/usr/share/sway/scripts` and `/usr/share/sway/templates` references.
- Hard-coded Manjaro GTK/Kvantum theme mutation.
- Output names and device identifiers from the source machine.
- Absolute `/home/clement` Foot include path.
- Manjaro package manager and support links.
- Source-machine recording mode until a supported Ubuntu 24.04 recorder package is selected.
- Generated Zsh completion dumps, Python bytecode, btop log, Neovim `.git` directory, and unrelated pip/uv launcher shims.

## Known source-config gaps

- The uploaded home archive did not include all linked/target files from the source machine. The old `.zshrc` symlink and `~/.config/.zshrc` were examined separately in conversation, but they are not carried forward.
- The source Kanshi archive only contained an example file, not an active display profile. The new config starts Kanshi only if a real non-empty user config exists.
- The source had other user scripts (`dualsub`, `flashfocus`, `rofinder.sh`, etc.). They are not copied automatically because their dependencies and current use were not established. Add them individually after review.
