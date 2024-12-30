local Add = Ambi.Inv.AddItem
local STACK = 10

-- ---------------------------------------------------------------------------------------------------------------------------------------
local CATEGORY = 'Бусты'
local ICON = 'https://static.vecteezy.com/system/resources/previews/021/456/528/original/medical-pill-3d-icon-png.png'

Add( 'boost_hp', 'Буст: Здоровье', 1000, CATEGORY, 'Даёт временный буст', ICON, function( ePly ) 
    if ePly.boost_hp then ePly:Notify( 'Нельзя!', 5, NOTIFY_ERROR ) return false end

    local old_hp = ePly:Health()

    ePly:SetHealth( 255 )
    ePly:Notify( 'У вас 10 секунд', 10, NOTIFY_ACCEPT ) 
    ePly.boost_hp = true

    timer.Simple( 10, function()
        if not IsValid( ePly ) or not ePly:Alive() then return end

        ePly:SetHealth( old_hp )

        ePly.boost_hp = false
        ePly:Notify( 'Буст прошёл!', 3 )
    end )

    return true 
end )

Add( 'boost_speed', 'Буст: Скорость', 1000, CATEGORY, 'Даёт временный буст', ICON, function( ePly ) 
    if ePly.boost_speed then ePly:Notify( 'Нельзя!', 5, NOTIFY_ERROR ) return false end

    local old_walkspeed = ePly:GetWalkSpeed()
    local old_runspeed = ePly:GetRunSpeed()

    ePly:SetWalkSpeed( old_walkspeed + 150 )
    ePly:SetRunSpeed( old_runspeed + 200 )

    ePly:Notify( 'У вас 10 секунд', 10, NOTIFY_ACCEPT ) 
    ePly.boost_speed = true

    timer.Simple( 10, function()
        if not IsValid( ePly ) or not ePly:Alive() then return end

        ePly:SetWalkSpeed( old_walkspeed )
        ePly:SetRunSpeed( old_runspeed )

        ePly.boost_speed = false
        ePly:Notify( 'Буст прошёл!', 3 )
    end )

    return true 
end )

Add( 'boost_jumppower', 'Буст: Прыжок', 1000, CATEGORY, 'Даёт временный буст', ICON, function( ePly ) 
    if ePly.boost_jp then ePly:Notify( 'Нельзя!', 5, NOTIFY_ERROR ) return false end

    local old_jp = ePly:GetJumpPower()

    ePly:SetJumpPower( old_jp + 300 )

    ePly:Notify( 'У вас 10 секунд', 10, NOTIFY_ACCEPT ) 
    ePly.boost_jp = true

    timer.Simple( 10, function()
        if not IsValid( ePly ) or not ePly:Alive() then return end

        ePly:SetJumpPower( old_jp )

        ePly.boost_jp = false
        ePly:Notify( 'Буст прошёл!', 3 )
    end )

    return true 
end )

-- ---------------------------------------------------------------------------------------------------------------------------------------
local CATEGORY = 'Бусты.Донат'

Add( 'boost_hp_d', '+Буст: Здоровье', 1000, CATEGORY, 'Даёт временный буст', ICON, function( ePly ) 
    if ePly.boost_hp then ePly:Notify( 'Нельзя!', 5, NOTIFY_ERROR ) return false end

    local old_hp = ePly:Health()

    ePly:SetHealth( 500 )
    ePly:Notify( 'У вас 2 минуты', 10, NOTIFY_ACCEPT ) 
    ePly.boost_hp = true

    timer.Simple( 60 * 2, function()
        if not IsValid( ePly ) or not ePly:Alive() then return end

        ePly:SetHealth( old_hp )

        ePly.boost_hp = false
        ePly:Notify( 'Буст прошёл!', 3 )
    end )

    return true 
end )

Add( 'boost_speed_d', '+Буст: Скорость', 1000, CATEGORY, 'Даёт временный буст', ICON, function( ePly ) 
    if ePly.boost_speed then ePly:Notify( 'Нельзя!', 5, NOTIFY_ERROR ) return false end

    local old_walkspeed = ePly:GetWalkSpeed()
    local old_runspeed = ePly:GetRunSpeed()

    ePly:SetWalkSpeed( old_walkspeed + 200 )
    ePly:SetRunSpeed( old_runspeed + 350 )

    ePly:Notify( 'У вас 2 минуты', 10, NOTIFY_ACCEPT ) 
    ePly.boost_speed = true

    timer.Simple( 60 * 2, function()
        if not IsValid( ePly ) or not ePly:Alive() then return end

        ePly:SetWalkSpeed( old_walkspeed )
        ePly:SetRunSpeed( old_runspeed )

        ePly.boost_speed = false
        ePly:Notify( 'Буст прошёл!', 3 )
    end )

    return true 
end )

Add( 'boost_jumppower_d', '+Буст: Прыжок', 1000, CATEGORY, 'Даёт временный буст', ICON, function( ePly ) 
    if ePly.boost_jp then ePly:Notify( 'Нельзя!', 5, NOTIFY_ERROR ) return false end

    local old_jp = ePly:GetJumpPower()

    ePly:SetJumpPower( old_jp + 450 )

    ePly:Notify( 'У вас 2 минуты', 10, NOTIFY_ACCEPT ) 
    ePly.boost_jp = true

    timer.Simple( 60 * 2, function()
        if not IsValid( ePly ) or not ePly:Alive() then return end

        ePly:SetJumpPower( old_jp )

        ePly.boost_jp = false
        ePly:Notify( 'Буст прошёл!', 3 )
    end )

    return true 
end )