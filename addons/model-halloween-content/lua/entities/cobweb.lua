
-- Add the files that need to be downloaded
resource.AddFile( 'models/Zerochain/props_halloween/cobweb.mdl' )

resource.AddFile( 'materials/props_halloween/cobweb.vtf' )
resource.AddFile( 'materials/props_halloween/cobweb.vmt' )

resource.AddFile( 'materials/particles/spiderweb.vmt' )
resource.AddFile( 'materials/particles/spiderweb.vtf' )

AddCSLuaFile( "lua/effects/spiderweb/init.lua" )

---------------------------------------------------------------
------ Model & Design by: Zerochain | Coding by : Zerochain ---
---------------------------------------------------------------



AddCSLuaFile()
--DEFINE_BASECLASS( "base_gmodentity" )

ENT.Type = "anim"
ENT.Base = "base_anim"

ENT.PrintName = "Spider Web"
ENT.Author = "ClemensProduction aka Zerochain"
ENT.Information = "Makes you slower"
ENT.Category = "Halloween Stuff"


ENT.Spawnable = true
ENT.AdminOnly = false
ENT.Entities = {}

function ENT:SpawnFunction( ply, tr )                   -- 膆nlich wie die Initialize Funktion Standard SEnt Funktion
                                                        -- Sie beschreibt was er tun soll wenn man das Entity spawnt
        if ( !tr.Hit ) then return end

        local SpawnPos = tr.HitPos + tr.HitNormal * 10  -- Speichert die Position wo der Spieler grade hinguckt

        local ent = ents.Create( "cobweb" )      -- Definiert dass wir wirklich dieses SEnt spawnen
        ent:SetPos( SpawnPos )                          -- Definiert Position unseres SEnts
        ent:Spawn()                                     -- Spawnt das SEnt
        ent:Activate()                                  -- Unser Script bzw. das SEnt
        return ent
end
-----------------------------------------------------------]]



-----------------------------------------------------------]]
function ENT:Initialize()

	-- We do NOT want to execute anything below in this FUNCTION on CLIENT
	if ( CLIENT ) then return end

	self.Entity.GotUsed = false

	self:SetModel( "models/zerochain/props_halloween/cobweb.mdl" )
	self.Entity:SetModelScale(math.random(2,3),0.5)

	self.Entity:DrawShadow(false)
	self.Entity:SetSkin( 1 )

    self.Entity:PhysicsInit( SOLID_VPHYSICS )
    self.Entity:SetMoveType( MOVETYPE_NONE )
    self.Entity:SetSolid( SOLID_VPHYSICS )

    self.Entity:SetTrigger(true)


    --self.Entity:UseTriggerBounds(true, 1)

    --local sequence = self:LookupSequence( "wave" )
	--self:SetSequence( sequence )
	--self:ResetSequence( sequence )

	--PrintTable(self:GetSequenceList())

    local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
	    phys:Wake()
		--phys:SetMass(50)
        phys:EnableMotion(false)
	end

	self.Entity.pos = self.Entity:GetPos()

end


--[[---------------------------------------------------------
	Name: Startouch
-----------------------------------------------------------]]
function ENT:StartTouch( activator )

  if ( activator:IsPlayer() && !activator:GetNWBool("IsSlowed")) then
    if(!GotUsed) then
      activator:SetNWBool("IsSlowed", true)

      self.Entity:SetModelScale(6,0.25)
      local walk = activator:GetWalkSpeed()
      local run = activator:GetRunSpeed()
      local jump = activator:GetJumpPower()
      timer.Create("ResetPlayerSpeed".. self.Entity:EntIndex(), 2, 1, function() self:ResetPlayerSpeed(activator,walk,run,jump) end)

      activator:SetJumpPower(5)
      activator:SetWalkSpeed(20)
      activator:SetRunSpeed(40)

      self.Entity.GotUsed = true

      self.Entity:SetSolid( SOLID_CUSTOM )
      self:TouchEffect()
    end
  else
    --print("Entity is already slowed down!")
  end
end




function ENT:ResetPlayerSpeed(owner,walk,run,jump)

  owner:SetJumpPower(jump)
  owner:SetWalkSpeed(walk)
  owner:SetRunSpeed(run)
  owner:SetNWBool("IsSlowed", false)
  self:Remove()
end

function ENT:TouchEffect()

		local TouchSound =  Sound( "player/footsteps/snow5.wav" )
	 	sound.Play( TouchSound, self:GetPos(), 75, 25,1)

        local part = EffectData()
        part:SetOrigin( self:GetPos())
        part:SetScale( 1 )
        util.Effect( "spiderweb", part)
end

-----------------------------------------------------------]]
function ENT:OnTakeDamage(dmginfo)
	 if !self:IsValid() then return end
  self:Remove()

end
-----------------------------------------------------------]]


function ENT:OnRemove()


      timer.Remove("ResetPlayerSpeed".. self.Entity:EntIndex() )

        local TouchSound =  Sound( "player/footsteps/snow6.wav" )
	 	     sound.Play( TouchSound, self:GetPos(), 75, 25,1)

        local part = EffectData()
        part:SetOrigin( self:GetPos())
        part:SetScale( 1 )
        util.Effect( "spiderweb", part)
end


if ( SERVER ) then return end -- We do NOT want to execute anything below in this FILE on SERVER


function ENT:Draw()

	self:DrawModel()

	local Pos = self:GetPos() + self:GetUp()* -2


end
