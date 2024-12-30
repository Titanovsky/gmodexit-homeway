Ambi.Promocode.promocodes = Ambi.Promocode.promocodes or {}

local SQL, C, Gen = Ambi.Packages.Out( 'sql, colors, general' )

local DB = SQL.CreateTable( 'ambi_promocode', 'Promocode, CanActivate, SteamID, Players, Header, Description, Date' )

-- ---------------------------------------------------------------------------------------------------------------------------------------------
function Ambi.Promocode.Add( sPromocode, sSteamID, sHeader, sDescription, fAction )
    if not sPromocode then return end

    sPromocode = string.ForceLower( sPromocode )

    if ( hook.Call( '[Ambi.Promocode.CanAdd]', nil, sPromocode, sSteamID, sHeader, sDescription, fAction ) == false ) then return end
    
    local promo = Ambi.Promocode.promocodes[ sPromocode ]

    Ambi.Promocode.promocodes[ sPromocode ] = {
        promocode = sPromocode,
        can_activate = true,
        header = sHeader or ( promo and promo.header or '' ),
        desc = sDescription or ( promo and promo.desc or '' ),
        steamid = sSteamID or ( promo and promo.steamid or '' ),
        players = promo and promo.players or 0,
        date = promo and promo.date or os.time(),
        Action = fAction or ( promo and promo.Action or nil ),
    }

    local tab = Ambi.Promocode.promocodes[ sPromocode ]
    if SQL.Select( DB, 'Promocode', 'Promocode', sPromocode ) then
        SQL.Update( DB, 'SteamID', tab.steamid, 'Promocode', sPromocode )
        SQL.Update( DB, 'Header', tab.header, 'Promocode', sPromocode )
        SQL.Update( DB, 'Description', tab.desc, 'Promocode', sPromocode )
        SQL.Update( DB, 'Players', tab.players, 'Promocode', sPromocode )
    else
        SQL.Insert( DB, 'Promocode, CanActivate, SteamID, Players, Header, Description, Date', '%s, %i, %s, %i, %s, %s, %i', sPromocode, 1, tab.steamid, tab.players, tab.header, tab.desc, tab.date )
    end

    if not promo then print( '[Promocode] Создан промокод: '..sPromocode ) end

    hook.Call( '[Ambi.Promocode.Added]', nil, Ambi.Promocode.promocodes[ sPromocode ] )
end

function Ambi.Promocode.Remove( sPromocode )
    if not sPromocode then return end

    sPromocode = string.ForceLower( sPromocode )

    SQL.Delete( DB, 'Promocode', sPromocode )
    Ambi.Promocode.promocodes[ sPromocode ] = nil

    print( '[Promocode] Промокод '..sPromocode..' удалён' )
end

function Ambi.Promocode.Get( sPromocode )
    return Ambi.Promocode.promocodes[ string.ForceLower( sPromocode or '' ) ]
end

function Ambi.Promocode.GetAll()
    return Ambi.Promocode.promocodes
end

function Ambi.Promocode.SetCanActivate( sPromocode, bCan )
    local promocode = Ambi.Promocode.Get( sPromocode )
    if not promocode then return end
    if ( hook.Call( '[Ambi.Promocode.CanSetActivate]', nil, promocode, bCan ) == false ) then return end

    sPromocode = promocode.promocode

    promocode.can_activate = bCan
    SQL.Update( DB, 'CanActivate', bCan and 1 or 0, 'Promocode', sPromocode )
end

function Ambi.Promocode.SetPlayers( sPromocode, nPlayers )
    if not nPlayers or not isnumber( nPlayers ) then return end
    nPlayers = math.floor( nPlayers )

    local promocode = Ambi.Promocode.Get( sPromocode )
    if not promocode then return end
    if ( hook.Call( '[Ambi.Promocode.CanSetPlayers]', nil, promocode, nPlayers ) == false ) then return end

    sPromocode = promocode.promocode

    promocode.players = nPlayers
    SQL.Update( DB, 'Players', nPlayers, 'Promocode', sPromocode )

    hook.Call( '[Ambi.Promocode.SetPlayers]', nil, promocode, nPlayers )
end

function Ambi.Promocode.AddPlayers( sPromocode, nPlayers )
    if not nPlayers or not isnumber( nPlayers ) then return end

    local promocode = Ambi.Promocode.Get( sPromocode )
    if not promocode then return end

    Ambi.Promocode.SetPlayers( sPromocode, nPlayers + promocode.players )
end

function Ambi.Promocode.SetHeader( sPromocode, sHeader )
    local promocode = Ambi.Promocode.Get( sPromocode )
    if not promocode then return end
    if ( hook.Call( '[Ambi.Promocode.CanSetHeader]', nil, promocode, sHeader ) == false ) then return end

    sPromocode = promocode.promocode

    promocode.header = sHeader
    SQL.Update( DB, 'Header', sHeader, 'Promocode', sPromocode )

    hook.Call( '[Ambi.Promocode.SetHeader]', nil, promocode, sHeader )
end

function Ambi.Promocode.SetSteamID( sPromocode, sSteamID )
    local promocode = Ambi.Promocode.Get( sPromocode )
    if not promocode then return end
    if ( hook.Call( '[Ambi.Promocode.CanSetSteamID]', nil, promocode, sSteamID ) == false ) then return end

    sPromocode = promocode.promocode

    promocode.steamid = sSteamID
    SQL.Update( DB, 'SteamID', sSteamID, 'Promocode', sPromocode )

    hook.Call( '[Ambi.Promocode.SetSteamID]', nil, promocode, sSteamID )
end

function Ambi.Promocode.SetDescription( sPromocode, sDescription )
    local promocode = Ambi.Promocode.Get( sPromocode )
    if not promocode then return end
    if ( hook.Call( '[Ambi.Promocode.CanSetDescription]', nil, promocode, sDescription ) == false ) then return end

    sPromocode = promocode.promocode

    promocode.desc = sDescription
    SQL.Update( DB, 'Description', sDescription, 'Promocode', sPromocode )

    hook.Call( '[Ambi.Promocode.SetDescription]', nil, promocode, sDescription )
end

function Ambi.Promocode.GiveAction( sPromocode, fAction )
    local promocode = Ambi.Promocode.Get( sPromocode )
    if not promocode then return end
    if ( hook.Call( '[Ambi.Promocode.CanGiveAction]', nil, promocode, fAction ) == false ) then return end

    promocode.Action = fAction

    hook.Call( '[Ambi.Promocode.GaveAction]', nil, promocode, fAction )
end

-- ---------------------------------------------------------------------------------------------------------------------------------------------
hook.Add( 'PostGamemodeLoaded', 'Ambi.Promocode.Setup', function()
    local db = SQL.SelectAll( DB )
    if not db or ( #db == 0 ) then return end
    
    for _, tab in ipairs( db ) do
        local old_tab = Ambi.Promocode.promocodes[ tab.Promocode ]

        Ambi.Promocode.promocodes[ tab.Promocode ] = {
            promocode = tab.Promocode,
            can_activate = tobool( tonumber( tab.CanActivate ) ),
            header = tab.Header,
            desc = tab.Description,
            steamid = tab.SteamID,
            players = tonumber( tab.Players ),
            date = tonumber( tab.Date ),
        }
        
        if old_tab then
            Ambi.Promocode.promocodes[ tab.Promocode ].Action = old_tab.Action
        end

        hook.Call( '[Ambi.Promocode.Setup]', nil, Ambi.Promocode.promocodes[ tab.Promocode ] )
    end

    print( '[Promocode] Промокоды загружены: '..#db )
end )