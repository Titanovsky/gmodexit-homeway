local Add = Ambi.Daily.AddPattern

Add( 'addmoney', {
    Description = function( tDaily )
        return 'Заработать денег'
    end,

    Reward = function( ePly, tDaily )
        ePly:ChatSend( '~B~ • ~W~ За выполнение дейлика вы получаете: 2000$'  )
        ePly:AddMoney( 2000 )
    end,

    Make = function( tDaily, nID )
        tDaily.count = math.random( 2000, 11000 )

        Ambi.Daily.HookAdd( tDaily, '[Ambi.DarkRP.AddMoney]', 'Ambi.MysticRP.DailyAddMoney', function( ePly, nMoney )
            if ( nMoney <= 0 ) then return end
            
            Ambi.Daily.AddCount( ePly, nID, nMoney )
        end )
    end
} )

-- Add( 'call_pet', {
--     Description = function( tDaily )
--         return 'Вызвать Питомца'
--     end,

--     Reward = function( ePly, tDaily )
--         ePly:ChatSend( '~B~ • ~W~ За выполнение дейлика вы получаете: ~AMBI~ 100 XP'  )
--         ePly:AddXP( 100 )
--     end,

--     Make = function( tDaily, nID )
--         tDaily.count = 1

--         Ambi.Daily.HookAdd( tDaily, '[Ambi.MysticRP.CallPet]', 'Ambi.MysticRP.DailyCallPet', function( ePly )
--             Ambi.Daily.AddCount( ePly, nID, 1 )
--         end )
--     end
-- } )