# Migration notes from the source audit

## Retained or reworked

- Vim-style focus/move bindings, resize mode, French AZERTY workspace keysyms, smart resize helper and floating mouse modifier.
- Generic touchpad settings and an optional touchpad toggle; no source-machine device ID is embedded.
- Waybar Sway workspaces/mode, battery, network, audio, idle inhibitor, clock, tray and a screen-recording indicator.
- Basic idle locking via Ubuntu's packaged `swayidle` and `swaylock`.
- Rofi launcher and file spotlight workflow.
- Foot and Neovim use Catppuccin Mocha independently.
- Swaylock's Catppuccin configuration restored to the Sway Stow package.
- Screenshot clipboard copy now explicitly declares `image/png`; full and region PNGs can also be saved.
- Screen recording is restored with Ubuntu Noble's `wf-recorder` package.
- Power menu now asks before reboot/poweroff and includes lock, logout and suspend.
- Zsh uses the XDG config path and upstream Oh My Zsh; Manjaro config and pyenv are removed.

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
- Absolute `/home/...` Foot include path.
- Manjaro package manager and support links.
- Generated Zsh completion dumps, Python bytecode, btop log, Neovim `.git` directory, and unrelated pip/uv launcher shims.

## Deferred or intentionally simplified

- Swappy annotation is not installed because it is absent from Noble's package archive; optional invocation is retained if the user installs it independently.
- Nerd Font installation is not automated; unsupported Nerd Font-only glyphs were removed from Waybar.
- Swayr is not included as an additional dependency. Alt+Tab uses Sway's built-in focus cycling instead of swayr's LRU policy.
- Waybar modules for CPU, memory, temperature, Bluetooth, GitHub notifications, playerctl, calendar and language switching were disabled or not retained pending a current-use decision.
- `wob` OSD, `wl-clip-persist`, foot server, `flashfocus`, `sworkstyle`, autotiling and third-party helper shims remain deferred; no source audit evidence established that these were necessary on the work machine.
- Automatic screen dimming, output-off and suspend timers remain with Ubuntu's power-management policy. Sway adds only lock timeout and lock-before-sleep.
- Kanshi is started only if the user supplies a non-empty profile; no machine-specific outputs are assumed.
