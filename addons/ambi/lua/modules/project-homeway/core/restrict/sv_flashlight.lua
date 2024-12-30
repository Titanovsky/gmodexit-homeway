hook.Add( 'PlayerSwitchFlashlight', 'Ambi.Homeway.StopFlashlightSpam', function( ePly ) 
    if timer.Exists( 'Ambi.Homeway.StaminaFlashlight:'..ePly:SteamID() ) then return false end

    timer.Create( 'Ambi.Homeway.StaminaFlashlight:'..ePly:SteamID(), 1, 1, function() end )
end )