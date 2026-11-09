# Fonts

The APT profile installs JetBrains Mono, Fira Code, Noto Color Emoji, and Font Awesome. It does not install a Nerd Font-patched typeface.

If you want the same Nerd Font icon coverage as the source Manjaro setup, install a Nerd Font manually into your user font directory:

```bash
mkdir -p ~/.local/share/fonts
# Download and extract a release archive from https://github.com/ryanoasis/nerd-fonts/releases
# into ~/.local/share/fonts, then:
fc-cache -f
```

Do not copy machine-specific font caches. The Waybar stylesheet and Rofi configuration fall back to regular JetBrains Mono if the Nerd Font family is absent. Some LazyVim/plugin icons may remain unavailable until a Nerd Font is installed.
