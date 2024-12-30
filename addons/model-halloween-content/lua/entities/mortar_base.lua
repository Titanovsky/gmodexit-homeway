
---------------------------------------------------------------
------ Model & Design by: Zerochain | Coding by : Zerochain ---
---------------------------------------------------------------

AddCSLuaFile()

DEFINE_BASECLASS( "base_anim" )
ENT.Spawnable		            	     =  false
ENT.AdminSpawnable		             =  false
ENT.Type							             = "anim"
ENT.PrintName		                   = "Name"
ENT.Author					          		 = "ClemensProduction aka Zerochain"
ENT.Information					         	 = "Info"
ENT.Category					           	 = "Halloween Stuff"


ENT.Model                            =  "models/zerochain/props_halloween/mortar_single01.mdl"
ENT.Skin              							 =	""
ENT.FuseEffect    	         				 =  "fuse01"
ENT.BurstEffect                      =  "mortar_burst"
ENT.Effect                           =  ""
ENT.ExplosionSound                   =  ""
ENT.LaunchSound                      =  "fireworks/mortar_fire.wav"
ENT.LitSound                 		     =  "fireworks/fuse.wav"

ENT.Life                             =  0
ENT.FuseTime                         =  0




-----------------------------------------------------------]]
function ENT:Initialize()
  if (SERVER) then
    self:SetModel( self.Model )
    self.Entity:SetModelScale(1)

    self.Entity:SetSkin( self.Skin )
    self.Entity:SetBodyGroups("0")

    self.Entity:PhysicsInit( SOLID_VPHYSICS )
    self.Entity:SetMoveType( MOVETYPE_VPHYSICS )
    self.Entity:SetSolid( SOLID_VPHYSICS )


    local phys = self:GetPhysicsObject()
    if (phys:IsValid()) then
      phys:Wake()
      phys:EnableMotion(false)
    end


    self.Ignited = false
    self.Used     = false
    self.FireReady = false
    self:Arm()

    if !(WireAddon == nil) then
      self.Inputs   = Wire_CreateInputs(self, { "Ignite" ,"Launch"})
    end
  end
end
-----------------------------------------------------------]]



-----------------------------------------------------------]]
function ENT:Arm()
	timer.Simple( 0.5, function()  self.FireReady = true end )
end
-----------------------------------------------------------]]



-----------------------------------------------------------]]
function ENT:BodyGroupState()

  local IsConnected = false
  if self.Inputs then
    for portname,input in pairs(self.Inputs) do
      if IsConnected == true then
        IsConnected = true
      else
        IsConnected = IsValid(input.Src)
      end
    end
  end
  if(self.Used) then
    self.Entity:SetBodyGroups("1")
  else
    self.Entity:SetBodyGroups((IsConnected and !self.Ignited) and "2" or "0")
  end
end
-----------------------------------------------------------]]



-----------------------------------------------------------]]
function ENT:TriggerInput(iname, value)
    if (iname == "Ignite") then
        if (value > 0) then
            if (!self.Ignited && self.FireReady) then
                  timer.Simple(0.01, function() self:Ignition() end)
            end
        end
    end

    if (iname == "Launch") then
        if (value > 0) then
            if (!self.Ignited && self.FireReady) then
                timer.Simple(0.01, function() self:Launch() end)
            end
        end
    end
end
-----------------------------------------------------------]]



-----------------------------------------------------------]]
function ENT:Use( activator)
  if(CLIENT and !game.SinglePlayer()) then return end
  if(!self.FireReady)then return end
  if(self.Used) then return end
  if(self:IsValid()) then
    if(GetConVar("hcp_easyuse"):GetInt() >= 1) then
      if(!self.Ignited) then
        if(!self.Used) then
          if(activator:IsPlayer()) then
            self:Ignition()
          end
        end
      end
    end
  end
end
-----------------------------------------------------------]]



-----------------------------------------------------------]]
function ENT:Ignition()
  if(!self:IsValid()) then return end
  if(self.Used) then return end
  if(self.Ignited) then return end
  self.Ignited = true
  if !(WireAddon == nil) then WireLib.Remove(self,false) end
  --self:SetBodyGroups("0")
  sound.Play( self.LitSound, self:GetPos(), 75, 100,1)
  timer.Simple(0.01,function() ParticleEffectAttach(self.FuseEffect,PATTACH_POINT_FOLLOW,self,1) end)

  if(GetConVar("hcp_autounfrezze"):GetBool()) then
    local phys = self:GetPhysicsObject()
    if (phys:IsValid()) then
      phys:Wake()
      phys:EnableMotion(true)
    end

  end



  timer.Simple( self.FuseTime, function()
    if (self:IsValid()) then
      self:StopParticles()
      self:Launch()
    end
  end )



end
-----------------------------------------------------------]]



-----------------------------------------------------------]]
function ENT:Launch()
  if(!self:IsValid()) then return end
	if(self.Used) then return end
  if !(WireAddon == nil) then WireLib.Remove(self,false) end
	self.Used = true
	self.Ignited = true
  self.Entity:SetBodyGroups("1")
	sound.Play( self.LaunchSound, self:GetPos(), 75, 100,1)
	timer.Simple(0.01,function() ParticleEffectAttach(self.Effect,PATTACH_POINT_FOLLOW,self,2) end)
	timer.Simple(0.01,function() ParticleEffectAttach(self.BurstEffect,PATTACH_POINT_FOLLOW,self,2) end)
  if(GetConVar("hcp_recoil"):GetBool()) then
    self:BurstForce()
  end
	if(GetConVar("hcp_autoremove"):GetBool()) then
		timer.Simple( 3, function()  if (self:IsValid()) then self:Remove() end  end )
	end
end
-----------------------------------------------------------]]



-----------------------------------------------------------]]
function ENT:OnTakeDamage(dmginfo)
	 if !self:IsValid() then return end

     self:TakePhysicsDamage(dmginfo)
	 local phys = self:GetPhysicsObject()

	 if(GetConVar("hcp_fragility"):GetBool()) then
	     if(!self.Used && !self.Ignited) then
	         self:Ignition()
	     end
	 end

	 if(self.Used && self.Ignited) then
	 	self:Remove()
	 end

end
-----------------------------------------------------------]]



-----------------------------------------------------------]]
function ENT:BurstForce()
	local phys = self:GetPhysicsObject()
  if phys:IsValid() then
	  phys:ApplyForceCenter( phys:GetMass() * self:GetUp() * -600)
  end
end
-----------------------------------------------------------]]



-----------------------------------------------------------]]
function ENT:OnRemove()
	self:StopParticles()
	self:StopSound(self.ExplosionSound)
	self:StopSound(self.LaunchSound)
	self:StopSound(self.LitSound)
end
-----------------------------------------------------------]]



-----------------------------------------------------------]]
if ( CLIENT ) then
function ENT:Draw()
	self:DrawModel()
	if !(WireAddon == nil) then Wire_Render(self.Entity) end
end
end
-----------------------------------------------------------]]



-----------------------------------------------------------]]
function ENT:OnRestore()
     Wire_Restored(self.Entity)
end
-----------------------------------------------------------]]



-----------------------------------------------------------]]
function ENT:BuildDupeInfo()
     return WireLib.BuildDupeInfo(self.Entity)
end
-----------------------------------------------------------]]



-----------------------------------------------------------]]
function ENT:ApplyDupeInfo(ply, ent, info, GetEntByID)
     WireLib.ApplyDupeInfo( ply, ent, info, GetEntByID )
end
-----------------------------------------------------------]]



-----------------------------------------------------------]]
function ENT:PreEntityCopy()
     local DupeInfo = self:BuildDupeInfo()
     if(DupeInfo) then
         duplicator.StoreEntityModifier(self,"WireDupeInfo",DupeInfo)
     end
end
-----------------------------------------------------------]]



-----------------------------------------------------------]]
function ENT:PostEntityPaste(Player,Ent,CreatedEntities)
     if(Ent.EntityMods and Ent.EntityMods.WireDupeInfo) then
         Ent:ApplyDupeInfo(Player, Ent, Ent.EntityMods.WireDupeInfo, function(id) return CreatedEntities[id] end)
     end
end
-----------------------------------------------------------]]
