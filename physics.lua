flr_y = 120
gravity = 0.02

-- flag 1: solid tile
function solid(tx,ty)
	return fget(mget(flr(tx),flr(ty)),1)
end

function solid_map(a,dx,dz)
	local by=flr(a.y/16)*16+15-(a.z+dz)
	return
		solid(a.x+dx-a.w,by-a.h*2) or
		solid(a.x+dx+a.w,by-a.h*2) or
		solid(a.x+dx-a.w,by) or
		solid(a.x+dx+a.w,by)
end

-- true if [a] will hit another
-- ent after moving dx,dy

-- also handle bounce response
-- (cheat version: both ents
-- end up with the velocity of
-- the fastest moving ent)

function solid_ent(a, dx, dy)
	for a2 in all(ent) do
		if a2 != a then
			if flr(a.x/16)==flr(a2.x/16) and
				flr(a.y/16)==flr(a2.y/16) then

			local x=(a.x+dx) - a2.x
			local z=(a.z+dy) - a2.z

			if ((abs(x) < (a.w+a2.w)) and
					 (abs(z) < (a.h+a2.h)))
			then

				-- moving together?
					-- this allows ents to
				-- overlap initially
				-- without sticking together

				-- process each axis separately

				-- along x

				if (dx != 0 and abs(x) <
				    abs(a.x-a2.x))
				then

					v=abs(a.dx)>abs(a2.dx) and
					  a.dx or a2.dx
					a.dx,a2.dx = v,v

					local ca=
					 collide_ent(a,a2) or
					 collide_ent(a2,a)
					return not ca
				end

				-- along y

				if (dy != 0 and abs(z) <
					   abs(a.z-a2.z)) then
					v=abs(a.dy)>abs(a2.dy) and
					  a.dy or a2.dy
					a.dy,a2.dy = v,v

					local ca=
					 collide_ent(a,a2) or
					 collide_ent(a2,a)
					return not ca
				end

			end
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

function move_z(a,dz)
	local s=sgn(dz)/8
	while abs(dz)>0 do
		local d=abs(dz)<1/8 and dz or s
		if solid_map(a,0,d) or solid_ent(a,0,d) then
			return false
		end
		a.z += d
		dz -= d
	end
	return true
end

-- return true when something
-- was collected / destroyed,
-- indicating that the two
-- ents shouldn't bounce off
-- each other

function collide_ent(a1,a2)

	-- player collects treasure
	if (a1==pl and a2.k==35) then
		del(ent,a2)
		sfx(3)
		return true
	end

	sfx(2) -- generic bump sound

	return false
end
