local Add = Ambi.Kit.Add
local MINUTE = 60
local HOUR = MINUTE * 60
local DAY = HOUR * 24

Add( 'vip', '', false, 1, function( ePly ) 
    return false
end )

-- Add( 'weapons', 'Выдача оружий', false, HOUR * 2, function( ePly )
--     local wep = table.Random( Ambi.MysticRP.Config.kit_weapons )
--     local item = Ambi.Inv.GetItem( wep )
--     if item then
--         ePly:AddInvItemOrDrop( wep, 1 )
--         ePly:ChatSend( '~AMBI_BLUE~ + ~AMBI~ '..item.name )
--     end

--     if ePly:IsVIP() then
--         local wep = table.Random( Ambi.MysticRP.Config.kit_weapons_vip )
--         local item = Ambi.Inv.GetItem( wep )

--         if item then
--             ePly:AddInvItemOrDrop( wep, 1 )

--             ePly:ChatSend( '~AMBI_ORANGE~ [VIP] ~AMBI_BLUE~ + ~AMBI~ '..item.name )
--         end
--     end

--     if ePly:IsPremium() then
--         local wep = table.Random( Ambi.MysticRP.Config.kit_weapons_premium )
--         local item = Ambi.Inv.GetItem( wep )

--         if item then
--             ePly:AddInvItemOrDrop( wep, 1 )
--             ePly:ChatSend( '~AMBI_PURPLE~ [Premium] ~AMBI_BLUE~ + ~AMBI~ '..item.name )
--         end
--     end

--     return true
-- end )

-- Add( 'premium', 'Premium', false, HOUR * 2, function( ePly )
--     if not ePly:IsPremium() then return false end

--     local time = ePly:TimeConnected() / 60 -- minutes
--     time = math.floor( time / 30 ) -- half-hour

--     local bonus = 400 * time + ( ePly:GetLevel() * math.random( 10, 20 ) )
--     ePly:AddXP( bonus )
--     ePly:ChatSend( '~AMBI~ +'..bonus )

--     local money = math.random( 4000, 12000 )
--     ePly:AddMoney( money )
--     ePly:ChatSend( '~G~ +'..money..'$' )

--     local skill = math.random( 1, 3 )
--     ePly:AddSkillPoints( skill )
--     ePly:ChatSend( '~B~ +'..money..' Skill Points' )

--     ePly:AddInvItemOrDrop( 'wep_arccw_gauss_rifle', 1 )
--     ePly:ChatSend( '~W~ Получена Гаусс пушка!' )

--     return true
-- end )

-- Donate

-- Add( 'dweapons', 'Выдача оружий', false, MINUTE * 10, function( ePly )
--     if not ePly:HasPurchase( 'kit_dweapons' ) then 
--         ePly:ChatSend( '~R~ >> F6 >> Спец. Оружия' )
--         ePly:SoundSend( 'Error4' )
--         IGS.UI( ePly )

--         return false 
--     end

--     local wep = table.Random( Ambi.MysticRP.Config.kit_weapons_vip )
--     local item = Ambi.Inv.GetItem( wep )

--     if item then
--         ePly:AddInvItemOrDrop( wep, 1 )

--         ePly:ChatSend( '~AMBI_ORANGE~ [Spec.Weapons] ~AMBI_BLUE~ + ~AMBI~ '..item.name )
--     end

--     local wep = table.Random( Ambi.MysticRP.Config.kit_weapons_premium )
--     local item = Ambi.Inv.GetItem( wep )

--     if item then
--         ePly:AddInvItemOrDrop( wep, 1 )
--         ePly:ChatSend( '~AMBI_PURPLE~ [Spec.Weapons] ~AMBI_BLUE~ + ~AMBI~ '..item.name )
--     end

--     return true
-- end )

-- Add( 'rpg', 'Выдача оружий', false, MINUTE * 10, function( ePly )
--     if not ePly:HasPurchase( 'kit_rpg' ) then 
--         ePly:ChatSend( '~R~ >> F6 >> RPG' )
--         ePly:SoundSend( 'Error4' )
--         IGS.UI( ePly )

--         return false 
--     end

--     ePly:Give( 'arccw_rpg7' )
--     ePly:SoundSend( 'Success1' )

--     return true
-- end )

-- Add( 'gauss', 'Выдача оружий', false, MINUTE * 20, function( ePly )
--     if not ePly:HasPurchase( 'kit_gauss' ) then 
--         ePly:ChatSend( '~R~ >> F6 >> Гаусс Пушка' )
--         ePly:SoundSend( 'Error4' )
--         IGS.UI( ePly )

--         return false 
--     end

--     ePly:Give( 'arccw_gauss_rifle' )
--     ePly:SoundSend( 'Success1' )

--     return true
-- end )

-- Add( 'boost1', 'Буст скорости', false, MINUTE * 5, function( ePly )
--     if not ePly:HasPurchase( 'boost_speed' ) then 
--         ePly:ChatSend( '~R~ >> F6' )
--         ePly:SoundSend( 'Error4' )
--         IGS.UI( ePly )

--         return false 
--     end

--     ePly:SetRunSpeed( ePly:GetRunSpeed() + 200 )
--     ePly:SetWalkSpeed( ePly:GetWalkSpeed() + 200 )
--     ePly:SoundSend( 'Success1' )

--     return true
-- end )

-- Add( 'boost2', 'Буст Здоровья', false, MINUTE * 5, function( ePly )
--     if not ePly:HasPurchase( 'boost_speed' ) then 
--         ePly:ChatSend( '~R~ >> F6' )
--         ePly:SoundSend( 'Error4' )
--         IGS.UI( ePly )

--         return false 
--     end

--     ePly:SetHealth( ePly:Health() + 200 )
--     ePly:SetMaxHealth( ePly:GetMaxHealth() + 200 )
--     ePly:SoundSend( 'Success1' )

--     return true
-- end )