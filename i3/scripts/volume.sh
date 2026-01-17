#!/bin/bash
#
# Controle de volume (PipeWire) com notificação via dunst
# Uso: volume.sh {up|down|mute}

SINK='@DEFAULT_AUDIO_SINK@'

case "$1" in
	up)
		wpctl set-mute "$SINK" 0
		wpctl set-volume "$SINK" 5%+ --limit 1.0
		;;
	down)
		wpctl set-mute "$SINK" 0
		wpctl set-volume "$SINK" 5%-
		;;
	mute)
		wpctl set-mute "$SINK" toggle
		;;
	*)
		echo "Usage: $(basename "$0") {up|down|mute}"
		exit 1
		;;
esac

# Notificação e barra de progresso
STATUS=$(wpctl get-volume "$SINK")
VOLUME=$(tr -dc '0-9' <<< "$STATUS" | sed 's/^0\{1,2\}//')
[ -z "$VOLUME" ] && VOLUME=0

if grep -q MUTED <<< "$STATUS"; then
	ICON=muted
	VOLUME=0
	TEXT=Muted
else
	[ "$VOLUME" -lt 33 ] && ICON=low ||
	[ "$VOLUME" -lt 66 ] && ICON=medium ||
	ICON=high
	TEXT="Volume: $VOLUME%"
fi

dunstify -a Volume \
	-h string:synchronous:volume \
	-h "int:value:$VOLUME" \
	-i "audio-volume-$ICON" \
	Volume "$TEXT" -t 2000
