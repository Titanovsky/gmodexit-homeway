if not Ambi.DarkRP then return end

local C = Ambi.Packages.Out( 'colors' )
local AddItem = Ambi.DarkRP.AddShopItem
local SimpleAddItem = Ambi.DarkRP.SimpleAddItem

-- ----------------------------------------------------------------------------------------------------------------------------
AddItem( 'mysticrp_lab', { 
    name = 'Лаборатория', 
    ent = 'mysticrp_lab',
    description = 'Машина для создания вирусов',
    model = 'models/props_lab/servers.mdl',
    category = 'Halloween',
    price = 75000,
    max = 1,
    order = 101,
    allowed = { 'j_scientist' },
    Spawned = function( ePly, eObj )
        Ambi.Homeway.NotifyAll( 'В городе появилась Лаборатория Вирусов', 12 )
    end,
    remove_after_set_job = true,
} )