function Ambi.Date.SendPlayerTime( ePly )
    net.Start( 'ambi_date_replication_time' )
        net.WriteTable( Ambi.Date.time )
        net.WriteFloat( timer.TimeLeft( 'Date' ) )
    net.Send( ePly )
end

function Ambi.Date.SendPlayersTime()
    net.Start( 'ambi_date_replication_time' )
        net.WriteTable( Ambi.Date.time )
        net.WriteFloat( timer.TimeLeft( 'Date' ) )
    net.Broadcast()
end

-- ---------------------------------------------------------------------------------------------------------------------------------------
hook.Add( 'PostGamemodeLoaded', 'Ambi.Date.Start', function()
    Ambi.Date.Go()
end )

net.AddString( 'ambi_date_replication_time' )
hook.Add( 'PlayerInitialSpawn', 'Ambi.Date.SendTime', function( ePly ) 
    Ambi.Date.SendPlayerTime( ePly )

    timer.Simple( 10, function()
        if IsValid( ePly ) then Ambi.Date.SendPlayerTime( ePly ) end
    end )
end )