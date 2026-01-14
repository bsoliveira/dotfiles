#!/bin/bash

# set a temporary location for the screenshot
tmpbg='/tmp/screen.png'

# take a screenshot
sleep 0.5 &&  maim "$tmpbg"

# blur the screenshot using ImageMagick's convert
# The '0x5' parameter controls the blur radius and sigma value
convert "$tmpbg" -blur 0x6 "$tmpbg"

# lock the screen with the blurred screenshot
i3lock -i "$tmpbg"