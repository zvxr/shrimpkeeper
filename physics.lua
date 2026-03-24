world_w = 16
flr_y = 120
gravity = 0.02

-- true if [a] will hit another
-- ent after moving dx,dy

-- also handle bounce response
-- (cheat version: both ents
-- end up with the velocity of
-- the fastest moving ent)

function solid_ent(a, dx, dy)
	for a2 in all(ent) do
		if a2 != a then

			local x=(a.x+dx) - a2.x
			local y=(a.y+dy) - a2.y

			if ((abs(x) < (a.w+a2.w)) and
					 (abs(y) < (a.h+a2.h)))
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

				if (dy != 0 and abs(y) <
					   abs(a.y-a2.y)) then
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

	return false
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
