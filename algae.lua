function make_algae(x,y)
	a=make_ent(26,x,y)
	a.ap=true
	a.grav=false
	a.frames=1
	a.dx=0
	a.dy=0
	a.w=0.4
	a.h=0.4
	return a
end

function algae_bad(x,y)
	return solid(x,y) or
		(x==60 and y==5) or
		(x==5 and y==4) or
		(x==25 and y==4) or
		(x==45 and y==5) or
		(x==33 and y==11) or
		(x==30 and y==10) or
		abs(pl.x-(x+.5))<2 and abs(pl.y-(y+.5))<2
end

function bloom_day(d)
	local n=4+d/10
	for r=0,3 do
		for i=1,n do
			local t=0
			while t<12 do
				local x=r*16+flr(rnd(16))
				local y=flr(rnd(16))
				if not algae_bad(x,y) then
					make_algae(x+.5,y+.5)
					break
				end
				t+=1
			end
		end
	end
end

function upd_algae()
	for a in all(ent) do
		if a.ap!=nil then
			a.dx=0
			a.dy=0
			for b in all(ent) do
				if b.np!=nil and
					abs(a.x-b.x)<1.2 and
					abs(a.y-b.y)<1.2 then
					tank.tds=max(0,tank.tds-3)
					sfx(8)
					del(ent,a)
					break
				end
			end
		end
	end
end
