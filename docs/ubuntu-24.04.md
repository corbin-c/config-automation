# Ubuntu 24.04 compatibility notes

The repository uses Ubuntu Noble packages for Sway, Waybar, Rofi, Mako, Swaylock, Swayidle, cliphist, wl-clipboard, XWayland, portal backends, the PolicyKit agent, Breeze cursors, Font Awesome and wf-recorder.

Sway is installed from Ubuntu's `universe` repository. The Rofi package in Noble is the X11 build; it runs under Sway through XWayland. The custom window picker does not use Rofi's X11 window enumeration: it queries Sway's IPC tree and asks Rofi to display the resulting list.

The upstream `autotiling` helper is installed from PyPI at version 1.9.3 using pipx. It uses i3ipc to watch Sway events and choose `splitv` or `splith` based on the focused container's dimensions. This is distinct from Sway's built-in `default_orientation auto`, which does not provide the same event-driven behavior. PyPI's published release history currently identifies 1.9.3 as the latest published release. See the upstream [project documentation](https://github.com/nwg-piotr/autotiling) and [PyPI release metadata](https://pypi.org/project/autotiling/).

Flashfocus is not packaged in Noble. It is installed with pipx, pinned to PyPI version 2.9.0, with its documented Ubuntu/Debian native build dependencies installed from APT. The pipx environments keep Python dependencies separate from Ubuntu's externally managed system Python.

The Breeze cursor theme package installs the theme as `/usr/share/icons/breeze_cursors`. The Sway config selects that exact theme name, and a separate GDM session wrapper exports `XCURSOR_THEME=breeze_cursors` and `XCURSOR_SIZE=24` before starting Sway. This avoids changing GNOME's cursor preference. The extra session entry is installed under `/usr/local/share/wayland-sessions`; GDM searches the system XDG data directories for Wayland session entries.

The Sway package provides the standard GDM Wayland session entry and a Sway portal configuration. The installer leaves the packaged session entry, GNOME session, GDM default, and `/etc` configuration untouched.
