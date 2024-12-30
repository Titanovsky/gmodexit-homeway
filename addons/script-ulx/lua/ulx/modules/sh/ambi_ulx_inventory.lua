local CATEGORY = '[Инвентарь]'

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------
local command = 'additem'
local function Action( eCaller, ePly, sItem, nCount )
    local count = ePly:GetInvItemCount( sItem )

    ePly:AddInvItem( sItem, nCount )

    if ( ePly:GetInvItemCount( sItem ) >= count + nCount ) then
	    ulx.fancyLogAdmin( eCaller, '#A выдал #s игроку #T в количестве #i', sItem, ePly, nCount )
    else
        if IsValid( eCaller ) then 
            eCaller:ChatSend( '~R~ Не удалось выдать игроку нужное количество предметов!' ) 
            eCaller:SoundSend( 'Error3' )
        end
    end
end
local method = ulx.command( CATEGORY, 'ulx '..command, Action, '!'..command )
method:addParam{ type=ULib.cmds.PlayerArg }
method:addParam{ type=ULib.cmds.StringArg, hint = 'Класс предмета' }
method:addParam{ type=ULib.cmds.NumArg, min = 0, default = 1, max = 99999, hint = 'Количество', ULib.cmds.optional, ULib.cmds.round }
method:defaultAccess( ULib.ACCESS_SUPERADMIN )
method:help( 'Выдать предмет игроку' )

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------
local command = 'removeitem'
local function Action( eCaller, ePly, sItem, nCount )
    local count = ePly:GetInvItemCount( sItem )

    ePly:RemoveInvItem( sItem, nCount )

	if ( ePly:GetInvItemCount( sItem ) <= ( count - nCount < 0 and 0 or count - nCount ) ) then
	    ulx.fancyLogAdmin( eCaller, '#A удалил #s игроку #T в количестве #i', sItem, ePly, nCount )
    else
        if IsValid( eCaller ) then 
            eCaller:ChatSend( '~R~ Не удалось удалить игроку нужное количество предметов!' ) 
            eCaller:SoundSend( 'Error3' )
        end
    end
end
local method = ulx.command( CATEGORY, 'ulx '..command, Action, '!'..command )
method:addParam{ type=ULib.cmds.PlayerArg }
method:addParam{ type=ULib.cmds.StringArg, hint = 'Класс предмета' }
method:addParam{ type=ULib.cmds.NumArg, min = 0, default = 1, max = 99999, hint = 'Количество', ULib.cmds.optional, ULib.cmds.round }
method:defaultAccess( ULib.ACCESS_SUPERADMIN )
method:help( 'Забрать предмет игроку' )

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------
local command = 'clearinventory'
local function Action( eCaller, ePly )
    local inv = Ambi.Inv.GetInventory( Ambi.Inv.GetKey( ePly ) )
    if not inv then return end

    local items = inv.items

    ePly:WipeInventory( #items )

	ulx.fancyLogAdmin( eCaller, '#A очистил инвентарь игроку #T', ePly )
end
local method = ulx.command( CATEGORY, 'ulx '..command, Action, '!'..command )
method:addParam{ type=ULib.cmds.PlayerArg }
method:defaultAccess( ULib.ACCESS_SUPERADMIN )
method:help( 'Очистить инвентарь игроку' )

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------
local command = 'setslots'
local function Action( eCaller, ePly, nSlots )
    local inv = Ambi.Inv.GetInventory( Ambi.Inv.GetKey( ePly ) )
    if not inv then return end

    local items = inv.items

    ePly:SetInvSlots( #items + 1 )

	ulx.fancyLogAdmin( eCaller, '#A изменил слоты у игрока #T на #i', ePly, nSlots )
end
local method = ulx.command( CATEGORY, 'ulx '..command, Action, '!'..command )
method:addParam{ type=ULib.cmds.PlayerArg }
method:addParam{ type=ULib.cmds.NumArg, min = 1, default = 8, max = 200, hint = 'Количество', ULib.cmds.optional, ULib.cmds.round }
method:defaultAccess( ULib.ACCESS_SUPERADMIN )
method:help( 'Изменить слоты' )