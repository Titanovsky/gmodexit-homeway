local C = Ambi.General.Global.Colors

local DISCORD_LAST_AUTHOR, DISCORD_LAST_TEXT = '', ''
timer.Create( 'Ambi.Homeway.DiscordBotChat', 1, 0, function()
    if not BotLog then return end

    BotLog:ReceiveMessages( '1264803277241974835', 1, function( tMsg )
        if not tMsg then return end

        local msg = tMsg[ 1 ]
        if not msg then return end
        
        local author_id, text = msg.author.id, msg.content 
        if ( author_id == DISCORD_LAST_AUTHOR ) and ( text == DISCORD_LAST_TEXT ) then return end
        DISCORD_LAST_AUTHOR, DISCORD_LAST_TEXT = author_id, text

        if ( author_id == '1272470416383803443' ) then return end -- Чтобы бот свои сообщения не читал, так как он двусторонний

        if Ambi.Discord.Config.bot_chat_commands_users[ author_id ] and ( string.StartWith( text, 'ulx' ) ) then
            local cmd = text

            game.ConsoleCommand( cmd..'\n' )
            
            return
        end
    
        local text = '['..msg.author.username..'] '..text
        for _, ply in ipairs( player.GetAll() ) do
            ply:ChatSend( C.AMBI_PURPLE, '[Discord] ', C.ABS_WHITE, text )
        end

        print( '[Discord] '..text )
    end )
end )