sudo apt update

sudo apt install \
  build-essential git meson ninja-build pkg-config \
  flex bison check \
  libpango1.0-dev libcairo2-dev libglib2.0-dev \
  libgdk-pixbuf-2.0-dev libstartup-notification0-dev \
  libxkbcommon-dev libxkbcommon-x11-dev \
  libxcb1-dev libxcb-xkb-dev libxcb-randr0-dev \
  libxcb-xinerama0-dev libxcb-ewmh-dev \
  libxcb-icccm4-dev libxcb-cursor-dev \
  libwayland-dev wayland-protocols

cd ~/Downloads

wget https://github.com/davatorium/rofi/releases/download/2.1.0/rofi-2.1.0.tar.xz

tar -xf rofi-2.1.0.tar.xz
cd rofi-2.1.0

meson setup build --prefix=/usr/local
ninja -C build

sudo ninja -C build install
