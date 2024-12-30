local CATEGORY = '[Quest]'

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------
local command = 'removequest'
local function Action( eCaller, ePly, sItem, nCount )
    ePly:RemoveQuestProgress()
end
local method = ulx.command( CATEGORY, 'ulx '..command, Action, '!'..command )
method:addParam{ type=ULib.cmds.PlayerArg }
method:defaultAccess( ULib.ACCESS_SUPERADMIN )
method:help( 'Выдать полный вайп (Инвентарь, Квесты, Аккаунт)' )

local command = 'wipequests'
local function Action( eCaller, ePly )
    for class, _ in pairs( Ambi.Quest.quests ) do
        ePly:ClearFinishedQuest( class )
        ePly:ChatPrint( 'Вайпнут квест: '..class )
    end
end
local method = ulx.command( CATEGORY, 'ulx '..command, Action, '!'..command )
method:addParam{ type=ULib.cmds.PlayerArg }
method:defaultAccess( ULib.ACCESS_SUPERADMIN )
method:help( 'Вайпнуть вайп квестов' )

local command = 'addquestcount'
local function Action( eCaller, ePly, nCount )
    ePly:AddQuestCount( nCount, ePly.nw_Quest, ePly.nw_QuestStep )
end
local method = ulx.command( CATEGORY, 'ulx '..command, Action, '!'..command )
method:addParam{ type=ULib.cmds.PlayerArg }
method:addParam{ type=ULib.cmds.NumArg, min = 0, default = 1, max = 99999, hint = 'Количество', ULib.cmds.optional, ULib.cmds.round }
method:defaultAccess( ULib.ACCESS_SUPERADMIN )
method:help( 'Дать Count квесту' )

local command = 'startquest'
local function Action( eCaller, ePly, sClass )
    ePly:ClearFinishedQuest( class )
    ePly:StartQuest( sClass, true )
end
local method = ulx.command( CATEGORY, 'ulx '..command, Action, '!'..command )
method:addParam{ type=ULib.cmds.PlayerArg }
method:addParam{ type=ULib.cmds.StringArg, hint = 'Класс предмета' }
method:defaultAccess( ULib.ACCESS_SUPERADMIN )
method:help( '' )

local command = 'endquest'
local function Action( eCaller, ePly )
    ePly:EndQuest( ePly.nw_Quest )
end
local method = ulx.command( CATEGORY, 'ulx '..command, Action, '!'..command )
method:addParam{ type=ULib.cmds.PlayerArg }
method:defaultAccess( ULib.ACCESS_SUPERADMIN )
method:help( '' )