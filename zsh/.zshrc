# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.

# Edit PATH variable (set PATH to the and to fix issues with WSL)
export PATH="/home/tom/.cargo/bin:$PATH:$HOME/.krew/bin:$HOME/.local/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin:/snap/bin:$HOME/.kubescape/bin:/home/linuxbrew/.linuxbrew/bin:$HOME/go/bin"

# Set the directory we want to store zinit and plugins
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# Download Zinit, if it's not there yet
if [ ! -d "$ZINIT_HOME" ]; then
   mkdir -p "$(dirname "$ZINIT_HOME")"
   git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# load additional config
if [ -f "$HOME/.additional_zsh_config" ]; then
   source "$HOME/.additional_zsh_config"
fi

# Source/Load zinit
source "${ZINIT_HOME}/zinit.zsh"

# add Oh-my-Posh
command -v oh-my-posh >/dev/null 2>&1 && eval "$(oh-my-posh init zsh --config $HOME/.config/ohmyposh/config.toml)"

# Add in zsh plugins
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab

# Add in snippets
zinit snippet OMZP::git
zinit snippet OMZP::sudo
zinit snippet OMZP::archlinux
zinit snippet OMZP::aws
zinit snippet OMZP::kubectl
zinit snippet OMZP::kubectx
zinit snippet OMZP::command-not-found

# Update zinit
zinit self-update >/dev/null 2>&1

# Remove "zi" alias for default zoxide alias to work
unalias zi

# Keybindings
bindkey -e
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward
bindkey '^[w' kill-region
bindkey "^[[3~" delete-char
bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word

# History
HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

# Load completions
autoload -Uz compinit && compinit
zinit cdreplay -q
command -v fzf >/dev/null 2>&1 && eval "$(fzf --zsh)"
command -v helm >/dev/null 2>&1 && eval "$(helm completion zsh)"
command -v kubectl >/dev/null 2>&1 && complete -F __start_kubectl k
command -v talosctl >/dev/null 2>&1 && eval "$(talosctl completion zsh)"
command -v trivy >/dev/null 2>&1 && eval "$(trivy completion zsh)"
command -v zoxide >/dev/null 2>&1 && eval "$(zoxide init zsh --cmd z)"
if [[ -f "/opt/homebrew/bin/brew" ]] ; then
  # If you're using macOS, you'll want this enabled
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi
compdef kubecolor=kubectl
if docker --version >/dev/null 2>&1; then
  eval "$(docker completion zsh)"
  complete -F __start_docker d
fi

# Aliases
alias flame="bash -c -- 'QT_QPA_PLATFORM=wayland flameshot gui'"
alias ls="eza"
alias k="kubecolor"
alias vim="nvim"
alias cls="clear"
alias fzf-preview="fzf --preview 'bat --color=always {}' --preview-window '~3'"
alias ks="kubectx"
alias update-ghostty="$HOME/Documents/scripts/update-ghostty.sh"
! command -v python >/dev/null 2>&1 && command -v python3 >/dev/null 2>&1 && alias python="python3"

# Env vars
export EDITOR="$(which nvim)"
export GPG_TTY=$(tty) # to fix gpg key issue
if [[ "$XDG_SESSION_TYPE" == "wayland" ]]; then
  export QT_QPA_PLATFORM=wayland
fi

# Open yazi in cwd
# Source: https://yazi-rs.github.io/docs/quick-start
function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}

# Start tmux
# if [ "$TMUX" = "" ]; then tmux; fi
