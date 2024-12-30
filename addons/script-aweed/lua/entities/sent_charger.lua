AddCSLuaFile()
DEFINE_BASECLASS( "base_anim" )

if SERVER then
  util.AddNetworkString("UpdateBatteries")
end

ENT.Base = "sent_base_gonzo"

ENT.Linkable = true
ENT.Size = Vector(10,40,30)
ENT.PrintName		= "Charger"
ENT.Author			= "Gonzo"
ENT.Category		= "Drugs"
ENT.Spawnable 		= false
ENT.AdminOnly 		= false

ENT.Batteries = {}
ENT.Filter = {}

function ENT:Initialize()

 	if SERVER then
		self:SetModel( "models/gonzo/weedb/charger.mdl" )
		self:PhysicsInit( SOLID_VPHYSICS )      -- Make us work with physics,
		self:SetMoveType( MOVETYPE_VPHYSICS )   -- after all, gmod is a physics
		self:SetSolid( SOLID_VPHYSICS )         -- Toolbox
	    local phys = self:GetPhysicsObject()
		if (phys:IsValid()) then
			phys:Wake()
		end
    self.Batteries = {}
	end
end

ENT.SN = 0

function ENT:Touch(entity)
  for k,v in pairs(self.Batteries) do
    if(v == NULL) then
      table.RemoveByValue(self.Batteries,v)
    end
  end
  if(entity:GetClass() == "sent_battery" && #self.Batteries < 2 && entity:GetNWInt("Charge",0) < 100 && !(entity.Charging or false) && !entity:GetNWBool("Disposable",false)) then
    entity.Charging = true
    self.SN = self.SN + 1
    for k,v in pairs(self.Filter) do
      if(v[1] == entity && v[2] == entity:GetNWInt("Charge")) then
        return
      elseif(v[2] != entity:GetNWInt("Charge",0)) then
        table.RemoveByValue(self.Filter,v)
      end
    end
    entity:SetParent(self)
    entity:SetLocalPos(Vector(0,0,0))
    entity:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
    if(#self.Batteries == 0) then
      entity:SetLocalAngles(Angle(0,0,0))
      self:SetNWEntity("Bat_A",entity)
    else
      entity:SetLocalAngles(Angle(0,0,60))
      self:SetNWEntity("Bat_B",entity)
    end
    table.insert(self.Batteries,entity)
  end
end

function ENT:Use(ply)

  if(ply.IsBeeping or false) then
    ply:AddLink(self)
    return
  end

  if(#self.Batteries > 0 && self.SN > 0) then
    self.SN = self.SN - 1
    local bat = Either(self.Batteries[1]:GetNWInt("Charge",0) > (self.Batteries[2] or game.GetWorld()):GetNWInt("Charge",0),self.Batteries[1],self.Batteries[2])
    local ent = ents.Create("sent_battery")
    ent:SetPos(self:GetPos() + Vector(0,0,30))
    ent.Charging = false
    ent:Spawn()
    ent:SetNWInt("Charge",bat:GetNWInt("Charge",0))
    DoBeep(self,"Battery charged successfully")
    undo.ReplaceEntity(v,ent)
    self.Batteries = {Either(self.Batteries[1] == bat,self.Batteries[2],self.Batteries[1])}
    table.insert(self.Filter,{ent,ent:GetNWInt("Charge")})
    bat:Remove()
  end

end

function ENT:Think()
  if SERVER then
    if(#self.Batteries > 0) then
      for k,v in pairs(self.Batteries) do
        if(v:GetNWInt("Charge",0) >= 100 && (v.Charging or false)) then
          local ent = ents.Create("sent_battery")
          ent:SetPos(self:GetPos() + Vector(0,0,30))
          ent.Charging = false
          ent:Spawn()
          ent:SetNWInt("Charge",100)
          DoBeep(self,"Battery charged successfully")
          undo.ReplaceEntity(v,ent)
          v:Remove()
        else
          v:SetNWInt("Charge",math.Clamp(v:GetNWInt("Charge",0)+1,0,100))
        end
      end
    end
    self:NextThink(WEED_CONFIG.ReloadRate + CurTime())
    return true
  end
end

if CLIENT then

  local rope = Material("gui/rope")
  local hl = {Color(231, 76, 60),Color(230, 126, 34),Color(241, 196, 15),Color(46, 204, 113)}
  local w,h = 0,0
  local light = surface.GetTextureID("gui/light")

  function ENT:DoInfo()
    surface.SetDrawColor(50,50,50,150)
    surface.DrawRect(12,-32,268,196)
    draw.SimpleTextOutlined(self.PrintName,"MainWeedFont_med",36,-2,Color(255,255,255),TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER,1,Color(75,75,75))
    surface.SetMaterial(rope)
  	surface.SetDrawColor(255,255,255,255)
    surface.DrawTexturedRectUV( 12, -32, 4, 196, 0, 0, 1, 1 )
    surface.DrawTexturedRectUVRotated(12+268, 64, 4, 196, 0, 0, 1, 1 ,180)
    surface.DrawTexturedRectUVRotated(12+268/2, -32, 4, 268, 0, 0, 1, 2 ,90)
    surface.DrawTexturedRectUVRotated(12+268/2, -32+196, 4, 268, 0, 0, 1, 2 ,90)

    surface.SetTexture(light)

    if(IsValid(self:GetNWEntity("Bat_A"))) then
      surface.SetDrawColor(255,255,255)
      draw.SimpleTextOutlined(self:GetNWEntity("Bat_A"):GetNWInt("Charge").."%","MainWeedFont",268,56,Color(255,255,255),TEXT_ALIGN_RIGHT,TEXT_ALIGN_CENTER,1,Color(75,75,75))
    else
      surface.SetDrawColor(255,255,255,50)
      draw.SimpleTextOutlined("Пусто","MainWeedFont",268,56,Color(255,255,255),TEXT_ALIGN_RIGHT,TEXT_ALIGN_CENTER,1,Color(75,75,75))
    end

    surface.DrawTexturedRect(30,24,64,64)

    if(IsValid(self:GetNWEntity("Bat_B"))) then
      surface.SetDrawColor(255,255,255)
      draw.SimpleTextOutlined(self:GetNWEntity("Bat_B"):GetNWInt("Charge").."%","MainWeedFont",268,56+64,Color(255,255,255),TEXT_ALIGN_RIGHT,TEXT_ALIGN_CENTER,1,Color(75,75,75))
    else
      surface.SetDrawColor(255,255,255,50)
      draw.SimpleTextOutlined("Пусто","MainWeedFont",268,56+64,Color(255,255,255),TEXT_ALIGN_RIGHT,TEXT_ALIGN_CENTER,1,Color(75,75,75))
    end

    surface.DrawTexturedRect(30,24+64,64,64)

  end

end
