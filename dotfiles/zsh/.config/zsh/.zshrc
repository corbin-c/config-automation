# User-owned Zsh configuration. No /etc/zsh or Manjaro config is sourced here.
export ZSH="${XDG_DATA_HOME:-$HOME/.local/share}/oh-my-zsh"
export ZSH_CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/oh-my-zsh"
mkdir -p "$ZSH_CACHE_DIR"

ZSH_THEME="robbyrussell"
plugins=(git node man sudo vscode)

if [[ -r "$ZSH/oh-my-zsh.sh" ]]; then
  source "$ZSH/oh-my-zsh.sh"
else
  print -u2 "Oh My Zsh not found at $ZSH. Run scripts/install-oh-my-zsh.sh from the workstation repository."
fi

# History
HISTFILE="${XDG_STATE_HOME:-$HOME/.local/state}/zsh/history"
mkdir -p "${HISTFILE:h}"
HISTSIZE=50000
SAVEHIST=50000
setopt HIST_IGNORE_DUPS HIST_IGNORE_SPACE SHARE_HISTORY INC_APPEND_HISTORY

# Common defaults
export EDITOR="${EDITOR:-nvim}"
export VISUAL="$EDITOR"
export PAGER="less"

# OSC 7: communicate the current directory to terminal emulators that support it.
function osc7 {
  local LC_ALL=C
  local uri="${PWD// /%20}"
  print -n "\e]7;file://${HOSTNAME}${uri}\e\\"
}
autoload -Uz add-zsh-hook
add-zsh-hook -Uz chpwd osc7
osc7

# Preserve the Alt+Arrow navigation behavior from the previous setup.
function cd_parent_and_list { builtin cd .. && ls }
function cd_home_and_list { builtin cd ~ && ls }
function cd_previous_and_list { popd >/dev/null 2>&1 || builtin cd -; ls }
zle -N cd_parent_and_list
zle -N cd_home_and_list
zle -N cd_previous_and_list
bindkey '^[[1;3A' cd_parent_and_list
bindkey '^[[1;3H' cd_home_and_list
bindkey '^[[1;3D' cd_previous_and_list

# Keep remote terminal compatibility for SSH sessions.
alias ssh='TERM=xterm-256color ssh'

# Optional personal overrides belong here, not in distribution files.
[[ -d "$ZDOTDIR/config.d" ]] && for f in "$ZDOTDIR"/config.d/*.zsh(N); do source "$f"; done
