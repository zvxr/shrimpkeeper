ent = {}

function make_ent(k, x, y)
	a={
		k = k,
		x = x,
		y = y,
		dx = 0,
		dy = 0,
		frame = 0,
		t = 0,
		grav = true,
		frames = 2,
		fs = 1,
		sw = 1,
		sh = 1,
		w = 0.4,
		h = 0.4
	}

	add(ent,a)

	return a
end

function move_ent(a)
	if (a.grav) a.dy += gravity

	if not move_x(a,a.dx) then
		a.dx = -sgn(a.dx)*bounce
	end

	if not move_y(a,a.dy) then
		a.dy = 0
	end

	a.dx *= fric
	a.dy *= fric

	if a.mb!=nil and a.y<3.5 then
		a.y=3.5
		a.dy=0
	end

	a.frame += abs(a.dx) * 4
	a.frame += abs(a.dy) * 4
	a.frame %= a.frames

	a.t += 1

end

function draw_ent(a)
	if a.sa!=nil then
		draw_shrimp(a)
		return
	end
	if a.np!=nil then
		draw_snail(a)
		return
	end
	if a.mp!=nil then
		draw_micro(a)
		return
	end
	if a.mb!=nil then
		draw_moss(a)
		return
	end
	local sx = (a.x * 8) - a.sw*4
	local sy = (a.y * 8) - a.sh*4
	spr(a.k + flr(a.frame)*a.fs, sx, sy, a.sw, a.sh)
end
