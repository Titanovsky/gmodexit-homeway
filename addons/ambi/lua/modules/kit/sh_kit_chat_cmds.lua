if not Ambi.ChatCommands then return end

local C = Ambi.General.Global.Colors
local Add = Ambi.ChatCommands.AddCommand

Add( 'kit', 'Наборы', 'Получить набор /kit [Название]', 1.5, function( ePly, tArgs ) 
    local kit = tArgs[ 2 ] or ''

    ePly:GiveKit( kit )
end )

Add( 'kits', 'Наборы', 'Показать все доступные наборы.', 1, function( ePly, tArgs ) 
    for name, kit in pairs( Ambi.Kit.kits ) do ePly:ChatSend( C.FLAT_RED, name, C.ABS_WHITE, ' — ', kit.desc ) end
end )