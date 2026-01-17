# ~/.bash_aliases — aliases para uso interativo no Bash
# Carregado automaticamente pelo ~/.bashrc

# básicos
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# Eza (substitui ls)
if command -v eza >/dev/null 2>&1; then
    alias ls='eza --color=auto --icons --hyperlink'
    alias ll='ls -lh --group'
    alias la='ls -lhA --group'
    alias lt='ls -T --level=2'
    alias l1='ls -1'
    alias lsd='ls -lh --sort=modified'
fi

# Diretórios
alias g.='cd ~/.config'
alias gh='cd ~'
alias gd='cd ~/Downloads'

# Rede
alias ipl='ip -c -br -4 a'
alias ipe='curl -4 -s --max-time 5 ifconfig.me || curl -4 -s --max-time 5 ipinfo.io/ip; echo'
alias ports='ss -tulnp'
alias portl='lsof -P -i -n'

# Previsao do tempo
alias wttr='curl -s --max-time 10 wttr.in/uberaba'

# Luz Noturna
alias xgon='xgamma -rgamma 1.0 -ggamma 0.8 -bgamma 0.6'
alias xgoff='xgamma -gamma 1.0'