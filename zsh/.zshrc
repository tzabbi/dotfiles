# =============================================================================
#  ZSH CONFIG
# =============================================================================
[[ -n "$ZSH_PROFILE" ]] && zmodload zsh/zprof

setopt extendedglob
typeset -U path PATH

# --- CACHE HELPER ---------------------------------------------------------
ZSH_CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/zsh"
[[ -d "$ZSH_CACHE_DIR" ]] || mkdir -p "$ZSH_CACHE_DIR"

zcache() {
  local name="$1"
  local file="$ZSH_CACHE_DIR/$name.zsh"
  local fresh=(${file}(Nmh-24))
  if ((! ${#fresh})); then
    "$@" >|"$file" 2>/dev/null || rm -f "$file"
  fi
  [[ -s "$file" ]] && source "$file"
}
zsh-refresh-cache() {
  rm -f "$ZSH_CACHE_DIR"/*.zsh "$COMP_DUMPFILE" ~/.zcompdump*
  echo "zsh caches cleared - restart your shell"
}

# --- PATH & CORE VARS -----------------------------------------------------
export EDITOR=nvim
export GPG_TTY=$TTY
export HOMEBREW_NO_ANALYTICS=1
export FZF_CTRL_R_OPTS="--preview 'echo {}' --preview-window down:3:hidden:wrap --bind '?:toggle-preview'"
[[ "$XDG_SESSION_TYPE" == "wayland" ]] && export QT_QPA_PLATFORM=wayland

# --- BREW -----------------------------------------------------------------
if [[ -z "$HOMEBREW_PREFIX" ]]; then
  export PATH="/home/linuxbrew/.linuxbrew/bin:$PATH"
  zcache brew shellenv
fi

path+=(
  "$HOME/.krew/bin"
  "$HOME/.local/bin"
  /snap/bin
  "$HOME/.kubescape/bin"
  "$HOME/go/bin"
  "$HOME/.cargo/bin"
)
export PATH

# --- COMPLETION SYSTEM ----------------------------------------------------
# Firmen-.zshrc hat compinit/bashcompinit ggf. schon ausgeführt.
if ((! $+functions[compdef])); then
  autoload -Uz compinit
  if [[ -n ~/.zcompdump(#qN.mh+24) ]]; then
    compinit
  else
    compinit -C
  fi
fi
((! $+functions[complete])) && { autoload -U +X bashcompinit && bashcompinit; }

# --- ZINIT SETUP ----------------------------------------------------------
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
if [ ! -d "$ZINIT_HOME" ]; then
  mkdir -p "$(dirname "$ZINIT_HOME")"
  git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi
source "${ZINIT_HOME}/zinit.zsh"

# --- PLUGINS (TURBO MODE) -------------------------------------------------
zinit ice wait'0' lucid
zinit light zsh-users/zsh-completions

# Firma lädt zsh-autosuggestions bereits aus Homebrew -> nicht doppelt laden.
if ((! $+functions[_zsh_autosuggest_start])); then
  zinit ice wait'0' lucid
  zinit light zsh-users/zsh-autosuggestions
fi

zinit ice wait'0' lucid
zinit light Aloxaf/fzf-tab

zinit ice wait'1' lucid
zinit snippet OMZP::sudo
zinit ice wait'1' lucid
zinit snippet OMZP::command-not-found

zinit cdreplay -q

# --- TOOL INTEGRATIONS (cached) -------------------------------------------
command -v fzf >/dev/null 2>&1 && zcache fzf --zsh
command -v zoxide >/dev/null 2>&1 && zcache zoxide init zsh --cmd z

COMP_DUMPFILE="$ZSH_CACHE_DIR/tools_completions.zsh"
_tools_fresh=(${COMP_DUMPFILE}(Nmh-24))
if ((! ${#_tools_fresh})); then
  echo "Generating completions cache..."
  {
    command -v npm >/dev/null && npm completion -- zsh
    # Docker/tofu macht die Firmen-.zshrc bereits selbst
    if [[ -z "$_COMPANY_ZSHRC" ]]; then
      command -v tofu >/dev/null && complete -o nospace -C "$(command -v tofu)" tofu
      command -v docker >/dev/null && docker completion zsh
    fi
  } >|"$COMP_DUMPFILE"
fi
[[ -s "$COMP_DUMPFILE" ]] && source "$COMP_DUMPFILE"
unset _tools_fresh

command -v kubecolor >/dev/null 2>&1 && compdef kubecolor=kubectl

# --- STYLES & CONFIG ------------------------------------------------------
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#88b892'

HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory sharehistory hist_ignore_space hist_ignore_all_dups hist_save_no_dups hist_ignore_dups hist_find_no_dups

bindkey -e
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward
bindkey '^[w' kill-region
bindkey "^[[3~" delete-char
bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word

zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

# --- ALIASES --------------------------------------------------------------
alias flame="bash -c -- 'QT_QPA_PLATFORM=wayland flameshot gui'"
alias ls="eza"
alias k="kubecolor"
alias cls="clear"
alias fzf-preview="fzf --preview 'bat --color=always {}' --preview-window '~3'"
alias ks="kubectx"
alias t="tofu"
alias update-ghostty="$HOME/Documents/scripts/update-ghostty.sh"
alias fix-zsh-history="$HOME/Documents/scripts/fix-zsh-history.sh"
! command -v python >/dev/null 2>&1 && command -v python3 >/dev/null 2>&1 && alias python="python3"

# --- FUNCTIONS ------------------------------------------------------------
function y() {
  local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
  yazi "$@" --cwd-file="$tmp"
  if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
    builtin cd -- "$cwd"
  fi
  rm -f -- "$tmp"
}

# --- PROMPT ---------------------------------------------------------------
if command -v oh-my-posh >/dev/null 2>&1 && [[ -f ~/.config/ohmyposh/config.yaml ]]; then
  eval "$(oh-my-posh init zsh --config ~/.config/ohmyposh/config.yaml)"
fi

# --- FINAL LOAD -----------------------------------------------------------
zinit ice wait'0' lucid atinit"zpcompinit; zicdreplay"
zinit light zsh-users/zsh-syntax-highlighting

unalias zi 2>/dev/null

if [ -f "$HOME/.additional_zsh_config" ]; then
  source "$HOME/.additional_zsh_config"
fi

if [[ ! -s "$ZSH_CACHE_DIR/lua_dir" ]]; then
  { brew --prefix luajit 2>/dev/null || echo /usr/local; } >|"$ZSH_CACHE_DIR/lua_dir"
fi
export LUA_DIR="$(<"$ZSH_CACHE_DIR/lua_dir")"

command -v nvm >/dev/null 2>&1 && [[ -n "$NVM_BIN" ]] && export PATH="$NVM_BIN:$PATH"

# --- KEYBINDING OWNERSHIP -------------------------------------------------
if ((${+widgets[fzf - history - widget]})); then
  bindkey '^r' fzf-history-widget
  bindkey '^t' fzf-file-widget
  bindkey '\ec' fzf-cd-widget
fi

# --- PROFILING REPORT -----------------------------------------------------
if [[ -n "$ZSH_PROFILE" ]]; then
  zprof
  return 0 2>/dev/null || exit 0
fi

# --- TMUX AUTOSTART ---
# Replace this shell with tmux, but ONLY in a real interactive terminal session.
# Each condition guards against a specific case where exec'ing tmux would break:
#   [[ -o interactive ]]           -> skip non-interactive shells (scripts)
#   [[ -z "$ZSH_EXECUTION_STRING" ]] -> set whenever zsh runs as `zsh -c '<cmd>'`,
#                                  even with -i. Editors/IDEs use that form for the
#                                  env dump, for tasks and - most importantly - for
#                                  agent/AI terminals, which run in a REAL pty.
#                                  Without this check tmux replaces the shell before
#                                  the command ever runs: the command produces no
#                                  output and never exits, so the caller hangs.
#   [[ -t 0 && -t 1 ]]             -> stdin AND stdout must be a TTY (pipes, CI, ...)
#   [[ "$TERM" != "dumb" ]]        -> skip dumb terminals (Emacs TRAMP, CI, some tools)
#   [[ ! "$TERM" =~ ... ]]         -> already inside a screen/tmux terminal
#   [[ -z "$TMUX" ]]               -> already inside a tmux pane; prevents nesting
#   [[ -z "$NO_TMUX_AUTOSTART" ]]  -> manual escape hatch for hosts/tools that need
#                                  a plain shell (export it in the tool's env)
#   command -v tmux                -> tmux is actually installed
# Note: the previous guard `[ -n "$PS1" ]` was useless in zsh, because PS1 always
# has a default value, even in non-interactive shells.
if [[ -o interactive ]] && [[ -z "$ZSH_EXECUTION_STRING" ]] &&
  [[ -t 0 && -t 1 ]] && [[ "$TERM" != "dumb" ]] &&
  [[ ! "$TERM" =~ (screen|tmux) ]] && [[ -z "$TMUX" ]] &&
  [[ -z "$NO_TMUX_AUTOSTART" ]] && command -v tmux &>/dev/null; then
  exec tmux
fi
