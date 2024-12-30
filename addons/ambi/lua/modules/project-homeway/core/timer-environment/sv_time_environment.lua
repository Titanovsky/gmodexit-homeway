SetGlobal2String( 'time_environment', 'day' )

function Ambi.Homeway.SetTimeEnvironment( sTime )
    SetGlobal2String( 'time_environment', sTime )

    if ( sTime == 'night' ) then engine.LightStyle( 0, 'b' )
    elseif ( sTime == 'xmas' ) then engine.LightStyle( 0, 'b' )
    elseif ( sTime == 'halloween' ) then engine.LightStyle( 0, 'c' )
    elseif ( sTime == 'dawn' ) then engine.LightStyle( 0, 'd' )
    else engine.LightStyle( 0, 'm' )
    end

    net.Start( 'ambi_homeway_time_environment' )
    net.Broadcast()
end

net.AddString( 'ambi_homeway_time_environment' )

timer.Create( 'Ambi.Homeway.SetTime', 60 * 10, 0, function() 
    -- UPD 22.12.2024 убрал из-за новой карты
    -- local h = os.date( '%H', os.time() )

    -- if ( h == '18' ) then
    --     if ( GetGlobal2String( 'time_environment' ) ~= 'night' ) then Ambi.Homeway.SetTimeEnvironment( 'night' ) end
    -- elseif ( h == '6' ) then
    --     if ( GetGlobal2String( 'time_environment' ) ~= 'day' ) then Ambi.Homeway.SetTimeEnvironment( 'day' ) end
    -- end
end )