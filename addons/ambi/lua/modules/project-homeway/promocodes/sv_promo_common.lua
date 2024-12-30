local Add = Ambi.Promocode.Add

local temp_plys = {}

-- --------------------------------------------------------------------------------------------------------------------------------------
local function GiveReward( ePly, sPromocode )
    if ( sPromocode == 'vkgroup' ) then
        ePly:Notify( 'Спасибо, что ввели промокод!', 10 )
        ePly:Notify( '4000$ и 30 рублей', 10, 2 )
        ePly:AddMoney( 4000 )
        ePly:AddIGSFunds( 30, 'За ввод промокода' )
    end
end

-- --------------------------------------------------------------------------------------------------------------------------------------
Add( 'vkgroup', 'Server', 'ВК', '', function( ePly ) 
    local sid = ePly:SteamID()

    ePly:Notify( 'Через '..Ambi.Homeway.Config.promocode_time_vk..' минут вы получите награду за промокод', 15 )
    ePly:ChatSend( '~HOMEWAY_BLUE~ • ~W~ Если тебя не будет на сервере, то зайди сегодня..' )
    ePly:ChatSend( '~HOMEWAY_BLUE~ • ~W~ Иначе промокод активируется, но ты ничего не получишь!' )

    timer.Create( 'Ambi.Homeway.Promocode.VKGROUP:'..sid, 60 * Ambi.Homeway.Config.promocode_time_vk, 1, function()
        if not IsValid( ePly ) then temp_plys[ sid ] = 'vkgroup' return end

        GiveReward( ePly, promocode )
    end )
end )

Add( 'alive2024', 'Server', 'Alive', '', function( ePly ) 
    ePly:ChatSend( '~HOMEWAY_BLUE~ • ~W~ Вы получаете 500 рублей и 3 сундука' )
    ePly:AddIGSFunds( 500, 'Спасибо SF STARs!' )

    ePly:AddInvItemOrDrop( 'chest', 1 )
    ePly:AddInvItemOrDrop( 'chest_money', 1 )
    ePly:AddInvItemOrDrop( 'chest_weapons', 1 )

    Ambi.Homeway.NotifyAll( ePly:Name()..' ввёл промокод ALIVE2024 и ахуел', 15 )
end )

-- --------------------------------------------------------------------------------------------------------------------------------------
hook.Add( '[Ambi.Homeway.Auth]', 'Ambi.Homeway.InitPromocodesForTempPlayers', function( ePly ) 
    local promocode = temp_plys[ ePly:SteamID() ]
    if not promocode then return end

    GiveReward( ePly, promocode )
    temp_plys[ ePly:SteamID() ] = nil
end )