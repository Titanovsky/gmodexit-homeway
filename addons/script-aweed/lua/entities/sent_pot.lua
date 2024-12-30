AddCSLuaFile()
DEFINE_BASECLASS( "base_anim" )

ENT.Base = "sent_base_gonzo"
ENT.Size = Vector(0,30,30)
ENT.PrintName		= "Pot"
ENT.Author			= "Gonzo"
ENT.Spawnable 		= false
ENT.Category		= "Drugs"
ENT.AdminOnly 		= true

local function IsLookingAt( a, b, nor, dis, targetVec )
	return nor:Dot( (a:GetPos() - b:GetPos()) ) / (a:GetPos() - b:GetPos()):Length() < -1.8
end

function ENT:SpawnFunction( ply, tr, ClassName )

	if ( !tr.Hit ) then return end

	local SpawnPos = tr.HitPos

	local ent = ents.Create( ClassName )
	ent:SetPos( SpawnPos )
	ent:Spawn()
	ent:Activate()
	ent:SetPersistent()
	ent.Owner = ply

	return ent

end

function ENT:Initialize()

 	if SERVER then
		self:SetModel( "models/gonzo/weedb/pot1.mdl" )
		self:PhysicsInit( SOLID_VPHYSICS )      -- Make us work with physics,
		self:SetMoveType( MOVETYPE_VPHYSICS )   -- after all, gmod is a physics
		self:SetSolid( SOLID_VPHYSICS )         -- Toolbox

		local phys = self:GetPhysicsObject()
		if (phys:IsValid()) then
			phys:Wake()
		end

		self:SetHealth(0)
		self:SetNWInt("Water",0)
		self:SetNWInt("Light",0)
		self:SetNWInt("Seed",0)
		self:SetNWInt("Level",1)
		self:SetNWInt("Percent",0)
		self:SetNWInt("Quality",0)

	end
end

function ENT:SetPot(x)

	self:SetModel( "models/gonzo/weedb/pot"..x..".mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )

	local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
	end

	if(x==1) then
		self:SetNWInt("MaxWater",90)
		self:SetNWInt("Extra",0)
	end
	if(x==2) then
		self:SetNWInt("MaxWater",100)
		self:SetNWInt("Extra",1)
	end
	if(x==3) then
		self:SetNWInt("MaxWater",140)
		self:SetNWInt("Extra",3)
	end
	if(x==4) then
		self:SetNWInt("MaxWater",100)
		self:SetNWInt("Extra",2)
		self:SetNWBool("MultiplePot",true)
	end

end

if SERVER then
	util.AddNetworkString("ReloadShadow")
end

ENT.OldSeed = 0
ENT.SeedWater = 0
ENT.SeedEx = 0
ENT.NSeed = 0

function ENT:Touch(entity)
	if(self:GetNWInt("Soil",0) > 0 && self:GetNWInt("Seed",0) == 0 && entity:GetClass() == "sent_seed" && !self:GetNWBool("MultiplePot",false)) then
		self:SetNWInt("Quality",entity.Quality)
		self:SetNWInt("Seed",1)
		self:SetNWInt("Water",50)
		self:SetHealth(100)
		self:SetNWInt("Level",1)
		self:SetNWInt("Progress",1)

		self:SetNWString("seedName", entity:GetNWString("PrintName"));
		entity:Remove()

		local ent = ents.Create("prop_dynamic")
		ent:SetModel("models/gonzo/weed_shared.mdl")
		ent:SetPos(self:GetPos() + self:GetUp()*16)
		ent:SetAngles(self:GetAngles())
		ent:Spawn()
		ent:SetParent(self)
		self:SetNWEntity("WeedGhost",ent)
		self.Weed = ent

		if(entity:GetClass() != "sent_seed") then
			self:SetNWInt("MaxWater",self:GetNWInt("MaxWater",100)+entity.Waterizer)
			self:SetNWInt("Extra",self:GetNWInt("Extra",100)+entity.Extra)
		else
			self:SetNWInt("MaxWater",self:GetNWInt("MaxWater",100)+entity.Waterizer)
			self:SetNWInt("Extra",self:GetNWInt("Extra",100)+entity.Extra)
			self.SeedWater = entity.Waterizer
			self.SeedEx = entity.Extra
		end
	end

	if(self.NSeed < CurTime() && self:GetNWInt("Soil",0) > 0 && entity:GetClass() == "sent_seed" && self:GetNWBool("MultiplePot",false) && self:GetNWInt("Seed",0) < 3) then
		self.NSeed = CurTime()+1
		if(self:GetNWInt("Seed",0) == 0) then
			self:SetNWInt("Quality",entity.Quality)
			self:SetNWInt("MaxWater",self:GetNWInt("MaxWater",100)+entity.Waterizer)
			self:SetNWInt("Extra",self:GetNWInt("Extra",100)+entity.Extra)
			self.SeedWater = entity.Waterizer
			self.SeedEx = entity.Extra
			entity:Remove()
			self:SetNWInt("Seed",self:GetNWInt("Seed",0)+1)
		elseif(entity.Waterizer == self.SeedWater && entity.Extra == self.SeedEx && self:GetNWInt("Seed",0) != 3) then
			self:SetNWString("seedName", entity:GetNWString("PrintName"));
			entity:Remove()
			self:SetNWInt("Seed",self:GetNWInt("Seed",0)+1)
			if(self:GetNWInt("Seed",0)==3) then
				self:SetNWInt("Water",50)
				self:SetNWInt("Level",1)
				self:SetNWInt("Progress",1)
				self:SetHealth(50)
				self.Weed = {}
				for k=1,3 do
					local ent = ents.Create("prop_dynamic")
					ent:SetModel("models/gonzo/weed_shared.mdl")
					ent:SetPos(self:GetPos() + self:GetUp()*24 - self:GetRight()*38*2 + self:GetRight()*k*38)
					ent:SetAngles(self:GetAngles())
					ent:Spawn()
					ent:SetParent(self)
					self.Weed[k] = ent
				end
				self:SetNWEntity("WeedGhostA",self.Weed[1])
				self:SetNWEntity("WeedGhostB",self.Weed[2])
				self:SetNWEntity("WeedGhostC",self.Weed[3])
			end
		end
	end
end


// XP boost in % depending on seed type.
local seedXPBonus = {
	["Haze Berry"] 	= 20,
	["Amnesia Haze"] 	= 40,
	["Bubble Kush"] 	= 60,
	["O.G. Kush"]	= 80
}

function ENT:Use(act)
	if(self:GetNWInt("Level",0) >= 7) then
		self:SetNWInt("Seed",0)
		self:SetNWInt("Progress",0)
		self:SetNWInt("Level",0)
		-- If you change your mind later...
		act.notificationType = { "Harvested Weed", ""}

		if(act.addEXP) then
			local xp = Either(self:GetNWBool("MultiplePot",false),5000,1500)
			xp = xp * ((seedXPBonus[self:GetNWString("seedName","Quick Seed")] or 20) / 100 + 1) // adds x% based on seed type.
			act:addEXP( xp );
		end

		if(!self:GetNWBool("MultiplePot",false)) then
			self.Weed:Remove()
			local ent = ents.Create("sent_drug_bag")
			ent:SetPos(self:GetPos() + Vector(0,0,64))
			ent:Spawn()
			ent:SetNWInt("Quality",self:GetNWInt("Quality",0))
			ent:SetNWString("PrintName","Weed - "..self:GetNWInt("Quality",0).."%")
		else
			for k,v in pairs(self.Weed) do
				local ent = ents.Create("sent_drug_bag")
				ent:SetPos(self:GetPos() + Vector(0,0,64) - self:GetRight()*38*2 + self:GetRight()*k*38)
				ent:Spawn()
				ent:SetNWInt("Quality",self:GetNWInt("Quality",0))
				ent:SetNWString("PrintName","Weed - "..self:GetNWInt("Quality",0).."%")
				v:Remove()
			end
		end

		self:SetNWInt("MaxWater",self:GetNWInt("MaxWater",100)-self.SeedWater)
		self:SetNWInt("Extra",self:GetNWInt("Extra",100)-self.SeedEx)
		self.SeedWater = 0
		self.SeedEx = 0

	end
end

function ENT:Think()
	if SERVER then
		local a = self:GetNWInt("Seed",0) > 0 && !self:GetNWBool("MultiplePot",false)
		local b = self:GetNWBool("MultiplePot",false) && self:GetNWInt("Seed",0)==3
		if((a || b)&& self:GetNWInt("Level",0) < 7) then

			if(!WEED_CONFIG.Demo) then
				if(WEED_CONFIG.WaterLossChance >= math.random(1,100) && (self.Watered or 0) <= CurTime()) then
					local m = math.random(WEED_CONFIG.WaterLoss[1],WEED_CONFIG.WaterLoss[2])
					self:SetNWInt("Water",math.Clamp(self:GetNWInt("Water",0)-m,0,self:GetNWInt("MaxWater",100)))
				end

				if(self:GetNWInt("Water",0) < self:GetNWInt("MaxWater",100)*0.25) then
					self:SetHealth(self:Health()-3-(self:GetNWInt("Water",0)/self:GetNWInt("MaxWater",100)*0.25)*3)
				end
				if(self:GetNWInt("Light",0) < 40) then
					self:SetHealth(self:Health()-2-(self:GetNWInt("Light",0)/50)*2.5)
				end
			end

			if(WEED_CONFIG.Demo) then
				self:SetNWInt("Progress",self:GetNWInt("Progress",0)+50)
			else
				self:SetNWInt("Progress",self:GetNWInt("Progress",0)+math.random(1,5)+math.max(0,self:GetNWInt("Extra",1)))
			end

			if(self:GetNWInt("Progress",0) >= 100) then
				self:SetNWInt("Progress",0)
				self:SetNWInt("Level",self:GetNWInt("Level",0)+1)
				self:SetNWInt("Water",math.max(self:GetNWInt("Water"),self:GetNWInt("MaxWater",100)*0.5))
				if(!istable(self.Weed)) then
					self.Weed:SetBodygroup(1,math.Clamp(self:GetNWInt("Level",1),0,7)-1)
				else
					for k,v in pairs(self.Weed) do
						v:SetBodygroup(1,math.Clamp(self:GetNWInt("Level",1),0,7)-1)
					end
				end

			end

			self.Machine = nil

			for k,v in pairs(ents.FindByClass("sent_light")) do
				if(!(v.IsRadial or false)) then
					local a = IsLookingAt(v,self,v:GetForward() + v:GetForward(),-172)
					if(v:GetPos():Distance(self:GetPos()) < 192 && a && self:GetNWFloat("Light",0) < 100 && v:GetNWInt("Charge",0) > 0 && v:GetNWBool("On",false)) then
						self.Machine = v
					end
				elseif(v:GetPos():Distance(self:GetPos()) < 192/2 && self:GetNWFloat("Light",0) < 100 && v:GetNWInt("Charge",0) > 0 && v:GetNWBool("On",false)) then
					self.Machine = v
				end
			end
			//76561198011794778
			if(IsValid(self.Machine)) then
				self:SetNWInt("Light",math.Clamp(self:GetNWInt("Light",0)+(20-self.Machine:GetPos():Distance(self:GetPos())/14.2),0,100))
			else
				self:SetNWInt("Light",math.Clamp(self:GetNWInt("Light",0)-10,0,100))
			end

			if(self:Health() <= 0) then
				self:SetNWInt("Seed",0)
				self:SetNWInt("Progress",0)
				self:SetNWInt("Level",0)
				if(isentity(self.Weed)) then
					self.Weed:Remove()
				elseif(istable(self.Weed)) then
					for k,v in pairs(self.Weed) do
						v:Remove()
					end
				end

				MsgN("YOU DIED "..self:GetNWInt("Light",100))

				self:SetNWInt("MaxWater",self:GetNWInt("MaxWater",100)-self.SeedWater)
				self:SetNWInt("Extra",self:GetNWInt("Extra",100)-self.SeedEx)
				self.SeedWater = 0
				self.SeedEx = 0
			end

		end

		self:NextThink( CurTime() + math.random(1,3) )

		return true
	end
end

if CLIENT then

function ENT:PostDraw()
	if(!self:GetNWBool("MultiplePot",false) && IsValid(self:GetNWEntity("WeedGhost"))) then
		prop = self:GetNWEntity("WeedGhost")
		mat = Matrix()
		mat:Scale( Vector(1,1,1)*(self:GetNWInt("Level",0)/7+(self:GetNWInt("Progress")/100)*(1/7))*1.2 )
		prop:EnableMatrix( "RenderMultiply", mat )
	elseif(IsValid(self:GetNWEntity("WeedGhostA"))) then
		for k=1,3 do
			prop = self:GetNWEntity("WeedGhost"..Either(k==1,"A",Either(k==2,"B","C")))
			mat = Matrix()
			mat:Scale( Vector(1,1,1)*(self:GetNWInt("Level",0)/7+(self:GetNWInt("Progress")/100)*(1/7))*1.2 )
			prop:EnableMatrix( "RenderMultiply", mat )
		end
	end
end

local water = surface.GetTextureID("gui/water")
local light = surface.GetTextureID("gui/light")

local emotes = {"dead","bad","neutral","regular","happy"}
local hl = {Color(231, 76, 60),Color(230, 126, 34),Color(241, 196, 15),Color(46, 204, 113)}
local em_tex = {}
for k,v in pairs(emotes) do
	em_tex[k] = surface.GetTextureID("gui/"..v)
end

local rope = Material("gui/rope")
local triangle = {}
local a,b,c,d,ang

function surface.DrawTexturedRectUVRotated(px,py,pw,ph,pu,pv,eu,ev,rot)

	ang = Angle(0,rot,0)
	a = Vector(-pw/2,-ph/2,0)
	a:Rotate(ang)
	b = Vector(pw/2,-ph/2,0)
	b:Rotate(ang)
	c = Vector(pw/2,ph/2,0)
	c:Rotate(ang)
	d = Vector(-pw/2,ph/2,0)
	d:Rotate(ang)

	triangle[1] = {x=px+a.x,y=py+a.y,u=pu,v=pv}
	triangle[2] = {x=px+b.x,y=py+b.y,u=eu,v=pv}
	triangle[3] = {x=px+c.x,y=py+c.y,u=eu,v=ev}
	triangle[4] = {x=px+d.x,y=py+d.y,u=pu,v=ev}

	surface.DrawPoly(triangle)

end

function ENT:DoInfo(pos)
  surface.SetDrawColor(50,50,50,150)
  surface.DrawRect(16,-64,272,128+16)

	surface.SetTexture(water)
	surface.SetDrawColor(hl[math.Clamp(math.ceil((self:GetNWInt("Water",0))/25)+1,1,4)])
	surface.DrawTexturedRect(30,0,64,64)

	surface.SetTexture(light)
	surface.SetDrawColor(hl[math.Clamp(math.ceil((self:GetNWInt("Light",0))/33)+1,1,4)])
	surface.DrawTexturedRect(214,0,64,64)

	if((self:GetNWBool("MultiplePot",false) && self:GetNWInt("Seed",0) >= 3) || (!self:GetNWBool("MultiplePot",false) && self:GetNWInt("Seed",0) > 0) && self:GetNWInt("Level",0) < 7) then
		for k,v in pairs(em_tex) do
			surface.SetTexture(v)
			surface.SetDrawColor(255,255,255,Either(math.ceil((self:Health())/25)+1==(k) or (k==1&&self:Health()==0),255,25))
			surface.DrawTexturedRect(-20+50*k,-52,48,48)
		end
	else
		if(self:GetNWInt("Level",0) < 7) then
			if(self:GetNWInt("Soil",0) > 0) then
				draw.SimpleTextOutlined(Either(self:GetNWBool("MultiplePot",false),"("..(3-self:GetNWInt("Seed",0))..") ","").."Seed me","MainWeedFont",152,-28,Color(255,150,50,250),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER,1,Color(75,75,75))
			else
				draw.SimpleTextOutlined("Soil me","MainWeedFont",152,-28,Color(255,150,50,250),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER,1,Color(75,75,75))
			end
		else
			draw.SimpleTextOutlined("Prepare me","MainWeedFont",152,-28,Color(100,255,50,250),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER,1,Color(75,75,75))
		end
	end
	//76561198011794778
	draw.SimpleTextOutlined("%"..self:GetNWInt("Progress",100),"MainWeedFont",152,32,Color(255,255,255,100),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER,1,Color(75,75,75))
	//draw.SimpleTextOutlined("HP "..self:Health().." Water "..self:GetNWInt("Water"),"MainWeedFont",152,-128,Color(255,255,255,100),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER,1,Color(75,75,75))

	surface.SetMaterial(rope)
	surface.SetDrawColor(255,255,255,255)
	surface.DrawTexturedRectUV( 14, -64, 8, 128+16, 0, 0, 1, 1 )

	surface.DrawTexturedRectUVRotated(153, -68, 8, 278, 0, 0, 1, 2 ,90)
	surface.DrawTexturedRectUVRotated(14+270+4, 0, 8, 128+16, 0, 0, 1, 1 ,180)
	surface.DrawTexturedRectUVRotated(153, 80, 8, 278, 0, 0, 1, 2 ,270)
end

end
