#!/usr/bin/env bash
#
# home-backup.sh
#
# Backup e restore simples da pasta HOME usando rsync.
# Projetado para uso pessoal com HD externo dedicado.
#
# Objetivo:
#   - Espelhar o conteúdo do $HOME de forma previsível
#   - Restaurar rapidamente após formatação ou troca de máquina
#   - Sem dependências complexas ou lógica obscura
#
# Características:
#   - Usa rsync como backend
#   - Backup completo (espelhamento)
#   - Restore direto para $HOME
#   - Exclusões explícitas e fixas
#   - Confirmação obrigatória antes do restore
#
# Requisitos do HD externo:
#   - Deve estar montado antes da execução
#   - Deve usar filesystem com suporte a:
#       * permissões POSIX
#       * symlinks
#       * hard links (para possível uso incremental futuro)
#   - Filesystems recomendados:
#       * ext4
#       * xfs
#       * btrfs
#   - NÃO recomendado:
#       * FAT
#       * exFAT
#       * NTFS (pode causar problemas com permissões e links)
#
# Avisos importantes:
#   - O backup usa --delete:
#       * arquivos removidos do $HOME também serão removidos do backup
#   - Este script assume que o HD é dedicado exclusivamente ao backup
#   - NÃO execute sem entender o que ele faz
#
# Uso:
#   ./home-backup.sh backup
#   ./home-backup.sh restore
#
# Autor: Bruno Silva Oliveira
#

set -euo pipefail

BACKUP_DIR="/media/bruno/BAKUP/home-backup"
HOME_DIR="$HOME"

EXCLUDES=(
  ".cache/"
  ".local/share/Trash/"
  "Downloads/"
  "Torrents/"
  "VirtManager/"
)

# Garante que o HD externo está montado
if ! mountpoint -q "$(dirname "$BACKUP_DIR")"; then
  echo "HD externo não está montado em $(dirname "$BACKUP_DIR")"
  exit 1
fi

backup() {
  echo "Iniciando backup da home..."

  rsync -avh \
    --progress \
    --delete \
    "${EXCLUDES[@]/#/--exclude=}" \
    "$HOME_DIR/" \
    "$BACKUP_DIR/"

  echo "Backup concluído com sucesso!"
}

restore() {
  echo "Este processo irá RESTAURAR arquivos para sua HOME."
  echo "Arquivos existentes podem ser SOBRESCRITOS."
  echo
  read -rp "Deseja continuar? (s/N): " CONFIRM

  [[ "$CONFIRM" =~ ^[sS]$ ]] || {
    echo "Restauração cancelada."
    exit 0
  }

  echo "Iniciando restauração da home..."

  rsync -avh \
    --progress \
    "$BACKUP_DIR/" \
    "$HOME_DIR/"

  echo "Restauração concluída com sucesso!"
}

usage() {
  echo "Uso: $(basename "$0") backup | restore"
}

case "${1:-}" in
  backup)  backup ;;
  restore) restore ;;
  *)       usage ;;
esac
