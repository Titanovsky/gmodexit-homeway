AddCSLuaFile()
DEFINE_BASECLASS( "base_anim" )

ENT.Base = "sent_base_gonzo"

ENT.Linkable = true

ENT.Size = Vector(30,30,40)
ENT.PrintName		= "Lamp"
ENT.Author			= "Gonzo"
ENT.Category		= "Drugs"
ENT.Spawnable 		= false
ENT.AdminOnly 		= false

function ENT:Initialize()

 	if SERVER then
		self:SetModel( "models/gonzo/weedb/lamp.mdl" )
		self:PhysicsInit( SOLID_VPHYSICS )      -- Make us work with physics,
		self:SetMoveType( MOVETYPE_VPHYSICS )   -- after all, gmod is a physics
		self:SetSolid( SOLID_VPHYSICS )         -- Toolbox
    self:SetUseType(SIMPLE_USE)
    self:SetNWInt("Charge",0)
    self:SetNWBool("On",false)
	    local phys = self:GetPhysicsObject()
		if (phys:IsValid()) then
			phys:Wake()
		end
	end
end

function ENT:Touch(entity)
  if(entity:GetClass() == "sent_battery" && entity:GetNWInt("Charge",0) > 0 && self:GetNWInt("Charge",0) <= 0) then
    entity:SetParent(self)
    entity:SetLocalAngles(Angle(90,0,0))
    entity:SetLocalPos(Either((self.IsRadial or false),Vector(-14,-7,26.5),Vector(-11,-7,38)))
    entity:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
    self.Battery = entity
    self:SetNWInt("Charge",entity:GetNWInt("Charge",0))
    self:EmitSound("buttons/button1.wav")
  end
end

function ENT:Think()
	if SERVER then
		if(self:GetNWBool("On") && self:GetNWInt("Charge",0) > 0) then

			self:SetNWInt("Charge",self:GetNWInt("Charge",100)-1)

			if self:GetNWInt("Charge",0) <= 0 then
        if(!self.Battery:GetNWBool("Disposable",false)) then
          local ent = ents.Create("sent_battery")
          ent:SetAngles(Angle(90,0,0))
          ent:SetPos(self:GetPos()-self:GetRight()*11-self:GetForward()*7+self:GetUp()*48)
          undo.ReplaceEntity(self.Battery,ent)
          if(IsValid(self.Battery)) then
            self.Battery:Remove()
          end
          ent:Spawn()
          ent:SetNWInt("Charge",0)
        else
          if(IsValid(self.Battery)) then
            self.Battery:Remove()
          end
        end
				if(IsValid(self.Shine)) then
					self.Shine:Remove()
				end
        self:SetNWBool("On",false)

        DoBeep(self,"YOUR LAMP RAN OF ENERGY!")

			end

			self:NextThink(WEED_CONFIG.LampDrain + CurTime())
			return true
		end
	end
end

function ENT:SetLight(x)
  if(x == 2) then
    self:SetModel("models/gonzo/weedb/lamp2.mdl")
    self:PhysicsInit( SOLID_VPHYSICS )      -- Make us work with physics,
    self:SetMoveType( MOVETYPE_VPHYSICS )   -- after all, gmod is a physics
    self:SetSolid( SOLID_VPHYSICS )         -- Toolbox
    self:SetUseType(SIMPLE_USE)
    local phys = self:GetPhysicsObject()
    if (phys:IsValid()) then
      phys:Wake()
    end
    self.IsRadial = true
  end
end

function ENT:Use(ply)

   if(ply.IsBeeping or false) then
     ply:AddLink(self)
     return
   end

    self:SetNWBool("On",Either(self:GetNWBool("On",false),false,true))
    self:EmitSound("buttons/button1.wav")
    if(self:GetNWBool("On") && self:GetNWInt("Charge",0) > 0) then
			Shine = ents.Create("env_sprite")
      local pos = Either(!(self.IsRadial or false), self:GetPos() + self:GetUp()*32 + self:GetRight()*-0 + self:GetForward()*20,self:GetPos()+self:GetUp()*102+self:GetRight()*16)
			Shine:SetPos(pos)
			Shine:SetKeyValue("renderfx", "0")
			Shine:SetKeyValue("rendermode", "9")
			Shine:SetKeyValue("renderamt", "200")
			Shine:SetKeyValue("rendercolor", "255 255 255")
			Shine:SetKeyValue("framerate12", "25")
			Shine:SetKeyValue("model", "light_glow03.spr")
			Shine:SetKeyValue("scale", Either(!(self.IsRadial or false),"1.3","2"))
			Shine:SetKeyValue("GlowProxySize", "20")
			Shine:SetParent(self)
			Shine:Spawn()
			Shine:Activate()
			self.Shine = Shine
		elseif(IsValid(self.Shine)) then
			self.Shine:Remove()
		end
end

if CLIENT then

local rope = Material("gui/rope")
local hl = {Color(231, 76, 60),Color(230, 126, 34),Color(241, 196, 15),Color(46, 204, 113)}
local light = surface.GetTextureID("gui/light")

function ENT:PostDraw()
  render.SetMaterial(rope)
  if(self:GetNWInt("Charge",0) > 0  && self:GetModel() != "models/gonzo/weedb/lamp2.mdl") then
    render.DrawBeam(self:GetPos() + self:GetForward()*148-self:GetRight()*64,self:GetPos() + self:GetForward()*16-self:GetRight()*8,1,0,4,Color(255, 180, 50,Either(self:GetNWBool("On"),255,35)))
    render.DrawBeam(self:GetPos() + self:GetForward()*148+self:GetRight()*64,self:GetPos() + self:GetForward()*16+self:GetRight()*8,1,0,4,Color(255, 180, 50,Either(self:GetNWBool("On"),255,35)))
    render.DrawBeam(self:GetPos() + self:GetForward()*148+self:GetRight()*65,self:GetPos() + self:GetForward()*148-self:GetRight()*65,1,0,4,Color(255, 180, 50,Either(self:GetNWBool("On"),255,35)))
  elseif(self:GetNWInt("Charge",0) > 0) then
    render.DrawBeam(self:GetPos() + self:GetForward()*196/2,self:GetPos(),1,0,4,Color(255, 180, 50,Either(self:GetNWBool("On"),255,35)))
    render.DrawBeam(self:GetPos() - self:GetForward()*196/2,self:GetPos(),1,0,4,Color(255, 180, 50,Either(self:GetNWBool("On"),255,35)))
    render.DrawBeam(self:GetPos() + self:GetRight()*196/2,self:GetPos(),1,0,4,Color(255, 180, 50,Either(self:GetNWBool("On"),255,35)))
    render.DrawBeam(self:GetPos() - self:GetRight()*196/2,self:GetPos(),1,0,4,Color(255, 180, 50,Either(self:GetNWBool("On"),255,35)))

    render.DrawBeam(self:GetPos() - self:GetRight()*196/2,self:GetPos() - self:GetForward()*196/2,1,0,4,Color(255, 180, 50,Either(self:GetNWBool("On"),255,35)))
    render.DrawBeam(self:GetPos() + self:GetRight()*196/2,self:GetPos() + self:GetForward()*196/2,1,0,4,Color(255, 180, 50,Either(self:GetNWBool("On"),255,35)))
    render.DrawBeam(self:GetPos() - self:GetRight()*196/2,self:GetPos() + self:GetForward()*196/2,1,0,4,Color(255, 180, 50,Either(self:GetNWBool("On"),255,35)))
    render.DrawBeam(self:GetPos() + self:GetRight()*196/2,self:GetPos() - self:GetForward()*196/2,1,0,4,Color(255, 180, 50,Either(self:GetNWBool("On"),255,35)))
  end
end

function ENT:DoInfo()
  surface.SetDrawColor(50,50,50,150)
  surface.DrawRect(12,-32,268,128)
  draw.SimpleTextOutlined(self.PrintName.." ("..Either(self:GetNWBool("On",false),"On","Off")..")","MainWeedFont_med",36,-2,Color(255,255,255),TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER,1,Color(75,75,75))
  surface.SetMaterial(rope)
	surface.SetDrawColor(255,255,255,255)
  surface.DrawTexturedRectUV( 12, -32, 4, 128, 0, 0, 1, 1 )
  surface.DrawTexturedRectUVRotated(12+268, 30, 4, 128, 0, 0, 1, 1 ,180)
  surface.DrawTexturedRectUVRotated(12+268/2, -32, 4, 268, 0, 0, 1, 2 ,90)
  surface.DrawTexturedRectUVRotated(12+268/2, -32+128, 4, 268, 0, 0, 1, 2 ,90)

  surface.SetTexture(light)
	surface.SetDrawColor(hl[math.Clamp(math.Round((self:GetNWInt("Water",100))/25),1,4)])
	surface.DrawTexturedRect(30,24,64,64)

  draw.SimpleTextOutlined(self:GetNWInt("Charge",0).." %","MainWeedFont",268,56,Color(255,255,255),TEXT_ALIGN_RIGHT,TEXT_ALIGN_CENTER,1,Color(75,75,75))

end

end
