function control_player(pl)
	local accel = 0.05
	local lift = 0.36
	if (btn(0)) pl.dx -= accel
	if (btn(1)) pl.dx += accel
	if (btnp(5)) pl.dy -= lift

end
