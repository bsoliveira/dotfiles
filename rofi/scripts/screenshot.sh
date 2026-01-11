#!/usr/bin/env bash

theme="$HOME/.config/rofi/applet"

# Screenshot
time=`date +%Y-%m-%d-%H-%M-%S`
geometry=`xrandr | grep 'current' | head -n1 | cut -d',' -f2 | tr -d '[:blank:],current'`
dir="`xdg-user-dir PICTURES`/Screenshots"
file="Screenshot_${time}_${geometry}.png"

# Theme Elements
prompt='Captura de tela'
mesg="DESTINO: $dir"

list_col='1'
list_row='5'
win_width='400px'

# Options
option_1=" Capturar área de trabalho"
option_2=" Selecionar região"
option_3=" Capturar janela"
option_4=" Esperar 5s"
option_5=" Esperar 10s"

# Rofi CMD
rofi_cmd() {
	rofi -theme-str "window {width: $win_width;}" \
		-theme-str "listview {columns: $list_col; lines: $list_row;}" \
		-theme-str 'textbox-prompt-colon {str: "";}' \
		-dmenu \
		-p "$prompt" \
		-mesg "$mesg" \
		-markup-rows \
		-theme ${theme}
}

# Pass variables to rofi dmenu
run_rofi() {
	echo -e "$option_1\n$option_2\n$option_3\n$option_4\n$option_5" | rofi_cmd
}

if [[ ! -d "$dir" ]]; then
	mkdir -p "$dir"
fi

# notify and view screenshot
notify_view() {
	notify_cmd_shot='dunstify -u low --replace=699'
	${notify_cmd_shot} "Captura de tela salva"
}

# Copy screenshot to clipboard
copy_shot () {
	tee "$file" | xclip -selection clipboard -t image/png
}

# countdown
countdown () {
	for sec in `seq $1 -1 1`; do
		dunstify -t 1000 --replace=699 "Iniciar captura em : $sec"
		sleep 1
	done
}

# take shots
shotnow () {
	cd ${dir} && sleep 0.5 && maim -u -f png | copy_shot
	notify_view
}

shot5 () {
	countdown '5'
	sleep 1 && cd ${dir} && maim -u -f png | copy_shot
	notify_view
}

shot10 () {
	countdown '10'
	sleep 1 && cd ${dir} && maim -u -f png | copy_shot
	notify_view
}

shotwin () {
	cd ${dir} && maim -u -f png -i `xdotool getactivewindow` | copy_shot
	notify_view
}

shotarea () {
	cd ${dir} && maim -u -f png -s -b 2 -c 0.35,0.55,0.85,0.25 -l | copy_shot
	notify_view
}

# Execute Command
run_cmd() {
	if [[ "$1" == '--opt1' ]]; then
		shotnow
	elif [[ "$1" == '--opt2' ]]; then
		shotarea
	elif [[ "$1" == '--opt3' ]]; then
		shotwin
	elif [[ "$1" == '--opt4' ]]; then
		shot5
	elif [[ "$1" == '--opt5' ]]; then
		shot10
	fi
}

# Actions
chosen="$(run_rofi)"
case ${chosen} in
    $option_1)
		run_cmd --opt1
        ;;
    $option_2)
		run_cmd --opt2
        ;;
    $option_3)
		run_cmd --opt3
        ;;
    $option_4)
		run_cmd --opt4
        ;;
    $option_5)
		run_cmd --opt5
        ;;
esac

