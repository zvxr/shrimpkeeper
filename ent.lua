ent = {} -- all ents

-- make an ent
-- and add to global collection
-- k: base sprite id
-- x,y: world position in tiles
-- returns the new ent table
--
-- common ent fields:
-- dx,dy: speed in tiles/frame
-- frame: current anim frame
-- t: ticks alive / local timer
-- grav: true if gravity applies
-- frames: anim frame count
-- fs: sprite step per frame
-- sw,sh: sprite size in cells
-- w,h: collision half-size in tiles
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

		-- half-width and half-height
		-- slightly less than 0.5 so
		-- that will fit through 1-wide
		-- holes.
		w = 0.4,
		h = 0.4
	}

	add(ent,a)

	return a
end

function move_ent(a)
	-- x,y: world position in tiles
	-- dy: vertical speed; gravity pulls down

	if (a.grav) a.dy += gravity

	if not move_x(a,a.dx) then
		a.dx = -sgn(a.dx)*bounce
	end

	if not move_y(a,a.dy) then
		a.dy = 0
	end

	-- apply friction
	a.dx *= fric
	a.dy *= fric

	-- advance one frame every
	-- time ent moves 1/4 of
	-- a tile

	a.frame += abs(a.dx) * 4
	a.frame += abs(a.dy) * 4
	a.frame %= a.frames

	a.t += 1

end

function draw_ent(a)
	local sx = (a.x * 8) - a.sw*4
	local sy = (a.y * 8) - a.sh*4
	spr(a.k + flr(a.frame)*a.fs, sx, sy, a.sw, a.sh)
end
