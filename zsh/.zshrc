# =============================================================================
#  ZSH CONFIG
# =============================================================================
# Startup profiling: run `ZSH_PROFILE=1 zsh -i -c exit` to get a timing report.
# When set, tmux auto-start is skipped and a zprof table is printed at the end.
[[ -n "$ZSH_PROFILE" ]] && zmodload zsh/zprof

# remove duplicated entries in PATH var
typeset -U path PATH

# --- CACHE HELPER ---------------------------------------------------------
# Caches the (static) output of slow `eval "$(tool init)"` style commands to a
# file and sources that instead of forking a subprocess on every startup.
# Regenerates automatically when the cache is missing or older than 24h.
# Force a full refresh anytime with:  zsh-refresh-cache
ZSH_CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/zsh"
[[ -d "$ZSH_CACHE_DIR" ]] || mkdir -p "$ZSH_CACHE_DIR"

zcache() {
  # usage: zcache <name> <command> [args...]
  local name="$1"
  shift
  local file="$ZSH_CACHE_DIR/$name.zsh"
  local fresh=(${file}(Nmh-24)) # non-empty only if file exists & <24h old
  if ((!${#fresh})); then
    "$@" >|"$file" 2>/dev/null || rm -f "$file"
  fi
  [[ -s "$file" ]] && source "$file"
}
zsh-refresh-cache() {
  rm -f "$ZSH_CACHE_DIR"/*.zsh "$COMP_DUMPFILE" ~/.zcompdump*
  echo "zsh caches cleared - restart your shell"
}

# --- PATH & CORE VARS -----------------------------------------------------
export EDITOR=nvim  # resolved via PATH by callers; no `which` fork
export GPG_TTY=$TTY # zsh sets $TTY automatically; no `tty` fork
export HOMEBREW_NO_ANALYTICS=1
[[ "$XDG_SESSION_TYPE" == "wayland" ]] && export QT_QPA_PLATFORM=wayland

# --- BREW -----------------------------------------------------------------
# Skip entirely if a parent/company .zshrc already set the brew env up.
[[ -z "$HOMEBREW_PREFIX" ]] && zcache brew /home/linuxbrew/.linuxbrew/bin/brew shellenv

# Edit PATH variable
export PATH="$PATH:$HOME/.krew/bin:$HOME/.local/bin:/snap/bin:$HOME/.kubescape/bin:$HOME/go/bin/:$HOME/.cargo/bin"

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

zinit ice wait'0' lucid
zinit light zsh-users/zsh-autosuggestions

zinit ice wait'0' lucid
zinit light Aloxaf/fzf-tab

# OMZ Snippets (Lazy loaded)
zinit ice wait'1' lucid
zinit snippet OMZP::sudo
zinit ice wait'1' lucid
zinit snippet OMZP::command-not-found

# --- COMPLETION SYSTEM ----------------------------------------------------
autoload -Uz compinit
if [[ -n ${ZDOTDIR}/.zcompdump(#qN.mh+24) ]]; then
  compinit
else
  compinit -C
fi

zinit cdreplay -q

# bashcompinit provides `complete`, which the cached tool-completions below use.
# It MUST be loaded before those caches are sourced.
autoload -U +X bashcompinit && bashcompinit

# --- TOOL INTEGRATIONS (cached) -------------------------------------------
command -v fzf >/dev/null 2>&1 && zcache fzf fzf --zsh
command -v zoxide >/dev/null 2>&1 && zcache zoxide zoxide init zsh --cmd z

# CLI completions (cached in one file; regenerated on first run / after 24h)
COMP_DUMPFILE="$ZSH_CACHE_DIR/tools_completions.zsh"
_tools_fresh=(${COMP_DUMPFILE}(Nmh-24))
if ((!${#_tools_fresh})); then
  echo "Generating completions cache..."
  {
    command -v helm >/dev/null && helm completion zsh
    command -v kubectl >/dev/null && kubectl completion zsh
    command -v npm >/dev/null && npm completion -- zsh
    command -v talosctl >/dev/null && talosctl completion zsh
    command -v tofu >/dev/null && complete -o nospace -C "$(command -v tofu)" tofu
    command -v trivy >/dev/null && trivy completion zsh
    command -v tv >/dev/null && tv init zsh
    command -v docker >/dev/null && docker completion zsh # slow daemon call -> cached
  } >|"$COMP_DUMPFILE"
fi
[[ -s "$COMP_DUMPFILE" ]] && source "$COMP_DUMPFILE"
unset _tools_fresh

command -v docker >/dev/null 2>&1 && compdef _docker d
command -v kubecolor >/dev/null 2>&1 && compdef kubecolor=kubectl

# --- STYLES & CONFIG ------------------------------------------------------
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
# Load Oh-My-Posh (cached). Skip if a parent .zshrc already started it ($POSH_PID).
if [[ -z "$POSH_PID" ]] && command -v oh-my-posh >/dev/null 2>&1; then
  zcache ohmyposh oh-my-posh init zsh --config "$HOME/.config/ohmyposh/config.yaml"
fi

# --- FINAL LOAD -----------------------------------------------------------
# Syntax Highlighting MUST be last to work correctly
zinit ice wait'0' lucid atinit"zpcompinit; zicdreplay"
zinit light zsh-users/zsh-syntax-highlighting

# Remove "zi" alias
unalias zi 2>/dev/null

# Load additional config last (in case it overwrites aliases)
if [ -f "$HOME/.additional_zsh_config" ]; then
  source "$HOME/.additional_zsh_config"
fi

# Lua config for luarocks (cached path; brew --prefix is slow).
# Only relevant when the luarocks eval below is enabled.
if [[ ! -s "$ZSH_CACHE_DIR/lua_dir" ]]; then
  { brew --prefix luajit 2>/dev/null || echo /usr/local; } >|"$ZSH_CACHE_DIR/lua_dir"
fi
export LUA_DIR="$(<"$ZSH_CACHE_DIR/lua_dir")"
# eval "$(luarocks path --lua-dir=$LUA_DIR)" # Only run if needed

# guarantee that nvm is first dir in PATH
command -v nvm >/dev/null 2>&1 && export PATH="$NVM_BIN:$PATH"

# --- PROFILING REPORT -----------------------------------------------------
# Print the profile and stop here (don't exec tmux) when profiling is enabled.
if [[ -n "$ZSH_PROFILE" ]]; then
  zprof
  return 0 2>/dev/null || exit 0
fi

# Auto-start tmux for interactive login shells
if command -v tmux &>/dev/null && [ -n "$PS1" ] && [[ ! "$TERM" =~ screen ]] && [[ ! "$TERM" =~ tmux ]] && [ -z "$TMUX" ]; then
  exec tmux
fi
