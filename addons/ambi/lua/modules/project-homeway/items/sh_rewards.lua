local Add = Ambi.Inv.AddItem

-- ---------------------------------------------------------------------------------------------------------------------------------------
local CATEGORY = 'Сундуки.Награды'
local STACK = 100
local ICON = 'https://i.postimg.cc/SKwygcQ8/reward-donate-25.png'

Add( 'reward_money1', '1.000$', STACK, CATEGORY, 'Получить деньги', ICON, function( ePly ) 
    ePly:AddMoney( 1000 )
    ePly:Notify( '+1000$', 4, 2 )

    return true
end )

Add( 'reward_money2', '2.000$', STACK, CATEGORY, 'Получить деньги', ICON, function( ePly ) 
    ePly:AddMoney( 2000 )
    ePly:Notify( '+2000$', 4, 2 )

    return true
end )

Add( 'reward_money3', '5.000$', STACK, CATEGORY, 'Получить деньги', ICON, function( ePly ) 
    ePly:AddMoney( 5000 )
    ePly:Notify( '+5000$', 4, 2 )

    return true
end )

Add( 'reward_money4', '10.000$', STACK, CATEGORY, 'Получить деньги', ICON, function( ePly ) 
    ePly:AddMoney( 10000 )
    ePly:Notify( '+10000$', 4, 2 )

    return true
end )

-- 

Add( 'reward_money_10k', '10.000$', STACK, CATEGORY, 'Получить деньги', ICON, function( ePly ) 
    ePly:AddMoney( 10000 )
    ePly:Notify( '+10000$', 4, 2 )

    return true
end )

Add( 'reward_money_50k', '50.000$', STACK, CATEGORY, 'Получить деньги', ICON, function( ePly ) 
    ePly:AddMoney( 50000 )
    ePly:Notify( '+50000$', 4, 2 )

    return true
end )

Add( 'reward_money_175k', '175.000$', STACK, CATEGORY, 'Получить деньги', ICON, function( ePly ) 
    ePly:AddMoney( 175000 )
    ePly:Notify( '+175000$', 4, 2 )

    return true
end )

Add( 'reward_money_250k', '250.000$', STACK, CATEGORY, 'Получить деньги', ICON, function( ePly ) 
    ePly:AddMoney( 250000 )
    ePly:Notify( '+250000$', 4, 2 )

    return true
end )

Add( 'reward_money_500k', '500.000$', STACK, CATEGORY, 'Получить деньги', ICON, function( ePly ) 
    ePly:AddMoney( 500000 )
    ePly:Notify( '+500000$', 4, 2 )

    return true
end )

Add( 'reward_donate_25', '25 Рублей', STACK, CATEGORY, 'Получить деньги', ICON, function( ePly ) 
    ePly:AddIGSFunds(25, 'Донат Сундук')
    ePly:Notify( '25 рублей', 4, 2 )

    return true
end )

Add( 'reward_donate_50', '50 Рублей', STACK, CATEGORY, 'Получить деньги', ICON, function( ePly ) 
    ePly:AddIGSFunds(50, 'Донат Сундук')
    ePly:Notify( '50 рублей', 4, 2 )

    return true
end )

Add( 'reward_donate_100', '100 Рублей', STACK, CATEGORY, 'Получить деньги', ICON, function( ePly ) 
    ePly:AddIGSFunds(100, 'Донат Сундук')
    ePly:Notify( '100 рублей', 4, 2 )

    return true
end )

Add( 'reward_donate_150', '150 Рублей', STACK, CATEGORY, 'Получить деньги', ICON, function( ePly ) 
    ePly:AddIGSFunds(150, 'Донат Сундук')
    ePly:Notify( '150 рублей', 4, 2 )

    return true
end )

Add( 'reward_donate_250', '250 Рублей', STACK, CATEGORY, 'Получить деньги', ICON, function( ePly ) 
    ePly:AddIGSFunds(250, 'Донат Сундук')
    ePly:Notify( '250 рублей', 4, 2 )

    return true
end )

Add( 'reward_donate_400', '400 Рублей', STACK, CATEGORY, 'Получить деньги', ICON, function( ePly ) 
    ePly:AddIGSFunds(400, 'Донат Сундук')
    ePly:Notify( '400 рублей', 4, 2 )

    return true
end )

Add( 'reward_donate_800', '800 Рублей', STACK, CATEGORY, 'Получить деньги', ICON, function( ePly ) 
    ePly:AddIGSFunds(800, 'Донат Сундук')
    ePly:Notify( '800 рублей', 4, 2 )

    return true
end )