function shrimp_size(a)
	if a.sa<8 then
		a.k=53
		a.fs=1
		a.frames=4
		a.sw=1
		a.sh=1
		a.w=0.3
		a.h=0.3
	else
		a.k=37
		a.fs=2
		a.frames=4
		a.sw=2
		a.sh=1
		a.w=0.7
		a.h=0.3
	end
end

function make_shrimp(x,y)
	a=make_ent(37,x,y)
	a.sa=8
	a.sp=0.5
	a.sb=rnd(1)<0.5
	a.sr=rnd(1)<0.3
	a.sd=rnd(1)<0.1
	a.st=0
	a.sdx=0
	a.so=0
	a.sj=0
	shrimp_size(a)
	return a
end

function shrimp_line(a)
	return a.sb and "red" or "green"
end

function near_shrimp(a)
	for b in all(ent) do
		if b.sa!=nil and
			abs(a.x-b.x)<1.5 and
			abs(a.y-b.y)<1.5 then
			return b
		end
	end
end

function try_shrimp(a)
	if btnp(4) then
		sd_a=near_shrimp(a)
	end
end

function draw_shrimp_dialog(a)
	rectfill(20,28,107,83,1)
	rect(20,28,107,83,7)
	print("shrimp",48,32,7)
	print("age:"..a.sa,28,42,7)
	print("pur:"..a.sp,28,50,7)
	print("line:"..shrimp_line(a),28,58,7)
	print("riley:"..(a.sr and "y" or "n"),28,66,7)
	print("devil:"..(a.sd and "y" or "n"),28,74,7)
end

function make_fry(x,y)
	a=make_shrimp(x,y)
	a.sa=3+flr(rnd(4))
	shrimp_size(a)
	return a
end

function make_baby(x,y,a,b)
	local c=make_shrimp(x,y)
	local lo=min(a.sp,b.sp)-0.2
	local hi=max(a.sp,b.sp)+0.2
	local m=false
	c.sa=1
	c.sp=lo+rnd(hi-lo)
	c.sb=a.sb
	c.sr=a.sr and b.sr or
		((a.sr or b.sr) and rnd(1)<0.5)
	c.sd=a.sd and b.sd or
		((a.sd or b.sd) and rnd(1)<0.5)
	if rnd(10)<1 then c.sp+=1 m=true end
	if rnd(20)<1 then c.sr=true m=true end
	if rnd(100)<1 then c.sd=true m=true end
	shrimp_size(c)
	return m
end

function breed_day()
	tank.bm="br:none"
	if not tank_ok() then
		tank.bm="br:bad"
		return
	end
	for a in all(ent) do
		if a.sa and a.sa>=8 then
			for b in all(ent) do
				if b!=a and b.sa and b.sa>=8 and
					a.sb==b.sb and
					flr(a.x/16)==flr(b.x/16) and
					flr(a.y/16)==flr(b.y/16) then
					if rnd(1)<0.5 then
						tank.bm=make_baby(
							7+flr(rnd(6))+flr(a.x/16)*16,
							9+flr(rnd(2))+flr(a.y/16)*16,
							a,b) and "Mutation!" or "br:bred"
					else
						tank.bm="br:fail"
					end
					return
				end
			end
		end
	end
end

function upd_shrimp()
	for a in all(ent) do
		if a.sa!=nil then
			for b in all(ent) do
				if b!=a and b.sa!=nil then
					local x=a.x-b.x
					local y=a.y-b.y
					if abs(x)<a.w+b.w and
						abs(y)<a.h+b.h then
						if x!=0 then
							a.dx+=sgn(x)*0.03
						else
							a.dx+=rnd(1)<0.5 and -0.03 or 0.03
						end
						if y!=0 then
							a.dy+=sgn(y)*0.02
						end
					end
				end
			end
			if a.sj>0 and rnd(1)<0.18 then
				a.sj-=1
				a.dy-=a.sa<8 and 0.45 or 0.6
				sfx(2)
			end
			if a.st>0 then
				a.st-=1
			else
				local r=flr(rnd(10))
				if r<4 then
					a.sdx=0
					a.st=30+flr(rnd(50))
				else
					a.sdx=r<5 and -1 or 1
					a.so=a.sdx>0 and 1 or 0
					a.st=15+flr(rnd(30))
					if rnd(1)<0.12 then
						a.dy-=a.sa<8 and 0.45 or 0.6
						a.sj=1+flr(rnd(4))
						sfx(2)
					end
				end
			end
			a.dx+=a.sdx*(a.sa<8 and 0.03 or 0.04)
		end
	end
end

function shrimp_day()
	for a in all(ent) do
		if a.sa!=nil then
			a.sa+=1
			shrimp_size(a)
		end
	end
end

function sbc(a,r,g)
	return a.sb and r or g
end

function shrimp_body(a)
	if a.sp>=2 then return sbc(a,2,3) end
	if a.sp>=0.7 then return sbc(a,8,11) end
	if a.sp>=0.5 then return sbc(a,9,10) end
	return sbc(a,4,5)
end

function shrimp_back(a)
	if a.sp>=2 then return sbc(a,2,3) end
	if a.sp>=0.9 then return sbc(a,8,11) end
	if a.sp>=0.6 then return sbc(a,9,10) end
	return sbc(a,4,5)
end

function draw_shrimp(a)
	local sx = (a.x * 8) - a.sw*4
	local sy = (a.y * 8) - a.sh*4
	local c=shrimp_body(a)
	local f=0
	if a.sdx!=0 or abs(a.dy)>0.05 then
		f=flr(a.t/6)%a.frames
	end
	pal(5,c)
	pal(6,shrimp_back(a))
	pal(7,a.sr and a.sp>0.7 and 7 or c)
	pal(14,a.sd and a.sp>0.9 and sbc(a,10,9) or 14)
	spr(a.k + f*a.fs, sx, sy, a.sw, a.sh, a.so==1)
	pal()
end
