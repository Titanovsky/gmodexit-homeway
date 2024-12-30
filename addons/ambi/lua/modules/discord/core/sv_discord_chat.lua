local C = Ambi.General.Global.Colors
local BotChat = Ambi.Discord.Bot.Create( Ambi.Discord.Config.bot_chat_token )

-- Receive --------------------------------------------------------------------------------------------------------------------------
local DISCORD_LAST_AUTHOR, DISCORD_LAST_TEXT = '', ''
local function SetLoopReceives() -- Wrap-метод исключительно, чтобы можно было менять таймер в конфиге и не рестартить
    timer.Create( 'AmbiDiscordBotReceiveMessages', Ambi.Discord.Config.bot_chat_delay_receive, 1, function()
        if not Ambi.Discord.Config.bot_chat_enable or not Ambi.Discord.Config.bot_chat_from_discord_in_gmod then SetLoopReceives() return end
        
        BotChat:ReceiveMessages( Ambi.Discord.Config.bot_chat_channel_id, 1, function( tMsg )
            if not tMsg then return end

            local msg = tMsg[ 1 ]
            if not msg then return end
            
            local author_id, text = msg.author.id, msg.content 
            if ( author_id == DISCORD_LAST_AUTHOR ) and ( text == DISCORD_LAST_TEXT ) then return end
            DISCORD_LAST_AUTHOR, DISCORD_LAST_TEXT = author_id, text

            if Ambi.Discord.Config.bot_chat_commands_enable and Ambi.Discord.Config.bot_chat_commands_users[ author_id ] and ( string.StartWith( text, '/cmd' ) ) then
                local cmd = string.sub( text, 6, #text )
                
                return RunConsoleCommand( 'ulx', 'rcon', cmd )
            end
    
            if ( author_id == Ambi.Discord.Config.bot_chat_id ) then return end -- Чтобы бот свои сообщения не читал, так как он двусторонний
        
            local text = '['..msg.author.username..'] '..text
            for _, ply in ipairs( player.GetAll() ) do
                ply:ChatSend( C.AMBI_PURPLE, '[Discord] ', C.ABS_WHITE, text )
            end
    
            print( '[Discord] '..text )
        end )

        SetLoopReceives()
    end )
end
SetLoopReceives()

-- Send --------------------------------------------------------------------------------------------------------------------------------
hook.Add( 'PlayerSay', 'Ambi.Discord.Bot.SendMessageInChannel', function( ePly, sText ) 
    if not Ambi.Discord.Config.bot_chat_enable or not Ambi.Discord.Config.bot_chat_from_gmod_in_discord then return end

    if timer.Exists( 'StopFloodInDiscord:'..ePly:SteamID() ) then return end
    timer.Create( 'StopFloodInDiscord:'..ePly:SteamID(), Ambi.Discord.Config.bot_chat_delay_send + 0.04, 1, function() end )

    local msg = string.format( [[**[%s]** %s]], ePly:Nick(), sText )

    BotChat:SendMessage( Ambi.Discord.Config.bot_chat_channel_id, msg, Ambi.Discord.Config.bot_chat_delay_send )
end )