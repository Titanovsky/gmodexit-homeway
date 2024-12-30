local C = Ambi.Packages.Out( 'colors' )
local Add = Ambi.DarkRP.AddShopItem
local SimpleAddItem = Ambi.DarkRP.SimpleAddShopItem

local ALL = 1
local VIP = 2
local PREMIUM = 3

-- ----------------------------------------------------------------------------------------------------------------------------
local function AddWeapon( sClass, sName, sEntity, nPrice, nTypeAllowed, sCategory )
    local _allowed = {}
    if ( nTypeAllowed == 1 ) then _allowed = { 'j_gundealer', 'j_gundealer_vip' }
    elseif ( nTypeAllowed == 2 ) then _allowed = { 'j_gundealer_vip' }
    elseif ( nTypeAllowed == 3 ) then _allowed = { 'j_gundealer_premium' }
    end

    local tab = Add( sClass, {
        name = sName or sClass,
        ent = sEntity,
        weapon = true,
        model = '',
        price = nPrice or 1000,
        max = 2,
        allowed = _allowed,
        order = 44,
        
        category = sCategory
    } )

    timer.Simple( 0.1, function()
        tab.model = weapons.Get( sEntity ).WorldModel
    end )

    return tab
end

-- ----------------------------------------------------------------------------------------------------------------------------
local CATEGORY = 'Weapons'

Add( 'lockpick', {
    name = 'Отмычка',
    ent = 'lockpick',
    weapon = true,
    model = 'models/weapons/w_crowbar.mdl',
    price = 800,
    max = 1,
    allowed = { 'j_mafia1', 'j_mafia2', 'j_mafia_leader', 'j_mafia_spec', 'j_mafia_elite', 'j_gang1', 'j_gang_spec', 'j_gundealer_premium', 'j_gang_elit', },
    
    category = CATEGORY
} )

Add( 'gunbox', {
    name = 'Знания Бокса',
    weapon = true,
    ent = 'arccw_melee_fists',
    model = 'models/Gibs/HGIBS.mdl',
    price = 500,
    max = 4,
    
    category = CATEGORY
} )

Add( 'knife', {
    name = 'Нож',
    weapon = true,
    ent = 'arccw_melee_knife',
    model = 'models/weapons/w_knife_t.mdl',
    price = 4000,
    max = 2,
    allowed = { 'j_gundealer', 'j_gundealer_vip', 'j_gundealer_premium' },
    
    category = CATEGORY
} )

-- ----------------------------------------------------------------------------------------------------------------------------
local CATEGORY = 'Weapons: Pistols'

AddWeapon( 'makarov', 'Макаров', 'arccw_makarov', 2200, ALL, CATEGORY )
AddWeapon( 'g18', 'Glock 18', 'arccw_g18', 3500, ALL, CATEGORY )
AddWeapon( 'm9', 'M92FS', 'arccw_m9', 4600, ALL, CATEGORY )
AddWeapon( 'deagle', 'Desert Eagle', 'arccw_deagle357', 12000, ALL, CATEGORY )

AddWeapon( 'p228', 'P228', 'arccw_p228', 5000, VIP, CATEGORY )

AddWeapon( 'prem_makarov', '+ Макаров', 'arccw_makarov', 1500, PREMIUM, CATEGORY )
AddWeapon( 'prem_g18', '+ Glock 18', 'arccw_g18', 2500, PREMIUM, CATEGORY )
AddWeapon( 'prem_m9', '+ M92FS', 'arccw_m9', 3000, PREMIUM, CATEGORY )
AddWeapon( 'prem_p228', '+ P228', 'arccw_p228', 4000, PREMIUM, CATEGORY )
AddWeapon( 'prem_deagle', '+ Desert Eagle', 'arccw_deagle357', 7500, PREMIUM, CATEGORY )

-- ----------------------------------------------------------------------------------------------------------------------------
local CATEGORY = 'Weapons: Shotguns'

AddWeapon( 'shorty', 'Shorty', 'arccw_shorty', 6000, ALL, CATEGORY )
AddWeapon( 'db', 'Sawn-Off', 'arccw_db', 7500, ALL, CATEGORY )

AddWeapon( 'db_small', 'Small Sawn-Off', 'arccw_db_sawnoff', 2900, VIP, CATEGORY )

AddWeapon( 'prem_db_small', '+ Small Sawn-Off', 'arccw_db_sawnoff', 1200, PREMIUM, CATEGORY )
AddWeapon( 'prem_shorty', '+ Shorty', 'arccw_shorty', 4000, PREMIUM, CATEGORY )
AddWeapon( 'prem_db', '+ Sawn-Off', 'arccw_db', 3000, PREMIUM, CATEGORY )
AddWeapon( 'prem_m1014', '+ M1014', 'arccw_m1014', 9000, PREMIUM, CATEGORY )

-- -- ----------------------------------------------------------------------------------------------------------------------------
local CATEGORY = 'Weapons: SMGs'

AddWeapon( 'tmp', 'TMP', 'arccw_tmp', 8000, ALL, CATEGORY )
AddWeapon( 'ump', 'UMP 45', 'arccw_ump45', 9000, ALL, CATEGORY )
AddWeapon( 'galil', 'Galil', 'arccw_galil556', 12000, ALL, CATEGORY )

AddWeapon( 'prem_tmp', '+ TMP', 'arccw_tmp', 5500, ALL, CATEGORY )
AddWeapon( 'prem_ump', '+ UMP 45', 'arccw_ump45', 7500, ALL, CATEGORY )
AddWeapon( 'prem_galil', '+ Galil', 'arccw_galil556', 9000, ALL, CATEGORY )
AddWeapon( 'MP5', '+ MP5', 'arccw_mp5', 10500, ALL, CATEGORY )

-- -- ----------------------------------------------------------------------------------------------------------------------------
local CATEGORY = 'Weapons: Hard Rifle'

AddWeapon( 'aug', 'AUG', 'arccw_aug', 12000, ALL, CATEGORY )
AddWeapon( 'p90', 'P90', 'arccw_p90', 16000, ALL, CATEGORY )
AddWeapon( 'g3a3', 'G3A3', 'arccw_g3a3', 18000, ALL, CATEGORY )
AddWeapon( 'ak47', 'AK-47', 'arccw_ak47', 20000, ALL, CATEGORY )

AddWeapon( 'bizon', 'Bizon', 'arccw_bizon', 15000, VIP, CATEGORY )
AddWeapon( 'm14', 'Абакан', 'arccw_m14', 20000, VIP, CATEGORY )
AddWeapon( 'sg550', 'SG 550', 'arccw_sg550', 25000, VIP, CATEGORY )

AddWeapon( 'prem_aug', '+ AUG', 'arccw_aug', 9000, PREMIUM, CATEGORY )
AddWeapon( 'prem_bizon', '+ Bizon', 'arccw_bizon', 11000, PREMIUM, CATEGORY )
AddWeapon( 'prem_p90', '+ P90', 'arccw_p90', 13000, PREMIUM, CATEGORY )
AddWeapon( 'prem_g3a3', '+ G3A3', 'arccw_g3a3', 14500, PREMIUM, CATEGORY )
AddWeapon( 'prem_ak47', '+ AK-47', 'arccw_ak47', 15000, PREMIUM, CATEGORY )
AddWeapon( 'prem_m14', '+ Абакан', 'arccw_m14', 16000, PREMIUM, CATEGORY )
AddWeapon( 'prem_sg550', '+ SG 550', 'arccw_sg550', 19000, PREMIUM, CATEGORY )

-- -- ----------------------------------------------------------------------------------------------------------------------------
local CATEGORY = 'Weapons: Special'

AddWeapon( 'prem_awp', '+ AWP', 'arccw_awm', 25000, PREMIUM, CATEGORY )
AddWeapon( 'prem_m60', '+ Пулемёт', 'arccw_m60', 32000, PREMIUM, CATEGORY )
AddWeapon( 'prem_rpg', '+ RPG 7', 'arccw_rpg7', 80000, PREMIUM, CATEGORY )


-- Ambi.DarkRP.AddShipmentFromShopWeapon( 'gauss', 'Gauss [Коробка]', CATEGORY, 'dsa', 16, 2, {
--     allowed = { 'j_gundealer_vip' },
-- } )