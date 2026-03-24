function init_world()
	ent = {}

	-- create some ents

	-- make player
	pl = make_ent(21,5,30)
	pl.frames=4
	pl.bounce=0

	-- bouncy ball
	local ball = make_ent(33,8.5,6)
	ball.dx=0.05
	ball.dy=0.05
	ball.friction=0.02
	ball.bounce=1

	-- treasure

	for i=0,16 do
		a = make_ent(35,8+cos(i/16)*3,
		    5+sin(i/16)*2)
		a.grav=false
		a.w=0.25 a.h=0.25
	end

	shrimp = make_ent(37,10,0)
	shrimp.frames=4
	shrimp.fs=2
	shrimp.sw=2
	shrimp.sh=2
	shrimp.w=0.9
	shrimp.bounce=0
	shrimp.friction=0.1
end
