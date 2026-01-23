#!/usr/bin/env bash

# Script de menu de sessão usando rofi

# Título exibido no prompt do rofi
prompt="󰐥  Confirma sair?"

# Tema do rofi utilizado no menu
theme="$HOME/.config/rofi/powermenu.rasi"

# Opções do menu
cancel="󰜺  Cancelar"
lock="  Bloquear"
logout="  Sair"
reboot="  Reiniciar"
shutdown="  Desligar"

# Executa o rofi em modo dmenu
run_rofi() {
    echo -e "$cancel\n$logout\n$lock\n$reboot\n$shutdown" | \
        rofi -dmenu -p "$prompt" -theme "$theme"
}

# Executa a ação conforme a opção escolhida
chosen="$(run_rofi)"
case "${chosen}" in
    "$shutdown")
        systemctl poweroff
        ;;
    "$reboot")
        systemctl reboot
        ;;
    "$lock")
        "$HOME/.local/bin/i3-blurlock.sh"
        ;;
    "$logout")
        i3-msg exit
        ;;
    "$cancel")
        exit 0
        ;;
esac
