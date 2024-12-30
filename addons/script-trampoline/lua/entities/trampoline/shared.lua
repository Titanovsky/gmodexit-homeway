ENT.Type			= "anim"
ENT.Base			= "base_anim"
ENT.PrintName		= "Trampoline"
ENT.Author			= "MacDGuy/Voided"
ENT.Contact			= "http://www.gmtower.org"
ENT.Purpose			= "Jump around all crazy like!"
ENT.Category		= "Fun + Games"
ENT.Spawnable		= true
ENT.AdminSpawnable 	= true

AddCSLuaFile()

function ENT:Boing()

    local seq = self:LookupSequence( "bounce" )
    
    if ( seq == -1 ) then return end
    
    self:ResetSequence( seq )
    
end

if SERVER then

    function ENT:SpawnFunction( ply, tr )

        if !tr.Hit then return end
    
        local SpawnPos = tr.HitPos + tr.HitNormal * 16
        local ent = ents.Create( "trampoline" )
        ent:SetPos( SpawnPos + Vector( 0, 0, 4 ) )
        ent:Spawn()
        ent:Activate()

        return ent

    end

    function ENT:Initialize()

        self:SetModel( "models/gmod_tower/trampoline.mdl" )

        self:PhysicsInit( SOLID_VPHYSICS )
        self:SetMoveType( MOVETYPE_VPHYSICS )
        self:SetSolid( SOLID_VPHYSICS )

        self:DrawShadow( true )

        local phys = self:GetPhysicsObject()
        if IsValid( phys ) then
            phys:Wake()
        end

    end

    function ENT:PhysicsCollide( data, phys )

        local ent = data.HitEntity
        if !IsValid( ent ) then return end

        local norm = data.HitNormal * -1
        local dot = self:GetUp():Dot( data.HitNormal )
        if math.abs( dot ) < 0.5 then return end

        local scale = math.Rand( 1, 1.25 )
        local dist = 250 * scale // at this scale, [250-312.5]
        local pitch = 100 * scale // [100-125]

        local mulNorm = norm * dist
        if ( mulNorm.z < 0 ) then mulNorm.z = -mulNorm.z end

        if ent:IsPlayer() || ent:IsNPC() then
            physent = ent
        else
            physent = ent:GetPhysicsObject()
        end

        if IsValid( physent ) then
            physent:SetVelocity( mulNorm )
        end

        ent:EmitSound( "GModTower/misc/boing.wav", 85, pitch )
        self:Boing()

        local stars = EffectData()
            stars:SetOrigin( data.HitPos )
            stars:SetNormal( data.HitNormal )
        util.Effect( "trampoline_stars", stars )

        umsg.Start( "ToyTramp" )
            umsg.Entity( self )
        umsg.End()

    end    

else // CLIENT

    function ENT:Draw() self:DrawModel() end

    usermessage.Hook( "ToyTramp", function( um )

        local ent = um:ReadEntity()
        if ent == nil || !IsValid( ent ) then return end

        if ent.Boing then
           ent:Boing()
        end

    end )


    local EFFECT = {}
    function EFFECT:Init( data )

        local vOffset = data:GetOrigin()
        local vNorm = data:GetNormal()

        local NumParticles = 8
    
        local emitter = ParticleEmitter( vOffset )
        for i=0, NumParticles do
            local particle = emitter:Add( "sprites/star", vOffset )
            if particle then
                local angle = vNorm:Angle()
                particle:SetVelocity( angle:Forward() * math.Rand( 0, 200 ) + angle:Right() * math.Rand( -200, 200 ) + angle:Up() * math.Rand( -200, 200 ) )
                particle:SetLifeTime( 0 )
                particle:SetDieTime( 1 )
                particle:SetStartAlpha( 255 )
                particle:SetEndAlpha( 0 )
                particle:SetStartSize( 8 )
                particle:SetEndSize( 2 )

                local col = Color( 255, 0, 0 )
                if i > 2 then
                    col = Color( 255, 255, 0 )
                    col.g = col.g - math.random(0, 50)
                end
                particle:SetColor( col.r, col.g, math.Rand( 0, 50 ) )
                particle:SetRoll( math.Rand( 0, 360 ) )
                particle:SetRollDelta( math.Rand( -2, 2 ) )
                particle:SetAirResistance( 100 )
                particle:SetGravity( vNorm * 15 )
            end
        end
        emitter:Finish()
    end

    function EFFECT:Think() return false end
    function EFFECT:Render() end

    effects.Register( EFFECT, "trampoline_stars" )

end