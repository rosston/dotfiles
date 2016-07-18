# Increase the maximum number of open file descriptors
ulimit -n 1024

export HISTCONTROL=erasedups
export HISTSIZE=10000000
# When the shell exits, append to the history file instead of overwriting it
shopt -s histappend
# Enable **/* matching
shopt -s globstar

# Set editor
export VISUAL='/usr/local/bin/nvim'
export EDITOR="$VISUAL"

export PS1="\h:\W \u 🍔  "

brew_prefix=$(brew --prefix)

# PHP 5.5 path may occasionally need to be updated with output from
# `brew --prefix homebrew/php/php55`
export PATH="${brew_prefix}/opt/php55/bin:/opt/bin:/usr/local/bin:/usr/local/sbin:$PATH:/usr/local/mysql/bin:~/bin:/Applications/VMware Fusion.app/Contents/Library"

alias ag='ag -p ~/.config/ag/agignore'
alias awake='caffeinate -d'
alias cls='clear && echo -en "\e[3J"'
alias embiggen='printf "\e[8;40;100t"'
alias ggrep='git grep --break --heading -n'
alias magit='emacs -f startup-magit'
alias subl='subl -n'


if [ -f "${brew_prefix}/share/bash-completion/bash_completion" ]; then
    . "${brew_prefix}/share/bash-completion/bash_completion"
fi

eval "$(nodenv init -)"

eval "$(rbenv init -)"

[ -f ~/.fzf.bash ] && source ~/.fzf.bash

[ -f ~/.bashrc.local ] && source ~/.bashrc.local
