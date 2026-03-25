function make_micro(x,y)
	a=make_ent(59,x,y)
	a.mp=true
	a.grav=false
	a.w=0
	a.h=0
	return a
end

function draw_micro(a)
	local sx=(a.x*8)-4
	local sy=(a.y*8)-4
	spr(59+flr(a.t/12)%2,sx,sy)
end
