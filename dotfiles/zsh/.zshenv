# Keep all interactive Zsh configuration in XDG_CONFIG_HOME.
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export ZDOTDIR="$XDG_CONFIG_HOME/zsh"
export PATH="$HOME/.local/bin:$PATH"
