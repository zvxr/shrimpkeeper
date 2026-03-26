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

function on_plant(a)
	return tank.ps and touch_tile(a,25,4)
end

function on_shrimp_shop(a)
	return tank.day>=12 and touch_tile(a,45,5)
end

function on_disc(a)
	return disc_ok() and touch_tile(a,33,11)
end

function on_cull(a)
	return cull_ok() and touch_tile(a,30,10)
end

function on_xf(a)
	return tank.day>=19 and touch_tile(a,53,4)
end

function try_door(a)
	if on_door(a) and btnp(2) then
		tank.sm=1
		tank.ss=1
	elseif on_plant(a) and btnp(2) then
		tank.sm=2
		tank.ss=1
	elseif on_shrimp_shop(a) and btnp(2) then
		tank.sm=3
		tank.ss=1
	elseif on_disc(a) and btnp(2) then
		tank.sm=4
		tank.ss=1
	elseif on_cull(a) and btnp(2) then
		tank.sm=5
		tank.ss=cull_n(1)>0 and 1 or 2
	elseif on_xf(a) and btnp(2) then
		tank.sm=6
		tank.ss=1
	end
end

function any_btn()
	return btnp(0) or btnp(1) or btnp(2) or
		btnp(3) or btnp(4) or btnp(5)
end
