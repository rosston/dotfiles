# Increase the maximum number of open file descriptors
ulimit -n 1024

# Use Emacs keybindings (<3 ctrl-n and ctrl-p)
bindkey -e

export HISTFILE=~/.zsh_history
export HISTSIZE=10000100
export SAVEHIST=10000000
# Set history-related options
setopt inc_append_history share_history hist_ignore_dups hist_ignore_space
# Allow typing the name of the directory to cd into it
setopt autocd

# Set editor
export VISUAL='/usr/local/bin/nvim'
export EDITOR="$VISUAL"

export PS1="%m:%1~ %n 🌮  "

export PATH="/usr/local/bin:/usr/local/sbin:$PATH:/Users/ross/.cargo/bin:/Users/ross/.local/bin"

alias ag='ag -p ~/.config/ag/agignore'
alias awake='caffeinate -d'
alias be='bundle exec'
alias c='clear && echo -en "\e[3J"'
alias embiggen='printf "\e[8;40;100t"'
alias g='git '
alias ggrep='git grep --break --heading -n'
alias lr='lein repl'
alias magit='emacs -nw -f startup-magit'
alias prettyjson='python -m json.tool'
alias subl='subl -n'
alias tmux="env TERM=xterm-256color tmux"
alias weechat="OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES weechat"

export FZF_DEFAULT_COMMAND='ag --hidden -g "" --ignore ".git/" --ignore "bower_components" --ignore "legacy/framework" --ignore "legacy/protected/extensions"'

if type brew &>/dev/null; then
  FPATH=$(brew --prefix)/share/zsh/site-functions:$FPATH
fi

eval "$(nodenv init -)"

eval "$(rbenv init -)"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

[ -f ~/.zshrc.local ] && source ~/.zshrc.local

# Load autocompletion, taken from
# https://gist.github.com/ctechols/ca1035271ad134841284#gistcomment-2767420
autoload -Uz compinit
setopt EXTENDEDGLOB
for dump in $HOME/.zcompdump(#qN.m1); do
  compinit
  if [[ -s "$dump" && (! -s "$dump.zwc" || "$dump" -nt "$dump.zwc") ]]; then
    zcompile "$dump"
  fi
done
unsetopt EXTENDEDGLOB
compinit -C
