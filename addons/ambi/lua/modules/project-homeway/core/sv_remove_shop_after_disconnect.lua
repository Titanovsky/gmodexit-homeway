hook.Add( '[Ambi.Homeway.Auth]', 'Ambi.Homeway.RemoverShopTimer', function( ePly ) 
    timer.Remove( 'Ambi.Homeway.RemoveShopEntities:'..ePly:SteamID() )
end )

hook.Add( 'PlayerDisconnected', 'Ambi.Homeway.RemoverShopTimer', function( ePly ) 
    local sid = ePly:SteamID()

    timer.Create( 'Ambi.Homeway.RemoveShopEntities:'..sid, FPP.Settings.FPP_GLOBALSETTINGS1.cleanupdisconnectedtime, 1, function() 
        for obj, _ in pairs( Ambi.DarkRP.players_shop_items[ sid ] ) do
            if IsValid( obj ) then obj:Remove() end
        end
    end )
end )