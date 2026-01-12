#!/usr/bin/env bash

set -e

DOTFILES_DIR="$HOME/dotfiles"

# Não permitir execução como root ou sudo
if [ "$(id -u)" -eq 0 ]; then
    echo "Não execute este script como root ou usando sudo."
    echo "Execute como usuário normal."
    exit 1
fi

echo "Criando symlinks..."

ln -sf "$DOTFILES_DIR/alacritty" ~/.config/
ln -sf "$DOTFILES_DIR/dunst" ~/.config/
ln -sf "$DOTFILES_DIR/fastfetch" ~/.config/
ln -sf "$DOTFILES_DIR/gtk-3.0" ~/.config/
ln -sf "$DOTFILES_DIR/gtk-4.0" ~/.config/
ln -sf "$DOTFILES_DIR/i3" ~/.config/
ln -sf "$DOTFILES_DIR/i3status" ~/.config/
ln -sf "$DOTFILES_DIR/nano" ~/.config/
ln -sf "$DOTFILES_DIR/picom" ~/.config/
ln -sf "$DOTFILES_DIR/rofi" ~/.config/
ln -sf "$DOTFILES_DIR/shell/bashrc" ~/.bashrc
ln -sf "$DOTFILES_DIR/shell/profile" ~/.profile

echo "Dotfiles instalados!"
