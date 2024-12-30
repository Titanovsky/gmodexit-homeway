Ambi.Time.today = Ambi.Time.today or {}

local SQL = Ambi.SQL
local DB = SQL.CreateTable( 'times', 'SteamID TEXT, Time NUMERIC' )

-- ---------------------------------------------------------------------------------------------------------------------------------------
hook.Add( 'PlayerInitialSpawn', 'Ambi.Time.Set', function( ePly )
    if ePly:IsBot() then return end

    local sid = ePly:SteamID()
    local time = 0

    SQL.Get( DB, 'SteamID', 'SteamID', sid, function()
        time = tonumber( SQL.Select( DB, 'Time', 'SteamID', sid ) )
    end, function() 
        SQL.Insert( DB, 'SteamID, Time', '%s, %i', sid, 0 )

        time = 0
    end )

    ePly.nw_Time = time

    if Ambi.Time.today[ sid ] then ePly.nw_TimeToday = Ambi.Time.today[ sid ] else ePly.nw_TimeToday = 0 end
end )

-- ---------------------------------------------------------------------------------------------------------------------------------------
timer.Create( 'Ambi.Time.Add', Ambi.Time.Config.save_players_time_delay, 0, function()
    if not Ambi.Time.Config.save_players_time then return end

    for _, ply in player.Iterator() do
        if ply.nw_Time and ( ply:TimeConnected() >= Ambi.Time.Config.save_players_time_delay ) then 
            local sid = ply:SteamID()
            local time = tonumber( SQL.Select( DB, 'Time', 'SteamID', sid ) ) + Ambi.Time.Config.save_players_time_delay

            SQL.Update( DB, 'Time', time, 'SteamID', sid ) 
            ply.nw_Time = time

            ply.nw_TimeToday = ply.nw_TimeToday + Ambi.Time.Config.save_players_time_delay
            Ambi.Time.today[ ply:SteamID() ] = ply.nw_TimeToday
        end
    end
end )