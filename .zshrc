# Increase the maximum number of open file descriptors
ulimit -n 1024

# Use Emacs keybindings (<3 ctrl-n and ctrl-p)
bindkey -e

# Enable Ctrl-x-e to edit command line
autoload -U edit-command-line
# And bind it to Emacs style keybindings (copying bash's keybinding)
zle -N edit-command-line
bindkey '^xe' edit-command-line
bindkey '^x^e' edit-command-line

export HISTFILE=~/.zsh_history
export HISTSIZE=10000100
export SAVEHIST=10000000
# Set history-related options
setopt inc_append_history share_history hist_ignore_dups hist_ignore_space
# Allow typing the name of the directory to cd into it
setopt autocd

# Set editor
export VISUAL=$(which nvim)

export PS1="%m:%1~ %n 🌮  "

export PATH="/usr/local/bin:/usr/local/sbin:$PATH:${HOME}/.cargo/bin:${HOME}/.local/bin"

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

source_if_present() {
  path_to_source=$1

  [ -f "$path_to_source" ] && source "$path_to_source"
}

export ASDF_NODEJS_LEGACY_FILE_DYNAMIC_STRATEGY="latest_installed"
if command -v brew &>/dev/null; then
  brew_prefix=$(brew --prefix)
  FPATH="${brew_prefix}/share/zsh/site-functions:$FPATH"

  brew_prefix_asdf=$(brew --prefix asdf)
  source_if_present "${brew_prefix_asdf}/libexec/asdf.sh"
fi

source_if_present "${HOME}/.asdf/asdf.sh"
source_if_present "${HOME}/.asdf/plugins/java/set-java-home.zsh"

if command -v thefuck &> /dev/null; then
  eval $(thefuck --alias)
fi

source_if_present "${HOME}/miniconda3/etc/profile.d/conda.sh"
source_if_present "${HOME}/.fzf.zsh"
source_if_present "${HOME}/.zshrc.local"

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
