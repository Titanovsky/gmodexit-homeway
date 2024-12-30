local cache_can = {}
local cache_cannot = {}

function Ambi.Homeway.CheckRestrictProp( ePly, sModel )
    if ePly:IsSeniorStaff() then return true end
    if cache_can[ sModel ] then return true end
    if cache_cannot[ sModel ] then return false end

    for _, tab in ipairs( Ambi.Homeway.Config.props ) do
        if ( tab.model == sModel ) then cache_can[ sModel ] = true return true end
    end

    cache_cannot[ sModel ] = true

    return false
end

hook.Add( 'PlayerSpawnProp', 'Ambi.Homeway.RestrictJail', function( ePly, sModel ) 
    if ePly:IsArrested() then ePly:Notify( 'Ты в тюрьме!', 4, NOTIFY_ERROR ) return false end
end )

hook.Add( 'PlayerSpawnProp', 'Ambi.Homeway.Restrict', function( ePly, sModel ) 
    if not Ambi.Homeway.CheckRestrictProp( ePly, sModel ) then ePly:Notify( 'Тебе нельзя этот проп', 4, NOTIFY_ERROR ) return false end
end )

hook.Add( 'PlayerSpawnRagdoll', 'Ambi.Homeway.Restrict', function( ePly ) 
    if not ePly:IsFounder() then return false end
end )

hook.Add( 'PlayerSpawnEffect', 'Ambi.Homeway.Restrict', function( ePly ) 
    if not ePly:IsFounder() then return false end
end )

hook.Add( 'PlayerSpawnVehicle', 'Ambi.Homeway.Restrict', function( ePly ) 
    if not ePly:IsFounder() then return false end
end )

-- ----------------------------------------------------------------------------------------------------------------------------
hook.Add( 'PlayerSpawnNPC', 'Ambi.Homeway.Restrict', function( ePly ) 
    if not ePly:IsRedStaff() then return false end
end )

hook.Add( 'PlayerSpawnSENT', 'Ambi.Homeway.Restrict', function( ePly ) 
    if not ePly:IsRedStaff() then return false end
end )

hook.Add( 'PlayerSpawnSWEP', 'Ambi.Homeway.Restrict', function( ePly ) 
    if not ePly:IsSeniorStaff() then return false end
end )

hook.Add( 'PlayerSpawnedSWEP', 'Ambi.Homeway.Restrict', function( ePly, eWeapon ) 
    eWeapon.cannot_drop = true
end )

hook.Add( 'PlayerGiveSWEP', 'Ambi.Homeway.Restrict', function( ePly ) 
    if not ePly:IsRedStaff() then return false end
end )

hook.Add( '[Ambi.DarkRP.CanArrest]', 'Ambi.Homeway.Restrict', function( ePolice, ePly )
    if not ePly:IsAuth() then return false end
    if ePly:IsJail() then return false end
    if ePly:GetJob() == 'j_admin' then return false end

    if IsValid( ePolice ) and ( ePolice:GetTime() <= 60 * 20 ) then ePolice:Notify( 'Наиграйте 20 минут', 5, NOTIFY_ERROR ) return false end
end )

-- ----------------------------------------------------------------------------------------------------------------------------
local restirct_tools = {
    [ 'permaprops' ] = true,
}

local time_tools = {
    [ 'advdupe2' ] = 2,
    [ 'advdupe' ] = 2,
}

hook.Add( 'CanTool', 'Ambi.Homeway.Restrict', function( ePly, _, sTool ) 
    if restirct_tools[ sTool ] and not ePly:IsRedStaff() then return false end
    if time_tools[ sTool ] and ( ePly:GetTime() < 60 * 60 * time_tools[ sTool ] ) then ePly:Notify( 'Наиграйте '..time_tools[ sTool ]..' часов', 3, NOTIFY_ERROR ) return false end
end )