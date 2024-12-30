local Gen = Ambi.Packages.Out( 'general' )

local ENTITY = FindMetaTable( 'Entity' )

local STRUCTURE_ITEMS = {
    [ 1 ] = {
        time_created = os.time(),
        item = {},
    },

    [ 2 ] = {
        time_created = os.time(),
        item = {},
    }
}
local STRUCTURE_ITEM = {
    class = 'item_class',
    count = 9999,
    time_created = os.time(),
}

-- ----------------------------------------------------------------------------------------------------------------------------
function ENTITY:AddInvItem( sClass, nCount, bForce )
    if not nCount or ( nCount <= 0 ) then Gen.Error( 'Inv', 'nCount <= 0 or is nill for '..sClass ) return end

    nCount = math.floor( nCount )

    local inv = Ambi.Inv.GetInventory( Ambi.Inv.GetKey( self ) )
    if not inv then Gen.Error( 'Inv', 'Doesnt have Inventory for '..tostring( self ) ) return end

    local items = inv.items

    local item_class = Ambi.Inv.GetItem( sClass )
    if not item_class then Gen.Error( 'Inv', 'sClass '..sClass..' is not valid' ) return end 

    local stack = item_class.stack
    local all_count = 0
    local same_slots = {}
    local free_slots = {}

    for i = 1, #items do
        local item = items[ i ].item

        if item then
            if ( item.class ~= sClass ) then continue end

            --if ( item.count > stack ) then return end --todo error

            all_count = all_count + item.count

            local len = #same_slots + 1
            same_slots[ len ] = {}
            same_slots[ len ].slot = i

            for k, v in pairs( item ) do
                same_slots[ len ][ k ] = v
            end
        else
            free_slots[ #free_slots + 1 ] = i
        end
    end

    local all_stack = stack * ( #same_slots + #free_slots )

    local has = false

    if bForce then 
        if same_slots[ 1 ] then
            local item = items[ same_slots[ 1 ].slot ].item
            item.count = item.count + nCount 

            has = true
        elseif free_slots[ 1 ] then
            items[ free_slots[ 1 ] ].item = {
                class = sClass,
                count = nCount,
                time_created = os.time(),
            }

            has = true
        end

        if not has then
            --todo make entity
            has = true
        end
    else
        if ( nCount + all_count > all_stack ) then return end
    end

    if not has then
        for i = 1, #same_slots do
            if ( nCount <= 0 ) then break end

            local item = items[ same_slots[ i ].slot ].item
            item.slot = nil -- the table has reference type of data

            local count = item.count
            if ( count >= stack ) then continue end

            local new_count = nCount + count > stack and stack - count or nCount --!

            nCount = nCount - new_count

            item.count = count + new_count

            Ambi.Inv.Log( 'Добавлено '..item.count..'/'..stack..' '..item_class.name..' ('..sClass..') для '..tostring( self ) )

            hook.Call( '[Ambi.Inv.EntityAddedItem]', nil, self, item.count, count, sClass, nCount, bForce )
        end

        for i = 1, #free_slots do
            if ( nCount <= 0 ) then break end

            local new_count = math.min( nCount, stack )
            nCount = nCount - new_count

            items[ free_slots[ i ] ].item = {
                class = sClass,
                count = new_count,
                time_created = os.time(),
            }

            Ambi.Inv.Log( 'Добавлено новое '..new_count..'/'..stack..' '..item_class.name..' ('..sClass..') для '..tostring( self ) )

            hook.Call( '[Ambi.Inv.EntityAddedItem]', nil, self, new_count, sClass, nCount, bForce )
        end
    end

    Ambi.Inv.Sync( self ) -- for player
    Ambi.Inv.Save( self )
end

function ENTITY:RemoveInvItem( sClass, nCount )
    --if not nCount or ( nCount <= 0 ) then return end
    
    local inv = Ambi.Inv.GetInventory( Ambi.Inv.GetKey( self ) )
    if not inv then Gen.Error( 'Inv', 'Doesnt have Inventory for '..tostring( self ) ) return end

    local items = inv.items

    local item_class = Ambi.Inv.GetItem( sClass )
    if not item_class then return end --todo error

    for i = 1, #items do
        if ( nCount <= 0 ) then break end

        local item = items[ i ].item
        if not item then continue end
        if ( item.class ~= sClass ) then continue end

        local new_count = item.count - nCount
        nCount = nCount - item.count

        item.count = new_count < 0 and 0 or new_count

        Ambi.Inv.Log( 'Удалено '..item_class.name..' ('..sClass..') на '..item.count..'/'..item_class.stack..' для '..tostring( self ) )

        if ( item.count <= 0 ) then items[ i ].item = nil end

        hook.Call( '[Ambi.Inv.EntityRemovedItem]', nil, self, items[ i ].item, sClass, nCount )
    end

    Ambi.Inv.Sync( self ) -- for player
    Ambi.Inv.Save( self )
end

function ENTITY:RemoveInvItems( sClass )
    local inv = Ambi.Inv.GetInventory( Ambi.Inv.GetKey( self ) )
    if not inv then Gen.Error( 'Inv', 'Doesnt have Inventory for '..tostring( self ) ) return end

    local items = inv.items

    for i = 1, #items do
        local item = items[ i ].item
        if not item then continue end
        if ( item.class ~= sClass ) then continue end

        items[ i ].item = nil
    end

    Ambi.Inv.Sync( self ) -- for player
    Ambi.Inv.Save( self )

    hook.Call( '[Ambi.Inv.EntityRemovedItems]', nil, self, sClass )
end

function ENTITY:SetInvSlots( nSlots )
    if not nSlots then Gen.Error( 'Inv', 'nSlots is null for '..tostring( self ) ) return end

    local inv = Ambi.Inv.GetInventory( Ambi.Inv.GetKey( self ) )
    if not inv then Gen.Error( 'Inv', 'Doesnt have Inventory for '..tostring( self ) ) return end

    local items = inv.items

    nSlots = math.floor( nSlots )

    if ( nSlots > 0 ) then
        for i = 1, math.max( nSlots, #items ) do
            if items[ i ] then 
                if ( i > nSlots ) then items[ i ] = nil end

                continue 
            end

            items[ i ] = {
                time_created = os.time(),
            }
        end
    else
        items = {}
    end

    Ambi.Inv.Log( 'Изменены слоты на '..nSlots..' для '..tostring( self ) )

    Ambi.Inv.Sync( self ) -- for player
    Ambi.Inv.Save( self )

    hook.Call( 'Ambi.Inv.SetInvSlots', nil, self, nSlots, items, inv )
end

function ENTITY:SetInvSlot( nSlot, sClass, nCount, bForce )
    if not nSlot then return end --todo error
    if not nCount then return end --todo error

    nCount = math.floor( ( nCount < 0 ) and 0 or nCount )

    local inv = Ambi.Inv.GetInventory( Ambi.Inv.GetKey( self ) )
    if not inv then Gen.Error( 'Inv', 'Doesnt have Inventory for '..tostring( self ) ) return end

    local items = inv.items
    if not items[ nSlot ] then return end --todo error

    local item_class = Ambi.Inv.GetItem( sClass )
    if not item_class then return end --todo error

    items[ nSlot ].item = {
        class = sClass,
        count = bForce and nCount or math.min( item_class.stack, nCount ),
        time_created = os.time(),
    }

    Ambi.Inv.Log( 'Изменён слот ('..nSlot..') на предмет: '..item_class.name..' ('..sClass..'), '..nCount..'/'..item_class.stack..' для '..tostring( self ) )

    Ambi.Inv.Sync( self ) -- for player
    Ambi.Inv.Save( self )

    hook.Call( 'Ambi.Inv.SetInvSlot', nil, self, items[ nSlot ].item, nSlots, sClass, nCount, bForce )

    if ( items[ nSlot ].item.count == 0 ) then
        self:WipeInvSlot( nSlot )
    end
end

function ENTITY:AddInvSlotCount( nSlot, nCount )
    if not nSlot then return end --todo
    if not nCount then return end --todo

    nCount = math.floor( nCount )

    local inv = Ambi.Inv.GetInventory( Ambi.Inv.GetKey( self ) )
    if not inv then Gen.Error( 'Inv', 'Doesnt have Inventory for '..tostring( self ) ) return end

    local slot = inv.items
    if not slot[ nSlot ] then return end --todo error
    
    local item = slot[ nSlot ].item
    if not item then return end

    local count = item.count + nCount
    local stack = Ambi.Inv.GetItem( item.class ).stack

    count = count > stack and stack or count

    self:SetInvSlot( nSlot, item.class, count )
end

function ENTITY:WipeInvSlot( nSlot )
    if not nSlot then return end --todo error

    local inv = Ambi.Inv.GetInventory( Ambi.Inv.GetKey( self ) )
    if not inv then Gen.Error( 'Inv', 'Doesnt have Inventory for '..tostring( self ) ) return end

    local items = inv.items
    if not items[ nSlot ] then return end --todo error

    items[ nSlot ] = {
        time_created = os.time()
    }

    Ambi.Inv.Log( 'Вайпнут слот ('..nSlot..') для '..tostring( self ) )

    Ambi.Inv.Sync( self ) -- for player
    Ambi.Inv.Save( self )

    hook.Call( 'Ambi.Inv.WipedInvSlot', nil, self, nSlot )
end

function ENTITY:RemoveInvSlot( nSlot )
    if not nSlot then return end --todo error

    local inv = Ambi.Inv.GetInventory( Ambi.Inv.GetKey( self ) )
    if not inv then Gen.Error( 'Inv', 'Doesnt have Inventory for '..tostring( self ) ) return end

    local items = inv.items
    if not items[ nSlot ] then return end --todo error

    table.remove( items, nSlot )

    Ambi.Inv.Log( 'Удалён слот ('..nSlot..'/'..#items..') для '..tostring( self ) )

    Ambi.Inv.Sync( self ) -- for player
    Ambi.Inv.Save( self )

    hook.Call( 'Ambi.Inv.RemovedInvSlot', nil, self, nSlot )
end

function ENTITY:DropInvItem( nSlot, nCount )
    if not nSlot then return end --todo error

    local inv = Ambi.Inv.GetInventory( Ambi.Inv.GetKey( self ) )
    if not inv then Gen.Error( 'Inv', 'Doesnt have Inventory for '..tostring( self ) ) return end

    local items = inv.items

    local slot = items[ nSlot ]
    if not slot then return end --todo error

    local item = slot.item
    if not item then return end --todo error

    local pos, ang = Ambi.General.Utility.GetFrontPos( self, 44 ), self:EyeAngles()

    local ent = ents.Create( 'inv_item' )
    ent:SetPos( pos )
    ent:SetAngles( ang )
    ent:SetItem( item.class, nCount )
    ent:Spawn()

    if FPP then 
        ent:CPPISetOwner( self ) 
    end

    timer.Create( 'Ambi.Inv.DropItem:'..tostring( ent ), 60 * 6, 1, function()
        if IsValid( ent ) then ent:Remove() end
    end )

    if not self.warning_on_remove_items then
        self:ChatPrint( 'Если спустя 6 минут никто не подберёт мешок, он исчезнет!' )
        self.warning_on_remove_items = true
    end

    hook.Call( '[Ambi.Inv.DroppedItem]', nil, self, ent, item, nSlot, nCount )
end

function ENTITY:AddInvItemOrDrop( sClass, nCount )
    local count = self:GetInvItemCount( sClass )

    self:AddInvItem( sClass, nCount )

    if ( count >= self:GetInvItemCount( sClass ) ) then
        local pos, ang = Ambi.General.Utility.GetFrontPos( self, 44 ), self:EyeAngles()

        local ent = ents.Create( 'inv_item' )
        ent:SetPos( pos )
        ent:SetAngles( ang )
        ent:SetItem( sClass, nCount )
        ent:Spawn()

        if FPP then 
            ent:CPPISetOwner( self ) 
        end
    end
end

-- ----------------------------------------------------------------------------------------------------------------------------
net.Receive( 'ambi_inv_drop_item', function( _, ePly ) 
    local slot = net.ReadUInt( 10 )
    local count = net.ReadUInt( 16 )

    local ply_slot = ePly:GetInvSlot( slot )
    if not ply_slot then return end

    local item = ply_slot.item
    if not item then return end
    if ( count > item.count ) then return end

    ePly:DropInvItem( slot, count ) --! only first
    ePly:AddInvSlotCount( slot, -count )
end )

net.Receive( 'ambi_inv_use_item', function( _, ePly ) 
    local slot = net.ReadUInt( 10 )

    local ply_slot = ePly:GetInvSlot( slot )
    if not ply_slot then return end

    local item = ply_slot.item
    if not item then return end

    local class = Ambi.Inv.GetItem( item.class )
    if not class then return end
    if not class.Use then return end

    local result = class.Use( ePly, item, slot )
    if result then
        ePly:AddInvSlotCount( slot, -1 )
    end
end )