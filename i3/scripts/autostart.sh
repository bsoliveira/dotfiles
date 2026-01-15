#!/bin/bash

# Script de inicialização de serviços da sessão i3

# Agente de autenticação PolicyKit
lxpolkit &

# Ajuste automático de layout (tiling dinâmico)
autotiling &

# Daemon de notificações
dunst &

# Compositor para transparência e efeitos visuais
picom &

# Define o papel de parede:
# - Usa o último papel salvo pelo feh, se existir
# - Caso contrário, aplica um papel de parede padrão
if [ -f ~/.fehbg ]; then
    ~/.fehbg &
else
    feh --bg-fill ~/.config/i3/backgrounds/default.png &
fi