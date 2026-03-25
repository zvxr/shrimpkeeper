function make_moss(x,y)
	a=make_ent(61,x,y)
	a.mb=true
	a.frames=2
	a.w=0.35
	a.h=0.35
	return a
end

function draw_moss(a)
	local sx=(a.x*8)-4
	local sy=(a.y*8)-4
	spr(61+flr(a.frame),sx,sy)
end
