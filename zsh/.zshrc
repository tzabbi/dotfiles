# --- PATH & CORE VARS ---
export EDITOR="$(which nvim)"
export GPG_TTY=$(tty)
export HOMEBREW_NO_ANALYTICS=1
if [[ "$XDG_SESSION_TYPE" == "wayland" ]]; then
  export QT_QPA_PLATFORM=wayland
fi
# --- BREW ---
# Handling Linux/Mac in one block efficiently
if [[ -f "/opt/homebrew/bin/brew" ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -f "/home/linuxbrew/.linuxbrew/bin/brew" ]]; then
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

# Edit PATH variable
export PATH="/usr/local/sbin/npm:$PATH:$HOME/.krew/bin:$HOME/.local/bin:/snap/bin:$HOME/.kubescape/bin:$HOME/go/bin/"

# --- ZINIT SETUP ---
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
if [ ! -d "$ZINIT_HOME" ]; then
   mkdir -p "$(dirname "$ZINIT_HOME")"
   git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi
source "${ZINIT_HOME}/zinit.zsh"

# --- PLUGINS (TURBO MODE) ---
zinit ice wait'0' lucid
zinit light zsh-users/zsh-completions

zinit light zsh-users/zsh-autosuggestions

zinit ice wait'0' lucid
zinit light Aloxaf/fzf-tab

# OMZ Snippets (Lazy loaded)
zinit ice wait'1' lucid; zinit snippet OMZP::sudo
zinit ice wait'1' lucid; zinit snippet OMZP::command-not-found

# --- COMPLETION SYSTEM ---
autoload -Uz compinit
if [[ -n ${ZDOTDIR}/.zcompdump(#qN.mh+24) ]]; then
  compinit;
else
  compinit -C;
fi

zinit cdreplay -q

# FZF
command -v fzf >/dev/null 2>&1 && source <(fzf --zsh)

# Zoxide (Integrated via Zinit is often faster, but eval is fine)
command -v zoxide >/dev/null 2>&1 && eval "$(zoxide init zsh --cmd z)"

COMP_DUMPFILE=~/.zsh_tools_completions
if [[ ! -f "$COMP_DUMPFILE" ]]; then
  echo "Generating completions cache..."
  {
    command -v helm >/dev/null && helm completion zsh
    command -v kubectl >/dev/null && kubectl completion zsh
    command -v npm >/dev/null && npm completion -- zsh
    command -v talosctl >/dev/null && talosctl completion zsh
    command -v tofu >/dev/null && tofu -install-autocomplete
    command -v trivy >/dev/null && trivy completion zsh

  } > "$COMP_DUMPFILE"
fi
source "$COMP_DUMPFILE"

if docker --version >/dev/null 2>&1; then
  source <(docker completion zsh)
  compdef _docker d
fi

# --- STYLES & CONFIG ---
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#88b892'

# History
HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory sharehistory hist_ignore_space hist_ignore_all_dups hist_save_no_dups hist_ignore_dups hist_find_no_dups

# Keybindings
bindkey -e
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward
bindkey '^[w' kill-region
bindkey "^[[3~" delete-char
bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word

# Completion Styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

# --- ALIASES ---
alias flame="bash -c -- 'QT_QPA_PLATFORM=wayland flameshot gui'"
alias ls="eza"
alias k="kubecolor"
compdef kubecolor=kubectl
alias cls="clear"
alias fzf-preview="fzf --preview 'bat --color=always {}' --preview-window '~3'"
alias ks="kubectx"
alias t="tofu"
alias update-ghostty="$HOME/Documents/scripts/update-ghostty.sh"
alias fix-zsh-history="$HOME/Documents/scripts/fix-zsh-history.sh"
! command -v python >/dev/null 2>&1 && command -v python3 >/dev/null 2>&1 && alias python="python3"

# --- FUNCTIONS ---
function y() {
    local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
    yazi "$@" --cwd-file="$tmp"
    if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
        builtin cd -- "$cwd"
    fi
    rm -f -- "$tmp"
}

# --- PROMPT ---
# Load Oh-My-Posh near the end but before Syntax Highlighting
command -v oh-my-posh >/dev/null 2>&1 && eval "$(oh-my-posh init zsh --config $HOME/.config/ohmyposh/config.toml)"

# --- FINAL LOAD ---
# Syntax Highlighting MUST be last to work correctly
zinit ice wait'0' lucid atinit"zpcompinit; zicdreplay"
zinit light zsh-users/zsh-syntax-highlighting

# Remove "zi" alias
unalias zi 2>/dev/null

# Load additional config last (in case it overwrites aliases)
if [ -f "$HOME/.additional_zsh_config" ]; then
   source "$HOME/.additional_zsh_config"
fi

# Lua config (slow call, consider caching path if possible)
export LUA_DIR="$(brew --prefix luajit 2>/dev/null || echo /usr/local)"
# eval "$(luarocks path --lua-dir=$LUA_DIR)" # Only run if needed

autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C /home/linuxbrew/.linuxbrew/Cellar/opentofu/1.11.5/bin/tofu tofu
