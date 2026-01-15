#!/bin/bash

# Script de bloqueio de tela usando i3lock com fundo desfocado
# A imagem de fundo é gerada a partir de uma captura da tela atual

# Caminho temporário para armazenar a captura de tela
tmpbg='/tmp/i3lock.png'

# Aguarda brevemente para evitar capturas incompletas
# e realiza a captura da tela com o maim
sleep 0.5 && maim "$tmpbg"

# Aplica efeito de desfoque à imagem usando ImageMagick
# O valor 0x0 define o nível de desfoque (raio e sigma)
convert "$tmpbg" -blur 0x5 "$tmpbg"

# Bloqueia a sessão utilizando a imagem desfocada como plano de fundo
i3lock -i "$tmpbg"