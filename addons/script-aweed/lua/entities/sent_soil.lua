
AddCSLuaFile()
DEFINE_BASECLASS( "base_anim" )

ENT.Base = "sent_base_gonzo"
ENT.PrintName		= "Weed Soil"
ENT.Author			= "Gonzo"
ENT.Spawnable 		= false
ENT.Category		= "Drugs"
ENT.AdminOnly 		= true
ENT.Size = Vector(20,30,30)

ENT.Soil = 1;

function ENT:SpawnFunction( ply, tr, ClassName )

	if ( !tr.Hit ) then return end

	local SpawnPos = tr.HitPos

	local ent = ents.Create( ClassName )
	ent:SetPos( SpawnPos )
	ent:Spawn()
	ent:Activate()
	ent.Owner = ply

	return ent

end

function ENT:Initialize()

 	if SERVER then
		self:SetModel( "models/gonzo/weedb/Soil_bag.mdl" )
		self:PhysicsInit( SOLID_VPHYSICS )
		self:SetMoveType( MOVETYPE_VPHYSICS )
		self:SetSolid( SOLID_VPHYSICS )
		self:SetNWInt("Charges",3)

	  local phys = self:GetPhysicsObject()
		if (phys:IsValid()) then
			phys:Wake()
		end
	end
end

ENT.Waterizer = 0
ENT.Extra = 0

function ENT:SetSoil(x)
	self:SetSkin(x-1)
	if(x==1) then
		self.Waterizer = 0
		self.Extra = 0
	elseif(x==2) then
		self.Waterizer = -30
		self.Extra = 5
		self:SetNWString("PrintName","Acid Soil")
	elseif(x==3) then
		self.Waterizer = 100
		self.Extra = -2
		self:SetNWString("PrintName","Dank Soil")
	end
end

function ENT:Touch(entity)
	if(entity:GetClass() == "sent_pot" && (entity:GetNWInt("Soil",0) == 0) && (!entity:GetNWBool("MultiplePot",false) || (entity:GetNWBool("MultiplePot",false) && self:GetNWInt("Charges",3) == 3))) then
		entity:SetBodygroup(1,1)
		entity:SetNWInt("Soil",self.Soil)
		entity:SetNWInt("MaxWater",entity:GetNWInt("MaxWater",100)+self.Waterizer)
		entity:SetNWInt("Extra",entity:GetNWInt("Extra",0)+self.Extra)
		self:SetNWInt("Charges",self:GetNWInt("Charges",3)-Either(entity:GetNWBool("MultiplePot",false),3,1))
		if(self:GetNWInt("Charges",0) <= 0) then
			self:Remove()
		end
	end
end

function ENT:Use(act)

end

function ENT:Think()
	if SERVER then

	end
end
