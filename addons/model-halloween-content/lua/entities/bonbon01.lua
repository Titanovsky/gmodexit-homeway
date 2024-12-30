
-- Add the files that need to be downloaded
resource.AddFile( 'models/Zerochain/props_halloween/bonbon01.mdl' )

resource.AddFile( 'materials/props_halloween/bonbon01.vtf' )
resource.AddFile( 'materials/props_halloween/bonbon01.vmt' )
resource.AddFile( 'materials/props_halloween/bonbon_normal.vtf' )
resource.AddFile( 'materials/props_halloween/lod01_bonbon01.vmt' )

resource.AddFile( 'materials/particles/pumbkinface01.vmt' )
resource.AddFile( 'materials/particles/pumbkinface01.vtf' )
resource.AddFile( "sound/NomNom.wav" )

AddCSLuaFile( "lua/effects/sweetspickup/init.lua" )

---------------------------------------------------------------
------ Model & Design by: Zerochain | Coding by : Zerochain ---
---------------------------------------------------------------



AddCSLuaFile()
DEFINE_BASECLASS( "base_gmodentity" )

ENT.PrintName = "Bonbon"
ENT.Author = "ClemensProduction aka Zerochain"
ENT.Information = "An edible item"
ENT.Category = "Halloween Stuff"

ENT.Editable = true
ENT.Spawnable = true
ENT.AdminOnly = false




function ENT:SpawnFunction( ply, tr )                   -- 膆nlich wie die Initialize Funktion Standard SEnt Funktion
                                                        -- Sie beschreibt was er tun soll wenn man das Entity spawnt 
        if ( !tr.Hit ) then return end                  
         
        local SpawnPos = tr.HitPos + tr.HitNormal * 25  -- Speichert die Position wo der Spieler grade hinguckt
         
        local ent = ents.Create( "bonbon01" )      -- Definiert dass wir wirklich dieses SEnt spawnen
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

	self:SetModel( "models/Zerochain/props_halloween/bonbon01.mdl" )

	local hue = math.abs(math.sin(math.random(1,25) *0.9) *355)
	local RandCol = HSVToColor(hue, 1, 1)
	self.Entity:SetColor(RandCol)


	self.Entity:SetSkin( 1 )
    self.Entity:PhysicsInit( SOLID_VPHYSICS )   
    self.Entity:SetMoveType( MOVETYPE_VPHYSICS )
    self.Entity:SetSolid( SOLID_VPHYSICS )

    local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
	    phys:Wake()
		--phys:SetMass(50)
        phys:EnableMotion(true)
	end

	self.Entity.pos = self.Entity:GetPos()

end




--[[---------------------------------------------------------
	Name: OnTakeDamage
-----------------------------------------------------------]]
function ENT:OnTakeDamage( dmginfo )

	-- React physically when shot/getting blown
	self:TakePhysicsDamage( dmginfo )

end




--[[---------------------------------------------------------
	Name: Use
-----------------------------------------------------------]]
local EatSound = Sound( "NomNom.wav" )
function ENT:Use( activator, caller )

	self:Remove()

	if ( activator:IsPlayer() ) then

		-- Give the collecting player some free health
		local health = activator:Health()
		activator:SetHealth( health + 5 )
	end

end


function ENT:OnRemove() 
        sound.Play( EatSound, self:GetPos(), 75, 100,1)
        sound.Play( "garrysmod/balloon_pop_cute.wav", self:GetPos(), 75, math.random(50,60),0.3 )

        local col = self:GetColor(); 
        local part = EffectData()
        part:SetOrigin( self:GetPos())
        part:SetStart(Vector(col.r, col.g, col.b))
        part:SetScale( 1 )
        util.Effect( "sweetspickup", part)
end

if ( SERVER ) then return end -- We do NOT want to execute anything below in this FILE on SERVER


function ENT:Draw()

	self:DrawModel()

	local Pos = self:GetPos() + self:GetUp()* -2


end
