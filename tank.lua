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
		sm=false,
		ss=1,
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
	return st_ph(tank.ph)==0 and
		st_amm(tank.amm)==0 and
		st_tds(tank.tds)==0 and
		st_kh(tank.kh)==0 and
		st_gh(tank.gh)==0 and
		st_stab(tank.stab)==0
end

function tank_step()
	local f=0
	local s=0
	local n=0
	for a in all(ent) do
		if a.np!=nil then
			n+=1
		elseif a.sa!=nil then
			if a.sa<8 then
				f+=1
			else
				s+=1
			end
		end
	end
	tank.stab=min(100,tank.stab+10)
	tank.amm+=f+s*2+n/2
	tank.kh-=0.2-n*0.1
	tank.tds+=10
end

function upd_tank()
	tank.t+=1
	local d=1+flr(tank.t/1500)
	if d>tank.day then
		tank.day=d
		shrimp_day()
		breed_day()
	end
	if tank.t%300==0 then tank_step() end
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
		else
			a=make_shrimp(pl.x+1,pl.y)
			a.sp=0.7+rnd(0.5)
			a.sr=rnd(1)<0.5
			a.sd=rnd(1)<0.1
		end
		tank.i1=0
		tank.i1p=0
	elseif tank.i2>0 then
		if tank.i2==49 then
			tank.stab-=50
			tank.amm/=2
			tank.kh-=1
			tank.gh-=1
			tank.tds-=50
		elseif tank.i2==50 then
			tank.stab-=20
			tank.kh+=2
			tank.gh+=2
			tank.tds+=50
		else
			tank.stab-=20
			tank.gh+=2
			tank.tds+=25
		end
		tank.i2=0
	end
end

function shop_cost()
	return tank.ss==1 and 5 or tank.ss<4 and 10 or tank.ss==4 and 20 or 30
end

function buy_shop()
	local c=shop_cost()
	if tank.money<c then return end
	if tank.ss<4 then
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
end

function upd_shop()
	if btnp(2) then
		tank.ss=max(1,tank.ss-1)
	elseif btnp(3) then
		tank.ss=min(5,tank.ss+1)
	elseif btnp(4) then
		buy_shop()
	elseif btnp(5) then
		tank.sm=false
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
	print("shop",56,28,7)
	draw_shop_row(1,38,"water",5)
	draw_shop_row(2,48,"kh+",10)
	draw_shop_row(3,58,"gh+",10)
	draw_shop_row(4,68,"snail",20)
	draw_shop_row(5,78,"fancy",30)
end

function draw_tank_hud()
	print("ph:"..fmt1(tank.ph),8,3,st_col(st_ph(tank.ph)))
	print("amm:"..tank.amm,36,3,st_col(st_amm(tank.amm)))
	print("$"..tank.money,102,9,10)
	print("day:"..tank.day,102,15,11)
	print("kh:"..fmt1(tank.kh),8,9,st_col(st_kh(tank.kh)))
	print("gh:"..fmt1(tank.gh),36,9,st_col(st_gh(tank.gh)))
	print(tank.bm,36,15,7)
	print("tds:"..tank.tds,64,3,st_col(st_tds(tank.tds)))
	print("stab:"..tank.stab,64,9,st_col(st_stab(tank.stab)))
	if tank.i1==1 then
		spr(48,16,16)
	elseif tank.i1==2 then
		spr(52,16,16)
	end
	if tank.i2>0 then spr(tank.i2,24,16) end
end
