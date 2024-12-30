
---------------------------------------------------------------
------ Model & Design by: Zerochain | Coding by : Zerochain ---
---------------------------------------------------------------



AddCSLuaFile()
DEFINE_BASECLASS( "mortar_base" )

ENT.Spawnable		            	 =  true
ENT.AdminSpawnable		             =  true
ENT.Type							 = "anim"
ENT.Base							 = "mortar_base"
ENT.PrintName		                 = "Demon Fuzz"
ENT.Author							 = "ClemensProduction aka Zerochain"
ENT.Information						 = "Makes Boom"
ENT.Category						 = "Halloween Stuff"


ENT.Model                            =  "models/zerochain/props_firework/mortartube_retail_01.mdl"
ENT.Skin							       =	"2"
ENT.FuseEffect    					      =  "fuse01"
ENT.BurstEffect                      =  "mortar_burst"
ENT.Effect                           =  "mortar_burst_halloween_demon"
ENT.ExplosionSound                   =  ""
ENT.LaunchSound                      =  "fireworks/mortar_fire.wav"
ENT.LitSound                 		 =  "fireworks/fuse.wav"

ENT.Life                             =  2
ENT.FuseTime                         =  3



function ENT:SpawnFunction( ply, tr )
     if ( !tr.Hit ) then return end
     local ent = ents.Create( self.ClassName )
	 ent:SetPhysicsAttacker(ply)
     ent:SetPos( tr.HitPos + tr.HitNormal * 10 )
     ent:Spawn()
     ent:Activate()
     return ent
end

/*
function ENT:Initialize()
 	if (SERVER) then
	     self:SetModel(self.Model)
	     self.Entity:SetSkin( self.Skin )
		 self:PhysicsInit( SOLID_VPHYSICS )
		 self:SetSolid( SOLID_VPHYSICS )
		 self:SetMoveType( MOVETYPE_VPHYSICS )

		 local phys = self:GetPhysicsObject()
		 if (phys:IsValid()) then
			 phys:Wake()
			 phys:EnableMotion(false)
	     end

		self.Ingnited = false
		self.Used     = false
		self.FireReady = false
		self:Arm()
		if !(WireAddon == nil) then self.Inputs   = Wire_CreateInputs(self, { "Ignite" }) end
	end
end
*/
