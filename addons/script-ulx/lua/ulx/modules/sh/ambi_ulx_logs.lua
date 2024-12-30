local CATEGORY = '[Logs]'

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------
local command = 'logs'
local function Action( eCaller )
    plogs.OpenMenu( eCaller )
end
local method = ulx.command( CATEGORY, 'ulx '..command, Action, '!'..command )
method:defaultAccess( ULib.ACCESS_SUPERADMIN )
method:help( 'Посмотреть логи' )