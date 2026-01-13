#!/usr/bin/env bash

# Screenshot
time=`date +%Y-%m-%d-%H-%M-%S`
geometry=`xrandr | grep 'current' | head -n1 | cut -d',' -f2 | tr -d '[:blank:],current'`
dir="`xdg-user-dir PICTURES`/Screenshots"
file="Screenshot_${time}_${geometry}.png"

# Theme Elements
prompt=' Captura'

# Options
optFull=" Tela cheia"
optArea=" Região"
optWin="󱣴 Janela"
opt5s="󰦖 Esperar 5s"
opt10s="󰦖 Esperar 10s"

# Rofi CMD
rofi_cmd() {
	rofi -dmenu \
		-p "$prompt" \
		-theme "$HOME/.config/rofi/config-screenshot.rasi"
}

# Pass variables to rofi dmenu
run_rofi() {
	echo -e "$optFull\n$optArea\n$optWin\n$opt5s\n$opt10s" | rofi_cmd
}

if [[ ! -d "$dir" ]]; then
	mkdir -p "$dir"
fi

# notify and view screenshot
notify_view() {
	notify_cmd_shot='dunstify -u low --replace=699'
	${notify_cmd_shot} "Captura de tela salva $file"
}

# Copy screenshot to clipboard
copy_shot () {
	tee "$file" | xclip -selection clipboard -t image/png
}

# countdown
countdown () {
	for sec in `seq $1 -1 1`; do
		dunstify -t 1000 --replace=699 "Captura em : $sec"
		sleep 1
	done
}

# take shots
shotFull () {
	cd ${dir} && sleep 0.5 && maim -u -f png | copy_shot
	notify_view
}

shotWin () {
	cd ${dir} && maim -u -f png -i `xdotool getactivewindow` | copy_shot
	notify_view
}

shotArea () {
	cd ${dir} && maim -u -f png -s -b 2 -c 0.35,0.55,0.85,0.25 -l | copy_shot
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

# Actions
chosen="$(run_rofi)"
case ${chosen} in
    $optFull)
		shotFull
        ;;
    $optArea)
		shotArea
        ;;
    $optWin)
		shotWin
        ;;
    $opt5s)
		shot5
        ;;
    $opt10s)
		shot10
        ;;
esac

