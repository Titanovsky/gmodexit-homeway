local Add = Ambi.Inv.AddItem
local CATEGORY = 'Общее'

-- ---------------------------------------------------------------------------------------------------------------------------------------
Add( 'small_health', 'Подорожник', 1000, CATEGORY, 'Для лечения', 'https://i.postimg.cc/CBMyfhGC/small-health.png', function( ePly ) 
    local hp, max = ePly:Health(), ePly:GetMaxHealth()
    if ( hp >= max ) then ePly:Notify( 'У вас и так полно здоровья!', 5, NOTIFY_ERROR ) return false end

    local add = hp + 25
    ePly:SetHealth( math.min( max, add ) )
    ePly:Notify( 'Наложил подорожник', 10, NOTIFY_ACCEPT )
end )

Add( 'armor', 'Половина Брони', 1000, CATEGORY, 'Для лечения', 'https://i.postimg.cc/94dV7gv2/armor.png', function( ePly ) 
    local armor, max = ePly:Armor(), ePly:GetMaxArmor()
    if ( armor >= ( max / 2 ) ) then ePly:Notify( 'У вас и так броня есть', 5, NOTIFY_ERROR ) return false end

    ePly:SetArmor( max / 2 )
    ePly:Notify( 'Ты надел половину брони', 10, NOTIFY_ACCEPT )

    return true 
end )