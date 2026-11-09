# Ubuntu 24.04 compatibility notes

- The target is Ubuntu 24.04 LTS (Noble) with GDM and GNOME already installed.
- Sway, Waybar, Rofi, Foot, Mako, Swaylock, Swayidle, wl-clipboard, cliphist, grim, slurp, wf-recorder, Kanshi and the portal backends are selected from Ubuntu packages.
- Ubuntu's Sway package supplies the session entry and Sway-specific portal selection metadata. The personal config does not source Manjaro `/etc/sway` fragments.
- `policykit-1-gnome` supplies the authentication agent launched by the Sway config.
- Ubuntu Desktop supplies PipeWire/WirePlumber and NetworkManager integration; this repository does not install a competing audio/network stack.
- `swappy` is not present in the Ubuntu 24.04 Noble package archive; screenshot annotation is therefore not an automatic package dependency.
- Regular JetBrains Mono, Fira Code, Noto Color Emoji and Font Awesome packages are installed. A patched Nerd Font is not assumed.
- The development profile installs Neovim from Snap only when needed; an existing older Neovim causes a stop rather than replacement.

Package availability should still be confirmed by `apt-get install` in the target VM with the intended Ubuntu repository components enabled. Web/package-index review is not an APT transaction test.
