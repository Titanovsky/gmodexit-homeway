CreateConVar( "taser_duration", "5", FCVAR_NONE, "The stun duration of the taser." )
CreateConVar( "taser_damage", "0.5", FCVAR_NONE, "The damage of the taser." )
CreateConVar( "taser_delay", "7", FCVAR_NONE, "The delay of each shot." )
CreateConVar( "taser_range", "450", FCVAR_NONE, "The range of the taser." )

hook.Add( "PhysgunPickup", "ced_disable_when_tased", function( _, ent )
    if ( ent:GetNWBool( "ced_tased" ) ) then return false end
end )

hook.Add( "EntityTakeDamage", "ced_ragdoll_damage", function( ent, data )
    if ( ent:GetClass() == "prop_ragdoll" and ent.OwnerEnt != nil ) then
        if ( data:GetAttacker():GetClass() == "worldspawn" and IsValid( ent.OwnerEnt ) ) then
            ent.OwnerEnt:TakeDamage( data:GetDamage() / 12, data:GetAttacker(), data:GetInflictor() )
        elseif ( IsValid( ent.OwnerEnt ) ) then
            ent.OwnerEnt:TakeDamage( data:GetDamage(), data:GetAttacker(), data:GetInflictor() )
        end
    end
end )

hook.Add( "Think", "ced_tased_entity_pos", function()
    for _, ent in pairs( ents.GetAll() ) do
        if ( ent:GetNWBool( "ced_tased" ) and IsValid( ent:GetNWEntity( "ced_ragdoll_entity" ) ) ) then
            ent:SetVelocity( Vector( 0, 0, 0 ) )
            ent:SetPos( ent:GetNWEntity( "ced_ragdoll_entity" ):GetPos() )
        end
    end
end )

hook.Add( "PlayerSpawn", "ced_remove_tased_ragdoll", function( ply )
    if ( IsValid( ply:GetNWEntity( "ced_ragdoll_entity" ) ) ) then
        ply:GetNWEntity( "ced_ragdoll_entity" ):Remove()
        ply:SetNWEntity( "ced_ragdoll_entity", nil )
    end
	
	if ( ply:GetNWBool( "ced_tased" ) ) then
		ply:Freeze( false )
		ply:SetNWBool( "ced_tased", false )
	end
end )

hook.Add( "PlayerSwitchWeapon", "ced_prevent_switch_when_tased", function(ply)
    if ( ply:GetNWBool( "ced_tased" ) ) then
        return true
    end
end )

hook.Add( "PostPlayerDeath", "ced_remove_ragdoll", function( ply )
	if ( ply:GetNWBool( "ced_tased" ) ) then
		ply:GetRagdollEntity():Remove()
	end
end ) 

hook.Add( "PlayerDisconnected", "ced_remove_tased_ragdoll", function( ply )
	if ( IsValid( ply:GetNWEntity( "ced_ragdoll_entity" ) ) ) then
        ply:GetNWEntity( "ced_ragdoll_entity" ):Remove()
        ply:SetNWEntity( "ced_ragdoll_entity", nil )
    end
end )

hook.Add( "Shutdown", "ced_remove_tased_ragdoll", function()
	for _, ply in pairs( player.GetAll() ) do
		if ( IsValid( ply:GetNWEntity( "ced_ragdoll_entity" ) ) ) then
			ply:GetNWEntity( "ced_ragdoll_entity" ):Remove()
			ply:SetNWEntity( "ced_ragdoll_entity", nil )
		end
	end
end )