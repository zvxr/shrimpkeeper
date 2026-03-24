ent = {} -- all ents

-- make an ent
-- and add to global collection
-- k: base sprite id
-- x: horizontal center in tiles
-- y: height above the floor in tiles
-- returns the new ent table
--
-- common ent fields:
-- dx,dy: velocity in tiles/frame
-- frame: current anim frame
-- t: ticks alive / local timer
-- grav: true if gravity applies
-- friction: velocity loss each frame
-- bounce: bounce factor on floor/ent hit
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
		friction = 0.15,
		bounce  = 0.3,
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
	-- x: horizontal position in tiles
	-- y: height above floor in tiles
	-- dy: upward speed; gravity lowers it

	if (a.grav) a.dy -= gravity

	if not solid_ent(a, a.dx, 0) then
		a.x += a.dx
	else
		a.dx *= -a.bounce
	end

	if not solid_ent(a, 0, a.dy) then
		a.y += a.dy
	else
		a.dy *= -a.bounce
	end

	if (a.x < a.w) then
		a.x = a.w
		a.dx *= -a.bounce
	elseif (a.x > world_w-a.w) then
		a.x = world_w-a.w
		a.dx *= -a.bounce
	end

	if (a.y < 0) then
		a.y = 0
		a.dy *= -a.bounce
	end

	-- apply friction
	a.dx *= (1-a.friction)
	a.dy *= (1-a.friction)

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
	local sy = flr_y - a.y*8 - a.sh*8
	spr(a.k + flr(a.frame)*a.fs, sx, sy, a.sw, a.sh)
end
