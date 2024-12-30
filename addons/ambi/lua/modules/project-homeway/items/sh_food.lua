local Add = Ambi.Inv.AddItem
local STACK = 1000

-- ---------------------------------------------------------------------------------------------------------------------------------------
local CATEGORY = 'Еда'

Add( 'hotdog', 'Хотдогина', STACK, CATEGORY, 'Вкусная пища: 25 хп', 'https://i.postimg.cc/JGSWdW8m/hotdog.png', function( ePly ) 
    local hp, max = ePly:Health(), ePly:GetMaxHealth()
    if ( hp >= max ) then ePly:Notify( 'У вас и так полно здоровья!', 5, NOTIFY_ERROR ) return false end

    local add = hp + 25
    ePly:SetHealth( math.min( max, add ) )
    ePly:Notify( 'Ты скушал и пополнил здоровице', 10, NOTIFY_ACCEPT )

    return true -- если вовзращает true, значит отберётся, если не вернёт, значит ничо
end )

Add( 'burger', 'Бургер', STACK, CATEGORY, 'Вкусная пища: 50 хп', 'https://i.postimg.cc/hJWchRZM/burger.png', function( ePly ) 
    local hp, max = ePly:Health(), ePly:GetMaxHealth()
    if ( hp >= max ) then ePly:Notify( 'У вас и так полно здоровья!', 5, NOTIFY_ERROR ) return false end

    local add = hp + 50
    ePly:SetHealth( math.min( max, add ) )
    ePly:Notify( 'Ты скушал и пополнил здоровице', 10, NOTIFY_ACCEPT )

    return true -- если вовзращает true, значит отберётся, если не вернёт, значит ничо
end )

Add( 'cake', 'Торт', STACK, CATEGORY, 'Вкусная пища: 75 хп', 'https://i.postimg.cc/87rT1z4j/cake.png', function( ePly ) 
    local hp, max = ePly:Health(), ePly:GetMaxHealth()
    if ( hp >= max ) then ePly:Notify( 'У вас и так полно здоровья!', 5, NOTIFY_ERROR ) return false end

    local add = hp + 75
    ePly:SetHealth( math.min( max, add ) )
    ePly:Notify( 'Ты скушал и пополнил здоровице', 10, NOTIFY_ACCEPT )

    return true -- если вовзращает true, значит отберётся, если не вернёт, значит ничо
end )