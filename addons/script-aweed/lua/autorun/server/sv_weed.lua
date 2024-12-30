
resource.AddWorkshop("572181423")

util.AddNetworkString("UpdateWeedState")
util.AddNetworkString("PurchaseWeed")

local ply = FindMetaTable("Player")

function ply:GetWeed()
	return self:GetNWInt("WeedLevel",0)
end

function ply:SetWeed(q,p)
	net.Start("UpdateWeedState")
	net.WriteInt(self:GetNWInt("WeedLevel",0),16)
	net.Send(self)
	if(p) then
		self:SetNWInt("WeedLevel",self:GetWeed()+p)
	else
		self:SetNWInt("WeedLevel",q)
	end
end

hook.Add("PlayerSpawn","NODRUG",function(ply)
	ply.DMG = 0
	ply:SetWeed(0)
end)

hook.Add("EntityTakeDamage","DoDelayedDamage",function(ply,dmg)
	if(ply:IsPlayer() && ply:GetWeed() > 0) then
		ply.DMG = (ply.DMG or 0) + dmg:GetDamage()
		dmg:SetDamage(0)
	end
end)

hook.Add("PlayerTick","ResolveDamage",function(ply)
	if(ply:GetWeed() > -1 && (ply.NWeed or 0) < CurTime()) then
		ply.NWeed = CurTime() + math.random(3.0,8.0)
		ply:SetWeed(1,-1)
	end
	if((ply.DMG or 0) > 0) then
		if(ply:GetWeed() > 0) then
			if((ply.NDamage or 0) < CurTime()) then
				ply.NDamage = CurTime() + 1
				ply:SetHealth(ply:Health() - math.ceil(ply.DMG/10))
				ply.DMG = ply.DMG - math.ceil(ply.DMG/10)
				if(ply:Health() <= 0 && ply:Alive()) then
					ply:Kill()
				end
			end
		else
			ply:SetHealth(ply:Health()-ply.DMG)
			ply.DMG = 0
			if(ply:Health() <= 0  && ply:Alive()) then
				ply:Kill()
			end
		end
	end
end)

hook.Add("SetupMove","ClippedMod",function(ply, mv, cmd)
	if(ply:GetWeed() > 0) then
		local w = ply:GetWeed()
		local f = mv:GetForwardSpeed()
		local s = mv:GetSideSpeed()
		if((ply.MustGoBack or 0) < CurTime()) then
			ply.MustGoBack = CurTime() + math.random(1,5)
			mv:SetForwardSpeed( f + -math.abs(math.cos(RealTime())*25*w/75 ))
		elseif((ply.MustGoBack or 0)+2 > CurTime()) then
			mv:SetForwardSpeed( f + math.abs(math.cos(RealTime())*25*w/75 ))
		end
		mv:SetSideSpeed( s + math.sin(RealTime())*25*w/100 )
	end
end)

function calculateWeed(ply,newAmount,newQuality)
	MsgN("Old quality: "..ply:GetNWInt("WeedQuality")," Amount ",ply:GetNWInt("WeedAmmount"))
	//cual es mi cantidad de marihuana
	local myQuality = math.max(ply:GetNWInt("WeedQuality"),1)
	//Cual es ese porcentage de marihuana que tengo
	local newDesired = (newAmount/math.max(ply:GetNWInt("WeedAmmount"),1))
	MsgN("Weed proportion ",newDesired)
	//Calculo el nuevo porcentage
	//Calculo el porcentage de calidad que tiene esa porcion
	local totalQuality = 0
	if(newQuality > myQuality) then
	 totalQuality = myQuality + (newDesired)*newQuality
 	elseif(newQuality < myQuality) then
		totalQuality = myQuality - (newDesired)*newQuality
	else
		totalQuality = myQuality
 	end

	if(ply:GetNWInt("WeedQuality") == 0) then
		totalQuality = newQuality
	end

	ply:SetNWInt("WeedQuality",totalQuality)
	ply:SetNWInt("WeedAmmount",ply:GetNWInt("WeedAmmount")+newAmount)
end

function clear()
	local ply = player.GetByID(1)
	ply:SetNWInt("WeedQuality",0)
	ply:SetNWInt("WeedAmmount",0)
end

net.Receive("PurchaseWeed",function(l,ply)
	local a = net.ReadInt(16)
	local b = net.ReadInt(16)
	local c = net.ReadBool()

	if(b > 100) then return end
	if(!isnumber(a) || a > math.huge || a < -math.huge) then return end
	if(b < 0) then return end
	if(a > 10000) then return end


	MsgN("Test")

	_weedDebug("Weed purchase, quality: "..b.." - Quantity: "..a)

	if(!c && !WEED_CONFIG.WeedPurchase) then
		_weedDebug("Weed purchase disabled!")
		DarkRP.notify(ply,0,5,"Weed purchase it's disabled, you only can purchase from dealers")
		return
	end

	local mn = math.Round((a*WEED_CONFIG.QuantityPrice * Either(c,math.Clamp(b,0,ply:GetNWInt("WeedQuality")),b)*WEED_CONFIG.QualityPrice * Either(c,WEED_CONFIG.SellingPrice,1))/10)*10
	if(mn < 0) then return end

	if(!c && mn <= ply:getDarkRPVar("money")) then

		_weedDebug("Weed transaction started!")

		ply:addMoney(-mn)
		MsgN(mn)
/*
		local am = a
		local om = ply:GetNWInt("WeedAmmount",0)
		local ql = ply:GetNWInt("WeedQuality",0)

		local div = Either(ql==0,1,2)
		ply:SetNWInt("WeedAmmount",ply:GetNWInt("WeedAmmount",0)+am)

		local totalQuality = ply:GetNWInt("WeedQuality")+((am/ply:GetNWInt("WeedAmmount"))*(b))
		ply:SetNWInt("WeedQuality",math.min(totalQuality,100))
*/
		calculateWeed(ply,a,b)

		_weedDebug("Weed transaction succefully!")

		if(!ply:HasWeapon("sent_bong")) then
			DarkRP.notify(ply,0,5,"Remember that you'll need a bong to smoke")
		else
			DarkRP.notify(ply,0,5,"You've purchased "..am.." grams")
		end

	elseif(c && math.Round(a) <= math.Round(ply:GetNWInt("WeedAmmount",0)) && math.Round(b) == math.Round(ply:GetNWInt("WeedQuality",0))) then

		_weedDebug("You sold some weed")
		ply:addMoney(mn)
		MsgN(mn)
		ply:SetNWInt("WeedAmmount",ply:GetNWInt("WeedAmmount",0)-a)
		DarkRP.notify(ply,0,5,"You sold "..a.." grams of weed")
	end

	timer.Simple(1,function()
		if(ply:GetNWInt("WeedAmmount",0) <= 0) then
			ply:SetNWInt("WeedQuality",0)
		end
	end)
end)
