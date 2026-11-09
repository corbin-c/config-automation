# Fonts

The desktop manifest installs Ubuntu-packaged JetBrains Mono, Fira Code, Noto Color Emoji and Font Awesome. Waybar uses Font Awesome glyphs where icons are needed; it does not assume a Nerd Font patch.

If a patched Nerd Font is preferred, install it per-user under `~/.local/share/fonts/`, refresh the font cache with `fc-cache -f`, and update Waybar's CSS. Do not install fonts system-wide as part of this bootstrap.
