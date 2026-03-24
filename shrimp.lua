function shrimp_size(a)
	if a.sa<8 then
		a.k=53
		a.fs=1
		a.frames=4
		a.sw=1
		a.sh=1
		a.w=0.4
	else
		a.k=37
		a.fs=2
		a.frames=4
		a.sw=2
		a.sh=1
		a.w=0.9
	end
end

function make_shrimp(x,y)
	a=make_ent(37,x,y)
	a.sa=8
	a.sp=0.5
	a.sb=rnd(1)<0.5
	a.sr=rnd(1)<0.3
	a.sd=rnd(1)<0.1
	shrimp_size(a)
	return a
end

function make_fry(x,y)
	a=make_shrimp(x,y)
	a.sa=flr(rnd(8))
	shrimp_size(a)
	return a
end

function shrimp_day()
	for a in all(ent) do
		if a.sa then
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
	pal(5,c)
	pal(6,shrimp_back(a))
	pal(7,a.sr and a.sp>0.7 and 7 or c)
	pal(14,a.sd and a.sp>0.9 and sbc(a,10,9) or 14)
	spr(a.k + flr(a.frame)*a.fs, sx, sy, a.sw, a.sh)
	pal()
end
