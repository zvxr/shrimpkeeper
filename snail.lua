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

function upd_snail()
	for a in all(ent) do
		if a.np!=nil then
			if a.nt>0 then
				a.nt-=1
			else
				local r=flr(rnd(12))
				if r<8 then
					a.ndx=0
					a.nt=30+flr(rnd(70))
				else
					a.ndx=r<10 and -1 or 1
					a.no=a.ndx>0 and 1 or 0
					a.nt=20+flr(rnd(40))
				end
			end
			a.dx+=a.ndx*0.01
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
