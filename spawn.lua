function make_coin(x,y)
	a = make_ent(36,x,y)
	a.grav=false
	a.w=0.25 a.h=0.25
end

function coin_n()
	local n=0
	for a in all(ent) do
		if a.k==36 then n+=1 end
	end
	return n
end

function add_coin()
	if coin_n()>=8 then return end
	local r=flr(rnd(4))
	make_coin(7+flr(rnd(6))+r*16,9+flr(rnd(2)))
end

function init_world()
	ent = {}
	init_tank()

	-- create some ents

	-- make player
	pl = make_ent(21,20,9)
	pl.frames=4

	shrimp = make_ent(37,25,9)
	shrimp.frames=4
	shrimp.fs=2
	shrimp.sw=2
	shrimp.sh=2
	shrimp.w=0.9
end
