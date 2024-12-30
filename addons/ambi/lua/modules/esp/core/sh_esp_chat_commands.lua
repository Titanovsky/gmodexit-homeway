if not Ambi.ChatCommands then return end

local C = Ambi.General.Global.Colors
local Add = Ambi.ChatCommands.AddCommand

Add( 'marks', 'GPS', 'Показать все точки GPS', 1.5, function( ePly, tArgs ) 
    local gps = Ambi.ESP.gps_points

    for name, point in pairs( gps ) do ePly:ChatSend( C.FLAT_RED, name, C.FLAT_GREEN, ' — ', point.desc ) end
end )

Add( 'gps', 'GPS', 'Поставить точку на карте /gps [Название]', 0.5, function( ePly, tArgs ) 
    local name = tArgs[ 2 ] or ''
    local gps = Ambi.ESP.gps_points

    local point = gps[ name ] 
    if not gps then return end

    ePly:RunCommand( 'ambi_esp_gps_'..name )
end )