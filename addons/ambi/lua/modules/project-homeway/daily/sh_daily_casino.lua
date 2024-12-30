local Add = Ambi.Daily.AddPattern

Add( 'playcasino_caligula', {
    Description = function( tDaily )
        return 'Сыграть в Coin Flipper у Крупье'
    end,

    Reward = function( ePly, tDaily )
        ePly:ChatSend( '~B~ • ~W~ За выполнение дейлика вы получаете: ~G~ 3000$'  )
        ePly:AddMoney( 3000 )
    end,

    Make = function( tDaily, nID )
        tDaily.count = math.random( 1, 6 )

        Ambi.Daily.HookAdd( tDaily, '[Ambi.Homeway.UsedCasino]', 'Ambi.MysticRP.DailyCasinoPlay', function( ePly )
            Ambi.Daily.AddCount( ePly, nID, 1 )
        end )
    end
} )