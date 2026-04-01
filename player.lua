function control_player(pl)
	local accel = 0.05
	local lift = 0.36
	if (btn(0)) then
		pl.dx -= accel
		pl.dir=-1
	end
	if (btn(1)) then
		pl.dx += accel
		pl.dir=1
	end
	if (btnp(5)) then
		pl.dy -= lift
		sfx(2)
	end

end

function touch_tile(a,x,y)
	return abs(a.x-(x+.5)) < a.w+.5 and
		abs(a.y-(y+.5)) < a.h+.5
end

function on_s1(a)
	return touch_tile(a,60,5) or
		touch_tile(a,5,4)
end

function on_s2(a)
	return s2_ok() and touch_tile(a,25,4)
end

function on_s3(a)
	return tank.day>=12 and touch_tile(a,45,5)
end

function on_s4(a)
	return s4_ok() and touch_tile(a,33,11)
end

function on_s5(a)
	return s5_ok() and touch_tile(a,30,10)
end

function on_s6(a)
	return tank.day>=19 and touch_tile(a,53,4)
end

function on_s7(a)
	return s7_ok() and touch_tile(a,1,14)
end

function try_door(a)
	if on_s1(a) and btnp(2) then
		tank.sm=1
		tank.ss=1
	elseif on_s2(a) and btnp(2) then
		tank.sm=2
		tank.ss=1
	elseif on_s3(a) and btnp(2) then
		tank.sm=3
		tank.ss=1
	elseif on_s4(a) and btnp(2) then
		tank.sm=4
		tank.ss=1
	elseif on_s5(a) and btnp(2) then
		tank.sm=5
		tank.ss=1
	elseif on_s6(a) and btnp(2) then
		tank.sm=6
		tank.ss=1
	elseif on_s7(a) and btnp(2) then
		tank.sm=7
		tank.ss=1
	end
end

function any_btn()
	return btnp(0) or btnp(1) or btnp(2) or
		btnp(3) or btnp(4) or btnp(5)
end
