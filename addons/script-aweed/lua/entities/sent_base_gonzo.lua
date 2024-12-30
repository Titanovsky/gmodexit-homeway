
AddCSLuaFile()

DEFINE_BASECLASS( "base_anim" )

ENT.PrintName		= "Drug"
ENT.Author			= "Gonzo"
ENT.Category		= "Drugs"

ENT.Spawnable 		= false
ENT.AdminOnly 		= false

ENT.Size = Vector(0,30,30)

ENT.RenderGroup                 = RENDERGROUP_TRANSLUCENT
ENT.AutomaticFrameAdvance = true;

ENT.Quality = 50

function ENT:SpawnFunction( ply, tr, ClassName )

        if ( !tr.Hit ) then return end

        local SpawnPos = tr.HitPos

        local ent = ents.Create( ClassName )
        ent:SetPos( SpawnPos + tr.HitNormal * 4 )
        ent:Spawn()
        ent:Activate()

        return ent
end

function ENT:OnTakeDamage(dmg)
    if(WEED_CONFIG.ItemsHealth > 0 && dmg:IsExplosionDamage() || dmg:IsBulletDamage()) then
        self.SHealth = (self.SHealth or WEED_CONFIG.ItemsHealth) - dmg:GetDamage()
        if(self.SHealth <= 0) then
            self:Remove()
        end
    end
end

function ENT:Initialize()

 	if SERVER then
		self:SetModel( "models/gonzo/weed/pot.mdl" )
		self:PhysicsInit( SOLID_VPHYSICS )      -- Make us work with physics,
		self:SetMoveType( MOVETYPE_VPHYSICS )   -- after all, gmod is a physics
		self:SetSolid( SOLID_VPHYSICS )         -- Toolbox
    self:SetUseType(SIMPLE_USE)
	  local phys = self:GetPhysicsObject()
		if (phys:IsValid()) then
			phys:Wake()
		end


		self:SetTrigger(true)
	end
end

function ENT:Use( activator, caller )
    return
end

local rope = Material("gui/rope")
function ENT:Draw()
    self:DrawModel()

		if(LocalPlayer():GetEyeTrace().Entity == self) then
      render.SetMaterial(rope)
			render.DrawBeam(self:GetPos()+self:GetUp()*self.Size.x,self:GetPos()+Vector(0,0,self.Size.z)+LocalPlayer():GetRight()*self.Size.y*1.05,1,0,3,Color(255,255,255))

      if LocalPlayer():GetPos():Distance(self:GetPos()) > 256 then
    		return
    	end

    	local eyeAng = EyeAngles()
    	eyeAng.p = 0
    	eyeAng.y = eyeAng.y - 90 - 18
    	eyeAng.r = 90

    	cam.Start3D2D(self:GetPos() + Vector(0,0,self.Size.z)+LocalPlayer():GetRight()*self.Size.y, eyeAng, 0.1)
        cam.IgnoreZ(true)
          self:DoInfo(self:GetPos())
        cam.IgnoreZ(false)
    	cam.End3D2D()
		end
    if(isfunction(self.PostDraw)) then
      self:PostDraw()
    end
end

local w,h = 0,0

function ENT:DoInfo()
  surface.SetDrawColor(50,50,50,150)
  surface.DrawRect(12,-h/2,w+40,h+16)
  w,h = draw.SimpleTextOutlined(self:GetNWString("PrintName",self.PrintName),"MainWeedFont",32,0,Color(255,255,255),TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER,1,Color(75,75,75))

  surface.SetMaterial(rope)
  surface.SetDrawColor(255,255,255,255)
  surface.DrawTexturedRectUV( 12, -32, 4, h+16, 0, 0, 1, 1 )
  surface.DrawTexturedRectUVRotated(12+w+40, 8, 4, h+16, 0, 0, 1, 1 ,180)
  surface.DrawTexturedRectUVRotated((w+40)/2+12, -32, 4, (w+40), 0, 0, 1, 2 ,90)
  surface.DrawTexturedRectUVRotated((w+40)/2+12, -32+h+16, 4, (w+40), 0, 0, 1, 2 ,90)

end
