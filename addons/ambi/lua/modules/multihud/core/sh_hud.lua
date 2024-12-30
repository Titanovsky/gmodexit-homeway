if not Ambi.General.CheckModule( 'ChatCommands', 'MultiHUD' ) then return end

-- --------------------------------------------------------------------------------------------------------------------------------------------
local Add = Ambi.ChatCommands.Add
local C = Ambi.Packages.Out( 'colors' )
local TYPE = 'MultiHUD'

-- --------------------------------------------------------------------------------------------------------------------------------------------
Add( 'hud', TYPE, 'Сменить худ', 0.25, function( ePly, tArgs ) 
    if not Ambi.MultiHUD.Config.enable then ePly:ChatSend( '~ERROR~ • ~W~ Система мульти-худов выключена!' ) return end

    local number = tArgs[ 2 ]
    if not number then ePly:ChatSend( '~ERROR~ • ~W~ Введите номер худа. Например: /hud 1' ) return end

    net.Start( 'ambi_multihud_change_hud' )
        net.WriteString( number )
    net.Send( ePly )

    return true
end )

Add( 'huds', TYPE, 'Вывести список всех худов', 1, function( ePly, tArgs ) 
    net.Start( 'ambi_multihud_show_huds' )
    net.Send( ePly )

    return true
end )