local SQL = Ambi.Packages.Out( 'sql' )
local DB = SQL.CreateTable( 'ambi_homeway_players', 'SteamID, SteamID64Owner, Name, IP, Date, NameReg, IPReg, DateReg' )
local PLAYER = FindMetaTable( 'Player' )
local EYE_POS = Angle( 0, 180, 0 )
local BLOCK_CHARS = {
    [ '*' ] = true,
    [ '!' ] = true,
    [ '%' ] = true,
    [ '^' ] = true,
    [ '@' ] = true,
}

-- ---------------------------------------------------------------------------------------------------------------------------------------в
function Ambi.Homeway.IsPlayerReg( sSteamID )
    if not sSteamID then return end

    return SQL.Select( DB, 'SteamID', 'SteamID', sSteamID )
end

-- ---------------------------------------------------------------------------------------------------------------------------------------в
function PLAYER:SetAuth( bAuth )
    self.nw_Auth = bAuth
end

-- ---------------------------------------------------------------------------------------------------------------------------------------в
hook.Add( 'PlayerInitialSpawn', 'Ambi.Homeway.ChangeEyePosOnWall', function( ePly ) 
    timer.Simple( 0.25, function()
        if not IsValid( ePly ) then return end
        if ePly:IsBot() then ePly:SetAuth( true ) return end

        ePly:SetEyeAngles( EYE_POS )

        timer.Create( 'Ambi.Homeway.AuthTimer:'..ePly:SteamID(), 20 * 60, 1, function() 
            if not IsValid( ePly ) then return end

            if not ePly:IsAuth() then ePly:Kick( 'Время на авторизацию вышло' ) return end
        end )
    end ) 
end )

-- ---------------------------------------------------------------------------------------------------------------------------------------в
net.AddString( 'ambi_homeway_auth', function( _, ePly ) 
    if ePly:IsAuth() then ePly:Kick( 'Подозрение в читерстве [Auth]' ) return end

    local sid = ePly:SteamID()
    local is_first = false

    SQL.Get( DB, 'SteamID', 'SteamID', sid, function()
        is_first = false

        SQL.Update( DB, 'Date', os.time(), 'SteamID', sid )
        SQL.Update( DB, 'Name', ePly:Name(), 'SteamID', sid )
        SQL.Update( DB, 'IP', ePly:IPAddress(), 'SteamID', sid )
    end, function() 
        is_first = true

        SQL.Insert( DB, 'SteamID, SteamID64Owner, Name, IP, Date, NameReg, IPReg, DateReg', '%s, %s, %s, %s, %i, %s, %s, %i', sid, ePly:OwnerSteamID64(), ePly:Name(), ePly:IPAddress(), os.time(), ePly:Name(), ePly:IPAddress(), os.time() )

        ePly:RunCommand( 'ambi_infohud 1' )
        ePly:RunCommand( 'ambi_territory_hud 0' )
    end )

    ePly:SetAuth( true )

    timer.Remove( 'Ambi.Homeway.AuthTimer:'..ePly:SteamID() )

    hook.Call( '[Ambi.Homeway.Auth]', nil, ePly, is_first )
end )

hook.Add( 'EntityEmitSound', 'Ambi.Homeway.AuthRemoveSpawnSound', function( tSound )
	if tSound.OriginalSoundName and ( tSound.OriginalSoundName == 'Player.DrownStart' ) then return false end
end )