local C, SQL = Ambi.General.Global.Colors, Ambi.SQL
local DB = SQL.CreateTable( 'privileges', 'SteamID, Privilege, Date, RegDate' )
local PLAYER = FindMetaTable( 'Player' )

function PLAYER:SetPrivilege( sPrivilege, nHours )
    local date = os.time() + 60 * 60 * nHours
    if ( nHours == -1 ) then date = -1 end

    SQL.Delete( DB, 'SteamID', self:SteamID() )
    SQL.Insert( DB, 'SteamID, Privilege, Date, RegDate', '%s, %s, %i, %i', self:SteamID(), sPrivilege, date, os.time() )

    self.nw_Privilege = sPrivilege

    hook.Call( '[Ambi.Privilege.Set]', nil, self, sPrivilege, nHours )

    print( '[Privilege] Активирован '..sPrivilege..' для '..self:Nick()..'('..self:SteamID()..') на '..nHours..' час' )
end

function PLAYER:RemovePrivilege()
    SQL.Delete( DB, 'SteamID', self:SteamID() )

    self.nw_Privilege = nil

    hook.Call( '[Ambi.Privilege.Remove]', nil, self )
end

function PLAYER:GetPrivilegeTime()
    local time = SQL.Select( DB, 'Date', 'SteamID', self:SteamID() )
    if not time then return end 

    return tonumber( time )
end

-- ---------------------------------------------------------------------------------------------------------------------------------------------
hook.Add( 'PlayerInitialSpawn', 'Ambi.Privilege.Init', function( ePly )
    timer.Simple( 0, function()
        if not IsValid( ePly ) then return end

        local sid = ePly:SteamID()

        SQL.Get( DB, 'SteamID', 'SteamID', sid, function()
            local privilege = SQL.Select( DB, 'Privilege', 'SteamID', sid )
            if not privilege then return end

            local date = tonumber( SQL.Select( DB, 'Date', 'SteamID', sid ) )

            if ( date ~= -1 ) and ( os.time() >= date ) then
                ePly:RemovePrivilege()
                ePly:ChatPrint( 'Срок вашей привилегий истёк!' )
            else
                ePly.nw_Privilege = privilege
            end
        end, function() end )
    end )
end )