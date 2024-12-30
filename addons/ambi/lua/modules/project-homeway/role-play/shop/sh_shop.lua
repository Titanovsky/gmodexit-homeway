-- Полная информация по созданию предметов в магазин --> https://titanovskyteam.gitbook.io/darkrp/getting-started/create-shop

if not Ambi.DarkRP then return end

local C = Ambi.Packages.Out( 'colors' )
local AddItem = Ambi.DarkRP.AddShopItem
local SimpleAddItem = Ambi.DarkRP.SimpleAddItem

-- ----------------------------------------------------------------------------------------------------------------------------
AddItem( 'rainbow_printer', { 
    name = 'Денежный Принтер', 
    ent = 'ent_rainbow_printer',
    description = 'Це нелегально',
    model = 'models/props_c17/consolebox01a.mdl',
    category = 'Денежный Принтер',
    price = 10000,
    max = 3,
    order = 101,
    Spawned = function( ePly, eObj )
        Ambi.DarkRP.Wanted( ePly, nil, 'Купил денежный принтер' )
    end,
    CanBuy = function( ePly )
        if ( #player.GetHumans() < 6 ) then ePly:Notify( 'Нужен онлайн от 6-ти человек', 8, NOTIFY_ERROR ) return false end
    end,
    remove_after_set_job = true,
} )

AddItem( 'rainbow_printer_upgrader', { 
    name = 'Апгрейд для маника', 
    ent = 'ent_rainbow_upgrader',
    description = '-1 секунда * Апгрейд и 100$ * Апгрейд',
    model = 'models/props_lab/box01a.mdl',
    category = 'Денежный Принтер',
    price = 20000,
    max = 2,
    order = 101,
    remove_after_set_job = true,
} )

AddItem( 'rainbow_printer_kit_repair', { 
    name = 'Ремонтный набор', 
    ent = 'ent_rainbow_kit_repair',
    description = 'Це нелегально',
    model = 'models/props_lab/box01a.mdl',
    category = 'Денежный Принтер',
    price = 2000,
    max = 2,
    order = 101,
    remove_after_set_job = true,
} )

AddItem( 'rainbow_printer_silencer', { 
    name = 'Глушитель маника', 
    ent = 'ent_rainbow_silencer',
    description = 'Це нелегально',
    model = 'models/props_lab/box01a.mdl',
    category = 'Денежный Принтер',
    price = 6000,
    max = 2,
    order = 101,
    remove_after_set_job = true,
} )

AddItem( 'boombox', { 
    name = 'Бумбокс (Радио)', 
    ent = 'boombox',
    description = 'Бумбокс для онлайн радио. Можно уничтожить',
    model = 'models/custom/boombox.mdl',
    category = 'Денежный Принтер',
    price = 10000,
    max = 1,
    order = 101,
    remove_after_set_job = true,
    allowed = { 'j_dj' }
} )

AddItem( 'box_for_money', { 
    name = 'Ящик для пожертвований', 
    ent = 'box_for_money',
    description = 'Ящик для сбора подати. Можно уничтожить',
    model = 'models/props/cs_militia/footlocker01_closed.mdl',
    category = 'Денежный Принтер',
    price = 1000,
    max = 4,
    order = 101,
    remove_after_set_job = true,
    allowed = { 'j_citizen', 'j_med', 'j_businessman', 'j_gundealer', 'j_miner', 'j_fc_worker', 'j_dj', 'j_mayor' }
} )

-- SimpleAddShopItem( sClass, sName, sCategory, sDescription, sClassEntity, sModel, nMax, nPrice, nDelay, tOther )
-- SimpleAddShopItem( 'money_printer', 'Денежный Принтер', 'Денежные Принтеры', 'Описание', 'money_printer', 'models/props_c17/consolebox01a.mdl', 4, 2000 )