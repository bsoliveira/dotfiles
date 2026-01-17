#!/bin/bash

# Script de captura de tela com menu interativo via rofi

# Timestamp para nomeação do arquivo
time="$(date +%Y%m%d%H%M%S)"

# Diretório e nome do arquivo de saída
dir="$(xdg-user-dir PICTURES)/Screenshots"
file="Screenshot_${time}.png"

# Tema do rofi
theme="$HOME/.config/rofi/screenshot.rasi"

# Prompt exibido no menu
prompt="  Captura de Tela"

# Opções do menu
optFull="  Tela cheia"
optArea="  Região"
optWin="󱣴  Janela"
optDelay="󰦖  Esperar 5s"

# Cria o diretório de screenshots, se não existir
mkdir -p "$dir"

# Executa o rofi em modo dmenu
run_rofi() {
    echo -e "$optFull\n$optArea\n$optWin\n$optDelay" | \
    	rofi -dmenu -p "$prompt" -theme "$theme"
}

# Exibe notificação após a captura
notify_view() {
    dunstify -u low \
        -h string:x-dunst-stack-tag:screenshot \
        -i "photo" \
        "$file"
}

# Salva a imagem em arquivo e copia para a área de transferência
copy_shot() {
    tee "$file" | xclip -selection clipboard -t image/png
}

# contador com barra de progresso
countdown() {
    local total=$1

    for ((sec=total; sec>=1; sec--)); do
        local progress=$(( (sec * 100) / total ))

        dunstify -t 1000 \
            -h string:x-dunst-stack-tag:screenshot \
            -h int:value:"$progress" \
            -i "clock" \
            "Captura em: $sec"

        sleep 1
    done
}

# Captura a tela inteira
# Aguarda brevemente para evitar capturar o menu do Rofi
shot_full() {
    cd "$dir" || exit 1
    sleep 0.5
    maim -u -f png | copy_shot
    notify_view
}

# Captura a janela ativa
shot_win() {
    cd "$dir" || exit 1
    maim -u -f png -i "$(xdotool getactivewindow)" | copy_shot
    notify_view
}

# Captura uma região selecionada pelo usuário
shot_area() {
    cd "$dir" || exit 1
    maim -u -f png -s -b 2 -c 0.35,0.55,0.85,0.25 -l | copy_shot
    notify_view
}

# Captura a tela inteira após um pequeno atraso
shot_delay() {
	countdown '5'
	shot_full
    notify_view
}

# Executa a ação conforme a opção escolhida
chosen="$(run_rofi)"
case "$chosen" in
    "$optFull")
        shot_full
        ;;
    "$optArea")
        shot_area
        ;;
    "$optWin")
        shot_win
        ;;
    "$optDelay")
        shot_delay
        ;;
esac
