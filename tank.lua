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
		ct=0
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

function upd_tank()
	tank.t+=1
	local d=1+flr(tank.t/1800)
	if d>tank.day then
		tank.day=d
		shrimp_day()
	end
	tank.ct+=1
	if tank.ct>=120 then
		tank.ct=0
		add_coin()
	end
end

function draw_tank_hud()
	print("ph:"..fmt1(tank.ph),8,3,st_col(st_ph(tank.ph)))
	print("amm:"..tank.amm,36,3,st_col(st_amm(tank.amm)))
	print("$"..tank.money,102,9,10)
	print("day:"..tank.day,102,15,11)
	print("kh:"..fmt1(tank.kh),8,9,st_col(st_kh(tank.kh)))
	print("gh:"..fmt1(tank.gh),36,9,st_col(st_gh(tank.gh)))
	print("tds:"..tank.tds,64,3,st_col(st_tds(tank.tds)))
	print("stab:"..tank.stab,64,9,st_col(st_stab(tank.stab)))
end
