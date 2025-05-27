#
# ~/.bashrc
#

parse_git_branch() {
  git branch 2>/dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
}

export PS1='\[\e[0;1;38;5;34m\]\u\[\e[0;1;38;5;34m\]@\[\e[0;1;38;5;34m\]\h\[\e[0;1m\]:\[\e[0;1;38;5;33m\]\w \[\e[0;91m\]$(parse_git_branch)\[\e[0m\]\$ \[\e[0m\]'
export GOPATH="$HOME/go"
export PATH="/home/tom/.cargo/bin/cargo:$PATH:$HOME/.krew/bin:$HOME/.local/bin:/snap/bin:$HOME/.local/share/JetBrains/Toolbox/scripts:$HOME/.kubescape/bin:/home/linuxbrew/.linuxbrew/bin:${KREW_ROOT:-$HOME/.krew}/bin:$GOPATH/bin"
export BAT_THEME="OneHalfLight"
source <(kubectl completion bash)
complete -o default -F __start_kubectl k
complete -C '/home/linuxbrew/.linuxbrew/bin/aws_completer' aws
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
eval "$(zoxide init bash)"
eval "$(fzf --bash)"
source <(helm completion bash)
source <(kustomize completion bash)
alias k=kubectl
alias fzf-preview="fzf --preview 'bat --color=always {}' --preview-window '~3'"

# add Oh-my-Posh
command -v oh-my-posh >/dev/null 2>&1 && eval "$(oh-my-posh init bash --config $HOME/.config/ohmyposh/config.toml)"

#if command -v tmux &> /dev/null && [ -n "$PS1" ] && [[ ! "$TERM" =~ screen ]] && [[ ! "$TERM" =~ tmux ]] && [ -z "$TMUX" ]; then
#  exec tmux
#fi
. "$HOME/.cargo/env"
