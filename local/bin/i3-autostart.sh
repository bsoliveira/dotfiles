#!/usr/bin/env bash
# Script de inicialização de serviços da sessão i3

# Garantir que a sessão esteja registrada no logind
systemctl --user import-environment DISPLAY XAUTHORITY XDG_SESSION_TYPE XDG_SESSION_ID 2>/dev/null

# Agente de autenticação PolicyKit
pgrep -x lxpolkit >/dev/null || lxpolkit &

# Ajuste automático de layout (tiling dinâmico)
pgrep -x autotiling >/dev/null || autotiling &

# Daemon de notificações
pgrep -x dunst >/dev/null || dunst &

# Compositor para transparência e efeitos visuais
pgrep -x picom >/dev/null || picom &

# Gestão de energia da tela (Xorg)
STANDBY_MIN=5
SUSPEND_MIN=15
TURNOFF_MIN=30

xset +dpms
xset dpms $((STANDBY_MIN*60)) $((SUSPEND_MIN*60)) $((TURNOFF_MIN*60))

# Toda vez que a tela apagar ou o sistema suspender executar bloqueio de tela
pgrep -x xss-lock >/dev/null || \
    xss-lock --transfer-sleep-lock -- \
    ~/.local/bin/i3-blurlock.sh --nofork &

# Define o papel de parede:
# - Usa o último papel salvo pelo feh, se existir
# - Caso contrário, aplica um papel de parede padrão
if [ -f ~/.fehbg ]; then
    ~/.fehbg &
else
    feh --bg-fill ~/.config/i3/backgrounds/default.png &
fi

# Atualizar pastas de usuário
if command -v xdg-user-dirs-update >/dev/null 2>&1; then
    xdg-user-dirs-update &
fi

# Som de início
if command -v canberra-gtk-play >/dev/null 2>&1; then
    canberra-gtk-play -i service-login &
fi