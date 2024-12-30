
---------------------------------------------------------------
------ Model & Design by: Zerochain | Coding by : Zerochain ---
---------------------------------------------------------------



AddCSLuaFile()

ENT.Spawnable           =  true
ENT.AdminSpawnable      =  true
ENT.Type                 = "anim"
ENT.Base                 = "mortar_box_base"
ENT.PrintName             = "Mortar Box Pumbkin Blaster"
ENT.Author							 = "ClemensProduction aka Zerochain"
ENT.Information						 = "Full of Boom"
ENT.Category						 = "Halloween Stuff"
ENT.Skin                  ="0"
ENT.BodyGroup             ="1"
ENT.MortarType            = "mortar_pumbkinblaster"
ENT.BoxModel              ="models/zerochain/props_firework/fireworkbox_01.mdl"

-----------------------------------------------------------]]
function ENT:SpawnFunction( ply, tr )
     if ( !tr.Hit ) then return end
     local ent = ents.Create(self.ClassName)
	   ent:SetPhysicsAttacker(ply)
     ent:SetPos( tr.HitPos + tr.HitNormal * 10 )
     ent:Spawn()
     ent:Activate()
     return ent
end
-----------------------------------------------------------]]



-----------------------------------------------------------]]
function ENT:Initialize()
 	if (SERVER) then
	     self:SetModel(self.BoxModel)
       self.Entity:SetSkin( self.Skin )
       self.Entity:SetBodyGroups(self.BodyGroup )
		 self:PhysicsInit( SOLID_VPHYSICS )
		 self:SetSolid( SOLID_VPHYSICS )
		 self:SetMoveType( MOVETYPE_VPHYSICS )

		 local phys = self:GetPhysicsObject()
		 if (phys:IsValid()) then
			 phys:Wake()
	   end
	end
end
-----------------------------------------------------------]]
