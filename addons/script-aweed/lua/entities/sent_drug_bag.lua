AddCSLuaFile()
DEFINE_BASECLASS( "base_anim" )

ENT.Base = "sent_base_gonzo"
ENT.Size = Vector(0,30,30)
ENT.PrintName		= "Drug Bag"
ENT.Author			= "Gonzo"
ENT.Spawnable 		= false
ENT.Category		= "Drugs"
ENT.AdminOnly 		= true

ENT.Level = 1

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
		self:SetModel( "models/gonzo/weedb/bag/bag.mdl" )
		self:PhysicsInit( SOLID_VPHYSICS )      -- Make us work with physics,
		self:SetMoveType( MOVETYPE_VPHYSICS )   -- after all, gmod is a physics
		self:SetSolid( SOLID_VPHYSICS )         -- Toolbox

	    local phys = self:GetPhysicsObject()
		if (phys:IsValid()) then
			phys:Wake()
		end

		self:SetNWInt("Quality",math.random(1,100))
		self:GetNWInt("Consumable",1)
	end
end

function ENT:Use(act)

	local am = self:GetNWInt("Consumable",1)*WEED_CONFIG.VialAmount+(self.Level-1)*(WEED_CONFIG.VialAmount*3)
	local om = act:GetNWInt("WeedAmmount",0)
	local ql = act:GetNWInt("WeedQuality",0)

	act:SetNWInt("WeedAmmount",act:GetNWInt("WeedAmmount",0)+am)

	if(act:GetNWInt("WeedQuality",0) == 0) then
		act:SetNWInt("WeedQuality",self:GetNWInt("Quality"))
	else
		act:SetNWInt("WeedQuality",math.Clamp((act:GetNWInt("WeedQuality")+self:GetNWInt("Quality"))/2,0,100))
	end

	self:Remove()

end

ENT.Touched = false
ENT.NLevel = 0

function ENT:Touch(ent)
	if(ent:GetClass() == self:GetClass() && self:GetNWInt("Consumable",1) >= ent:GetNWInt("Consumable",1) && self.Level == ent.Level && !self.Touched && self.NLevel < CurTime() && self.Level != 3) then
		ent.Touched = true
		self.NLevel = CurTime() + 0.1
		self:SetNWInt("Consumable",ent:GetNWInt("Consumable",1)+self:GetNWInt("Consumable",1))
		ent:Remove()
		if(self:GetNWInt("Consumable",1) >= 3) then
      		self.Level = self.Level + 1
      		self:SetNWInt("Quality",(self:GetNWInt("Quality")+ent:GetNWInt("Quality"))/2)
      		self:SetNWInt("Consumable",1)
      		if(self.Level == 2) then
        		self:SetModel( "models/gonzo/weedb/bag/jar.mdl" )
      		else
        		self:SetModel( "models/gonzo/weedb/bag/brick.mdl" )
      		end
      		self:PhysicsInit( SOLID_VPHYSICS )
      		self:SetMoveType( MOVETYPE_VPHYSICS )
      		self:SetSolid( SOLID_VPHYSICS )
      		self:SetNWString("PrintName","Weed - "..self:GetNWInt("Quality",0).."%")
		end
	end
end
