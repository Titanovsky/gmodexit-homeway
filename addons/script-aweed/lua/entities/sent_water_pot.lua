AddCSLuaFile()
DEFINE_BASECLASS( "base_anim" )

ENT.Base = "sent_base_gonzo"

ENT.PrintName		= "Water pot"
ENT.Author			= "Gonzo"
ENT.Category		= "Drugs"
ENT.Spawnable 		= false
ENT.AdminOnly 		= false

ENT.Amount = 30

function ENT:Initialize()

 	if SERVER then
		self:SetModel( "models/gonzo/weedb/water_pot.mdl" )
		self:PhysicsInit( SOLID_VPHYSICS )      -- Make us work with physics,
		self:SetMoveType( MOVETYPE_VPHYSICS )   -- after all, gmod is a physics
		self:SetSolid( SOLID_VPHYSICS )         -- Toolbox
    self:SetNWInt("Water",100)
    local phys = self:GetPhysicsObject()
		if (phys:IsValid()) then
			phys:Wake()
		end

        self:SetNWBool("On",true)
	end
end

function ENT:Use(ply)

    if(!self:GetNWBool("Shower",false)) then return end

    self:SetNWBool("On",Either(self:GetNWBool("On",false),false,true))
    self:EmitSound("buttons/button1.wav")

end

function ENT:SetWater(x)
    self.Size = Vector(10,30,30)
    if(x==2) then
        self:SetModel("models/gonzo/weedb/shower.mdl")
        self:PhysicsInit( SOLID_VPHYSICS )
		self:SetMoveType( MOVETYPE_VPHYSICS )
		self:SetSolid( SOLID_VPHYSICS )
        self:SetUseType(SIMPLE_USE)
        self:SetNWInt("Water",300)
        self:SetNWBool("Shower",true)
        self.Size = Vector(100,0,50)
    end
end

function ENT:Think()
  if SERVER then
    local ang = self:GetAngles().r
    if(self:GetNWInt("Water",0) > 0 && Either(self:GetNWBool("Shower",false),true,(ang < -90 || ang >= 40)) && self:GetNWBool("On",true)) then

        local mr = math.random(1,Either(self:GetNWBool("Shower",false),1,5))
        self:SetNWInt("Water",self:GetNWInt("Water",0)-mr)

      if(!self:GetNWBool("Shower",false)) then

          local vPoint = self:GetPos() + self:GetUp()*28 + self:GetRight()*24
          local effectdata = EffectData()
          effectdata:SetOrigin( vPoint )
          effectdata:SetSurfaceProp( 0 )
          effectdata:SetHitBox( 0 )
          util.Effect( "watersplash", effectdata )

          local tr = util.QuickTrace( self:GetPos() + self:GetUp()*28 + self:GetRight()*24, Vector(0,0,-1)*512, self )
          if(tr.Entity:GetClass() == "sent_pot") then
            local wat = Either(self:GetNWBool("Shower",false),3,1)*mr*WEED_CONFIG.WaterEffectiveness;
            tr.Entity:SetNWInt("Water",math.Clamp(tr.Entity:GetNWInt("Water",0)+wat,0,tr.Entity:GetNWInt("MaxWater",100)))
            tr.Entity.Watered = CurTime() + 3
            tr.Entity:SetHealth(math.Clamp(tr.Entity:Health()+mr,0,100))
          end
      else
          for k=0,3 do
              local vPoint = self:GetPos() + self:GetUp()*92 + self:GetRight()*32*k - self:GetRight()*48
              local effectdata = EffectData()
              effectdata:SetOrigin( vPoint )
              effectdata:SetScale(0.35)
              effectdata:SetSurfaceProp( 0 )
              effectdata:SetHitBox( 0 )
              util.Effect( "watersplash", effectdata )

              local tr = util.QuickTrace( self:GetPos() + self:GetUp()*92 + self:GetRight()*32*k - self:GetRight()*48, Vector(0,0,-1)*512, self )
              if(tr.Entity:GetClass() == "sent_pot") then
                local wat = Either(self:GetNWBool("Shower",false),3,1)*mr*WEED_CONFIG.WaterEffectiveness;
                tr.Entity:SetNWInt("Water",math.Clamp(tr.Entity:GetNWInt("Water",0)+wat,0,tr.Entity:GetNWInt("MaxWater",100)))
                tr.Entity.Watered = CurTime() + 1
                tr.Entity:SetHealth(math.Clamp(tr.Entity:Health()+mr,0,100))
              end
          end
      end

      if(self:GetNWInt("Water",0) <= 0) then
        self:Remove()
      end
      self:NextThink( CurTime() + Either(self:GetNWBool("Shower",false),math.random(1.5,4),math.random(0.5,1.4)) )
  		return true
    end
  end
end

if CLIENT then

local rope = Material("gui/rope")
local hl = {Color(231, 76, 60),Color(230, 126, 34),Color(241, 196, 15),Color(46, 204, 113)}
local w,h = 0,0
local water = surface.GetTextureID("gui/water")
local ctr;
function ENT:PostDraw()
  local ang = self:GetAngles().r
  if(!self:GetNWBool("Shower",false)) then
    ctr = util.QuickTrace( self:GetPos() + self:GetUp()*28 + self:GetRight()*24, Vector(0,0,-1)*128, self )

    render.SetMaterial(rope)
    render.DrawBeam(self:GetPos() + self:GetUp()*28 + self:GetRight()*24,ctr.HitPos,1,0,3,Color(72, 200, 512,Either(self:GetNWInt("Water",0) > 0 && ang < -90 || ang >= 40,200,50)))
    if(isvector(ctr.HitPos)) then
      render.DrawBeam(ctr.HitPos + Vector(-16,0,0),ctr.HitPos + Vector(0,0,0),1,0,1,Color(72, 200, 512,Either(self:GetNWInt("Water",0) > 0 && ang < -90 || ang >= 40,200,50)))
      render.DrawBeam(ctr.HitPos + Vector(0,16,0),ctr.HitPos + Vector(0,-0,0),1,0,1,Color(72, 200, 512,Either(self:GetNWInt("Water",0) > 0 && ang < -90 || ang >= 40,200,50)))
      render.DrawBeam(ctr.HitPos + Vector(0,-16,0),ctr.HitPos + Vector(0,0,0),1,0,1,Color(72, 200, 512,Either(self:GetNWInt("Water",0) > 0 && ang < -90 || ang >= 40,200,50)))
      render.DrawBeam(ctr.HitPos + Vector(16,0,0),ctr.HitPos + Vector(0,-0,0),1,0,1,Color(72, 200, 512,Either(self:GetNWInt("Water",0) > 0 && ang < -90 || ang >= 40,200,50)))
    end
    else
        render.SetMaterial(rope)
        for k=0,3 do
            ctr = util.QuickTrace( self:GetPos() + self:GetUp()*92 + self:GetRight()*32*k - self:GetRight()*48, Vector(0,0,-1)*128, self )
            render.DrawBeam(self:GetPos() + self:GetUp()*92 + self:GetRight()*32*k - self:GetRight()*48,ctr.HitPos,1,0,3,Color(72, 200, 512,Either(self:GetNWInt("Water",0) > 0 && ang < -90 || ang >= 40,200,50)))
        end
  end
end

function ENT:DoInfo()
  surface.SetDrawColor(50,50,50,150)
  surface.DrawRect(12,-32,268,128)
  draw.SimpleTextOutlined(self.PrintName,"MainWeedFont",36,-2,Color(255,255,255),TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER,1,Color(75,75,75))
  surface.SetMaterial(rope)
	surface.SetDrawColor(255,255,255,255)
  surface.DrawTexturedRectUV( 12, -32, 4, 128, 0, 0, 1, 1 )
  surface.DrawTexturedRectUVRotated(12+268, 30, 4, 128, 0, 0, 1, 1 ,180)
  surface.DrawTexturedRectUVRotated(12+268/2, -32, 4, 268, 0, 0, 1, 2 ,90)
  surface.DrawTexturedRectUVRotated(12+268/2, -32+128, 4, 268, 0, 0, 1, 2 ,90)

  surface.SetTexture(water)
	surface.SetDrawColor(hl[math.Clamp(math.Round((self:GetNWInt("Water",100))/25),1,4)])
	surface.DrawTexturedRect(30,22,64,64)

  draw.SimpleTextOutlined(Either(self:GetNWBool("On",true),(self:GetNWInt("Water",0)/20).." lts","OFF"),"MainWeedFont",268,56,Color(255,255,255),TEXT_ALIGN_RIGHT,TEXT_ALIGN_CENTER,1,Color(75,75,75))

end

end
