AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_gmodentity"
 
ENT.PrintName = "Admin Taser Prong"
ENT.Author = "Ced"

ENT.Released = false

if ( CLIENT ) then 
	function ENT:Draw()
		self:DrawModel()
	end

	return 
end

function ENT:Initialize()
	self:SetModel( "models/hunter/blocks/cube025x025x025.mdl" )
    self:SetModelScale( 0.05 )
    self:SetMaterial( "models/debug/debugwhite" )
    self:SetColor( Color( 100, 100 ,100 ) )

    self:SetNoDraw( true )
	
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	self:PhysicsInit( SOLID_VPHYSICS )
	
	local phys = self:GetPhysicsObject()
	if ( IsValid( phys ) ) then
		phys:Wake()
	end

    timer.Create( "Cleanup" .. self:EntIndex(), GetConVar( "taser_duration" ):GetInt(), 1, function()
        if ( IsValid( self ) ) then
            self:Remove()
        end
    end )
end

local function CleanUp( ragdoll, ent, weapon, rendermode, movetype, time )
    if ( IsValid( ragdoll ) ) then
        if ( IsValid( ent ) ) then
            ent:SetPos(ragdoll:GetPos())
        end

        if ( ent:IsPlayer() and ent:Alive() or ent:IsNPC() ) then  
            ragdoll:Remove()
        end
    end
        
    if ( not IsValid( ent ) ) then return end

    ent:SetRenderMode( rendermode )
    ent:SetMoveType( movetype )
    ent:DrawShadow( true )
    ent:SetNotSolid( false )

    ent:SetNWBool( "ced_tased", false )

    if ( ent:IsPlayer() ) then
        ent:Freeze( false )
        ent:DrawViewModel( true )
    else
        ent:ClearCondition( 67 )
        ent:SetCondition( 68 )
    end

    if ( IsValid( weapon ) ) then
        weapon:SetNoDraw( false )
    end
end

local function Ragdoll( ent, self )
    if ( not IsValid( ent ) or IsValid( ent ) and ent:Health() <= 0 ) then return end

    local movetype = ent:GetMoveType()
    local rendermode = ent:GetRenderMode()

    ent:SetRenderMode( RENDERMODE_NONE )
    ent:SetMoveType( MOVETYPE_NONE ) 
    ent:DrawShadow( false )
    ent:SetNotSolid( true )

    if ( ent:IsPlayer() ) then
        ent:Freeze( false )
        ent:DrawViewModel( false )
    elseif ( ent:IsNPC() ) then
        ent:ClearCondition( 68 )
        ent:SetCondition( 67 )
    end

    local weapon = ent:GetActiveWeapon()
    if ( IsValid( weapon ) ) then
        weapon:SetNoDraw( true )
    end

    ent:SetNWBool( "ced_tased", true )

    local ragdoll = ents.Create( "prop_ragdoll" )
    if ( not IsValid( ragdoll ) ) then return end

    ragdoll:SetModel( ent:GetModel() )
    ragdoll:SetPos( ent:GetPos() )
    ragdoll:SetAngles( ent:GetAngles() )
    ragdoll:SetVelocity( ent:GetVelocity() )
    ragdoll:Spawn()

    ragdoll:SetHealth( ent:Health() )
    ragdoll.OwnerEnt = ent
    ent:SetNWEntity( "ced_ragdoll_entity", ragdoll )

    local num = ragdoll:GetPhysicsObjectCount() - 1
    local v = ent:GetVelocity()

    for i=0, num do
        local bone = ragdoll:GetPhysicsObjectNum( i )

        if ( IsValid( bone ) ) then
            local bp, ba = ent:GetBonePosition( ragdoll:TranslatePhysBoneToBone( i ) )
            if ( bp and ba ) then
                bone:SetPos( bp )
                bone:SetAngles( ba )
            end

            bone:SetVelocity( v )
        end
    end
	
	timer.Create( "valid_ragdoll_check" .. ent:EntIndex(), 0, 0, function()
		if ( not IsValid( ragdoll ) ) then
			CleanUp( nil, ent, weapon, rendermode, movetype )
			timer.Destroy( "valid_ragdoll_check" .. ent:EntIndex() )
		end
	end )

    timer.Create( "death_check" .. ent:EntIndex(), 0, 0, function()
        if ( IsValid( ragdoll ) and IsValid( ent ) and ent:IsNPC() and ent:Health() <= 0 ) then
            ragdoll:Remove()
        end
    end )
	
	timer.Create( "release_check" .. ent:EntIndex(), 0, 0, function()
		if ( self.Released ) then
			self.Target = nil
			CleanUp( ragdoll, ent, weapon, rendermode, movetype )

			timer.Destroy( "death_check" .. ent:EntIndex() )
		end
	end	)
end

function ENT:Touch( ent )
    --if ( ent == self.Owner or self.Touched == true or ent:GetClass() == "npc_rollermine" ) then return end

    local speed = self:GetVelocity():Length()
        
    if ( speed > 200 and ( ent:IsPlayer() or ent:IsNPC() ) ) then
        self.Touched = true

        if timer.Exists( "Cleanup" .. self:EntIndex() ) then 
            timer.Remove( "Cleanup" .. self:EntIndex() )
        end

        self.Sparks = EffectData()
        self.Sparks:SetOrigin( self:GetPos() )
            
        for i=5, 0, -1 do
            util.Effect( "StunstickImpact", self.Sparks )
        end

        if ( self.TaserHitSound == nil ) then
            self.TaserHitSound = true
            ent:EmitSound( Sound( "ced/taser/taser_hit.wav" ) )
        end
        
        Ragdoll( ent, self )
        self:SetParent( ent:GetNWEntity( "ced_ragdoll_entity" ) )
        self:SetMoveType( MOVETYPE_NOCLIP )

        self.Target = ent

        local ragdoll = ent:GetNWEntity( "ced_ragdoll_entity" )
		if ( not IsValid( ragdoll ) ) then return end
		
        local effect = EffectData()
		effect:SetOrigin( ragdoll:GetPos() )
		effect:SetStart( ragdoll:GetPos() )
		effect:SetMagnitude( 5 )
		effect:SetEntity( ragdoll )

		util.Effect( "teslaHitBoxes", effect )
		ragdoll:EmitSound( "Weapon_StunStick.Activate" )

		timer.Create( "Electricity" .. self:EntIndex(), 0.35, 0, function()
            if ( not IsValid( ragdoll ) ) then 
                timer.Destroy( "Electricity" .. self:EntIndex() )

                return
            end
			
			if ( IsValid( ent ) and ( ent:IsPlayer() and not ent:Alive() ) ) then 
				ragdoll:Ignite()
			elseif ( IsValid( ent ) and ent:IsNPC() and ent:Health() <= 0 ) then
				ragdoll:Ignite()
			end

            local effect2 = EffectData()
            effect2:SetOrigin( ragdoll:GetPos() )
            effect2:SetStart( ragdoll:GetPos() )
            effect2:SetMagnitude( 5 )
            effect2:SetEntity( ragdoll )

            util.Effect( "teslaHitBoxes", effect2 )
            ragdoll:EmitSound( "Weapon_StunStick.Activate" )

            ragdoll:Fire( "StartRagdollBoogie", "", 0 )
		end )
    end
end