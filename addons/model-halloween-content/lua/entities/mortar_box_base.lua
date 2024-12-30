
---------------------------------------------------------------
------ Model & Design by: Zerochain | Coding by : Zerochain ---
---------------------------------------------------------------



AddCSLuaFile()
DEFINE_BASECLASS( "base_gmodentity" )

ENT.Spawnable           =  false
ENT.AdminSpawnable      =  false
ENT.Type                 = "anim"
ENT.PrintName             = "Name"
ENT.Author							 = "ClemensProduction aka Zerochain"
ENT.Information						 = "Full of Boom"
ENT.Category						 = "Halloween Stuff"
ENT.Skin                  =""
ENT.BodyGroup             =""
ENT.MortarType            = "mortar_pumbkinblaster"
ENT.BoxModel              ="models/zerochain/props_firework/fireworkbox_01.mdl"




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



-----------------------------------------------------------]]
function ENT:Use( activator, caller )
	self:SpawnFirework(activator)
end
-----------------------------------------------------------]]



-----------------------------------------------------------]]
function ENT:OnTakeDamage(dmginfo)
	 if !self:IsValid() then return end
	 self:SpawnFirework(nil)
end
-----------------------------------------------------------]]



-----------------------------------------------------------]]
function ENT:SpawnFirework(owner)

	local pos = self:GetPos()

	if(owner and IsValid(owner) and owner:IsPlayer())then
    	undo.Create("sent")
    end
	for i = 1, 6 do
		--debugoverlay.BoxAngles(self:GetPos(), Vector(0,0,0), Vector(15,35,15),ang, 25, Color(255,255,255,255) )
		pos = self:GetPos() + self:GetRight() * (i-4) * 10
		self:CreateProp(pos,owner)
	end
	if(owner and IsValid(owner) and owner:IsPlayer())then
		undo.SetPlayer(owner)
		undo.Finish()
	end
	self:Remove()
end
-----------------------------------------------------------]]



-----------------------------------------------------------]]
function ENT:OnRemove()
  local effectdata = EffectData()
	effectdata:SetOrigin( self:GetPos() )
	effectdata:SetStart( Vector(255,255,255) )
	util.Effect( "balloon_pop", effectdata )
end
-----------------------------------------------------------]]


-----------------------------------------------------------]]
function ENT:CreateProp(pos,owner)
	local p = ents.Create(self.MortarType)
  local ang = self:GetAngles()
  ang:RotateAroundAxis(ang:Up(),90)
	p:SetPos(pos)
	p:SetAngles(ang)
	p:SetMoveType(MOVETYPE_VPHYSICS)

	local phys = p:GetPhysicsObject()
		if (phys:IsValid()) then
			phys:Wake()
			phys:EnableMotion( false )
		end
	p:Spawn()
	p:Activate()
	p:DeleteOnRemove(self)
	if(owner and IsValid(owner) and owner:IsPlayer())then
		undo.AddEntity(p)
	end
end
-----------------------------------------------------------]]
