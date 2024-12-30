local HOOKS = {
    'PlayerSpawnObject',
    'PlayerSpawnNPC',
    'PlayerSpawnVehicle',
    'PlayerSpawnSWEP',
    'PlayerGiveSWEP',
    'PlayerSwitchWeapon',
    'PlayerSwitchFlashlight',
    'PlayerNoClip',
    'PlayerShouldTakeDamage',
    'PlayerSay',
    'CanTool',
    'CanProperty',
    'CanUndo',
    'PlayerUse',
    'AllowPlayerPickup',
    'CanPlayerSuicide',
    'CanPlayerEnterVehicle',
    'PlayerCanPickupItem',
    'PlayerLeaveVehicle',
    'PlayerLoadout',
    'PlayerSpray',
    'PlayerStartTaunt',
    'CanPlayerUnfreeze',
    'OnPhysgunReload',
    'PlayerCanHearPlayersVoice',
}

-- ---------------------------------------------------------------------------------------------------------------------------------------в
for _, value in ipairs( HOOKS ) do
    hook.Add( value, 'Ambi.Homeway.AuthBlock', function( ePly )
        if not ePly:IsAuth() then return false end
    end )
end

hook.Add( 'CuffsCanHandcuff', 'Ambi.Homeway.AuthBlock', function( ePly, eVictim ) 
    if not eVictim:IsAuth() then return false end
end )