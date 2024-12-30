local CATEGORY = '[Privilege]'

-- ---------------------------------------------------------------------------------------------------------------------------------------
local command = 'privilege'
local function Action( eCaller, ePly, sPrivilege, nTime )
    ePly:SetPrivilege( sPrivilege, nTime )

	ulx.fancyLogAdmin( eCaller, '#A выдал для #T привилегию #s на #i минут', ePly, sPrivilege, nTime )

    hook.Call( '[Ambi.ULX.privilege]', nil, eCaller, ePly, sPrivilege, nTime )
end
local method = ulx.command( CATEGORY, 'ulx '..command, Action, '!'..command )
method:addParam{ type=ULib.cmds.PlayerArg }
method:addParam{ type=ULib.cmds.StringArg, hint = 'Привилегия', ULib.cmds.optional, ULib.cmds.takeRestOfLine }
method:addParam{ type=ULib.cmds.NumArg, min = -1, default = -1, max = 99999999, hint = 'Минуты (-1 навсегда)', ULib.cmds.optional, ULib.cmds.round }
method:defaultAccess( ULib.ACCESS_SUPERADMIN )
method:help( 'Дать игроку привилегию' )

local command = 'removeprivilege'
local function Action( eCaller, ePly, sReason )
    ePly:RemovePrivilege( sPrivilege )

	ulx.fancyLogAdmin( eCaller, '#A удалил привилегию для #T по причине: #s', ePly, sReason )

    hook.Call( '[Ambi.ULX.removeprivilege]', nil, eCaller, ePly, sReason )
end
local method = ulx.command( CATEGORY, 'ulx '..command, Action, '!'..command )
method:addParam{ type=ULib.cmds.PlayerArg }
method:addParam{ type=ULib.cmds.StringArg, hint = 'Причина снятия привилегий', ULib.cmds.optional, ULib.cmds.takeRestOfLine }
method:defaultAccess( ULib.ACCESS_SUPERADMIN )
method:help( 'Удалить привилегию' )