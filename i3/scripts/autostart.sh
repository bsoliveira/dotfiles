lxpolkit &
autotiling &
dunst &
picom &

if [ -f ~/.fehbg ]; then
	~/.fehbg &
else
	feh --bg-fill ~/.config/i3/backgrounds/default.png &
fi
