# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=100000
SAVEHIST=100000
bindkey -e
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/toza/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

export PATH="$PATH:/home/toza/.krew/bin:/home/toza/.local/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin:/snap/bin:/home/toza/.local/share/JetBrains/Toolbox/scripts:/home/toza/.kubescape/bin:/home/linuxbrew/.linuxbrew/bin"
source <(kubectl completion zsh)
alias k=kubectl
compdef k='kubectl'

#autoload bashcompinit && bashcompinit
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"
alias cs-cli="$HOME/Documents/cs-cli/cs-cli.py"
alias update-k9s="$HOME/Documents/scripts/update-k9s.sh"
export GOPATH="$HOME/go"
export PATH="$GOPATH/bin:$PATH"
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
alias z="zoxide"
eval "$(zoxide init zsh)"
eval "$(fzf --zsh)"

alias fzf-preview="fzf --preview 'bat --color=always {}' --preview-window '~3'"
export BAT_THEME="OneHalfLight"

source <(helm completion zsh)
source <(kustomize completion zsh)

#if command -v tmux &> /dev/null && [ -n "$PS1" ] && [[ ! "$TERM" =~ screen ]] && [[ ! "$TERM" =~ tmux ]] && [ -z "$TMUX" ]; then
#  exec tmux
#fi

alias svc-shell="ssh ssh://svcsh.internal.mms-support.de/"
alias ks="kubecm switch"
eval "$(oh-my-posh init zsh --config .config/ohmyposh/config.toml)"
