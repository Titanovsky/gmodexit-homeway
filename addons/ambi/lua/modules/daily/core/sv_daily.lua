Ambi.Daily.patterns = Ambi.Daily.patterns or {}
Ambi.Daily.dailies = Ambi.Daily.dailies or {}
Ambi.Daily.temp_players_count = Ambi.Daily.temp_players_count or {}

-- ------------------------------------------------------------------------------------------------------------
function Ambi.Daily.Make( nID )
    if Ambi.Daily.dailies[ nID ] then
        for event, id in pairs( Ambi.Daily.dailies[ nID ].hooks ) do
            hook.Remove( event, id )
            print( '[Daily] remove old hook: '..id )
        end

        Ambi.Daily.dailies[ nID ] = {}
    end

    Ambi.Daily.temp_players_count[ nID ] = {}

    local class = table.Random( table.GetKeys( Ambi.Daily.patterns ) )
    local pattern = Ambi.Daily.patterns[ class ] or {}
    local daily = {}
    daily.class = class
    daily.id = nID
    daily.count = 1
    daily.features = {}
    daily.players = {}
    daily.hooks = {}
    
    for k, v in pairs( pattern ) do
        if ( k == 'Reward' ) then continue end

        daily[ k ] = v
    end

    daily.Reward = function( ePly, tDaily )
        if not IsValid( ePly ) or ePly:IsBot() then return end
        if not tDaily then return end

        tDaily.players[ ePly:SteamID() ] = true

        Ambi.Daily.Sync( ePly, nID )

        pattern.Reward( ePly, tDaily )

        hook.Call( '[Ambi.Daily.Rewarded]', nil, ePly, tDaily, nID )
    end

    daily.Make( daily, nID )

    Ambi.Daily.dailies[ nID ] = daily

    for _, ply in ipairs( player.GetHumans() ) do
        ply[ 'nw_DailyCount'..nID ] = 0
        Ambi.Daily.Sync( ply, nID )
    end

    print( '[Daily] maked daily: '..class..' ('..daily.Description( daily )..')' ) 

    hook.Call( '[Ambi.Daily.AddedCount]', nil, daily, nID, pattern )
end

function Ambi.Daily.MakeAll()
    local can = false
    for k, v in pairs( Ambi.Daily.patterns ) do
        can = true    
    end
    if not can then return end

    for i = 1, Ambi.Daily.Config.max do
        Ambi.Daily.Make( i )
    end
end

function Ambi.Daily.AddCount( ePly, nID, nCount )
    if not IsValid( ePly ) or not ePly:IsPlayer() or ePly:IsBot() then return end
    if not Ambi.Daily.temp_players_count[ nID ] then return end

    local sid = ePly:SteamID() 

    local daily = Ambi.Daily.Get( nID )
    if daily.players[ sid ] then return end

    if not Ambi.Daily.temp_players_count[ nID ][ sid ] then Ambi.Daily.temp_players_count[ nID ][ sid ] = 0 end

    local count = ePly[ 'nw_DailyCount'..nID ] + nCount
    local max = daily.count
    if ( count > max ) then count = max end

    Ambi.Daily.temp_players_count[ nID ][ sid ] = count
    ePly[ 'nw_DailyCount'..nID ] = count

    hook.Call( '[Ambi.Daily.AddedCount]', nil, ePly, count, nID, nCount )

    if ( count >= max ) then
        daily.Reward( ePly, daily, nID )
    end
end

function Ambi.Daily.Sync( ePly, nID )
    local daily = Ambi.Daily.Get( nID )

    net.Start( 'ambi_daily_sync' )
        net.WriteUInt( nID, 10 )
        net.WriteUInt( daily.count, 23 )
        net.WriteString( daily.class )
        net.WriteTable( daily.features )
        net.WriteTable( daily.players )
    net.Send( ePly )

    print( '[Daily] '..ePly:Nick()..' sync' )
end

-- ------------------------------------------------------------------------------------------------------------
net.AddString( 'ambi_daily_sync' )

-- ------------------------------------------------------------------------------------------------------------
hook.Add( 'PostGamemodeLoaded', 'Ambi.Daily.Create', function() 
    timer.Simple( 1, Ambi.Daily.MakeAll )
end )

hook.Add( 'PlayerInitialSpawn', 'Ambi.Daily.Sync', function( ePly ) 
    if ePly:IsBot() then return end

    timer.Simple( 2, function()
        if not IsValid( ePly ) then return end

        for i = 1, Ambi.Daily.Config.max do
            local daily = Ambi.Daily.Get( i )
            if not daily then print( '[Daily] Error: '..i ) continue end

            Ambi.Daily.Sync( ePly, i )

            ePly[ 'nw_DailyCount'..i ] = 0

            local temp_count = Ambi.Daily.temp_players_count[ i ][ ePly:SteamID() ]
            if temp_count then
                Ambi.Daily.AddCount( ePly, i, temp_count )
            end
        end
    end )
end )