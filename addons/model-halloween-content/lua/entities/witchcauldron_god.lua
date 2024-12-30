
-- Add the files that need to be downloaded
resource.AddFile( 'models/Zerochain/props_halloween/witchcauldron.mdl' )

resource.AddFile( 'materials/props_halloween/witchcauldron.vtf' )
resource.AddFile( 'materials/props_halloween/witchcauldron.vmt' )
resource.AddFile( 'materials/props_halloween/witchcauldron_normal.vtf' )

resource.AddFile( 'materials/props_halloween/witchcauldron_soup.vtf' )
resource.AddFile( 'materials/props_halloween/witchcauldron_soup.vmt' )

resource.AddFile( "sound/cauldron_bubbling_loop.wav" )
resource.AddFile( "sound/absorb.wav" )
resource.AddFile( "sound/cauldron_magicspell.wav" )

---------------------------------------------------------------
------ Model & Design by: Zerochain | Coding by : Zerochain ---
---------------------------------------------------------------

AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_anim"

ENT.PrintName = "Magic WitchCauldron"
ENT.Author = "ClemensProduction aka Zerochain"
ENT.Information = "Bubbles"
ENT.Category = "Halloween Stuff"

ENT.Spawnable = true
ENT.AdminOnly = false

ENT.Effect    =  "soup_bubbles01" 
ENT.ExplosionEffect    =  "effect_bubble_explosion" 
ENT.DespawnEffect    =  "effect_witchcauldron_despawn" 

local AbsorbSound = Sound( "absorb.wav" )
local MagicSpellSound = Sound( "cauldron_magicspell.wav" )
local SacrificeCount = 0
local NeedAmount = 2
local amount = 0

function ENT:SpawnFunction( ply, tr )                   -- 膆nlich wie die Initialize Funktion Standard SEnt Funktion
                                                        -- Sie beschreibt was er tun soll wenn man das Entity spawnt 
        if ( !tr.Hit ) then return end                  
         
        local SpawnPos = tr.HitPos + tr.HitNormal * 2 -- Speichert die Position wo der Spieler grade hinguckt
         
        local ent = ents.Create( "witchcauldron_god" )      -- Definiert dass wir wirklich dieses SEnt spawnen
        ent:SetPos( SpawnPos )                          -- Definiert Position unseres SEnts
        ent:Spawn()                                     -- Spawnt das SEnt
        ent:Activate()                                  -- Unser Script bzw. das SEnt
        return ent 
end

--[[---------------------------------------------------------
	Name: Initialize
-----------------------------------------------------------]]
function ENT:Initialize()
	
	-- We do NOT want to execute anything below in this FUNCTION on CLIENT
	if ( CLIENT ) then return end

	self:SetModel( "models/zerochain/props_halloween/witchcauldron.mdl" )

	self.Entity:SetSkin( 1 )

    self.Entity:PhysicsInit( SOLID_VPHYSICS )   
    self.Entity:SetMoveType( MOVETYPE_VPHYSICS )
    self.Entity:SetSolid( SOLID_VPHYSICS )
    self.Entity:SetNotSolid(false)

    local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
	    phys:Wake()
        phys:EnableMotion(true)
	end

	self.Entity.pos = self.Entity:GetPos()

	ParticleEffectAttach(self.Effect,PATTACH_POINT_FOLLOW,self,1)
	--ParticleEffectAttach(self.DespawnEffect,PATTACH_POINT_FOLLOW,self,1)
	self.SoundName = Sound( "cauldron_bubbling_loop.wav" )

	self:StartBubbleSound()
	amount = NeedAmount - SacrificeCount
end
-----------------------------------------------------------]]




-----------------------------------------------------------]]
function ENT:Think()


	if CLIENT then
		local dlight = DynamicLight( self:EntIndex())
		if ( dlight ) then
			local r, g, b, a = 0
			dlight.Pos = self.Entity:GetPos() + Vector(0,0,60)
			dlight.r = 160
			dlight.g = 255
			dlight.b = 0
			dlight.Brightness = 1
			dlight.Size = 256
			dlight.Decay = 0
			dlight.Style = 5
			dlight.DieTime = CurTime() + 1
		end
	end
end



function ENT:OnRestore()
	ParticleEffectAttach(self.Effect,PATTACH_POINT_FOLLOW,self,1)
end
-----------------------------------------------------------]]




-----------------------------------------------------------]]
function ENT:StartBubbleSound()
	self.Sound = CreateSound( self.Entity, self.SoundName )
	self.Sound:PlayEx( 0.5, 100 )
end


function ENT:SetSound( sound )
	self.SoundName = Sound( sound )
	self.Sound = nil
end
-----------------------------------------------------------]]




-----------------------------------------------------------]]

function ENT:StartTouch(activator)

	if ( !activator:IsPlayer() && activator:EntIndex() != self:EntIndex() && activator:GetClass() == "prop_physics") then

        
        sound.Play( AbsorbSound, self:GetPos(), 75, math.random(60,100),1)

		ParticleEffect(self.ExplosionEffect,self.Entity:GetPos()+ Vector(0,0,45), Angle(0,0,0), nil)   
		--ParticleEffect(self.DespawnEffect,self.Entity:GetPos()+ Vector(0,0,30), Angle(0,0,0), nil)
		activator:Remove()

		SacrificeCount = SacrificeCount + 1
		amount = NeedAmount - SacrificeCount

		--print("amount:" ..amount)
		--print("sacrificeCount:" ..SacrificeCount)
	
		if(SacrificeCount > NeedAmount) then
			for i = 1, math.random(1,3) do
				local yummi = ents.Create("bonbon01")
				if(!IsValid(yummi)) then return end
					yummi:SetPos(self.Entity:GetPos() + Vector(math.random(-60,60),math.random(-60,60),60))
					yummi:Spawn()
					sound.Play( "garrysmod/balloon_pop_cute.wav", self:GetPos(), 75, math.random(50,60),0.8 )
			end
			sound.Play( MagicSpellSound, self:GetPos(), 75, 100,1)
			SacrificeCount = 0 
			ParticleEffect(self.DespawnEffect,self.Entity:GetPos()+ Vector(0,0,30), Angle(0,0,0), nil)
			--self:Despawn()
		end
	end
end


-----------------------------------------------------------]]

/*
function ENT:Despawn()
	self.RenderModel = false
	self.Entity:SetNotSolid(true)
	ParticleEffect(self.DespawnEffect,self.Entity:GetPos()+ Vector(0,0,30), Angle(0,0,0), nil)
	--ParticleEffectAttach(self.DespawnEffect,PATTACH_POINT_FOLLOW,self,1)
	timer.Simple(1,function() self:Remove()end)
end
*/
-----------------------------------------------------------]]



function ENT:OnRemove()
 	if ( self.Sound ) then
		self.Sound:Stop()
	end
		self:StopParticles()
end


if ( SERVER ) then return end -- We do NOT want to execute anything below in this FILE on SERVER



function ENT:Draw()
	
	--if(self.RenderModel) then
		self:DrawModel()
	   	self:drawInfo()
	--end
end

function ENT:drawInfo()
    local Pos = self:GetPos()
    local Ang = self:GetAngles() --+ Angle(0,90,0)

    surface.SetFont("CloseCaption_Bold")
    local text = "Sacrifice me Stuff!"
   	--local text = "Sacrifice me " ..amount .." more objects"
    local TextWidth = surface.GetTextSize(text)

    Ang:RotateAroundAxis(Ang:Forward(), 90)
    Ang:RotateAroundAxis(Ang:Right(), 90)
    Pos = Pos + Ang:Right() * 5

    TextWidth = surface.GetTextSize(text)
  
    cam.Start3D2D(Pos + Ang:Up() * 30 , Ang, 0.2)
        draw.WordBox(5, -TextWidth * 0.5 -5, -150, text, "CloseCaption_Bold", Color(125, 255, 0, 100), Color(255, 255, 255, 255))
    cam.End3D2D()
end

