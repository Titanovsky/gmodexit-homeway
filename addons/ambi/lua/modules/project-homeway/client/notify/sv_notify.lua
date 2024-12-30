local PLAYER = FindMetaTable( 'Player' )

-- ---------------------------------------------------------------------------------------------------------------------------------------
function Ambi.Homeway.NotifyAll( sText, nTime, nType, fCheck )
    for _, ply in ipairs( player.GetHumans() ) do
        if fCheck and not fCheck( ply ) then continue end 
        
        ply:Notify( sText, nTime, nType )
    end
end

-- ---------------------------------------------------------------------------------------------------------------------------------------
function PLAYER:Notify( sText, nTime, nType, bDontPlaySound )
    net.Start( 'ambi_homeway_notify' )
        net.WriteString( sText or '' )
        net.WriteUInt( nTime or 2, 9 )
        net.WriteUInt( nType or 0, 3 )
        net.WriteBool( tobool( bDontPlaySound ) )
    net.Send( self )
end

-- ---------------------------------------------------------------------------------------------------------------------------------------
net.AddString( 'ambi_homeway_notify' )