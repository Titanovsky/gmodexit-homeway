Ambi.Inv.inventories = Ambi.Inv.inventories or {}

local ENTITY = FindMetaTable( 'Entity' )

-- ----------------------------------------------------------------------------------------------------------------------------
function Ambi.Inv.GetInventory( sID )
    return Ambi.Inv.inventories[ sID ]
end

-- ----------------------------------------------------------------------------------------------------------------------------
function ENTITY:GetInventory()
    return Ambi.Inv.GetInventory( Ambi.Inv.GetKey( self ) )
end

function ENTITY:GetInvFreeSlots()
    local inv = Ambi.Inv.GetInventory( Ambi.Inv.GetKey( self ) )
    local items = inv.items 

    local slots = {}

    for i = 1, items do
        local item = items.item
        if item then continue end

        slots[ #slots + 1 ] = i
    end

    return slots
end