function init_tank()
	tank={
		ph=7.0,
		amm=0.0,
		stab=100,
		kh=0,
		gh=6.0,
		tds=140,
		money=0,
		day=1,
		t=0,
		ct=0,
		msg="",
		msgc=5,
		mt=0,
		sm=0,
		ss=1,
		pu=false,
		su=false,
		du=false,
		fu=false,
		gu=false,
		hu=false,
		rx=0,
		go=false,
		got=0,
		i1=0,
		i2=0,
		i1p=0,
		i1b=false,
		gp=0,
		gr=0,
		gd=0,
		pp=0,
		f1=3,
		f4=3,
		f5=3,
		b2=4,
		b7=4,
		m2=10,
		m4=10
	}
end

function fmt1(n)
	return flr(n).."."..flr(n%1*10)
end

function st_col(s)
	return s==0 and 11 or s==1 and 10 or 8
end

function st_ph(v)
	if v<6.3 or v>8.7 then return 2 end
	if v<6.8 or v>8.2 then return 1 end
	return 0
end

function st_amm(v)
	if v==0 then return 0 end
	return v<0.5 and 1 or 2
end

function st_tds(v)
	if v<25 or v>375 then return 2 end
	if v<100 or v>300 then return 1 end
	return 0
end

function st_kh(v)
	if v>=8 then return 2 end
	return v>=5 and 1 or 0
end

function st_gh(v)
	if v<3 or v>14 then return 2 end
	if v<5 or v>12 then return 1 end
	return 0
end

function st_stab(v)
	if v>80 then return 0 end
	return v>60 and 1 or 2
end

function tank_ok()
	return st_ph(tank.ph)<2 and
		st_amm(tank.amm)<2 and
		st_tds(tank.tds)<2 and
		st_kh(tank.kh)<2 and
		st_gh(tank.gh)<2 and
		st_stab(tank.stab)<2
end

function tank_red()
	return st_ph(tank.ph)==2 or
		st_amm(tank.amm)==2 or
		st_tds(tank.tds)==2 or
		st_kh(tank.kh)==2 or
		st_gh(tank.gh)==2 or
		st_stab(tank.stab)==2
end

function chk_go()
	if tank.day>=42 or tank.stab<=0 or tank.amm>=3 or tank.rx>=3 or adult_n()+fry_n()<1 then
		if not tank.go then
			hs=max(hs,flr(score_n()))
			dset(0,hs)
			tank.got=30
		end
		tank.go=true
	end
end

function set_msg(s,c)
	tank.msg=s
	tank.msgc=c
	tank.mt=150
end

function adult_n()
	local s=0
	for a in all(ent) do
		if a.sa!=nil and a.sa>=5 then s+=1 end
	end
	return s
end

function fry_n()
	local s=0
	for a in all(ent) do
		if a.sa!=nil and a.sa<5 then s+=1 end
	end
	return s
end

function s4_ok()
	local a=false
	local b=false
	local c=false
	local d=false
	for e in all(ent) do
		if e.sa!=nil and e.sp<0.5 then
			return true
		end
		if e.np!=nil then
			local x=flr(e.x/16)
			if x==0 then
				a=true
			elseif x==1 then
				b=true
			elseif x==2 then
				c=true
			elseif x==3 then
				d=true
			end
		end
	end
	return a and b and c and d
end

function max_pur()
	local p=0
	for a in all(ent) do
		if a.sa!=nil and a.sp>p then p=a.sp end
	end
	return p
end

function avg_pur()
	local n=0
	local p=0
	for a in all(ent) do
		if a.sa!=nil and a.sa>=5 then
			n+=1
			p+=a.sp
		end
	end
	return n>0 and p/n or 0
end

function snail_n()
	local n=0
	for a in all(ent) do
		if a.np!=nil then n+=1 end
	end
	return n
end

function moss_n()
	local n=0
	for a in all(ent) do
		if a.mb!=nil then n+=1 end
	end
	return n
end

function fancy_sp()
	return 1+rnd(max(0,max_pur()-0.8))
end

function algae_n()
	local n=0
	for a in all(ent) do
		if a.ap!=nil then n+=1 end
	end
	return n
end

function go_days()
	return min(5000,tank.day*100+(tank.day>=42 and 800 or 0))
end

function go_ct()
	return adult_n()*100
end

function go_pur()
	return flr(max_pur()*100)
end

function score_n()
	return go_days()+go_ct()+go_pur()
end

function go_col(v,a,b,c)
	return v>=a and 11 or v>=b and 10 or v>=c and 9 or 8
end

function go_rank(s)
	return s>=8000 and "Prawn" or s>=6000 and "Jumbo" or s>=3000 and "Shrimp" or "Fry"
end

function rprint(s,x,y,c)
	s=tostr(s)
	print(s,x-#s*4,y,c)
end

function s5_ok()
	return adult_n()>0
end

function s2_ok()
	return adult_n()+fry_n()>=10
end

function s7_ok()
	return tank.day>=35 or adult_n()+fry_n()>=20
end

function tank_step()
	local b=0
	local o=min(40,max(0,tank.day-17)*2.5)
	for a in all(ent) do
		if a.mb!=nil then
			b+=1
		end
	end
	tank.stab=min(100,tank.stab+15+b*2.5-o)
end

function chem_step()
	local f=0
	local s=0
	local m=0
	local o=max(0,tank.day-17)
	for a in all(ent) do
		if a.mp!=nil then
			m+=1
		elseif a.sa!=nil then
			if a.sa<5 then
				f+=1
			else
				s+=1
			end
		end
	end
	tank.amm=max(0,tank.amm+(f+s*2)*(0.025-m*0.0025)+o*0.05)
	tank.kh=max(0,tank.kh-0.1)
	tank.tds+=10+o*2.5
end

function upd_tank()
	tank.t+=1
	if tank.mt>0 then tank.mt-=1 end
	local u=false
	if not tank.pu and s2_ok() then tank.pu=true u=true end
	if not tank.su and tank.day>=12 then tank.su=true u=true end
	if not tank.du and s4_ok() then tank.du=true u=true end
	if not tank.fu and s5_ok() then tank.fu=true u=true end
	if not tank.gu and tank.day>=19 then tank.gu=true u=true end
	if not tank.hu and s7_ok() then tank.hu=true u=true end
	if u then sfx(7) end
	if tank.t>=1500 then
		tank.t=0
		tank.day+=1
		local d=tank.day
		if tank_red() then
			tank.rx+=1
			sfx(5)
		elseif tank.rx>0 then
			tank.rx-=1
		end
		shrimp_day()
		local m=breed_day()
		if d%10==0 then
			bloom_day(d)
			set_msg("Algae bloom!",3)
		elseif m then
			set_msg(m,11)
		elseif d==41 then
			set_msg("Last day",8)
		elseif d==12 or d==19 then
			set_msg("Shop opened!",13)
		elseif d>=18 then
			set_msg("Old tank",5)
		else
			set_msg("New day",5)
		end
	end
	if tank.t%375==0 then tank_step() end
	if tank.t%750==0 then chem_step() end
	chk_go()
	tank.ct+=1
	if tank.ct>=100 then
		tank.ct=0
		add_coin()
	end
end

function use_item()
	if tank.i1>0 then
		local d=pl.dir or 1
		if tank.i1==1 then
			a=make_snail(pl.x+d,pl.y)
			a.np=tank.i1p
			a.nb=tank.i1b
		elseif tank.i1==2 then
			a=make_shrimp(pl.x+d,pl.y)
			a.sp=fancy_sp()
			a.sr=rnd(20)<sr_o*2
			a.sd=rnd(20)<sd_o*2
		elseif tank.i1==5 then
			a=make_shrimp(pl.x+d,pl.y)
			a.sp=fancy_sp()
			a.sr=rnd(20)<sr_o*2
			a.sd=rnd(20)<sd_o*2
		elseif tank.i1==6 then
			a=make_shrimp(pl.x+d,pl.y)
			a.sp=2
			a.sr=rnd(20)<sr_o*2
			a.sd=rnd(20)<sd_o*2
		elseif tank.i1==7 then
			a=make_shrimp(pl.x+d,pl.y)
			a.sp=1.5
			a.sr=rnd(20)<sr_o*2
			a.sd=true
		elseif tank.i1==3 then
			make_micro(pl.x+d,pl.y)
		else
			make_moss(pl.x+d,pl.y)
		end
		tank.i1=0
		tank.i1p=0
	elseif tank.i2>0 then
		if tank.i2==49 then
			tank.stab-=30
			tank.amm=max(0,tank.amm-1)
			if tank.ph<7 then
				tank.ph=min(7,tank.ph+0.1)
			elseif tank.ph>7 then
				tank.ph=max(7,tank.ph-0.1)
			end
			tank.kh=max(0,tank.kh-1)
			tank.gh=max(0,tank.gh-0.5)
			tank.tds=max(0,tank.tds-30)
		elseif tank.i2==32 then
			tank.stab-=30
			tank.ph-=0.3
			tank.amm=max(0,tank.amm-2)
			tank.kh=max(0,tank.kh-2)
			tank.gh=max(0,tank.gh-2)
			tank.tds=max(0,tank.tds-120)
		elseif tank.i2==50 then
			tank.stab-=20
			tank.kh+=3
			tank.tds+=40
		elseif tank.i2==208 then
			tank.stab-=15
			tank.tds+=100
		elseif tank.i2==192 then
			tank.ph+=0.1
		else
			tank.stab-=20
			tank.gh+=4
			tank.tds+=25
		end
		tank.i2=0
	end
	chk_go()
end

function draw_tank_hud()
	if tank.day==41 then
		pal(9,11)
		map(room_x*16,room_y*16,0,0,16,3)
		pal()
	elseif tank.rx>0 then
		pal(9,8)
		if tank.rx>1 then pal(10,8) end
		map(room_x*16,room_y*16,0,0,16,3)
		pal()
	end
	print("ph:"..fmt1(tank.ph),8,3,st_col(st_ph(tank.ph)))
	print("amm:"..fmt1(tank.amm),36,3,st_col(st_amm(tank.amm)))
	print("$"..tank.money,80,15,10)
	print("Ct:"..adult_n(),104,3,3)
	local c=tank.t<375 and 11 or tank.t<750 and 10 or tank.t<1125 and 9 or 8
	print("day:"..tank.day,100,15,c)
	print("kh:"..fmt1(tank.kh),8,9,st_col(st_kh(tank.kh)))
	print("gh:"..fmt1(tank.gh),36,9,st_col(st_gh(tank.gh)))
	if tank.mt>0 then print(tank.msg,36,15,tank.msgc) end
	print("tds:"..tank.tds,72,3,st_col(st_tds(tank.tds)))
	print("stab:"..tank.stab,72,9,st_col(st_stab(tank.stab)))
	if tank.i1==1 then
		spr(48,16,16)
	elseif tank.i1==2 or tank.i1==5 or tank.i1==6 or tank.i1==7 then
		spr(52,16,16)
	elseif tank.i1==3 then
		spr(16,16,16)
	elseif tank.i1==4 then
		spr(20,16,16)
	end
	if tank.i2>0 then spr(tank.i2,24,16) end
end

function draw_go()
	local s=flr(score_n())
	local d=go_days()
	local c=go_ct()
	local p=go_pur()
	local dc=go_col(tank.day,40,32,16)
	local cc=go_col(adult_n(),28,20,14)
	local pc=go_col(max_pur(),12,8,4)
	local sc=go_col(s,8000,6000,3000)
	rectfill(16,30,112,96,tank.day>=42 and 3 or 0)
	rect(16,30,112,96,tank.day>=42 and 11 or 8)
	print("game over",40,36,tank.day>=42 and 11 or 8)
	print("days:"..tank.day,22,50,dc)
	rprint(d,108,50,dc)
	print("ct:"..adult_n(),22,62,cc)
	rprint(c,108,62,cc)
	print("max pur:"..fmt1(max_pur()),22,74,pc)
	rprint(p,108,74,pc)
	print("Rank: "..go_rank(s),22,86,sc)
	rprint(s,108,86,sc)
end
