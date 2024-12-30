net.AddString( 'ambi_homeway_perma_weapon_choice', function( _, ePly ) 
    local id = net.ReadUInt( 7 )
    local item = Ambi.Homeway.Config.perma_weapons[ id ]
    if not item then return end
    
    if not ePly:CheckPermaWeapon( id ) then return end
    if ( ePly:IsPolice() or ePly:IsMafia() or ePly:IsFBI() ) then ePly:Notify( 'Временно нельзя для ФБР, Полиции и Мафии', 10, NOTIFY_ERROR ) return false end -- todo remove
    if not ePly:Alive() then return end

    if timer.Exists( 'Ambi.Homeway.PermaWeaponsDelay:'..id..':'..ePly:SteamID() ) then ePly:Notify( 'Подождите: '..math.floor( timer.TimeLeft( 'Ambi.Homeway.PermaWeaponsDelay:'..id..':'..ePly:SteamID() ) )..' сек', 6, NOTIFY_ERROR ) return end
    timer.Create( 'Ambi.Homeway.PermaWeaponsDelay:'..id..':'..ePly:SteamID(), item.delay, 1, function() end )

    ePly:Give( item.class )

    ePly:GetWeapon( item.class ).cannot_drop = true
    
    ePly:Notify( 'Вы взяли перма оружие: '..item.header, 5 )
end )

hook.Add( 'PlayerSpawn', 'Ambi.Homeway.ReloadDelayPermaWeapons', function( ePly ) 
    for id, item in ipairs( Ambi.Homeway.Config.perma_weapons ) do
        timer.Create( 'Ambi.Homeway.PermaWeaponsDelay:'..id..':'..ePly:SteamID(), item.delay, 1, function() end )
    end
end )