local CHESTS = {
    [ 'chest_d' ] = true,
    [ 'weapons_d' ] = true,
    [ 'clothes_d' ] = true,
    [ 'money_d' ] = true,
    [ 'boost_d' ] = true,
    [ 'food_d' ] = true,
    [ 'money_rubles' ] = true,
}

hook.Add( '[Ambi.DarkRP.SetJob]', 'Ambi.Homeway.Notify', function( ePly, sClass, _, _, tJob ) 
    if ( sClass == Ambi.DarkRP.Config.jobs_class ) then return end

    Ambi.Homeway.NotifyAll( ePly:Name()..' стал '..tJob.name, 3.2 )
end )

hook.Add( '[Ambi.Homeway.Auth]', 'Ambi.Homeway.ChatSend', function( ePly, bFirst ) 
    local text = bFirst and 'В город впервые пришёл ~HOMEWAY_BLUE~ %s' or 'Игрок ~HOMEWAY_BLUE~ %s ~W~ явился в город'

    for _, ply in ipairs( player.GetAll() ) do
        ply:ChatSend( '~HOMEWAY_BLUE~ • ~W~ '..Format( text, ePly:Name() ) )
    end
end )

hook.Add( 'PlayerDisconnected', 'Ambi.Homeway.ChatSend', function( ePly ) 
    if not ePly:IsAuth() then return end

    for _, ply in ipairs( player.GetAll() ) do
        ply:ChatSend( '~FLAT_RED~ • ~W~ Игрок ~FLAT_RED~ '..ePly:Name()..' ~W~ покинул город' )
    end
end )

hook.Add( '[Ambi.DarkRP.GetPaydaySalary]', 'Ambi.Homeway.Notify', function( ePly )
    ePly:Notify( 'Вы получили зарплату: '..( ePly:GetJobTable().salary or 0 )..'$', 6, 2 )
end )

hook.Add( '[Ambi.Homeway.OpenChest]', 'Ambi.Homeway.PrintAll', function( ePly, eChest, sReward, tRewardItem ) 
    if not CHESTS[ eChest.nw_Chest ] then return end

    Ambi.UI.Chat.SendAll( '~W~ 👑 ~HOMEWAY_BLUE~ '..ePly:Name()..' ~W~ открыл сундук и получил ~FLAT_GREEN~ '..tRewardItem.name ) 
    Ambi.Homeway.NotifyAll( 'Получить сундуки F6 -> Сундуки', 10 )
end )

timer.Create( 'Ambi.Homeway.NotifyAboutServer', 60 * 13, 0, function()
    for _, ply in ipairs( player.GetAll() ) do
        if not ply:IsAuth() then continue end

        ply:ChatSend( ' ' )
        ply:ChatSend( '~W~ ⭐ АКЦИЯ ~B~ X2 ~W~ ДОНАТ! 💸' )
        ply:ChatSend( '~W~ 💙 Вы играете на ~HOMEWAY_BLUE~ Homeway ~W~ сервере' )
        ply:ChatSend( '~W~ 💙 Онлайн: '..#player.GetAll()..' / 100' )
        ply:ChatSend( '~W~ 💙 '..os.date( '%H:%M  (%d.%m.%Y)', os.time() ) )
        ply:ChatSend( '~W~ 💙 '..game.GetIPAddress() )
        ply:ChatSend( ' ' )

        ply:RunCommand( 'r_cleardecals' )
        ply:Notify( 'Акция: x2 Донат', 35 )
    end
end )

timer.Create( 'Ambi.Homeway.Notice', 60 * 5, 0, function()
    local notice = table.Random( Ambi.Homeway.Config.help_text ).answer 

    for _, ply in ipairs( player.GetAll() ) do
        if not ply:IsAuth() then continue end

        ply:ChatSend( '~HOMEWAY_BLUE~ [Совет] ~W~ '..notice )
    end
end )