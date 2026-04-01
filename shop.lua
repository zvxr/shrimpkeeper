function shop_cost()
	if tank.sm==5 then
		return 5
	end
	if tank.sm==4 then
		return tank.ss==1 and 3 or tank.ss==2 and 10 or 20
	end
	if tank.sm==6 then
		return tank.ss==1 and 20 or tank.ss==2 and 6 or 10
	end
	if tank.sm==7 then
		return tank.ss==1 and 15+tank.pp*5 or 28
	end
	if tank.sm==2 then
		return tank.ss==1 and 6 or tank.ss==2 and 24 or 12
	end
	return tank.ss==1 and 5 or tank.ss==2 and 10 or tank.ss==3 and 6 or tank.ss==4 and 8 or 16
end

function shrimp_price()
	if ha and ha.sa!=nil then
		return (flr(ha.sp*5)+(ha.sr and 2 or 0)+(ha.sd and 5 or 0))*2
	end
	return 0
end

function cull_n(k)
	local n=0
	for a in all(ent) do
		if a.sa!=nil and a.sp<0.5 then
			if k==1 and a.sa<5 or k==2 and a.sa>=5 then
				n+=1
			end
		end
	end
	return n
end

function cull_one(k)
	local n=0
	for a in all(ent) do
		if a.sa!=nil and a.sp<0.5 then
			if k==1 or k==2 then
				del(ent,a)
				n+=1
			end
		end
	end
	return n>0
end

function buy_shop()
	local c=shop_cost()
	if tank.money<c then return end
	if tank.sm==5 then
		if not ha or ha.sa==nil or ha.sa>=5 then return end
		ha.sa+=1
		shrimp_size(ha)
	elseif tank.sm==6 then
		if tank.ss==1 then
			tank.gp+=1
		elseif tank.ss==2 then
			tank.gr+=1
		else
			tank.gd+=1
		end
	elseif tank.sm==7 then
		if tank.ss==1 then
			if tank.i2>0 then return end
			tank.i2=192
			tank.pp+=1
		else
			if tank.b7<1 then return end
			if tank.i1>0 then return end
			tank.i1=3
			tank.b7-=1
		end
	elseif tank.sm==4 then
		if tank.ss==1 then
			if tank.i2>0 then return end
			tank.i2=49
		else
			if tank.ss==2 and tank.m4<1 then return end
			if tank.ss==3 and tank.f4<1 then return end
			if tank.i1>0 then return end
			tank.i1=tank.ss==2 and 4 or 2
			if tank.ss==2 then tank.m4-=1 end
			if tank.ss==3 then tank.f4-=1 end
		end
	elseif tank.sm==2 then
		if tank.ss==1 then
			if tank.i2>0 then return end
			tank.i2=32
		else
			if tank.ss==2 and tank.b2<1 then return end
			if tank.ss==3 and tank.m2<1 then return end
			if tank.i1>0 then return end
			tank.i1=tank.ss+1
			if tank.ss==2 then tank.b2-=1 end
			if tank.ss==3 then tank.m2-=1 end
		end
	elseif tank.ss<4 then
		if tank.i2>0 then return end
		tank.i2=48+tank.ss
	elseif tank.ss<5 then
		if tank.i2>0 then return end
		tank.i2=tank.ss==4 and 208 or 48+tank.ss
	else
		if tank.i1>0 then return end
		tank.i1=1
		tank.i1p=rnd(1)
		tank.i1b=rnd(1)<0.5
	end
	tank.money-=c
	if tank.sm==6 then sfx(3) end
	tank.sm=0
end

function upd_shop()
	if tank.sm==3 then
		if btnp(5) and ha and ha.sa!=nil and ha.sa>=5 then
			tank.money+=shrimp_price()
			ha=nil
			tank.sm=0
		elseif btnp(4) then
			tank.sm=0
		end
		return
	elseif tank.sm==5 then
		if btnp(5) and ha and ha.sa!=nil and ha.sa<5 and tank.money>=5 then
			buy_shop()
		elseif btnp(4) then
			tank.sm=0
		end
		return
	end
	if btnp(2) then
		tank.ss=max(1,tank.ss-1)
	elseif btnp(3) then
		tank.ss=min(tank.sm==7 and 2 or (tank.sm==2 or tank.sm==5 or tank.sm==6) and 3 or 5,tank.ss+1)
	elseif btnp(5) then
		buy_shop()
	elseif btnp(4) then
		tank.sm=0
	end
end

function draw_shop_row(n,y,s,c,z)
	print(tank.ss==n and ">" or " ",18,y,7)
	print(s,26,y,z and 8 or 7)
	print("$"..c,88,y,z and 8 or tank.money<c and 8 or 11)
end

function draw_shop()
	rectfill(12,24,116,88,1)
	rect(12,24,116,88,7)
	if tank.sm==3 then
		if ha and ha.sa!=nil then
			if ha.sa>=5 then
				print("sell shrimp",36,40,7)
				print("for $"..shrimp_price().."?",42,56,7)
				print("x yes  z no",34,72,7)
			else
				print("cannot sell",34,48,7)
				print("bring adult",32,58,7)
				print("z exit",46,72,7)
			end
		else
			print("no shrimp to sell",24,52,7)
			print("z exit",46,72,7)
		end
	elseif tank.sm==5 then
		if ha and ha.sa!=nil and ha.sa<5 then
			print("grow shop",36,40,7)
			print("grow fry to "..(ha.sa+1).."?",22,56,7)
			print("z no",34,72,7)
			print("x yes",74,72,tank.money<5 and 8 or 7)
		else
			print("grow shop",36,40,7)
			print("bring fry",38,56,7)
			print("to age",46,66,7)
			print("z exit",46,78,7)
		end
	elseif tank.sm==4 then
		print("thrift",44,28,7)
		draw_shop_row(1,38,"water",3)
		draw_shop_row(2,48,"moss ("..tank.m4..")",10,tank.m4<1)
		draw_shop_row(3,58,"fancy ("..tank.f4..")",20,tank.f4<1)
	elseif tank.sm==6 then
		print("genetic",44,28,7)
		draw_shop_row(1,38,"purity+ ("..tank.gp..")",20)
		draw_shop_row(2,48,"riley+ ("..tank.gr..")",6)
		draw_shop_row(3,58,"devil+ ("..tank.gd..")",10)
	elseif tank.sm==7 then
		print("glass",44,28,7)
		draw_shop_row(1,38,"ph+",15+tank.pp*5)
		draw_shop_row(2,48,"bacter ("..tank.b7..")",28,tank.b7<1)
	elseif tank.sm==2 then
		print("plant",52,28,7)
		draw_shop_row(1,38,"ro water",6)
		draw_shop_row(2,48,"bacter ("..tank.b2..")",24,tank.b2<1)
		draw_shop_row(3,58,"moss ("..tank.m2..")",12,tank.m2<1)
	else
		print("shop",56,28,7)
		draw_shop_row(1,38,"water",5)
		draw_shop_row(2,48,"kh+",10)
		draw_shop_row(3,58,"gh+",6)
		draw_shop_row(4,68,"tds+",8)
		draw_shop_row(5,78,"snail",16)
	end
end
