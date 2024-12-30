local SQL, C = Ambi.Packages.Out( 'sql, colors' )
local DB = SQL.CreateTable( 'ambi_promocode_players', 'SteamID, Nick, Promocode, Date' )
local PLAYER = FindMetaTable( 'Player' ) 

-- --------------------------------------------------------------------------------------------------------------------------------------
function Ambi.Promocode.Wipe( sSteamID, sPromocode )
    if not sSteamID then return end
    if not sPromocode then return end

    local ply = player.GetBySteamID( sSteamID )
    if IsValid( ply ) then ply:WipePromocode( sPromocode ) return end

    sql.Query( 'DELETE FROM '..DB..' WHERE Promocode = '..SQL.Str( sPromocode )..' AND SteamID = '..SQL.Str( sSteamID )..';' )

    hook.Call( '[Ambi.Promocode.Wipe]', nil, sSteamID, promocode )
end

-- --------------------------------------------------------------------------------------------------------------------------------------
function PLAYER:ActivatePromocode( sPromocode )
    if self:IsBot() then return end
    
    local promocode = Ambi.Promocode.Get( sPromocode )
    if not promocode then self:ChatSend( '~R~ • ~W~ Промокода ~R~ '..sPromocode..' ~W~ не существует' ) return end

    sPromocode = promocode.promocode

    if not self.promocodes then self.promocodes = {} end -- на всякий случай
    
    if ( promocode.can_activate == false ) then self:ChatSend( '~R~ • ~W~ Промокод ~R~ '..sPromocode..' ~W~ не доступен' ) return end
    if self:GetPromocode( sPromocode ) then self:ChatSend( '~R~ • ~W~ Промокод ~R~ '..sPromocode..' ~W~ уже активирован' ) return end

    if ( hook.Call( '[Ambi.Promocode.CanActivate]', nil, self, promocode ) == false ) then return end

    local time = os.time()
    self.promocodes[ sPromocode ] = time
    SQL.Insert( DB, 'SteamID, Nick, Promocode, Date', '%s, %s, %s, %i', self:SteamID(), self:Nick(), sPromocode, time )

    for _, ply in ipairs( player.GetHumans() ) do
        self:SyncPromocodes( ply )
    end

    Ambi.Promocode.AddPlayers( sPromocode, 1 )

    if promocode.Action then promocode.Action( self, promocode ) end

    hook.Call( '[Ambi.Promocode.Activated]', nil, self, promocode )
end

function PLAYER:WipePromocode( sPromocode )
    if self:IsBot() then return end

    local promocode = Ambi.Promocode.Get( sPromocode ) 
    if not promocode then return end

    sPromocode = promocode.promocode
    if not self:GetPromocode( sPromocode ) then return end

    if ( hook.Call( '[Ambi.Promocode.CanWipe]', nil, self, promocode ) == false ) then return end

    self.promocodes[ sPromocode ] = nil
    sql.Query( 'DELETE FROM '..DB..' WHERE Promocode = '..SQL.Str( sPromocode )..' AND SteamID = '..SQL.Str( self:SteamID() )..';' )

    if not self.promocodes then self.promocodes = {} end -- на всякий случай

    for _, ply in ipairs( player.GetHumans() ) do
        self:SyncPromocodes( ply )
    end

    Ambi.Promocode.AddPlayers( sPromocode, -1 )

    hook.Call( '[Ambi.Promocode.WipePlayer]', nil, self, promocode )
end

function PLAYER:SyncPromocodes( ePly )
    if self:IsBot() then return end
    if ePly:IsBot() then return end

    net.Start( 'ambi_promocode_sync' )
        net.WriteString( self:SteamID() )
        net.WriteTable( self.promocodes )
    net.Send( ePly )

    hook.Call( '[Ambi.Promocode.Sync]', nil, self, self.promocodes )
end

-- --------------------------------------------------------------------------------------------------------------------------------------
hook.Add( 'PlayerInitialSpawn', 'Ambi.Promocode.Init', function( ePly )
    ePly.promocodes = {}

    if ePly:IsBot() then return end

    timer.Simple( 0.25, function()
        if not IsValid( ePly ) then return end

        local humans = player.GetHumans()

        for _, ply in ipairs( humans ) do
            if ( ply == ePly ) then continue end

            ply:SyncPromocodes( ePly )
        end

        local db = SQL.SelectAll( DB )
        if not db or ( #db == 0 ) then return end
        
        local have_some_promocode = false
        for _, tab in ipairs( db ) do
            local sid = tab.SteamID
            if ( sid ~= ePly:SteamID() ) then continue end

            ePly.promocodes[ tab.Promocode ] = tonumber( tab.Date )

            have_some_promocode = true

            hook.Call( '[Ambi.Promocode.Init]', nil, ePly, tab.Promocode )
        end

        if have_some_promocode then
            for _, ply in ipairs( humans ) do
                ePly:SyncPromocodes( ply )
            end
        end
    end )
end )