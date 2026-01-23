# Dotfiles – i3wm

É aqui que guardo meus dotfiles para i3wm + Linux desktop.

Sinta-se a vontade para copiar qualquer um dos arquivos ou scripts que você encontrar aqui, grande parte deles são baseados nos .dotfiles de outros. 

## Preview

![i3wm + Debian 13](previews/workspace.png)

## Inclui
- alacritty
- dunst
- fastfetch
- i3
- i3status
- nano
- picom
- rofi

## Instalação

ATENÇÃO: este instalador sobrescreve arquivos existentes no $HOME.

```bash
git clone https://github.com/bsoliveira/dotfiles.git ~/dotfiles
cd ~/dotfiles
./install.sh
```

### Requerimentos

```bash
sudo apt install alacritty autotiling dunst eza feh fastfetch fonts-cantarell htop imagemagick lxappearance lxpolkit maim nano picom rofi xclip xdotool       
```

Fonte Utilizada `MesloLGM Nerd Font` (Requerida para os ícones do terminal, i3status e scripts do Rofi)

## Recursos Utilizados
- Thema GTK: https://github.com/lassekongo83/adw-gtk3

- Icones: https://github.com/PapirusDevelopmentTeam/papirus-icon-theme

- Alterar Cores das pastas: https://github.com/PapirusDevelopmentTeam/papirus-folders

- Paleta de cores: https://monokai.pro/

- Rofi applets: https://github.com/adi1090x/rofi

- Nerd Fonts: https://www.nerdfonts.com

- Instalador fácil das fontes: https://github.com/officialrajdeepsingh/nerd-fonts-installer

- Wallpapes: https://github.com/Henriquehnnm/Monokai-Pro-Wallpapers



## i3wm — Atalhos de Teclado Personalizados

**Mod:** `Super (Mod4)` Tecla Windows

### Apps
- `Mod + Enter` → Terminal (Alacritty)
- `Mod + d` → Launcher (Rofi)
- `Mod + b` → Firefox
- `Mod + e` → Thunar
- `Mod + c` → Bitwarden
- `Mod + Shift + p` → Screenshot (script Rofi)

### Janelas
- `Mod + Shift + q` → Fechar
- `Mod + f` → Fullscreen
- `Mod + Space` → Flutuante
- `Mod + ← ↓ ↑ →` → Mover foco
- `Mod + Shift + ← ↓ ↑ →` → Mover janela

### Layout
- `Mod + v` → Split vertical
- `Mod + s` → Split horizontal
- `Mod + r` → Resize  
  `← → ↑ ↓` redimensiona · `Enter / Esc` sai

### Workspaces
- `Mod + 1–5` → Ir para workspace
- `Mod + Shift + 1–5` → Mover janela

### Áudio
- `Mute` → Toggle mute
- `Vol − / +` → −5% / +5%

### Sessão
- `Mod + Shift + c` → Reload config
- `Mod + Shift + r` → Restart i3
- `Mod + Shift + e` → Power menu (script Rofi)



## GNU nano — Atalhos de Teclado Personalizados

- `Ctrl + X` → Recortar
- `Ctrl + C` → Copiar
- `Ctrl + V` → Colar
- `Ctrl + S` → Salvar
- `Ctrl + Q` → Sair do nano
- `Ctrl + Z` → Desfazer
- `Ctrl + Y` → Refazer
- `Ctrl + A` → Marcar seleção
- `Ctrl + T` → Ir para linha
- `Ctrl + /` → Comentar / Descomentar
- `Ctrl + H` → Abrir / fechar ajuda


## Dicas

Desativar opção duplicada do Thunar de definir Wallpaper pelo menu de contexto (Debian 13)

```bash
sudo mv /usr/lib/x86_64-linux-gnu/thunarx-3/thunar-wallpaper-plugin.so /usr/lib/x86_64-linux-gnu/thunarx-3/thunar-wallpaper-plugin.so.bak
```
