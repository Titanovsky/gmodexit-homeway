hook.Add( '[Ambi.Warn.GiveWarn]', 'Ambi.Homeway.Warn', function( ePly, nID ) 
    local time = 60 * 60 * Ambi.Homeway.Config.warn_time_remove
    timer.Create( 'Ambi.Warn.RemoveID:'..nID..' SteamID:'..ePly:SteamID(), time, 1, function() 
        if not IsValid( ePly ) then return end

        ePly:Notify( 'У вас истёк варн под ID '..nID, 15 )
        ePly:UnWarn( nID )
    end )

    if ( nID < Ambi.Homeway.Config.warn_max ) or ePly:IsStaff() then return end

    ePly:RemoveAllWarns()
    
    RunConsoleCommand( 'ulx', 'ban', ePly:Name(), 60 * 24 * 4, 'Достиг лимита варнов' )
end )

hook.Add( '[Ambi.Homeway.Auth]', 'Ambi.Homeway.Warn', function( ePly ) 
    local warns = ePly:GetWarns()
    if ( #warns == 0 ) then return end

    for i = #warns, 1, -1 do
        local warn = warns[ i ]
        local date = warn.date + 60 * 60 * Ambi.Homeway.Config.warn_time_remove
        local id = warn.id

        if ( date <= os.time() ) then 
            ePly:Notify( 'У вас истёк варн под ID '..warn.id, 15 )
        
            ePly:UnWarn( warn.id )

            continue 
        end

        local time = date - os.time()
        timer.Create( 'Ambi.Warn.RemoveID:'..id..' SteamID:'..ePly:SteamID(), time, 1, function() 
            if not IsValid( ePly ) then return end

            ePly:Notify( 'У вас истёк варн под ID '..id, 15 )
            ePly:UnWarn( id )
        end )
    end

    for id, warn in ipairs( ePly:GetWarns() ) do
        ePly:ChatSend( '~FLAT_RED~ [Warn] ~W~ '..id..'. '..warn.reason )
    end

    ePly:ChatSend( '~FLAT_RED~ [Warn] ~W~ У вас ~FLAT_RED~ '..#ePly:GetWarns()..' ~W~ варнов' )
end )

hook.Add( '[Ambi.Warn.RemoveWarn]', 'Ambi.Homeway.RemoveTimerWarn', function( ePly, nID )
    timer.Remove( 'Ambi.Warn.RemoveID:'..nID..' SteamID:'..ePly:SteamID() )
end )

-- ----------------------------------------------------------------------------------------------
hook.Add( '[Ambi.Homeway.Auth]', 'Ambi.Homeway.DonateWarn', function( ePly ) 
    local warns = ePly:GetDonateWarns()
    if ( #warns == 0 ) then return end

    for id, warn in ipairs( ePly:GetDonateWarns() ) do
        ePly:ChatSend( '~AMBI_YELLOW~ [Donate Warn] ~W~ '..id..'. '..warn.reason )
    end

    ePly:ChatSend( '~AMBI_YELLOW~ [Donate Warn] ~W~ У вас ~AMBI_YELLOW~ '..#ePly:GetDonateWarns()..' ~W~ варнов' )
end )

-- ----------------------------------------------------------------------------------------------
hook.Add( '[Ambi.Homeway.Auth]', 'Ambi.Homeway.AdminWarn', function( ePly ) 
    local warns = ePly:GetAdminWarns()
    if ( #warns == 0 ) then return end

    for id, warn in ipairs( warns ) do
        ePly:ChatSend( '~AU_SOFT_PURPLE~ [Admin Warn] ~W~ '..id..'. '..warn.reason )
    end

    ePly:ChatSend( '~AU_SOFT_PURPLE~ [Admin Warn] ~W~ У вас ~RED~ '..#warns..' ~W~ варнов' )
end )