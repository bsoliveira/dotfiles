#!/usr/bin/env bash
# virus-scan — Varredura antivírus usando clamscan
# Move arquivos infectados para quarentena e registra apenas as detecções
#
# Uso:
#   virus-scan <arquivo|diretório>
#   (se nenhum argumento for fornecido, o diretório atual será escaneado)
#
# Exemplo (ação personalizada no Thunar):
#   alacritty -e virus-scan %f

# Diretórios e arquivos base
BASE_DIR="$HOME/.local/share/virus-scan"
INFECTED_DIR="$BASE_DIR/infected"
LOG_FILE="$BASE_DIR/infecteds-$(date +'%Y-%m-%d').log"

# Arquivo temporário para capturar a saída do clamscan
TMPFILE="$(mktemp)"
trap 'rm -f "$TMPFILE"' EXIT

# Verifica dependência
command -v clamscan >/dev/null 2>&1 || exit 2

# Caminho alvo (arquivo ou diretório)
TARGET="${1:-.}"
[ -e "$TARGET" ] || exit 2

# Garante que o diretório de quarentena exista
mkdir -p "$INFECTED_DIR"

# Executa a varredura antivírus
# Códigos de saída:
#   0 = nenhum vírus encontrado
#   1 = vírus encontrado(s)
#  >1 = erro
clamscan --recursive \
  --alert-encrypted \
  --exclude-dir="$INFECTED_DIR" \
  --move="$INFECTED_DIR" \
  --log="$TMPFILE" \
  "$TARGET"

SCAN_EXIT_CODE=$?

# Registra apenas arquivos infectados
if [ "$SCAN_EXIT_CODE" -eq 1 ]; then
  {
    printf '%s\n' "$(date +'%Y-%m-%d %H:%M:%S') ---------------------"
    grep -- "FOUND" "$TMPFILE" || true
    printf '\n'
  } >> "$LOG_FILE"
fi

# Pausa quando executado em um terminal (ex: Thunar)
[ -t 1 ] && read -rsn1

exit "$SCAN_EXIT_CODE"
