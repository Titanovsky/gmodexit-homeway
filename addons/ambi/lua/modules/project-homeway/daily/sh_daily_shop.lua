local Add = Ambi.Daily.AddPattern

Add( 'buy_shop_item', {
    Description = function( tDaily )
        return 'Купить что-то в магазине'
    end,

    Reward = function( ePly, tDaily )
        ePly:ChatSend( '~B~ • ~W~ Награда: ~G~ 600$'  )
        ePly:AddMoney( 600 )
    end,

    Make = function( tDaily, nID )
        tDaily.count = math.random( 1, 3 )

        Ambi.Daily.HookAdd( tDaily, '[Ambi.DarkRP.BuyShopItem]', 'Ambi.Homeway.DailyBuyShopItem', function( ePly )
            Ambi.Daily.AddCount( ePly, nID, 1 )
        end )
    end
} )

Add( 'buy_weapon_gundealer', {
    Description = function( tDaily )
        return 'Купить оружие у Дэйва'
    end,

    Reward = function( ePly, tDaily )
        ePly:ChatSend( '~B~ • ~W~ Награда: ~G~ 1000$'  )
        ePly:AddMoney( 1000 )
    end,

    Make = function( tDaily, nID )
        tDaily.count = 1

        Ambi.Daily.HookAdd( tDaily, '[Ambi.Homeway.BuyWeaponGunDealer]', 'Ambi.Homeway.DailyBuyWeaponGunDealer', function( ePly )
            Ambi.Daily.AddCount( ePly, nID, 1 )
        end )
    end
} )