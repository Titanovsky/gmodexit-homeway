
AddCSLuaFile()
DEFINE_BASECLASS( "base_anim" )

ENT.Base = "sent_base_gonzo"
ENT.PrintName		= "Water supply"
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
		self:SetModel( "models/props_c17/canister01a.mdl" )
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

function ENT:Touch(entity)
	if(entity:GetClass() == "sent_water_pot" && entity:GetNWInt("Water",250) < 250 && entity:GetNWBool("Shower",false)) then
		entity:SetNWInt("Water",300)
		entity:EmitSound("buttons/button1.wav")
		self:SetNWInt("Charges",self:GetNWInt("Charges",3)-1)
		if(self:GetNWInt("Charges",0) <= 0) then
			self:Remove()
		end
	end
end
