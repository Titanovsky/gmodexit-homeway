hook.Add( 'PostGamemodeLoaded', 'Ambi.Homeway.ChangeSkinDoorForGunDealer', function() 
    if ( game.GetMap() == 'rp_bangclaw' ) then
        timer.Simple( 0, function()
            local door = Entity( 380 )

            door:SetSkin( 13 )
            door:SetColor( Color( 208, 118, 118, 255 ) )
            door:Fire( 'Open', '1' )
            door:Fire( 'Lock', '1' )
        end )
    elseif ( game.GetMap() == 'rp_bangclaw_drp_winter_v1') then
        timer.Simple( 0, function()
            local door = Entity( 378 )

            door:SetSkin( 13 )
            door:SetColor( Color( 208, 118, 118, 255 ) )
            door:Fire( 'Open', '1' )
            door:Fire( 'Lock', '1' )
        end )
    end
end )

hook.Add( 'PostGamemodeLoaded', 'Ambi.Homeway.RemoveHuinaForBangclaw', function() 
    if ( game.GetMap() == 'rp_bangclaw' ) then 
        timer.Simple( 0, function()
            Entity( 371 ):Remove()
            Entity( 372 ):Remove()

            Entity( 434 ):Remove() -- забор сзади ПУ 1
            Entity( 435 ):Remove() -- забор сзади ПУ 2
        end )
    elseif ( game.GetMap() == 'rp_bangclaw_drp_winter_v1') then
        --
    end
end )

hook.Add( 'PostGamemodeLoaded', 'Ambi.Homeway.OpenPrisonDoors', function() 
    if ( game.GetMap() == 'rp_bangclaw' ) then 
        timer.Simple( 0, function()
            Entity( 311 ):Fire( 'Unlock' )
            Entity( 311 ):Fire( 'Open' )
            Entity( 311 ):Fire( 'Lock' )

            Entity( 312 ):Fire( 'Unlock' )
            Entity( 312 ):Fire( 'Open' )
            Entity( 312 ):Fire( 'Lock' )

            Entity( 313 ):Fire( 'Unlock' )
            Entity( 313 ):Fire( 'Open' )
            Entity( 313 ):Fire( 'Lock' )
        end )
    elseif ( game.GetMap() == 'rp_bangclaw_drp_winter_v1') then
        timer.Simple( 0, function()
            Entity( 311 ):Fire( 'Unlock' )
            Entity( 311 ):Fire( 'Open' )
            Entity( 311 ):Fire( 'Lock' )

            Entity( 990 ):Fire( 'Unlock' )
            Entity( 990 ):Fire( 'Open' )
            Entity( 990 ):Fire( 'Lock' )

            Entity( 991 ):Fire( 'Unlock' )
            Entity( 991 ):Fire( 'Open' )
            Entity( 991 ):Fire( 'Lock' )
        end )
    end
end )