function init_tank()
	tank={
		ph=7.0,
		amm=0.0,
		stab=100,
		kh=4.0,
		gh=6.0,
		tds=140,
		money=0,
		day=1,
		t=0,
		ct=0,
		bm="",
		sm=0,
		ss=1,
		ps=false,
		i1=0,
		i2=0,
		i1p=0,
		i1b=false
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
	return v<0.4 and 1 or 2
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

function adult_n()
	local s=0
	for a in all(ent) do
		if a.sa!=nil and a.sa>=8 then s+=1 end
	end
	return s
end

function tank_step()
	local f=0
	local s=0
	local n=0
	local m=0
	local b=0
	for a in all(ent) do
		if a.mp!=nil then
			m+=1
		elseif a.mb!=nil then
			b+=1
		elseif a.np!=nil then
			n+=1
		elseif a.sa!=nil then
			if a.sa<8 then
				f+=1
			else
				s+=1
			end
		end
	end
	tank.stab=min(100,tank.stab+30+b*2)
	tank.amm+=(f+s*2+n/2)*(0.025-m*0.005)
	tank.kh=max(0,tank.kh-0.2-n*0.1)
	tank.gh+=b*0.05
	tank.tds+=10
end

function upd_tank()
	tank.t+=1
	if not tank.ps and adult_n()>=10 then tank.ps=true end
	local d=1+flr(tank.t/1500)
	if d>tank.day then
		tank.day=d
		shrimp_day()
		breed_day()
	end
	if tank.t%750==0 then tank_step() end
	tank.ct+=1
	if tank.ct>=120 then
		tank.ct=0
		add_coin()
	end
end

function use_item()
	if tank.i1>0 then
		if tank.i1==1 then
			a=make_snail(pl.x+1,pl.y)
			a.np=tank.i1p
			a.nb=tank.i1b
		elseif tank.i1==2 then
			a=make_shrimp(pl.x+1,pl.y)
			a.sp=0.7+rnd(0.5)
			a.sr=rnd(1)<0.5
			a.sd=rnd(1)<0.1
		elseif tank.i1==3 then
			make_micro(pl.x+1,pl.y)
		else
			make_moss(pl.x+1,pl.y)
		end
		tank.i1=0
		tank.i1p=0
	elseif tank.i2>0 then
		if tank.i2==49 then
			tank.stab-=30
			tank.amm=max(0,tank.amm-1)
			tank.kh=max(0,tank.kh-1)
			tank.gh=max(0,tank.gh-0.5)
			tank.tds=max(0,tank.tds-30)
		elseif tank.i2==32 then
			tank.ph-=0.2
			tank.amm=max(0,tank.amm-1.2)
			tank.kh=max(0,tank.kh-2)
			tank.gh=max(0,tank.gh-1)
			tank.tds=max(0,tank.tds-80)
		elseif tank.i2==50 then
			tank.stab-=20
			tank.kh+=2
			tank.gh+=2
			tank.tds+=200
		else
			tank.stab-=20
			tank.gh+=4
			tank.tds+=25
		end
		tank.i2=0
	end
end

function shop_cost()
	if tank.sm==2 then
		return tank.ss==1 and 6 or tank.ss==2 and 30 or 12
	end
	return tank.ss==1 and 5 or tank.ss<4 and 10 or tank.ss==4 and 20 or 30
end

function shrimp_price()
	if ha and ha.sa!=nil then
		return flr(ha.sp*5)+(ha.sr and 2 or 0)+(ha.sd and 5 or 0)
	end
	return 0
end

function buy_shop()
	local c=shop_cost()
	if tank.money<c then return end
	if tank.sm==2 then
		if tank.ss==1 then
			if tank.i2>0 then return end
			tank.i2=32
		else
			if tank.i1>0 then return end
			tank.i1=tank.ss+1
		end
	elseif tank.ss<4 then
		if tank.i2>0 then return end
		tank.i2=48+tank.ss
	else
		if tank.i1>0 then return end
		tank.i1=tank.ss-3
		if tank.i1==1 then
			tank.i1p=rnd(1)
			tank.i1b=rnd(1)<0.5
		end
	end
	tank.money-=c
	tank.sm=0
end

function upd_shop()
	if tank.sm==3 then
		if btnp(5) and ha and ha.sa!=nil then
			tank.money+=shrimp_price()
			ha=nil
			tank.sm=0
		elseif btnp(4) then
			tank.sm=0
		end
		return
	end
	if btnp(2) then
		tank.ss=max(1,tank.ss-1)
	elseif btnp(3) then
		tank.ss=min(tank.sm==2 and 3 or 5,tank.ss+1)
	elseif btnp(5) then
		buy_shop()
	elseif btnp(4) then
		tank.sm=0
	end
end

function draw_shop_row(n,y,s,c)
	print(tank.ss==n and ">" or " ",18,y,7)
	print(s,26,y,7)
	print("$"..c,88,y,tank.money<c and 8 or 11)
end

function draw_shop()
	rectfill(12,24,116,88,1)
	rect(12,24,116,88,7)
	if tank.sm==3 then
		if ha and ha.sa!=nil then
			print("sell shrimp",36,40,7)
			print("for $"..shrimp_price().."?",42,56,7)
			print("x yes  z no",34,72,7)
		else
			print("no shrimp to sell",24,52,7)
			print("z exit",46,72,7)
		end
	elseif tank.sm==2 then
		print("plant",52,28,7)
		draw_shop_row(1,38,"ro water",6)
		draw_shop_row(2,48,"bacter ae",30)
		draw_shop_row(3,58,"moss ball",12)
	else
		print("shop",56,28,7)
		draw_shop_row(1,38,"water",5)
		draw_shop_row(2,48,"kh+",10)
		draw_shop_row(3,58,"gh+",10)
		draw_shop_row(4,68,"snail",20)
		draw_shop_row(5,78,"fancy",30)
	end
end

function draw_tank_hud()
	print("ph:"..fmt1(tank.ph),8,3,st_col(st_ph(tank.ph)))
	print("amm:"..fmt1(tank.amm),36,3,st_col(st_amm(tank.amm)))
	print("$"..tank.money,72,15,10)
	print("day:"..tank.day,102,15,11)
	print("kh:"..fmt1(tank.kh),8,9,st_col(st_kh(tank.kh)))
	print("gh:"..fmt1(tank.gh),36,9,st_col(st_gh(tank.gh)))
	print(tank.bm,36,15,7)
	print("tds:"..tank.tds,72,3,st_col(st_tds(tank.tds)))
	print("stab:"..tank.stab,72,9,st_col(st_stab(tank.stab)))
	if tank.i1==1 then
		spr(48,16,16)
	elseif tank.i1==2 then
		spr(52,16,16)
	elseif tank.i1==3 then
		spr(16,16,16)
	elseif tank.i1==4 then
		spr(20,16,16)
	end
	if tank.i2>0 then spr(tank.i2,24,16) end
end
