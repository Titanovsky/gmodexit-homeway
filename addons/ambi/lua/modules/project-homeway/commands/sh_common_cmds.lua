if not Ambi.ChatCommands.AddCommand then return end

local Add = Ambi.ChatCommands.AddCommand
local C = Ambi.General.Global.Colors

-- ---------------------------------------------------------------------------------------------------------------------------------------
Add( 'looc', 'Homeway', 'Сказать в OOC чат, но локальный', 0.25, function( ePly, tArgs ) 
    local text = ''

    for i, v in ipairs( tArgs ) do
        if ( i == 1 ) then continue end

        text = text..' '..v
    end

    if ePly.gimp then
        return
    end

    if ( hook.Call( '[Ambi.Homeway.CanChatSayLOOC]', nil, ePly, text ) == false ) then return end

    for _, ply in ipairs( ents.FindInSphere( ePly:GetPos(), Ambi.DarkRP.Config.chat_max_length ) ) do
        if not ply:IsPlayer() then continue end
        ply:ChatSend( C.AMBI_BLOOD, '[LOOC] ', Ambi.DarkRP.Config.chat_commands_color_ooc, '['..ePly:Name()..']'..text )
    end

    hook.Call( '[Ambi.Homeway.ChatSayLOOC]', nil, ePly, text )
end )
Ambi.ChatCommands.AddAlias( '//', 'looc' )

Add( '911', 'Homeway', 'Сказать в OOC чат, но локальный', 60, function( ePly, tArgs ) 
    if ePly.gimp then
        return
    end

    local text = ''

    for i, v in ipairs( tArgs ) do
        if ( i == 1 ) then continue end

        text = text..' '..v
    end

    if ( hook.Call( '[Ambi.Homeway.Can911]', nil, ePly, text ) == false ) then return end

    for _, ply in ipairs( player.GetAll() ) do
        if ply:IsPolice() then ply:ChatSend( '~B~ [911] ~W~ '..text ) end
    end

    hook.Call( '[Ambi.Homeway.Say911]', nil, ePly, text )
end )

Add( 'mypromo', 'Homeway', 'Узнавать инфу о вашем промокоде', 1, function( ePly, tArgs ) 
    local promo = ePly.user_promocode
    if not promo then
        for promocode, tab in pairs( Ambi.Promocode.GetAll() ) do
            if ( tab.header == 'user' ) and ( tab.steamid == ePly:SteamID() ) then 
                ePly.user_promocode = promocode
                promo = promocode
                break 
            end
        end
    end
    if not Ambi.Promocode.Get( promo ) then ePly:Notify( 'Создайте свой промокод (F4)', 4, NOTIFY_ERROR ) return end

    ePly:ChatSend( '~W~ Ваш промокод ~HOMEWAY_BLUE~ '..promo )
    ePly:ChatSend( '~W~ Его ввели ~HOMEWAY_BLUE~ '..Ambi.Promocode.Get( promo ).players..' ~W~ игроков' )
end )

Add( 'help', 'Homeway', 'Открыть гайд', 1, function( ePly, tArgs ) 
    ePly:SendLua( 'local main = Ambi.Homeway.ShowF4Menu().main; Ambi.Homeway.ShowPageGuide( main )' )
end )

local ACTS = {
    [ ACT_GMOD_GESTURE_AGREE ] = 'Согласен',
    [ ACT_GMOD_GESTURE_WAVE ] = 'Поприветствовать',
    [ ACT_GMOD_GESTURE_BECON ] = 'Позвать к себе',
    [ ACT_GMOD_TAUNT_SALUTE ] = 'Воинское Приветствие',
    [ ACT_GMOD_GESTURE_BOW ] = 'Уважение',
    [ ACT_GMOD_TAUNT_CHEER ] = 'Радоваться',
    [ ACT_GMOD_TAUNT_DANCE ] = 'Танцевать',
    [ ACT_GMOD_GESTURE_DISAGREE ] = 'Не согласен',
    [ ACT_GMOD_GESTURE_POINT ] = 'Вперёд',
    [ ACT_GMOD_GESTURE_ITEM_PLACE ] = 'Сгрупироваться',
    [ ACT_GMOD_GESTURE_MELEE_SHOVE_1HAND ] = 'Стоять',
    [ ACT_GMOD_TAUNT_LAUGH ] = 'Смеяться',
    [ ACT_GMOD_TAUNT_MUSCLE ] = 'Эротишный танец',
    [ ACT_GMOD_TAUNT_PERSISTENCE ] = 'Лев',
    [ ACT_GMOD_GESTURE_TAUNT_ZOMBIE ] = 'Зомби',
    [ ACT_GMOD_TAUNT_ROBOT ] = 'Лев',
}

Add( 'anim', 'Homeway', 'Проиграть анимацию', 1, function( ePly, tArgs ) 
    local act = tArgs[ 2 ] or ''
    if ( act == '' ) then return end

    local dont_kill = tobool( tArgs[ 3 ] )

    local text = ACTS[ tonumber( act ) ] or act

    ePly:StartAnim( tonumber( act ), ePly:IsStaff() and dont_kill )
    ePly:Notify( 'Вы начали проигрывать анимацию: '..text )
end )

Add( 'tts', 'Homeway', 'Использование ттс, ключ. слова: on, off, ignore, voice', 0.25, function( ePly, tArgs, bTeamChat ) 
    local word = tArgs[ 2 ]
    if not word then return end
    if bTeamChat then return end

    if ( word == 'on' ) then ePly.tts_on = true ePly:Notify( 'Auto TTS Включен!' ) return
    elseif ( word == 'off' ) then ePly.tts_on = nil ePly:Notify( 'Auto TTS Выключен!' ) return
    elseif ( word == 'voice' ) then
        local arg = tArgs[ 3 ]
        if not arg then ePly:ChatPrint( 'Все голоса: google, zahar, ermil, oksana, alyss, omazh, jane' ) return end 
        arg = string.lower( arg )

        ePly.nw_TTSVoice = arg

        ePly:ChatPrint( 'Вы сменили голос на '..arg )
    
        return
    elseif ( word == 'ignore' ) then 
        local arg = tArgs[ 3 ]
        if not arg then ePly:RunCommand( 'ambi_tts_ignore 1' ) return end

        ePly:RunCommand( 'ambi_tts_ignore '..arg )

        return
    end

    local text = ''
    for i, word in ipairs( tArgs ) do
        if ( i == 1 ) then continue end
        local sep = ( i == 2 ) and '' or ' '
        text = text..sep..word
    end

    if string.StartWith( text, '/' ) then return end
    if string.StartWith( text, 'http' ) then return end
    if string.StartWith( text, 'www' ) then return end
    
    net.Start( 'ambi_rus_tts_start' )
        net.WriteString( text )
        net.WriteEntity( ePly )
    net.Broadcast()

    return
end )

Add( 'marry', 'Secret', 'Предложение руки и сердца', 60, function(ePly, tArgs)
    local another = ePly:GetEyeTrace().Entity

    if IsValid( another ) and another:IsPlayer() and ( another:GetPos():Distance( ePly:GetPos() ) < 150 ) then
        -- сообщение и выдача опыта "свидетелям"
        for k, ply in ipairs( player.GetHumans() ) do
            ply:ChatSend( '~AMBI_PURPLE~ '..ePly:Name()..' ~W~ Сделал предложение руки и сердца у ~AMBI_PURPLE~ '..another:Name() )
        end
    else
        ePly:ChatPrint('Вы должны встать напротив другого игрока, чтобы сделать ему предложение!')
    end    
end )

Add( 'cancel', 'Computer Club', 'Выйти из компьютерного клуба', 0.25, function(ePly, tArgs)
    if not ePly:IsPlayingInComputerClub() then return end  

    local game = Ambi.ComputerClub.GetCurrentGame()
    if not game then return end

    for i, ply in ipairs( game.players ) do
        if ( ply ~= ePly ) then continue end

        ePly:SetPlayInComputerClub( false )
        table.remove( game.players, i )
        Ambi.ComputerClub.Get( game.class ).EndAction( ePly )

        break
    end
end )