local SQL = Ambi.SQL
local DB = SQL.CreateTable( 'ambi_warn_admin', 'SteamID, Name, ID, Reason, SteamIDWarner, Date' )
local PLAYER = FindMetaTable( 'Player' )

-- -------------------------------------------------------------------------------------------------------------------
function Ambi.Warn.GetAdminWarns( sSteamID )
    local warns = SQL.SelectAll( DB )
    if not warns then return {} end

    local result = {}
    for _, warn in ipairs( warns ) do
        if ( warn.SteamID ~= sSteamID ) then continue end

        result[ tonumber( warn.ID ) ] = { 
            id = tonumber( warn.ID ),  
            warner = warn.SteamIDWarner,
            date = tonumber( warn.Date ),
            reason = warn.Reason
        }
    end

    return result
end

-- -------------------------------------------------------------------------------------------------------------------
function PLAYER:AdminWarn( sReason, sWarnerSteamID )
    sReason = sReason or ''
    sWarnerSteamID = sWarnerSteamID or 'Server'

    local sid = self:SteamID()

    local id = #self:GetAdminWarns()
    id = id + 1

    local time = os.time()

    SQL.Insert( DB, 'SteamID, Name, ID, Reason, SteamIDWarner, Date', '%s, %s, %i, %s, %s, %i', sid, self:Name(), id, sReason, sWarnerSteamID, time )

    hook.Call( '[Ambi.Warn.GiveAdminWarn]', nil, self, id, sReason, sWarnerSteamID, time )
end

function PLAYER:UnAdminWarn( nID ) 
    if not nID then return end

    local sid = self:SteamID()
    local warns = self:GetAdminWarns()
    if ( #warns == 0 ) then return end

    local warner = ''
    local date = 0
    local reason = ''

    for id, warn in ipairs( warns ) do
        if ( tonumber( warn.ID ) ~= nID ) then continue end

        warner = warn.SteamIDWarner
        date = tonumber( warn.Date )
        reason = warn.Reason
    end

    sql.Query( 'DELETE FROM `'..DB..'` WHERE SteamID = '..sql.SQLStr( sid )..' AND ID = '..nID )

    if ( nID ~= #warns ) and ( #warns ~= 1 ) then 
        for i = 1, #warns do
            if ( i <= nID ) then continue end

            local old_id = sql.Query( 'UPDATE `'..DB..'` SET ID = '..( i - 1 )..' WHERE SteamID = '..sql.SQLStr( sid )..' AND ID = '..i )
        end
    end

    hook.Call( '[Ambi.Warn.RemoveAdminWarn]', nil, self, nID, reason, warner, date )
end

function PLAYER:RemoveLastAdminWarn()
    local last_warn = #self:GetAdminWarns()
    if ( last_warn == 0 ) then return end

    self:UnAdminWarn( last_warn )
end

function PLAYER:RemoveAllAdminWarns()
    local warns = Ambi.Warn.GetAdminWarns( self:SteamID() )
    if not warns then return end

    for i = 1, #warns do
        self:RemoveLastAdminWarn()
    end
end

function PLAYER:GetAdminWarns()
    return Ambi.Warn.GetAdminWarns( self:SteamID() )
end