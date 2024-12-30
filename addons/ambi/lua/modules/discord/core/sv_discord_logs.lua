local BotLog = Ambi.Discord.Bot.Create( Ambi.Discord.Config.bot_logs_token )

local LAST_CONNECTED = {}
hook.Add( 'CheckPassword', 'Ambi.Discord.Bot.Logs', function( sSteamID64, sIP, _, _, sName ) 
    if not Ambi.Discord.Config.bot_logs_enable or not Ambi.Discord.Config.bot_logs_player_connecting_enable then return end

    if LAST_CONNECTED and LAST_CONNECTED[ sSteamID64 ] then return end
    LAST_CONNECTED[ sSteamID64 ] = true

    local time = os.time()

    timer.Simple( Ambi.Discord.Config.bot_logs_player_connecting_delay, function()
        BotLog:SendMessage( Ambi.Discord.Config.bot_logs_player_connecting_channel_id, string.format( [[✅ Подключается ```lua
        SteamID: '%s'
        IP: '%s'
        Name: '%s'
        Time: '%s'```
        %s]], util.SteamIDFrom64( sSteamID64 ), sIP, sName, os.date( '%X  %d.%m.%Y', time ), 'https://steamcommunity.com/profiles/'..sSteamID64 ) )

        LAST_CONNECTED[ sSteamID64 ] = nil
    end )
end )

hook.Add( 'PlayerDisconnected', 'Ambi.Discord.Bot.Logs', function( ePly ) 
    if not Ambi.Discord.Config.bot_logs_enable or not Ambi.Discord.Config.bot_logs_player_disconnected_enable then return end

    local time = os.time()
    local sid, ip, nick, sid64 = ePly:SteamID(), ePly:IPAddress(), ePly:Nick(), ePly:SteamID64()

    timer.Simple( Ambi.Discord.Config.bot_logs_player_disconnected_delay, function()
        BotLog:SendMessage( Ambi.Discord.Config.bot_logs_player_disconnected_channel_id, string.format( [[❌ Отключился ```lua
        SteamID: '%s'
        IP: '%s'
        Name: '%s'
        Time: '%s'```
        %s]], sid, ip, nick, os.date( '%X  %d.%m.%Y', time ), 'https://steamcommunity.com/profiles/'..sid64 ) )
    end )
end )

hook.Add( 'PlayerInitialSpawn', 'Ambi.Discord.Bot.Logs', function( ePly ) 
    if not Ambi.Discord.Config.bot_logs_enable or not Ambi.Discord.Config.bot_logs_player_initialized_enable then return end

    timer.Simple( Ambi.Discord.Config.bot_logs_player_initialized_delay, function()
        if not IsValid( ePly ) then return end

        BotLog:SendMessage( Ambi.Discord.Config.bot_logs_player_initialized_channel_id, string.format( [[⭐ Игрок **%s** инициализировался!]], ePly:Nick() ) )
    end )
end )