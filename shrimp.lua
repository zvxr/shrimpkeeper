function shrimp_size(a)
	if a.sa<5 then
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
	a.sr=rnd(1)<0.4
	a.sd=rnd(1)<0.2
	a.st=0
	a.sdx=0
	a.so=0
	a.sj=0
	shrimp_size(a)
	return a
end

function shrimp_line(a)
	return a.sb and "red" or "yellow"
end

function near_pet(a)
	for b in all(ent) do
		if (b.sa!=nil or b.np!=nil or b.ap!=nil) and
			abs(a.x-b.x)<1.5 and
			abs(a.y-b.y)<1.5 then
			return b
		end
	end
end

function hold_pet(a)
	ha=a
	del(ent,a)
end

function drop_pet()
	add(ent,ha)
	ha.x=pl.x+1
	ha.y=pl.y
	ha.dx=0
	ha.dy=0
	ha=nil
end

function try_pet(a)
	if btnp(4) then
		if ha then
			drop_pet()
		else
			local b=near_pet(a)
			if btn(3) and b then
				hold_pet(b)
			else
				if b and b.ap==nil then
					sd_a=b
				else
					use_item()
				end
			end
		end
	end
end

function draw_pet_dialog(a)
	rectfill(20,28,107,83,1)
	rect(20,28,107,83,7)
	if a.sa!=nil then
		print("shrimp",48,32,7)
		print("age:"..a.sa,28,42,7)
		print("pur:"..a.sp,28,50,7)
		print("line:"..shrimp_line(a),28,58,7)
		print("riley:"..(a.sr and "y" or "n"),28,66,7)
		print("devil:"..(a.sd and "y" or "n"),28,74,7)
	else
		print("snail",52,32,7)
		print("pur:"..a.np,28,50,7)
		print("line:"..(a.nb and "red" or "yellow"),28,58,7)
	end
end

function make_fry(x,y)
	a=make_shrimp(x,y)
	a.sa=2+flr(rnd(2))
	shrimp_size(a)
	return a
end

function make_baby(x,y,a,b)
	local c=make_shrimp(x,y)
	local lo=min(a.sp,b.sp)-0.2
	local hi=max(a.sp,b.sp)+0.2
	local m=false
	c.sa=1
	c.sp=lo+rnd(hi-lo)+tank.kh/4
	c.sb=a.sb
	c.sr=a.sr and b.sr or
		((a.sr or b.sr) and rnd(1)<0.5)
	c.sd=a.sd and b.sd or
		((a.sd or b.sd) and rnd(1)<0.5)
	if rnd(10)<1 then c.sp+=1 m=true end
	if rnd(20)<1 then c.sr=true m=true end
	if rnd(100)<1 then c.sd=true m=true end
	shrimp_size(c)
	if c.sp>=2 then
		return c.sb and "BloodyMary!" or "GreenJade!"
	end
	if m then return "Mutation!" end
end

function breed_room(r)
	local c=nil
	local nr=0
	local ny=0
	for a in all(ent) do
		if a.sa and a.sa>=5 and flr(a.x/16)==r then
			if a.sb then
				nr+=1
			else
				ny+=1
			end
		end
	end
	if nr<2 and ny<2 then return end
	if nr>1 and (ny<2 or rnd(1)<0.5) then
		c=true
	else
		c=false
	end
	local a1=nil
	local a2=nil
	local n=0
	for a in all(ent) do
		if a.sa and a.sa>=5 and a.sb==c and flr(a.x/16)==r then
			n+=1
			if n==1 then
				a1=a
			elseif n==2 then
				a2=a
			else
				if rnd(n)<1 then
					a1=a
				elseif rnd(n)<1 then
					a2=a
				end
			end
		end
	end
	if not a2 then return end
	if rnd(1)<0.5 then
		local m=make_baby(7+flr(rnd(6))+r*16,9+flr(rnd(2)),a1,a2)
		sfx(4)
		return m
	end
end

function breed_day()
	if not tank_ok() then
		return
	end
	local m=false
	for r=0,3 do
		local e=breed_room(r)
		if e=="Bloody M Born!" or e=="Jade Born!" then
			m=e
		elseif e and not m then
			m=e
		end
	end
	return m
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
				a.dy-=a.sa<5 and 0.45 or 0.6
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
						a.dy-=a.sa<5 and 0.45 or 0.6
						a.sj=1+flr(rnd(4))
						sfx(2)
					end
				end
			end
			a.dx+=a.sdx*(a.sa<5 and 0.03 or 0.04)
		end
	end
end

function shrimp_day()
	for a in all(ent) do
		if a.sa!=nil then
			a.sa+=1
			if a.sa>=30 and rnd(1)<0.5 then
				del(ent,a)
			else
				shrimp_size(a)
			end
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

function draw_held_pet()
	if not ha then return end
	if ha.sa!=nil then
		local c=shrimp_body(ha)
		pal(5,c)
		pal(6,shrimp_back(ha))
		pal(7,ha.sr and ha.sp>0.7 and 7 or c)
		pal(14,ha.sd and ha.sp>0.9 and sbc(ha,10,9) or 14)
		spr(52,room_x*128+8,16)
		if ha.sp>0.6 then print("*",36,15,c) end
	else
		if ha.np!=nil then
			pal(5,snail_shell(ha))
			spr(48,room_x*128+8,16)
		else
			spr(26,room_x*128+8,16)
		end
	end
	pal()
end
