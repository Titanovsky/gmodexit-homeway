local SD, Gen = Ambi.Packages.Out( 'savedata, general' )

local DB = SD.Create( Ambi.Inv.Config.database_inv, { ID = '', Inv = {} } )
-- local DB = SD.Create( 'mystic_entities_id', { ID = '', Class = '', Model = '',  } ) --todo for 

function Ambi.Inv.Save( eObj )
    if not Ambi.Inv.Config.should_save then return end

    local inv = eObj:GetInventory()
    if not inv then Gen.Error( 'Inv', 'Doesnt have Inventory for '..tostring( eObj ) ) return end
    if not inv.should_save then return end

    local id = Ambi.Inv.GetKey( eObj )

    if ( hook.Call( '[Ambi.Inv.CanSave]', nil, eObj, id, inv ) == false ) then return end

    SD.IsValid( DB, { ID = id }, function()
        SD.Set( DB, { ID = id }, { Inv = inv } )
    end, function() 
        SD.Init( DB, { ID = id, Inv = inv } )
    end )

    Ambi.Inv.Log( 'Сохранён инвентарь у '..tostring( eObj ) )

    hook.Call( '[Ambi.Inv.Saved]', nil, eObj, id, inv )
end 

function Ambi.Inv.Load( eObj, bForce )
    if not IsValid( eObj ) then Gen.Error( 'Inv', 'eObj == nil' ) return end

    local inv = eObj:GetInventory()
    if ( not bForce ) and inv then Gen.Error( 'Inv', 'Doesnt have Inventory for '..tostring( eObj ) ) return end 

    local id = Ambi.Inv.GetKey( eObj )

    local data = SD.Get( DB, { ID = id } ) -- it is always one table
    if not data then Gen.Error( 'Inv', 'data from SaveData == nil' ) return end

    local inv = data.Inv

    Ambi.Inv.inventories[ id ] = inv

    Ambi.Inv.Log( 'Загружен (сохранённый) инвентарь для '..tostring( eObj ) )

    Ambi.Inv.Sync( eObj )

    hook.Call( '[Ambi.Inv.Loaded]', nil, eObj, id, inv, bForce )
end