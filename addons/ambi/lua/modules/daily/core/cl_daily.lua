Ambi.Daily.patterns = Ambi.Daily.patterns or {}
Ambi.Daily.dailies = Ambi.Daily.dailies or {}

-- ------------------------------------------------------------------------------------------------------------
net.Receive( 'ambi_daily_sync', function() 
    local id = net.ReadUInt( 10 )
    local count = net.ReadUInt( 23 )
    local class = net.ReadString()
    local features = net.ReadTable()
    local players = net.ReadTable()

    Ambi.Daily.dailies[ id ] = {}
    Ambi.Daily.dailies[ id ].class = class
    Ambi.Daily.dailies[ id ].id = id
    Ambi.Daily.dailies[ id ].count = count
    Ambi.Daily.dailies[ id ].players = players
    Ambi.Daily.dailies[ id ].features = features

    for k, v in pairs( Ambi.Daily.GetPattern( class ) ) do
        Ambi.Daily.dailies[ id ][ k ] = v
    end

    print( '[Daily] Sync with '..class..' ('..id..')' )
end )