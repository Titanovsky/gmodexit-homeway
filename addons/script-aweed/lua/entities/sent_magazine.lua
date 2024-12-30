AddCSLuaFile()
DEFINE_BASECLASS( "base_anim" )

ENT.Base = "sent_base_gonzo"

if SERVER then
  util.AddNetworkString("ShowManual")
end

ENT.Size = Vector(5,20,20)
ENT.PrintName		= "Drug Magazine"
ENT.Author			= "Gonzo"
ENT.Category		= "Drugs"
ENT.Spawnable 		= false
ENT.AdminOnly 		= false

ENT.Seed = 1

function ENT:Initialize()

 	if SERVER then
		self:SetModel( "models/props_lab/bindergreenlabel.mdl" )
		self:PhysicsInit( SOLID_VPHYSICS )      -- Make us work with physics,
		self:SetMoveType( MOVETYPE_VPHYSICS )   -- after all, gmod is a physics
		self:SetSolid( SOLID_VPHYSICS )         -- Toolbox
	 	self:SetModelScale(1,0)
    self:SetUseType(SIMPLE_USE)
	    local phys = self:GetPhysicsObject()
		if (phys:IsValid()) then
			phys:Wake()
		end
	end
end

function ENT:Use(act)
  if(SERVER) then
    net.Start("ShowManual")
    net.Send(act)
  end
end
