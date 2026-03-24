gravity = 0.02
fric = 0.85
bounce = 0.3

function solid(tx,ty)
	return fget(mget(flr(tx),flr(ty)),1)
end

function solid_map(a,dx,dy)
	return solid(a.x+dx-a.w,a.y+dy-a.h) or
		solid(a.x+dx+a.w,a.y+dy-a.h) or
		solid(a.x+dx-a.w,a.y+dy+a.h) or
		solid(a.x+dx+a.w,a.y+dy+a.h)
end

function solid_ent(a, dx, dy)
	for a2 in all(ent) do
		if a2 != a and
			flr(a.x/16)==flr(a2.x/16) and
			flr(a.y/16)==flr(a2.y/16) then
			local x=(a.x+dx)-a2.x
			local y=(a.y+dy)-a2.y
			if abs(x) < a.w+a2.w and
				abs(y) < a.h+a2.h then
				local ca=
					collide_ent(a,a2) or
					collide_ent(a2,a)
				if ca then return false end
				sfx(2)
				if dx != 0 then
					a.dx=-sgn(dx)*bounce
					a2.dx=sgn(dx)*bounce
				else
					a.dy=0
					a2.dy=0
				end
				return true
			end
		end
	end

	return false
end

function move_x(a,dx)
	local s=sgn(dx)/8
	while abs(dx)>0 do
		local d=abs(dx)<1/8 and dx or s
		if solid_map(a,d,0) or solid_ent(a,d,0) then
			return false
		end
		a.x += d
		dx -= d
	end
	return true
end

function move_y(a,dy)
	local s=sgn(dy)/8
	while abs(dy)>0 do
		local d=abs(dy)<1/8 and dy or s
		if solid_map(a,0,d) or solid_ent(a,0,d) then
			return false
		end
		a.y += d
		dy -= d
	end
	return true
end

function collide_ent(a1,a2)
	if (a1==pl and a2.k==36) then
		del(ent,a2)
		tank.money+=1
		sfx(3)
		return true
	end

	return false
end
