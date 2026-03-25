function shop_cost()
	if tank.sm==4 then
		return tank.ss==1 and 4 or tank.ss==2 and 10 or 20
	end
	if tank.sm==2 then
		return tank.ss==1 and 6 or tank.ss==2 and 24 or 12
	end
	return tank.ss==1 and 5 or tank.ss==2 and 10 or tank.ss==3 and 6 or tank.ss==4 and 20 or 30
end

function shrimp_price()
	if ha and ha.sa!=nil then
		return (flr(ha.sp*5)+(ha.sr and 2 or 0)+(ha.sd and 5 or 0))*2
	end
	return 0
end

function buy_shop()
	local c=shop_cost()
	if tank.money<c then return end
	if tank.sm==4 then
		if tank.ss==1 then
			if tank.i2>0 then return end
			tank.i2=49
		else
			if tank.i1>0 then return end
			tank.i1=tank.ss==2 and 4 or 2
		end
	elseif tank.sm==2 then
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
		if btnp(5) and ha and ha.sa!=nil and ha.sp>=1 then
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
			if ha.sp>=1 then
				print("sell shrimp",36,40,7)
				print("for $"..shrimp_price().."?",42,56,7)
				print("x yes  z no",34,72,7)
			else
				print("cannot sell",34,48,7)
				print("purity < 1",34,58,7)
				print("z exit",46,72,7)
			end
		else
			print("no shrimp to sell",24,52,7)
			print("z exit",46,72,7)
		end
	elseif tank.sm==4 then
		print("discount",40,28,7)
		draw_shop_row(1,38,"water",4)
		draw_shop_row(2,48,"moss ball",10)
		draw_shop_row(3,58,"fancy",20)
	elseif tank.sm==2 then
		print("plant",52,28,7)
		draw_shop_row(1,38,"ro water",6)
		draw_shop_row(2,48,"bacter ae",30)
		draw_shop_row(3,58,"moss ball",12)
	else
		print("shop",56,28,7)
		draw_shop_row(1,38,"water",5)
		draw_shop_row(2,48,"kh+",10)
		draw_shop_row(3,58,"gh+",6)
		draw_shop_row(4,68,"snail",20)
		draw_shop_row(5,78,"fancy",30)
	end
end
