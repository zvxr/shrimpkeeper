function make_snail(x,y)
	a=make_ent(57,x,y)
	a.np=0.5
	a.nb=rnd(1)<0.5
	a.nt=0
	a.ndx=0
	a.no=0
	a.frames=2
	a.w=0.3
	a.h=0.3
	return a
end

function snail_shell(a)
	if a.np>0.9 then return a.nb and 2 or 3 end
	if a.np>0.7 then return a.nb and 8 or 11 end
	if a.np>0.4 then return a.nb and 9 or 10 end
	return 5
end

function snail_ledge(a)
	local d=a.ndx
	return d!=0 and not solid(a.x+d*.6,a.y+a.h+.2)
end

function upd_snail()
	for a in all(ent) do
		if a.np!=nil then
			if snail_ledge(a) then
				a.ndx=0
				a.dx=0
				a.nt=6
			end
			if a.nt>0 then
				a.nt-=1
			else
				local r=flr(rnd(10))
				if r<5 then
					a.ndx=0
					a.nt=15+flr(rnd(30))
				else
					a.ndx=r<7 and -1 or 1
					a.no=a.ndx>0 and 1 or 0
					a.nt=18+flr(rnd(24))
				end
			end
			a.dx+=a.ndx*0.015
		end
	end
end

function draw_snail(a)
	local sx=(a.x*8)-4
	local sy=(a.y*8)-4
	pal(5,snail_shell(a))
	spr(57+flr(a.t/12)%2,sx,sy,1,1,a.no==1)
	pal()
end
