AddCSLuaFile()
DEFINE_BASECLASS( "base_anim" )

ENT.Base = "sent_base_gonzo"

ENT.Linkable = true
ENT.Size = Vector(30,60,75)
ENT.PrintName		= "Water Source"
ENT.Author			= "Gonzo"
ENT.Category		= "Drugs"
ENT.Spawnable 		= false
ENT.AdminOnly 		= false

function ENT:Initialize()

 	if SERVER then
		self:SetModel( "models/gonzo/weedb/water_source.mdl" )
		self:PhysicsInit( SOLID_VPHYSICS )
		self:SetMoveType( MOVETYPE_VPHYSICS )
		self:SetSolid( SOLID_VPHYSICS )
    self:SetNWInt("Charge",100)
    self:SetNWInt("Buckets",WEED_CONFIG.WaterSourceBuckets)
    self:SetNWInt("MaxBuckets",WEED_CONFIG.WaterSourceBuckets)
	    local phys = self:GetPhysicsObject()
		if (phys:IsValid()) then
			phys:Wake()
		end
	end
end

ENT.Ready = false

function ENT:Use(ply)
  if(ply.IsBeeping or false) then
    ply:AddLink(self)
    return
  end
  if(self:GetNWInt("Water",0) >= 100) then
    local ent = ents.Create("sent_water_pot")
    ent:SetPos(self:GetPos() + self:GetUp()*28 + self:GetRight()*52 - self:GetForward()*32 + Vector(0,0,-30))
    ent:Spawn()
    ent:GetPhysicsObject():Sleep()
    self:SetNWInt("Water",0)
    self.Ready = false
    self:SetNWInt("Buckets",self:GetNWInt("Buckets",50)-1)
    if(self:GetNWInt("Buckets") <= 0) then
      self:Remove()
      DoBeep(self,"YOUR WATER SOURCE RAN OF BUCKETS")
    end
  end
end

function ENT:Think()
  if SERVER then
    if(self:GetNWInt("Water",0) < 100) then
      self:SetNWInt("Water",self:GetNWInt("Water",0)+1)
    else
      if(!self.Ready) then
        self.Ready = true
        DoBeep(self,"YOUR WATER IT'S READY")
      end
    end
    self:NextThink(CurTime()+WEED_CONFIG.WaterSourceSpeed);
    return true
  end
end

if CLIENT then

local rope = Material("gui/rope")
local hl = {Color(231, 76, 60),Color(230, 126, 34),Color(241, 196, 15),Color(46, 204, 113)}
local w,h = 0,0
local water = surface.GetTextureID("gui/water")
local ctr;
function ENT:PostDraw()
  if(true) then
    render.SetMaterial(rope)
    render.DrawBeam(self:GetPos() + self:GetUp()*28 + self:GetRight()*52 - self:GetForward()*22 + Vector(0,0,-30),self:GetPos() + self:GetUp()*28 + self:GetRight()*52 - self:GetForward()*22,1,0,3,Color(72, 200, 512,255))
  end
end

function ENT:DoInfo()
  surface.SetDrawColor(50,50,50,150)
  surface.DrawRect(12,-32,332,128)
  draw.SimpleTextOutlined(self.PrintName,"MainWeedFont",36,-2,Color(255,255,255),TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER,1,Color(75,75,75))
  surface.SetMaterial(rope)
	surface.SetDrawColor(255,255,255,255)
  surface.DrawTexturedRectUV( 12, -32, 4, 128, 0, 0, 1, 1 )
  surface.DrawTexturedRectUVRotated(12+332, 30, 4, 128, 0, 0, 1, 1 ,180)
  surface.DrawTexturedRectUVRotated(12+332/2, -32, 4, 332, 0, 0, 1, 2 ,90)
  surface.DrawTexturedRectUVRotated(12+332/2, -32+128, 4, 332, 0, 0, 1, 2 ,90)

  if(self:GetNWInt("Water",0) < 100) then
    surface.SetTexture(water)

  	surface.SetDrawColor(hl[math.Clamp(math.Round((self:GetNWInt("Buckets",50)/self:GetNWInt("MaxBuckets",50))*4),1,4)])
  	surface.DrawTexturedRect(30,22,64,64)
    draw.SimpleTextOutlined(self:GetNWInt("Buckets",0),"MainWeedFont",110,56,Color(255,255,255),TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER,1,Color(75,75,75))

    draw.SimpleTextOutlined(self:GetNWInt("Water",0).."%","MainWeedFont",332,56,Color(255,255,255),TEXT_ALIGN_RIGHT,TEXT_ALIGN_CENTER,1,Color(75,75,75))
  else
    draw.SimpleTextOutlined("Наполнить ведро (E)","MainWeedFont_med",186,56,Color(50,150,255),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER,1,Color(75,75,75))
  end

end

end
