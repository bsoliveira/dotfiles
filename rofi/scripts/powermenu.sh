#!/usr/bin/env bash

# Theme Elements
prompt="󰐥  Confirma sair?"

# Options
cancel="󰜺 Cancelar"
lock=" Bloquear"
logout=" Sair"
reboot=" Reiniciar"
shutdown=" Deligar"

# Rofi CMD
rofi_cmd() {
	rofi -dmenu \
		-p "$prompt" \
		-theme "$HOME/.config/rofi/powermenu.rasi"
}

# Pass variables to rofi dmenu
run_rofi() {
	echo -e "$cancel\n$logout\n$lock\n$reboot\n$shutdown" | rofi_cmd
}

# Actions
chosen="$(run_rofi)"
case ${chosen} in
    $shutdown)
		systemctl poweroff
        ;;
    $reboot)
		systemctl reboot
        ;;
    $lock)
		i3lock --nofork --color=FC9867
        ;;
    $logout)
		i3-msg exit
        ;;
	$cancel)
		exit 1
        ;;
esac