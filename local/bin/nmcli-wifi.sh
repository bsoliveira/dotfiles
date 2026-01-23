#!/usr/bin/env bash
#
# nmcli-wifi — Gerenciador Wi-Fi interativo minimalista
#
# Descrição:
#   Gerenciador Wi-Fi interativo simples baseado no NetworkManager (nmcli).
#
# Requisitos:
#   - Bash 4+
#   - NetworkManager (nmcli)
#
# Observações:
#   - Usa estado em cache para evitar chamadas repetidas ao nmcli.
#   - Projetado para uso interativo.
#

# Modo estrito:
# -e : encerra ao ocorrer erro
# -u : trata variáveis não definidas como erro
# -o pipefail : falha se qualquer comando do pipeline falhar
set -euo pipefail

# Estado em cache (atualizado via refresh_state)
declare -g wifi_state="disabled"
declare -g current_ssid=""

# Atualiza o estado do Wi-Fi em cache (status do rádio e SSID ativo)
refresh_state() {
    wifi_state="$(nmcli -t radio wifi 2>/dev/null || echo disabled)"

    current_ssid="$(
        nmcli -t -f NAME,TYPE connection show --active |
        awk -F: '$2=="802-11-wireless"{print $1}'
    )"
}

# Retorna sucesso se o rádio Wi-Fi estiver ligado
wifi_is_on() {
    [[ "$wifi_state" == "enabled" ]]
}

# Retorna sucesso se o Wi-Fi estiver conectado
wifi_is_connected() {
    [[ -n "$current_ssid" ]]
}

# Alterna o rádio Wi-Fi (ligar/desligar).
# Ao ligar, aguarda brevemente pela reconexão automática
# e atualiza o estado em cache.
wifi_toggle() {
    if wifi_is_on; then
        nmcli radio wifi off
        sleep 0.5
        refresh_state
        return
    fi

    nmcli radio wifi on

    for i in {1..5}; do
        refresh_state
        wifi_is_connected && return
        sleep 1
    done

    refresh_state
}

# Conecta a uma rede Wi-Fi pelo SSID (senha solicitada interativamente)
wifi_connect() {
    echo "Conectando a: $1"
    if ! nmcli device wifi connect "$1" --ask; then
        read -rp "Falha na conexão. Pressione Enter para continuar..." _
    fi

    refresh_state
}

# Desenha o cabeçalho principal usando o estado em cache
header() {
    clear
    echo "=== Gerenciador Wi-Fi ==="

    if ! wifi_is_on; then
        echo "Wi-Fi: DESLIGADO"
    elif [[ -n "$current_ssid" ]]; then
        echo "Conectado: $current_ssid"
    else
        echo "Wi-Fi: LIGADO"
    fi

    echo
    echo "$1"
}

wifi_list_networks() {

    local -a nets=()

    # Garante que o Wi-Fi esteja ativo
    if ! wifi_is_on; then
        wifi_toggle
    fi

    header "Procurando redes..."

    # Escaneia redes disponíveis, remove duplicadas e ignora SSIDs vazios
    mapfile -t nets < <(
        nmcli -t -f SSID,SIGNAL,SECURITY device wifi list |
        awk -F: '!seen[$1]++ && $1 !~ /^[[:space:]]*$/'
    )

    if (( ${#nets[@]} == 0 )); then
        echo "Nenhuma rede encontrada."
        read -rp "Pressione Enter para voltar..." _
        return
    fi

    header "Redes disponíveis"
    printf "%-2s %-6s %-10s %s\n" "#" "SINAL" "SEGURANÇA" "SSID"

    for i in "${!nets[@]}"; do
        awk -F: -v n=$((i+1)) '
            { printf "%d) %-6s %-10s %s\n",
              n, $2, ($3=="--"?"ABERTA":$3), $1 }
        ' <<< "${nets[$i]}"
    done

    echo
    read -rp "Número da rede (ou Enter para cancelar): " c

    # Valida a entrada do usuário
    if ! [[ "$c" =~ ^[0-9]+$ ]]; then
        return
    fi

    local idx=$((c - 1))

    if (( idx < 0 || idx >= ${#nets[@]} )); then
        return
    fi

    wifi_connect "${nets[$idx]%%:*}"
}

## Ponto de entrada do programa
refresh_state

while true; do
    header "Menu principal"
    echo "1) Listar redes"
    echo "2) Ligar/Desligar Wi-Fi"
    echo "*) Sair"
    echo
    read -rp "Opção: " c

    case "$c" in
        1) wifi_list_networks ;;
        2) wifi_toggle ;;
        *) exit 0 ;;
    esac
done
