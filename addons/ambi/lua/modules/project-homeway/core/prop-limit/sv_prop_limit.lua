hook.Add( 'PlayerSpawnProp', 'Ambi.Homeway.PropLimit', function( ePly, sModel ) 
    if ePly:HasPropsLimit() then ePly:Notify( 'Вы достигли лимита '..ePly:GetPropsLimit(), 6, NOTIFY_ERROR ) return false end
    if timer.Exists( 'Ambi.Homeway.PropAntiSpam:'..ePly:SteamID() ) then ePly:Notify( 'Нельзя быстро спавнить пропы (Наиграйте 2 часа)', 5, NOTIFY_ERROR ) return false end
end )

hook.Add( 'PlayerSpawnedProp', 'Ambi.Homeway.PropLimit', function( ePly ) 
    if ( ePly:GetTime() < 60 * 60 * 2 ) then timer.Create( 'Ambi.Homeway.PropAntiSpam:'..ePly:SteamID(), 0.5, 1, function() end ) end

    net.Start( 'ambi_homeway_show_prop_limit' )
    net.Send( ePly )
end )

hook.Add( 'PostUndo', 'Ambi.Homeway.PropLimit', function( tUndo ) 
    local owner = tUndo.Owner
    local name = tUndo.Name

    if IsValid( owner ) and ( name == 'Prop' ) then
        net.Start( 'ambi_homeway_show_prop_limit' )
        net.Send( owner )
    end
end )

net.AddString( 'ambi_homeway_show_prop_limit' )