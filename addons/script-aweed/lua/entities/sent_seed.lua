AddCSLuaFile()
DEFINE_BASECLASS( "base_anim" )

ENT.Base = "sent_base_gonzo"

ENT.PrintName		= "Seed"
ENT.Author			= "Gonzo"
ENT.Category		= "Drugs"
ENT.Spawnable 		= false
ENT.AdminOnly 		= false

ENT.Seed = 1

function ENT:Initialize()

 	if SERVER then
		self:SetModel( "models/props_junk/watermelon01.mdl" )
        self:SetModelScale(0.6,0)
		self:PhysicsInit( SOLID_VPHYSICS )      -- Make us work with physics,
		self:SetMoveType( MOVETYPE_VPHYSICS )   -- after all, gmod is a physics
		self:SetSolid( SOLID_VPHYSICS )         -- Toolbox
        self:SetMaterial("models/gonzo/weed/weed")
	 	self:SetHealth(99999)
	 	self:SetColor(Color(75,75,75))

	    local phys = self:GetPhysicsObject()
		if (phys:IsValid()) then
			phys:Wake()
		end
	end
end

ENT.Waterizer = 0
ENT.Extra = 0

function ENT:SetSeed(x)
	self:SetColor(Color(150,150,150))
	if(x==1) then
		self.Waterizer = 0
		self.Extra = 0
    self.Quality = 50
    self:SetNWString("PrintName","Amnesia Haze")
	elseif(x==2) then
		self.Waterizer = -30
		self.Extra = 2
    self:SetColor(Color(255,175,75))
    self.Quality = 75
    self:SetNWString("PrintName","Bubble Kush")
	elseif(x==3) then
		self.Waterizer = 30
		self.Extra = -5
    self.Quality = 100
    self:SetColor(Color(75,150,75))
    self:SetNWString("PrintName","O.G. Kush")
  elseif(x==4) then
    self.Waterizer = -40
    self.Extra = 5
    self.Quality = 35
    self:SetColor(Color(255,75,255))
    self:SetNWString("PrintName","Haze Berry")
	end
end
