local ENTITY = FindMetaTable( 'Entity' )

-- ----------------------------------------------------------------------------------------------------------------------------
function ENTITY:GetInvItemCount( sClass )
    local inv = Ambi.Inv.GetInventory( Ambi.Inv.GetKey( self ) )
    local items = inv.items 

    local count = 0

    for i = 1, #items do
        local item = items[ i ].item
        if not item then continue end
        if ( item.class ~= sClass ) then continue end

        count = count + item.count
    end

    return count
end

function ENTITY:GetInvItemSlots( sClass )
    local inv = Ambi.Inv.GetInventory( Ambi.Inv.GetKey( self ) )
    local items = inv.items 

    local slots = {}

    for i = 1, #items do
        local item = items[ i ].item
        if not item then continue end
        if ( item.class ~= sClass ) then continue end

        slots[ #slots + 1 ] = item
        slots.slot = i
    end

    return slots
end

function ENTITY:GetInvSlot( nSlot )
    if not nSlot then return end

    local inv = Ambi.Inv.GetInventory( Ambi.Inv.GetKey( self ) )
    --todo
    local items = inv.items

    return items[ nSlot ]
end

function ENTITY:GetInvSlots()
    local inv = Ambi.Inv.GetInventory( Ambi.Inv.GetKey( self ) )
    local items = inv.items 

    return #items
end