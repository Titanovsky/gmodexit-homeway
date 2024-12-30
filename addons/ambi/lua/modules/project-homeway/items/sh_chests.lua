local Add = Ambi.Inv.AddItem
local STACK = 10

local ICON_CHEST = 'https://i.postimg.cc/qqcMhgTK/chest-skins-d.png'
local ICON_CHEST_MONEY = 'https://i.postimg.cc/90HQQZvV/chest-money-rubles-d.png'
local ICON_CHEST_WEAPON = 'https://i.postimg.cc/jdKjV6H4/chest-weapons.png'

-- ---------------------------------------------------------------------------------------------------------------------------------------
local CATEGORY = 'Сундуки'

Add( 'chest', 'Сундук', STACK, CATEGORY, 'Открой и ахуей', ICON_CHEST, function( ePly ) 
    if IsValid( ePly:GetEyeTrace().Entity ) and ( ePly:GetEyeTrace().Entity:GetClass() == 'build_industry' ) then ePly:Notify( 'Нельзя вызвать внутри завода', 6, NOTIFY_ERROR ) return false end
    local pos = Ambi.General.Utility.GetFrontPos( ePly, 75 ) + Vector( 0, 0, 0 )

    local chest = ents.Create( 'chest' )
    chest:SetPos( pos )
    chest:Spawn()
    chest:SetPlayerOwner( ePly )
    chest:SetChest( 'chest' )

    local direction = ( ePly:GetPos() - chest:GetPos()):GetNormalized()
    local ang = direction:Angle()

    chest:SetAngles( Angle( 0, ang.y, ang.z ) )

    return true
end )

Add( 'chest_money', 'Сундук: Денежный', STACK, CATEGORY, 'Открой и ахуей', ICON_CHEST_MONEY, function( ePly ) 
    if IsValid( ePly:GetEyeTrace().Entity ) and ( ePly:GetEyeTrace().Entity:GetClass() == 'build_industry' ) then ePly:Notify( 'Нельзя вызвать внутри завода', 6, NOTIFY_ERROR ) return false end
    local pos = Ambi.General.Utility.GetFrontPos( ePly, 75 ) + Vector( 0, 0, 0 )

    local chest = ents.Create( 'chest' )
    chest:SetPos( pos )
    chest:Spawn()
    chest:SetPlayerOwner( ePly )
    chest:SetChest( 'money' )
    chest:EmitSound( 'ambi/painkiller/accept2.ogg' )

    local direction = ( ePly:GetPos() - chest:GetPos()):GetNormalized()
    local ang = direction:Angle()

    chest:SetAngles( Angle( 0, ang.y, ang.z ) )

    return true
end )

Add( 'chest_weapons', 'Сундук: Оружейный', STACK, CATEGORY, 'Открой и ахуей', ICON_CHEST_WEAPON, function( ePly ) 
    if IsValid( ePly:GetEyeTrace().Entity ) and ( ePly:GetEyeTrace().Entity:GetClass() == 'build_industry' ) then ePly:Notify( 'Нельзя вызвать внутри завода', 6, NOTIFY_ERROR ) return false end
    local pos = Ambi.General.Utility.GetFrontPos( ePly, 75 ) + Vector( 0, 0, 0 )

    local chest = ents.Create( 'chest' )
    chest:SetPos( pos )
    chest:Spawn()
    chest:SetPlayerOwner( ePly )
    chest:SetChest( 'weapons' )

    local direction = ( ePly:GetPos() - chest:GetPos()):GetNormalized()
    local ang = direction:Angle()

    chest:SetAngles( Angle( 0, ang.y, ang.z ) )

    return true
end )

Add( 'chest_skins', 'Сундук: Скины', STACK, CATEGORY, 'Открой и ахуей', ICON_CHEST, function( ePly ) 
    if IsValid( ePly:GetEyeTrace().Entity ) and ( ePly:GetEyeTrace().Entity:GetClass() == 'build_industry' ) then ePly:Notify( 'Нельзя вызвать внутри завода', 6, NOTIFY_ERROR ) return false end
    local pos = Ambi.General.Utility.GetFrontPos( ePly, 75 ) + Vector( 0, 0, 0 )

    local chest = ents.Create( 'chest' )
    chest:SetPos( pos )
    chest:Spawn()
    chest:SetPlayerOwner( ePly )
    chest:SetChest( 'clothes' )

    local direction = ( ePly:GetPos() - chest:GetPos()):GetNormalized()
    local ang = direction:Angle()

    chest:SetAngles( Angle( 0, ang.y, ang.z ) )

    return true
end )

Add( 'chest_food', 'Сундук: Еда', STACK, CATEGORY, 'Открой и ахуей', ICON_CHEST, function( ePly ) 
    if IsValid( ePly:GetEyeTrace().Entity ) and ( ePly:GetEyeTrace().Entity:GetClass() == 'build_industry' ) then ePly:Notify( 'Нельзя вызвать внутри завода', 6, NOTIFY_ERROR ) return false end
    local pos = Ambi.General.Utility.GetFrontPos( ePly, 75 ) + Vector( 0, 0, 0 )

    local chest = ents.Create( 'chest' )
    chest:SetPos( pos )
    chest:Spawn()
    chest:SetPlayerOwner( ePly )
    chest:SetChest( 'food' )

    local direction = ( ePly:GetPos() - chest:GetPos()):GetNormalized()
    local ang = direction:Angle()

    chest:SetAngles( Angle( 0, ang.y, ang.z ) )

    return true
end )

Add( 'chest_boost', 'Сундук: Бусты', STACK, CATEGORY, 'Открой и ахуей', ICON_CHEST, function( ePly ) 
    if IsValid( ePly:GetEyeTrace().Entity ) and ( ePly:GetEyeTrace().Entity:GetClass() == 'build_industry' ) then ePly:Notify( 'Нельзя вызвать внутри завода', 6, NOTIFY_ERROR ) return false end
    local pos = Ambi.General.Utility.GetFrontPos( ePly, 75 ) + Vector( 0, 0, 0 )

    local chest = ents.Create( 'chest' )
    chest:SetPos( pos )
    chest:Spawn()
    chest:SetPlayerOwner( ePly )
    chest:SetChest( 'boost' )

    local direction = ( ePly:GetPos() - chest:GetPos()):GetNormalized()
    local ang = direction:Angle()

    chest:SetAngles( Angle( 0, ang.y, ang.z ) )

    return true
end )

Add( 'chest_small_donate_rubles', 'Маленький Сундук: Рубли', STACK, CATEGORY, 'Открой и ахуей', ICON_CHEST, function( ePly ) 
    if IsValid( ePly:GetEyeTrace().Entity ) and ( ePly:GetEyeTrace().Entity:GetClass() == 'build_industry' ) then ePly:Notify( 'Нельзя вызвать внутри завода', 6, NOTIFY_ERROR ) return false end
    local pos = Ambi.General.Utility.GetFrontPos( ePly, 75 ) + Vector( 0, 0, 0 )

    local chest = ents.Create( 'chest' )
    chest:SetPos( pos )
    chest:Spawn()
    chest:SetPlayerOwner( ePly )
    chest:SetChest( 'small_donate_rubles' )

    local direction = ( ePly:GetPos() - chest:GetPos()):GetNormalized()
    local ang = direction:Angle()

    chest:SetAngles( Angle( 0, ang.y, ang.z ) )

    return true
end )

-- ---------------------------------------------------------------------------------------------------------------------------------------
local CATEGORY = 'Сундуки Донатные'

Add( 'chest_d', '[+] Сундук', STACK, CATEGORY, 'Донатный сундук ', ICON_CHEST, function( ePly ) 
    if IsValid( ePly:GetEyeTrace().Entity ) and ( ePly:GetEyeTrace().Entity:GetClass() == 'build_industry' ) then ePly:Notify( 'Нельзя вызвать внутри завода', 6, NOTIFY_ERROR ) return false end
    local pos = Ambi.General.Utility.GetFrontPos( ePly, 75 ) + Vector( 0, 0, 0 )

    local chest = ents.Create( 'chest' )
    chest:SetPos( pos )
    chest:Spawn()
    chest:SetPlayerOwner( ePly )
    chest:SetChest( 'chest_d' )
    chest:SetModel( 'models/clashroyale/chests/kingchest.mdl' )
    chest:SetColor( Color( 255, 255, 255, 255 ) )

    local direction = ( ePly:GetPos() - chest:GetPos()):GetNormalized()
    local ang = direction:Angle()

    chest:SetAngles( Angle( 0, ang.y, ang.z ) )

    return true
end )

Add( 'chest_money_d', '[+] Сундук: Денежный', STACK, CATEGORY, 'Открой и ахуей', ICON_CHEST_MONEY, function( ePly ) 
    if IsValid( ePly:GetEyeTrace().Entity ) and ( ePly:GetEyeTrace().Entity:GetClass() == 'build_industry' ) then ePly:Notify( 'Нельзя вызвать внутри завода', 6, NOTIFY_ERROR ) return false end
    local pos = Ambi.General.Utility.GetFrontPos( ePly, 75 ) + Vector( 0, 0, 0 )

    local chest = ents.Create( 'chest' )
    chest:SetPos( pos )
    chest:Spawn()
    chest:SetPlayerOwner( ePly )
    chest:SetChest( 'money_d' )
    chest:SetModel( 'models/clashroyale/chests/kingchest.mdl' )
    chest:SetColor( Color( 255, 255, 255, 255 ) )

    local direction = ( ePly:GetPos() - chest:GetPos()):GetNormalized()
    local ang = direction:Angle()

    chest:SetAngles( Angle( 0, ang.y, ang.z ) )

    return true
end )

Add( 'chest_weapons_d', '[+] Сундук: Оружейный', STACK, CATEGORY, 'Открой и ахуей', ICON_CHEST_WEAPON, function( ePly ) 
    if IsValid( ePly:GetEyeTrace().Entity ) and ( ePly:GetEyeTrace().Entity:GetClass() == 'build_industry' ) then ePly:Notify( 'Нельзя вызвать внутри завода', 6, NOTIFY_ERROR ) return false end
    local pos = Ambi.General.Utility.GetFrontPos( ePly, 75 ) + Vector( 0, 0, 0 )

    local chest = ents.Create( 'chest' )
    chest:SetPos( pos )
    chest:Spawn()
    chest:SetPlayerOwner( ePly )
    chest:SetChest( 'weapons_d' )
    chest:SetModel( 'models/clashroyale/chests/kingchest.mdl' )
    chest:SetColor( Color( 255, 255, 255, 255 ) )

    local direction = ( ePly:GetPos() - chest:GetPos()):GetNormalized()
    local ang = direction:Angle()

    chest:SetAngles( Angle( 0, ang.y, ang.z ) )

    return true
end )

Add( 'chest_skins_d', '[+] Сундук: Скины', STACK, CATEGORY, 'Открой и ахуей', ICON_CHEST, function( ePly ) 
    if IsValid( ePly:GetEyeTrace().Entity ) and ( ePly:GetEyeTrace().Entity:GetClass() == 'build_industry' ) then ePly:Notify( 'Нельзя вызвать внутри завода', 6, NOTIFY_ERROR ) return false end
    local pos = Ambi.General.Utility.GetFrontPos( ePly, 75 ) + Vector( 0, 0, 0 )

    local chest = ents.Create( 'chest' )
    chest:SetPos( pos )
    chest:Spawn()
    chest:SetPlayerOwner( ePly )
    chest:SetChest( 'clothes_d' )
    chest:SetModel( 'models/clashroyale/chests/kingchest.mdl' )
    chest:SetColor( Color( 255, 255, 255, 255 ) )

    local direction = ( ePly:GetPos() - chest:GetPos()):GetNormalized()
    local ang = direction:Angle()

    chest:SetAngles( Angle( 0, ang.y, ang.z ) )

    return true
end )

Add( 'chest_food_d', '[+] Сундук: Еда', STACK, CATEGORY, 'Открой и ахуей', ICON_CHEST, function( ePly ) 
    if IsValid( ePly:GetEyeTrace().Entity ) and ( ePly:GetEyeTrace().Entity:GetClass() == 'build_industry' ) then ePly:Notify( 'Нельзя вызвать внутри завода', 6, NOTIFY_ERROR ) return false end
    local pos = Ambi.General.Utility.GetFrontPos( ePly, 75 ) + Vector( 0, 0, 0 )

    local chest = ents.Create( 'chest' )
    chest:SetPos( pos )
    chest:Spawn()
    chest:SetPlayerOwner( ePly )
    chest:SetChest( 'food_d' )
    chest:SetModel( 'models/clashroyale/chests/kingchest.mdl' )
    chest:SetColor( Color( 255, 255, 255, 255 ) )

    local direction = ( ePly:GetPos() - chest:GetPos()):GetNormalized()
    local ang = direction:Angle()

    chest:SetAngles( Angle( 0, ang.y, ang.z ) )

    return true
end )

Add( 'chest_boost_d', '[+] Сундук: Бусты', STACK, CATEGORY, 'Открой и ахуей', ICON_CHEST, function( ePly ) 
    if IsValid( ePly:GetEyeTrace().Entity ) and ( ePly:GetEyeTrace().Entity:GetClass() == 'build_industry' ) then ePly:Notify( 'Нельзя вызвать внутри завода', 6, NOTIFY_ERROR ) return false end
    local pos = Ambi.General.Utility.GetFrontPos( ePly, 75 ) + Vector( 0, 0, 0 )

    local chest = ents.Create( 'chest' )
    chest:SetPos( pos )
    chest:Spawn()
    chest:SetPlayerOwner( ePly )
    chest:SetChest( 'boost_d' )
    chest:SetModel( 'models/clashroyale/chests/kingchest.mdl' )
    chest:SetColor( Color( 255, 255, 255, 255 ) )

    local direction = ( ePly:GetPos() - chest:GetPos()):GetNormalized()
    local ang = direction:Angle()

    chest:SetAngles( Angle( 0, ang.y, ang.z ) )

    return true
end )

Add( 'chest_money_rubles_d', '[Р] Сундук: Рублёвый', STACK, CATEGORY, 'Открой и ахуей', ICON_CHEST_MONEY, function( ePly ) 
    if IsValid( ePly:GetEyeTrace().Entity ) and ( ePly:GetEyeTrace().Entity:GetClass() == 'build_industry' ) then ePly:Notify( 'Нельзя вызвать внутри завода', 6, NOTIFY_ERROR ) return false end
    local pos = Ambi.General.Utility.GetFrontPos( ePly, 75 ) + Vector( 0, 0, 0 )

    local chest = ents.Create( 'chest' )
    chest:SetPos( pos )
    chest:Spawn()
    chest:SetPlayerOwner( ePly )
    chest:SetChest( 'money_rubles' )
    chest:SetModel( 'models/clashroyale/chests/fortunechest.mdl' ) 

    local direction = ( ePly:GetPos() - chest:GetPos()):GetNormalized()
    local ang = direction:Angle()

    chest:SetAngles( Angle( 0, ang.y, ang.z ) )

    local id = chest:EntIndex()
    hook.Add( 'Think', 'Ambi.Homeway.ChestRubles:'..id, function() 
        if not IsValid( chest ) then hook.Remove( 'Think', 'Ambi.Homeway.ChestRubles:'..id ) return end

        chest:SetColor( HSVToColor( ( CurTime() * 35 ) % 360, 1, 1 ) )
    end )

    return true
end )