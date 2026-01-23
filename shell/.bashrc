# ~/.bashrc — Debian 13
# Executado para shells interativos não-login

# Somente shell interativo
case $- in
    *i*) ;;
    *) return ;;
esac

# Histórico
HISTCONTROL=ignoreboth
HISTSIZE=1000
HISTFILESIZE=2000
shopt -s histappend
shopt -s checkwinsize

# lesspipe
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# Prompt (PS1)
PS1='\[\033[01;32m\]╭╴\u@\h\[\033[00m\]:\[\033[01;34m\]\w\n\[\033[01;32m\]╰╴$\[\e[0m\] '

# bash-completion
if ! shopt -oq posix; then
    if [ -f /usr/share/bash-completion/bash_completion ]; then
        . /usr/share/bash-completion/bash_completion
    elif [ -f /etc/bash_completion ]; then
        . /etc/bash_completion
    fi
fi

# PATH
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi

# XDG Base Directory
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_STATE_HOME="$HOME/.local/state"

export TERMINAL=alacritty

# Aliases externos
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi