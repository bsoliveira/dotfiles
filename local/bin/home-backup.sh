#!/usr/bin/env bash
#
# home-backup.sh
#
# Backup e restauração de pastas essenciais do usuário.
#
# Pastas incluídas:
# - Documentos
# - Imagens
# - Músicas
# - Vídeos
#
# O backup é feito em um HD externo, com uma pasta por data (bkp-YYYY-MM-DD).
# Cada pasta é compactada individualmente em arquivos .tar.gz.
#
# A restauração é interativa e extrai os arquivos diretamente para o $HOME.
#
# Requisitos:
# - bash
# - tar
# - mountpoint
#
# Uso:
# ./home-backup.sh backup
# ./home-backup.sh restore

set -euo pipefail

if [[ "$(id -u)" -eq 0 ]]; then
    echo "Não execute este script como root."
    exit 1
fi

MOUNT_POINT="/media/bruno/BACKUP"
BACKUP_DIR="$MOUNT_POINT/home-backup"

SOURCE_DIRS=(
    "$HOME/Documentos"
    "$HOME/Imagens"
    "$HOME/Músicas"
    "$HOME/Vídeos"
)

check_mount() {
    if ! mountpoint -q "$MOUNT_POINT"; then
        echo "HD de backup não está montado em $MOUNT_POINT"
        exit 1
    fi
}

backup() {
    local DEST_DIR

    check_mount

    echo "ATENÇÃO: este script cria backup das pastas da HOME."
    echo "Este processo poderá demorar muito tempo."
    echo
    read -rp "Deseja continuar? (s/N): " CONFIRM

    [[ "$CONFIRM" =~ ^[sS]$ ]] || {
        echo "Backup Cancelado."
        exit 0
    }

    echo "Iniciando backup..."
    
    DEST_DIR="$BACKUP_DIR/bkp-$(date +%F)"
    mkdir -p "$DEST_DIR"

    for SRC in "${SOURCE_DIRS[@]}"; do
        if [[ ! -d "$SRC" ]]; then
            echo "Pasta não encontrada, ignorando: $SRC"
            continue
        fi

        NAME="$(basename "$SRC")"
        FINAL="$DEST_DIR/$NAME.tar.gz"
        PART="$FINAL.part"

        if [[ -f "$FINAL" ]]; then
            echo "Arquivo já existe, backup ignorado: $FINAL"
            continue
        fi

        if [[ -f "$PART" ]]; then
            echo "Backup incompleto encontrado, removendo: $PART"
            rm -f "$PART"
        fi
        
        echo "Criando arquivo $FINAL"
        tar -czf "$PART" -C "$(dirname "$SRC")" "$NAME"

        mv "$PART" "$FINAL"
    done

    echo "Backup concluído!"
}

restore() {
    local backups=()
    local dir
    local BKP_SRC
    
    check_mount      

    # listando backups
    for dir in "$BACKUP_DIR"/bkp-*; do
        [[ -d "$dir" ]] && backups+=("$dir")
    done

    [[ "${#backups[@]}" -gt 0 ]] || {
        echo "Nenhum backup disponível."
        exit 1
    }

    echo "Backups disponíveis:"
    echo

    local i=1
    for dir in "${backups[@]}"; do
        echo "  [$i] $(basename "$dir")"
        ((i++))
    done

    echo    
    read -rp "Escolha o backup para restaurar: " choice

    if ! [[ "$choice" =~ ^[0-9]+$ ]] || (( choice < 1 || choice > ${#backups[@]} )); then
        echo "Opção inválida."
        exit 1
    fi

    BKP_SRC="${backups[choice-1]}"

    echo "ATENÇÃO: este processo irá RESTAURAR arquivos para sua HOME."
    echo "Arquivos existentes podem ser SOBRESCRITOS."
    echo
    read -rp "Deseja continuar? (s/N): " CONFIRM

    [[ "$CONFIRM" =~ ^[sS]$ ]] || {
        echo "Restauração cancelada."
        exit 0
    }
        
    for ARCHIVE in "$BKP_SRC"/*.tar.gz; do
        [[ -e "$ARCHIVE" ]] || continue

        # A opção --skip-old-files evita sobrescrever arquivos existentes
        # Se desejar sobrescrever, remova essa opção
        echo "Descompactando arquivo $ARCHIVE sem sobrescrever arquivos existentes."
        tar -xzf "$ARCHIVE" -C "$HOME" --skip-old-files
    done

    echo "Restauração concluída!"
}

usage() {
    echo "Uso: $(basename "$0") backup | restore"
    exit 1
}

case "${1:-}" in
    backup)  backup ;;
    restore) restore ;;
    *)       usage ;;
esac