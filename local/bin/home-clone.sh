#!/usr/bin/env bash
#
# home-clone.sh
#
# Clonagem simples da pasta HOME usando rsync.
# Replica o estado atual do HOME (espelhamento, NÃO é backup).
# Projetado para uso pessoal com HD externo dedicado.
#
# Objetivo:
#   - Espelhar o conteúdo do $HOME de forma previsível
#   - Recriar rapidamente o ambiente do usuário
#     após formatação ou troca de máquina
#   - Evitar dependências complexas ou lógica obscura
#
# Características:
#   - Usa rsync como backend
#   - Clonagem completa do HOME (espelhamento)
#   - Restauração direta para $HOME
#   - Exclusões explícitas e fixas
#   - Confirmação obrigatória antes da restauração
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
#       * arquivos removidos do $HOME
#         também serão removidos no clone
#   - Este script assume que o HD externo é
#     dedicado exclusivamente ao home-clone
#   - NÃO execute sem entender o que o script faz
#
# Uso:
#   ./home-clone.sh backup
#   ./home-clone.sh restore
#
# Autor: Bruno Silva Oliveira

set -euo pipefail

## Configuração
MOUNT_POINT="/media/bruno/BAKUP"
CLONE_DIR="$MOUNT_POINT/home-clone"
HOME_DIR="$HOME"

EXCLUDES=(
  ".cache/"
  ".local/share/Trash/"
  "Downloads/"
  "Torrents/"
  "VirtManager/"
)

# Validações iniciais
# Garante que o HD externo está montado
if ! mountpoint -q "$MOUNT_POINT"; then
  echo "HD externo não está montado em $MOUNT_POINT"
  exit 1
fi

# Garante que o diretório de clone existe
mkdir -p "$CLONE_DIR"

# Funções
backup() {
  echo "ATENÇÃO: este script CLONA o HOME."
  echo "Arquivos ausentes na origem serão removidos no clone."
  echo
  read -rp "Deseja continuar? (s/N): " CONFIRM

  [[ "$CONFIRM" =~ ^[sS]$ ]] || {
    echo "Clonagem cancelada."
    exit 0
  }

  echo "Iniciando clonagem da home..."

  rsync -avh \
    --progress \
    --delete \
    --numeric-ids \
    --one-file-system \
    "${EXCLUDES[@]/#/--exclude=}" \
    "$HOME_DIR/" \
    "$CLONE_DIR/"

  echo "Clonagem concluída com sucesso!"
}

restore() {
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
    --numeric-ids \
    --one-file-system \
    "$CLONE_DIR/" \
    "$HOME_DIR/"

  echo "Restauração concluída com sucesso!"
}

usage() {
  echo "Uso: $(basename "$0") backup | restore"
}

# Entrada principal
case "${1:-}" in
  backup)  backup ;;
  restore) restore ;;
  *)       usage ;;
esac
