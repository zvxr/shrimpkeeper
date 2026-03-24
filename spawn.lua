function make_coin(x,y)
	a = make_ent(36,x,y)
	a.frames=1
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

function add_fry()
	make_fry(7+flr(rnd(6))+(1+flr(rnd(2)))*16,9+flr(rnd(2)))
end

function init_world()
	ent = {}
	init_tank()
	pl = make_ent(21,20,9)
	pl.frames=4

	for i=1,4 do
		add_fry()
	end
end
