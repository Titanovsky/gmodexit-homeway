Ambi.Inv.inventories = Ambi.Inv.inventories or {}

local SD, Gen = Ambi.Packages.Out( 'savedata, general' )

local ENTITY = FindMetaTable( 'Entity' )

local STRUCTURE_INVENTORY = {
    id = 'SteamID' or 0, -- у игрока SteamID, у энтити EntIndex
    time_created = 0,
    should_save = true,
    items = {}
}

-- ----------------------------------------------------------------------------------------------------------------------------
function Ambi.Inv.GiveInventory( eObj, bSave, nSlots )
    if not IsValid( eObj ) or not IsEntity( eObj ) then return end --todo error

    local id = eObj:IsPlayer() and eObj:SteamID() or eObj:EntIndex()
    if Ambi.Inv.inventories[ id ] then return end --todo error

    Ambi.Inv.inventories[ id ] = { -- так удобнее передавать клиенту, заместо самой энтити
        time_created = os.time(),
        should_save = bSave,
        items = {}
    }

    if nSlots then
        if ( nSlots < 1 ) then return end --todo error

        for i = 1, nSlots do
            Ambi.Inv.inventories[ id ].items[ i ] = {
                time_created = os.time()
            }
        end
    end

    local str = bSave and ' с сохранением' or ''
    Ambi.Inv.Log( 'Выдан инвентарь для '..tostring( eObj )..str )
    
    Ambi.Inv.Sync( eObj )

    hook.Call( '[Ambi.Inv.GaveInventory]', nil, eObj, bSave, id, Ambi.Inv.inventories[ id ] )
end

function Ambi.Inv.WipeInventory( eObj, bSave, nSlots )
    if not IsValid( eObj ) then return end

    local id = Ambi.Inv.GetKey( eObj )

    local inv = Ambi.Inv.inventories[ id ]
    if not inv then return end --todo error

    Ambi.Inv.inventories[ id ] = {
        time_created = os.time(),
        should_save = bSave,
        items = {}
    }

    if nSlots then
        if ( nSlots < 1 ) then Ambi.Inv.inventories[ id ] = nil return end --todo error

        for i = 1, nSlots do
            Ambi.Inv.inventories[ id ].items[ i ] = {
                time_created = os.time()
            }
        end
    end

    Ambi.Inv.Sync( eObj )
    Ambi.Inv.Save( eObj )

    Ambi.Inv.Log( 'Вайпнут инвентарь для '..tostring( eObj ) )

    hook.Call( '[Ambi.Inv.WipedInventory]', nil, eObj, bSave, Ambi.Inv.inventories[ id ], id )
end

function Ambi.Inv.Sync( ePly, anyKey )
    if not IsValid( ePly ) or not ePly:IsPlayer() then return end
    anyKey = anyKey or ePly:SteamID()

    net.Start( 'ambi_inv_send_inv_to_client' )
        net.WriteTable{ key = anyKey, inv = Ambi.Inv.inventories[ anyKey ] }
    net.Send( ePly )

    Ambi.Inv.Log( 'Инвентарь ('..anyKey..') отправлен на клиент к '..ePly:Nick()..' ('..ePly:SteamID()..')' )

    hook.Call( '[Ambi.Inv.Sync]', nil, ePly, anyKey, Ambi.Inv.inventories[ anyKey ] )
end

-- ----------------------------------------------------------------------------------------------------------------------------
function ENTITY:WipeInventory( bSave, nSlots )
    Ambi.Inv.WipeInventory( self, bSave, nSlots )
end

function ENTITY:GiveInventory( bSave, nSlots )
    Ambi.Inv.GiveInventory( self, bSave, nSlots )
end

-- ----------------------------------------------------------------------------------------------------------------------------
hook.Add( 'PlayerInitialSpawn', 'Ambi.Inv.GiveInventory', function( ePly ) 
    timer.Simple( 0.5, function()
        if not IsValid( ePly ) then return end
        if ePly:IsBot() then return end

        if Ambi.Inv.inventories[ ePly:SteamID() ] then Ambi.Inv.Sync( ePly ) return end

        local id = Ambi.Inv.GetKey( ePly )

        SD.IsValid( Ambi.Inv.Config.database_inv, { ID = id }, function()
            Ambi.Inv.Load( ePly )
        end, function() 
            Ambi.Inv.GiveInventory( ePly, Ambi.Inv.Config.should_save, Ambi.Inv.Config.slots )
        end )
    end )
end )