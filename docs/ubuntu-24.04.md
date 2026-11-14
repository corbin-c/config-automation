# Ubuntu 24.04 compatibility notes

The repository uses Ubuntu Noble packages for Sway, Waybar, Rofi, Mako, Swaylock, Swayidle, cliphist, wl-clipboard, XWayland, portal backends and the PolicyKit agent.

Sway is installed from Ubuntu's `universe` repository. The Rofi package in Noble is the X11 build; it runs under Sway through XWayland. The custom window picker does not use Rofi's X11 window enumeration: it queries Sway's IPC tree and asks Rofi to display the resulting list.

Flashfocus is not packaged in Noble. It is installed with pipx, pinned to PyPI version 2.9.0, with its documented Ubuntu/Debian native build dependencies installed from APT. The pipx environment keeps its Python dependencies separate from Ubuntu's externally managed system Python.

The Sway package provides the GDM Wayland session entry and a Sway portal configuration. The installer does not create a second portal configuration or modify `/etc`.
