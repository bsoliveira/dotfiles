#!/usr/bin/env bash
#
# home-clone.sh
#
# Clonagem simples da pasta HOME usando rsync.
# Replica o estado atual do HOME (espelhamento, NÃO é backup).
# Projetado para uso pessoal com HD externo dedicado.
#
# Objetivo:
#   - Espelhar o conteúdo do $HOME
#   - Recriar rapidamente o ambiente do usuário
#     após formatação ou troca de máquina
#
# Características:
#   - Usa rsync como backend
#   - Clonagem completa do HOME (espelhamento)
#   - Restauração direta para $HOME
#   - Exclusões explícitas e fixas
#   - Confirmação obrigatória antes da restauração
#
# Requisitos:
# - bash
# - rsync
# - mountpoint
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
#   - A clonagem usa rsync com --delete:
#    arquivos removidos do $HOME também serão removidos no clone
#
#   - A restauração por segurança NÃO usa --delete por padrão.
#     Arquivos extras no $HOME não serão removidos no restore.
#
# Uso:
#   ./home-clone.sh backup
#   ./home-clone.sh restore

set -euo pipefail

if [ "$(id -u)" -eq 0 ]; then
  echo "Não execute este script como root."
  exit 1
fi

MOUNT_POINT="/media/bruno/BACKUP/"
BACKUP_DIR="$MOUNT_POINT/home-clone"

# Coloque aqui tudo que é considerado recriável ou não essencial.
EXCLUDES=(
  # cache
  ".cache/"
  ".thumbnails/"
  ".local/share/Trash/"
  ".var/"

  # browsers
  ".mozilla/firefox/*/storage/"
  ".mozilla/firefox/*/cache2/"

  # flatpak
  ".local/share/flatpak/"
  ".var/app/*/cache/"
  ".config/VSCodium/"

  # dev
  node_modules/
  .npm/
  .yarn/
  .gradle/
  .m2/repository/
  __pycache__/
  *.pyc

  # Pastas
  "Área de trabalho/"
  "Downloads/"
  "Público/"
  "Torrents/"
  "VirtManager/"
)

check_mount() {
    if ! mountpoint -q "$MOUNT_POINT"; then
        echo "HD de backup não está montado em $MOUNT_POINT"
        exit 1
    fi
}

backup() {
  check_mount

  echo "ATENÇÃO: este script CLONA o HOME."
  echo "Arquivos ausentes na origem serão removidos no clone."
  echo
  read -rp "Deseja continuar? (s/N): " CONFIRM

  [[ "$CONFIRM" =~ ^[sS]$ ]] || {
    echo "Clonagem cancelada."
    exit 0
  }

  echo "Iniciando clonagem da home..."

  mkdir -p "$BACKUP_DIR"

  rsync -avh \
    --progress \
    --delete \
    "${EXCLUDES[@]/#/--exclude=}" \
    "$HOME/" \
    "$BACKUP_DIR/"

  echo "Clonagem concluída com sucesso!"
}

restore() {
  check_mount
  
  if [ ! -d "$BACKUP_DIR" ]; then
    echo "Diretório de backup não encontrado: $BACKUP_DIR"
    exit 1
  fi

  echo "ATENÇÃO: este processo irá RESTAURAR arquivos para sua HOME."
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
    "$HOME/"

  echo "Restauração concluída com sucesso!"
}

usage() {
  echo "Uso: $(basename "$0") backup | restore"
  exit 1
}

# Entrada principal
case "${1:-}" in
  backup)  backup ;;
  restore) restore ;;
  *)       usage ;;
esac
