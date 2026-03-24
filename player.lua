function control_player(pl)
	local accel = 0.05
	local lift = 0.36
	if (btn(0)) pl.dx -= accel
	if (btn(1)) pl.dx += accel
	if (btnp(5)) then
		pl.dy -= lift
		sfx(2)
	end

end

function touch_tile(a,x,y)
	return abs(a.x-(x+.5)) < a.w+.5 and
		abs(a.y-(y+.5)) < a.h+.5
end

function on_door(a)
	return touch_tile(a,60,5) or
		touch_tile(a,5,4)
end

function try_door(a)
	if on_door(a) and btnp(2) then
		sfx(2)
	end
end
