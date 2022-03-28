# Increase the maximum number of open file descriptors
ulimit -n 1024

export HISTCONTROL="ignorespace:erasedups"
export HISTSIZE=10000000
# When the shell exits, append to the history file instead of overwriting it
shopt -s histappend
# Enable **/* matching
shopt -s globstar

# Set editor
export VISUAL=$(which nvim)

export PS1="\h:\W \u 🌮  "

export PATH="/usr/local/bin:/usr/local/sbin:$PATH:${HOME}/.cargo/bin:${HOME}/.local/bin"

alias ag='ag -p ~/.config/ag/agignore'
alias awake='caffeinate -d'
alias be='bundle exec'
alias c='clear && echo -en "\e[3J"'
alias coauth='printf "Co-authored-by: %s" "$(git log --pretty=format:"%an <%ae>" -10000 | sort | uniq | fzf)" | pbcopy'
alias embiggen='printf "\e[8;40;100t"'
alias g='git '
alias ggrep='git grep --break --heading -n'
alias lr='lein repl'
alias magit='emacs -nw -f startup-magit'
alias prettyjson='python -m json.tool'
alias subl='subl -n'
alias tmux="env TERM=xterm-256color tmux"

export FZF_DEFAULT_COMMAND='ag --hidden -g "" --ignore ".git/" --ignore "bower_components" --ignore "legacy/framework" --ignore "legacy/protected/extensions"'

if command -v brew &> /dev/null; then
  brew_prefix=$(brew --prefix)

  if [ -f "${brew_prefix}/share/bash-completion/bash_completion" ]; then
      . "${brew_prefix}/share/bash-completion/bash_completion"
      __git_complete g __git_main
  fi
fi

if command -v nodenv &> /dev/null; then
  eval "$(nodenv init -)"
fi

if command -v rbenv &> /dev/null; then
  eval "$(rbenv init -)"
fi

if command -v thefuck &> /dev/null; then
  eval $(thefuck --alias)
fi

[ -f ~/.fzf.bash ] && source ~/.fzf.bash

[ -f ~/.bashrc.local ] && source ~/.bashrc.local
