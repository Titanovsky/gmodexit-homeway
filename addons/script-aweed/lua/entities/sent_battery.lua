AddCSLuaFile()
DEFINE_BASECLASS( "base_anim" )

ENT.Base = "sent_base_gonzo"

ENT.Size = Vector(10,10,20)
ENT.PrintName		= "Battery"
ENT.Author			= "Gonzo"
ENT.Category		= "Drugs"
ENT.Spawnable 		= false
ENT.AdminOnly 		= false

function ENT:Initialize()

 	if SERVER then
		self:SetModel( "models/gonzo/weedb/battery.mdl" )
		self:PhysicsInit( SOLID_VPHYSICS )      -- Make us work with physics,
		self:SetMoveType( MOVETYPE_VPHYSICS )   -- after all, gmod is a physics
		self:SetSolid( SOLID_VPHYSICS )         -- Toolbox
    self:SetNWInt("Charge",100)
	    local phys = self:GetPhysicsObject()
		if (phys:IsValid()) then
			phys:Wake()
		end
	end
end

function ENT:SetBattery(x)
  self:SetNWBool("Disposable",Either(x==1,true,false))
end

if CLIENT then

  local rope = Material("gui/rope")
  local water = surface.GetTextureID("gui/light")
  local hl = {Color(231, 76, 60),Color(230, 126, 34),Color(241, 196, 15),Color(46, 204, 113)}
  local x,_ = 0,0;

  function ENT:DoInfo()
    surface.SetDrawColor(50,50,50,150)
    surface.DrawRect(12,-32,math.Clamp(x+48,268,999),128)
    x,_ = draw.SimpleTextOutlined(Either(self:GetNWBool("Disposable",false),"One-Use ","")..self.PrintName,"MainWeedFont",36,-2,Color(255,255,255),TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER,1,Color(75,75,75))
    surface.SetMaterial(rope)
  	surface.SetDrawColor(255,255,255,255)
    surface.DrawTexturedRectUV( 12, -32, 4, 128, 0, 0, 1, 1 )
    surface.DrawTexturedRectUVRotated(12+math.Clamp(x+48,268,999), 30, 4, 128, 0, 0, 1, 1 ,180)
    surface.DrawTexturedRectUVRotated(12+math.Clamp(x+48,268,999)/2, -32, 4, math.Clamp(x+48,268,999), 0, 0, 1, 2 ,90)
    surface.DrawTexturedRectUVRotated(12+math.Clamp(x+48,268,999)/2, -32+128, 4, math.Clamp(x+48,268,999), 0, 0, 1, 2 ,90)

    surface.SetTexture(water)
  	surface.SetDrawColor(hl[math.Clamp(math.Round((self:GetNWInt("Charge",100))/25),1,4)])
  	surface.DrawTexturedRect(30,22,64,64)

    draw.SimpleTextOutlined((self:GetNWInt("Charge",0)).."%","MainWeedFont",math.Clamp(x+48,268,999),56,Color(255,255,255),TEXT_ALIGN_RIGHT,TEXT_ALIGN_CENTER,1,Color(75,75,75))

  end
end
