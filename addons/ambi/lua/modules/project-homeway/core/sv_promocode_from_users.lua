Ambi.Homeway.users_promocode_temp_receivers = Ambi.Homeway.users_promocode_temp_receivers or {}
Ambi.Homeway.users_promocode_temp_makers = Ambi.Homeway.users_promocode_temp_makers or {}
Ambi.Homeway.users_promocode_cache_makers = Ambi.Homeway.users_promocode_cache_makers or {}

-- --------------------------------------------------------------------------------------------------------------------------------------
function Ambi.Homeway.GiveUserPromocodeRewardReceiver( ePly, tPromocode )
    Ambi.Promocode.AddPlayers( tPromocode.promocode, 1 )

    local time = os.time()
    ePly.promocodes[ tPromocode.promocode ] = time
    Ambi.SQL.Insert( 'ambi_promocode_players', 'SteamID, Nick, Promocode, Date', '%s, %s, %s, %i', ePly:SteamID(), ePly:Nick(), tPromocode.promocode, time )

    for _, ply in ipairs( player.GetHumans() ) do
        ePly:SyncPromocodes( ply )
    end

    ePly:ChatSend( '~HOMEWAY_BLUE~ • ~W~ Награда: Глок (Инвентарь), 10.000$, 50 рублей и сундуки' )

    ePly:AddInvItem( 'arccw_g18', 1 )
    ePly:AddMoney( 10000 )
    ePly:AddInvItem( 'chest', 1 )
    ePly:AddInvItem( 'chest_money', 1 )
    ePly:AddIGSFunds( 50, 'User Promocode' )

    Ambi.Homeway.NotifyAll( 'Игрок '..ePly:Name()..' получил награду за промокод!', 15, 2 )

    print( '[Homeway] Промокодер '..ePly:Name()..' ('..ePly:SteamID()..') получил награду' ) 
end

function Ambi.Homeway.GiveUserPromocodeRewardMaker( ePly, tPromocode, nCount )
    nCount = nCount or 1

    timer.Simple( 1, function()
        if not IsValid( ePly ) then return end

        ePly:ChatSend( '~HOMEWAY_BLUE~ • ~W~ От 10 игроков будет VIP +2 дня' )
        ePly:ChatSend( '~HOMEWAY_BLUE~ • ~W~ От 30 игроков будет Premium +2 дня' )

        local donate_rubles = 10 * nCount
        ePly:ChatSend( '~HOMEWAY_BLUE~ • ~W~ Награда: '..donate_rubles..' рублей' )
        ePly:AddIGSFunds( donate_rubles, 'Ввели ваш кастомный промокод' )

        local players = Ambi.Promocode.Get( tPromocode.promocode ).players
        if ( players >= 30 ) then
            local time = ePly:IsPrivilege( 'premium' ) and math.floor( ( ePly:GetPrivilegeTime() - os.time() ) / 60 / 60 ) or 0
            local days = 24 * nCount

            time = time + days

            ePly:SetPrivilege( 'premium', time )
            ePly:Notify( 'Вы получаете/продлеваете Premium на '..time..' часов', 8, 2 )
        elseif ( players >= 10 ) then
            if ePly:IsPrivilege( 'premium' ) then return end

            local time = ePly:IsPrivilege( 'vip' ) and math.floor( ( ePly:GetPrivilegeTime() - os.time() ) / 60 / 60 ) or 0
            local days = 24 * nCount

            time = time + days

            ePly:SetPrivilege( 'vip', time )
            ePly:Notify( 'Вы получаете/продлеваете VIP на '..time..' часов', 8, 2 )
        end

        ePly:Notify( 'Ваш промокод ввели '..players..' игроков', 25 )
    end )

    print( '[Homeway] Создатель промокода '..ePly:Name()..' ('..ePly:SteamID()..') получил награду x'..nCount ) 
end

function Ambi.Homeway.StartUserPromocodeAction( ePly, tPromocode )
    local sid = ePly:SteamID()

    ePly:Notify( 'Через '..Ambi.Homeway.Config.promocode_user_time_receiver..' минут вы получите награду за промокод', 25 )
    ePly:ChatSend( '~HOMEWAY_BLUE~ • ~W~ Ты ввёл промокод ~HOMEWAY_BLUE~ '..tPromocode.promocode )
    ePly:ChatSend( '~HOMEWAY_BLUE~ • ~W~ Если тебя не будет на сервере, то зайди сегодня..' )
    ePly:ChatSend( '~HOMEWAY_BLUE~ • ~W~ Иначе промокод активируется, но ты ничего не получишь!' )

    local maker = player.GetBySteamID( tPromocode.steamid )
    if IsValid( maker ) then
        maker:Notify( 'Через '..Ambi.Homeway.Config.promocode_user_time_maker..' минут вы получите награду', 25 )
        maker:ChatSend( '~HOMEWAY_BLUE~ • ~W~ Твой ~HOMEWAY_BLUE~ '..tPromocode.promocode..' ~W~ промокод ввёл ~HOMEWAY_BLUE~ '..ePly:Name() )
        maker:ChatSend( '~HOMEWAY_BLUE~ • ~W~ Если тебя не будет на сервере, то зайди сегодня..' )
        maker:ChatSend( '~HOMEWAY_BLUE~ • ~W~ Иначе промокод активируется, но ты ничего не получишь!' )
    end

    timer.Create( 'Ambi.Homeway.Promocode.User.Receiver:'..sid, Ambi.Homeway.Config.promocode_user_time_receiver * 60, 1, function()
        if not IsValid( ePly ) then 
            print( '[Homeway] Промокодер '..tPromocode.steamid..' занесён в temp_receivers' ) 
            Ambi.Homeway.users_promocode_temp_receivers[ sid ] = tPromocode 
            Ambi.Promocode.Wipe( sid, tPromocode.promocode ) 
            return 
        end

        Ambi.Homeway.GiveUserPromocodeRewardReceiver( ePly, tPromocode )
    end )

    timer.Create( 'Ambi.Homeway.Promocode.User.Maker:'..sid, Ambi.Homeway.Config.promocode_user_time_maker * 60, 1, function()
        local maker = player.GetBySteamID( tPromocode.steamid )
        if not IsValid( maker ) then 
            print( '[Homeway] Создатель '..tPromocode.steamid..' промокода занесён в temp_makers' ) 
            Ambi.Homeway.users_promocode_temp_makers[ tPromocode.steamid ] = { count = ( Ambi.Homeway.users_promocode_temp_makers[ tPromocode.steamid ] and Ambi.Homeway.users_promocode_temp_makers[ tPromocode.steamid ].count or 0 ) + 1, promocode = tPromocode } 
            return 
        end

        Ambi.Homeway.GiveUserPromocodeRewardMaker( maker, tPromocode, 1 )
    end )
    
    ePly.promocodes[ tPromocode.promocode ] = nil
    sql.Query( 'DELETE FROM ambi_promocode_players WHERE Promocode = '..Ambi.SQL.Str( tPromocode.promocode )..' AND SteamID = '..Ambi.SQL.Str( ePly:SteamID() )..';' )
    Ambi.Promocode.AddPlayers( tPromocode.promocode, -1 )
end

function Ambi.Homeway.MakeUserPromocode( sSteamID, sPromocode )
    if not sPromocode then return end

    local ply = player.GetBySteamID( sSteamID )
    local text = IsValid( ply ) and ply:Name() or sSteamID
    local desc = 'Промокод от '..text

    if ( hook.Call( '[Ambi.Homeway.CanMakeUserPromocode]', nil, sSteamID, sPromocode, ply ) == false ) then return end

    Ambi.Promocode.Add( sPromocode, sSteamID, 'user', desc, function( ePly, tPromocode ) Ambi.Homeway.StartUserPromocodeAction( ePly, tPromocode ) end ) -- the last arg is cuz change Action

    print( '[Homeway] игрок '..text..' создал свой промокод '..sPromocode )

    Ambi.Homeway.users_promocode_cache_makers[ sSteamID ] = sPromocode

    hook.Call( '[Ambi.Homeway.MakeUserPromocode]', nil, sSteamID, sPromocode, ply )
end

-- --------------------------------------------------------------------------------------------------------------------------------------
hook.Add( '[Ambi.Promocode.Setup]', 'Ambi.Homeway.SetupUserPromocodes', function( tPromocode ) 
    if ( tPromocode.header ~= 'user' ) then return end

    tPromocode.Action = function( ePly, tPromocode ) Ambi.Homeway.StartUserPromocodeAction( ePly, tPromocode ) end

    Ambi.Homeway.users_promocode_cache_makers[ tPromocode.steamid ] = tPromocode.promocode
end )

hook.Add( '[Ambi.Promocode.Added]', 'Ambi.Homeway.AddedUserPromocodes', function( tPromocode ) 
    if ( tPromocode.header ~= 'user' ) then return end

    tPromocode.Action = function( ePly, tPromocode ) Ambi.Homeway.StartUserPromocodeAction( ePly, tPromocode ) end

    Ambi.Homeway.users_promocode_cache_makers[ tPromocode.steamid ] = tPromocode.promocode
end )

hook.Add( '[Ambi.Promocode.CanActivate]', 'Ambi.Homeway.BlockActivateUserPromocode', function( ePly, tPromocode )
    if ( tPromocode.header ~= 'user' ) then return end
    if ( tPromocode.steamid == ePly:SteamID() ) then ePly:Notify( 'Нельзя активировать свой промокод', 10, NOTIFY_ERROR ) return false end
    if ( ePly:GetTime() >= Ambi.Homeway.Config.promocode_user_time_limit * 60 * 60 ) then ePly:Notify( 'Активировать User Промокоды можно до '..Ambi.Homeway.Config.promocode_user_time_limit..' часов игры', 10, NOTIFY_ERROR ) return false end
    if timer.Exists( 'Ambi.Homeway.Promocode.User.Receiver:'..ePly:SteamID() ) then ePly:Notify( 'Вы уже ждёте промокод', 10, NOTIFY_ERROR ) return false end

    for promocode, tab in pairs( Ambi.Promocode.GetAll() ) do
        if ( tab.header ~= 'user' ) then continue end

        if ePly:GetPromocode( promocode ) then ePly:Notify( 'У вас уже активирован промокод ~R~ '..promocode..' ~W~ от игрока', 10, NOTIFY_ERROR ) return false end
    end
end )

hook.Add( '[Ambi.Homeway.Auth]', 'Ambi.Homeway.InitUsersPromocodesForTempPlayers', function( ePly ) 
    local sid = ePly:SteamID()

    if Ambi.Homeway.users_promocode_temp_receivers[ sid ] then
        Ambi.Homeway.GiveUserPromocodeRewardReceiver( ePly, Ambi.Homeway.users_promocode_temp_receivers[ sid ] )

        Ambi.Homeway.users_promocode_temp_receivers[ sid ] = nil
    end

    if Ambi.Homeway.users_promocode_temp_makers[ sid ] then
        Ambi.Homeway.GiveUserPromocodeRewardMaker( ePly, Ambi.Homeway.users_promocode_temp_makers[ sid ].promocode, Ambi.Homeway.users_promocode_temp_makers[ sid ].count )

        Ambi.Homeway.users_promocode_temp_makers[ sid ] = nil
    end
end )

hook.Add( '[Ambi.Homeway.CanMakeUserPromocode]', 'Ambi.Homeway.BlockMakeUserPromocode', function( sSteamID, sPromocode, ePly )
    for promocode, tab in pairs( Ambi.Promocode.GetAll() ) do
        if ( tab.header == 'user' ) and ( tab.steamid == sSteamID ) then 
            if IsValid( ePly ) then ePly:Notify( 'Вы не можете создать ещё один промокод', 10, NOTIFY_ERROR ) end

           return false 
        end
    end
end )

-- --------------------------------------------------------------------------------------------------------------------------------------
net.AddString( 'ambi_homeway_make_user_promocode', function( _, ePly ) 
    if Ambi.Homeway.users_promocode_cache_makers[ ePly:SteamID() ] then ePly:Notify( 'Вы не можете создать ещё один промокод', 10, NOTIFY_ERROR ) return end

    local promocode = net.ReadString()
    if Ambi.Promocode.Get( promocode ) then return end

    local len = utf8.len( promocode )
    if ( len > Ambi.Homeway.Config.promocode_user_max_len ) then ePly:Kick( '[Homeway] Подозрение в читерстве. Промокод больше 12-ти символов ' ) return end
    if ( len < Ambi.Homeway.Config.promocode_user_min_len ) then ePly:Kick( '[Homeway] Подозрение в читерстве. Промокод менбще 4-ёх символов ' ) return end

    Ambi.Homeway.MakeUserPromocode( ePly:SteamID(), promocode )
end )

net.AddString( 'ambi_homeway_activate_user_promocode', function( _, ePly ) 
    local promocode = net.ReadString()
    
    ePly:ActivatePromocode ( promocode )
end )