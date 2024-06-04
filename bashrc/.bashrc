#
# ~/.bashrc
#

parse_git_branch() {
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
}

export PS1='\[\e[0;1;38;5;34m\]\u\[\e[0;1;38;5;34m\]@\[\e[0;1;38;5;34m\]\h\[\e[0;1m\]:\[\e[0;1;38;5;33m\]\w \[\e[0;91m\]$(parse_git_branch)\[\e[0m\]\$ \[\e[0m\]'
export GOPATH="$HOME/go"
export PATH="$PATH:/home/toza/.krew/bin:/home/toza/.local/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin:/snap/bin:/home/toza/.local/share/JetBrains/Toolbox/scripts:/home/toza/.kubescape/bin:/home/linuxbrew/.linuxbrew/bin:${KREW_ROOT:-$HOME/.krew}/bin:$PATH:$GOPATH/bin:$PATH"
export BAT_THEME="OneHalfLight"
source <(kubectl completion bash)
complete -o default -F __start_kubectl k
complete -C '/home/linuxbrew/.linuxbrew/bin/aws_completer' aws
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
eval "$(zoxide init bash)"
eval "$(starship init bash)"
eval "$(fzf --bash)"
alias k=kubectl
alias z="zoxide"
alias fzf-preview="fzf --preview 'bat --color=always {}' --preview-window '~3'"
