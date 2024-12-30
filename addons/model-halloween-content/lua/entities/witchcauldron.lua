
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

ENT.PrintName = "Normal WitchCauldron"
ENT.Author = "ClemensProduction aka Zerochain"
ENT.Information = "Bubbles"
ENT.Category = "Halloween Stuff"

ENT.Spawnable = true
ENT.AdminOnly = false

ENT.Effect    =  "soup_bubbles01" 


function ENT:SpawnFunction( ply, tr )                   -- 膆nlich wie die Initialize Funktion Standard SEnt Funktion
                                                        -- Sie beschreibt was er tun soll wenn man das Entity spawnt 
        if ( !tr.Hit ) then return end                  
         
        local SpawnPos = tr.HitPos + tr.HitNormal * 2 -- Speichert die Position wo der Spieler grade hinguckt
         
        local ent = ents.Create( "witchcauldron" )      -- Definiert dass wir wirklich dieses SEnt spawnen
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
	--end
end



