#!/usr/bin/env bash
set -euo pipefail

if [ "$(id -u)" -eq 0 ]; then
    echo "Não execute este script como root ou sudo."
    exit 1
fi

echo "Instalando dotfiles"
mkdir -p "$HOME/.config" "$HOME/.local"

cp -a config/. "$HOME/.config/"
cp -a local/.  "$HOME/.local/"
cp -a shell/.  "$HOME/"

if [ -d "$HOME/.local/bin" ]; then
    echo "Definindo permissão de execução em ~/.local/bin"
    chmod +x "$HOME/.local/bin/"*
fi

if [ -d "$HOME/.local/share/fonts" ]; then
    echo "Atualizando cache de fontes"
    fc-cache -fv
fi

echo "Instalação concluída"
