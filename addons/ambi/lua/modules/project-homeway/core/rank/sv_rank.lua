local C, SQL = Ambi.General.Global.Colors, Ambi.SQL
local DB = SQL.CreateTable( 'ambi_ranks', 'SteamID, Rank, Date, RegDate' )
local PLAYER = FindMetaTable( 'Player' )

--! Эта система связана с ULX, и не должна сама по себе сетаться

-- --------------------------------------------------------------------------------------------------------------------------------------------
function Ambi.Homeway.SetRank( sSteamID, sRank, nHours )
    local date = os.time() + 60 * 60 * nHours
    if ( nHours == -1 ) then date = -1 end

    SQL.Delete( DB, 'SteamID', sSteamID )
    SQL.Insert( DB, 'SteamID, Rank, Date, RegDate', '%s, %s, %i, %i', sSteamID, sRank, date, os.time() )

    print( '[Rank] Оффлайн активирован '..sRank..' для '..sSteamID..' на '..nHours..' час' )

    hook.Call( '[Ambi.Homeway.SetRankOffline]', nil, sSteamID, sRank, nHours )
end

function Ambi.Homeway.RemoveRank( sSteamID )
    SQL.Delete( DB, 'SteamID', sSteamID )

    hook.Call( '[Ambi.Homeway.RemoveRankOffline]', nil, sSteamID )
end

-- --------------------------------------------------------------------------------------------------------------------------------------------
function PLAYER:SetRank( sRank, nHours )
    local date = os.time() + 60 * 60 * nHours
    if ( nHours == -1 ) then date = -1 end

    SQL.Delete( DB, 'SteamID', self:SteamID() )
    SQL.Insert( DB, 'SteamID, Rank, Date, RegDate', '%s, %s, %i, %i', self:SteamID(), sRank, date, os.time() )

    self.nw_Rank = sRank

    hook.Call( '[Ambi.Rank.Set]', nil, self, sRank, nHours )

    print( '[Rank] Активирован '..sRank..' для '..self:Nick()..'('..self:SteamID()..') на '..nHours..' час' )

    hook.Call( '[Ambi.Homeway.SetRank]', nil, self, sRank, nHours )
end

function PLAYER:RemoveRank()
    SQL.Delete( DB, 'SteamID', self:SteamID() )

    self.nw_Rank = nil

    hook.Call( '[Ambi.Homeway.RemoveRank]', nil, self )
end

function PLAYER:GetRankTime()
    local time = SQL.Select( DB, 'Date', 'SteamID', self:SteamID() )
    if not time then return end 

    return tonumber( time )
end

-- ---------------------------------------------------------------------------------------------------------------------------------------------
hook.Add( 'PlayerInitialSpawn', 'Ambi.Homeway.InitRank', function( ePly )
    timer.Simple( 0, function()
        if not IsValid( ePly ) then return end

        local sid = ePly:SteamID()

        SQL.Get( DB, 'SteamID', 'SteamID', sid, function()
            local rank = SQL.Select( DB, 'Rank', 'SteamID', sid )
            if not rank then return end

            local date = tonumber( SQL.Select( DB, 'Date', 'SteamID', sid ) )

            if ( date ~= -1 ) and ( os.time() >= date ) then
                ePly:ChatSend( '~R~ • ~W~ Срок вашего ранг истёк!' )

                RunConsoleCommand( 'ulx', 'removeuser', ePly:Name() )
            else
                ePly.nw_Rank = rank
            end
        end, function() end )
    end )
end )