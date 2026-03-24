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

function upd_tank()
	tank.t+=1
	tank.day=1+flr(tank.t/1800)
	tank.ct+=1
	if tank.ct>=120 then
		tank.ct=0
		add_coin()
	end
end

function draw_tank_hud()
	print("ph:"..fmt1(tank.ph),8,3,11)
	print("amm:"..tank.amm,36,3,11)
	print("$"..tank.money,102,9,10)
	print("day:"..tank.day,102,15,11)
	print("kh:"..fmt1(tank.kh),8,9,11)
	print("gh:"..fmt1(tank.gh),36,9,11)
	print("tds:"..tank.tds,64,3,11)
	print("stab:"..tank.stab,64,9,11)
end
