local CATEGORY = '[Skills]'

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------
local command = 'setskillpoints'
local function Action( eCaller, tPlayers, nCount )
    
    for _, ply in ipairs( tPlayers ) do ply:SetSkillPoints( nCount ) end

	ulx.fancyLogAdmin( eCaller, '#A изменил для #T на #i скилл поинтов', tPlayers, nCount )
end
local method = ulx.command( CATEGORY, 'ulx '..command, Action, '!'..command )
method:addParam{ type=ULib.cmds.PlayersArg }
method:addParam{ type=ULib.cmds.NumArg, min = 0, default = 0, max = 5000, hint = 'Количество', ULib.cmds.optional, ULib.cmds.round }
method:defaultAccess( ULib.ACCESS_SUPERADMIN )
method:help( 'Изменить Skill Points игроку' )

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------
local command = 'addskillpoints'
local function Action( eCaller, tPlayers, nCount )
    
    for _, ply in ipairs( tPlayers ) do ply:AddSkillPoints( nCount ) end

	ulx.fancyLogAdmin( eCaller, '#A выдал для #T столько #i скилл поинтов', tPlayers, nCount )
end
local method = ulx.command( CATEGORY, 'ulx '..command, Action, '!'..command )
method:addParam{ type=ULib.cmds.PlayersArg }
method:addParam{ type=ULib.cmds.NumArg, min = -5000, default = 0, max = 5000, hint = 'Количество', ULib.cmds.optional, ULib.cmds.round }
method:defaultAccess( ULib.ACCESS_SUPERADMIN )
method:help( 'Выдать Skill Points игроку' )

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------
local command = 'setskill'
local function Action( eCaller, tPlayers, sSkill, nNode )
    
    for _, ply in ipairs( tPlayers ) do 
        ply:SetSkill( sSkill, nNode ) 
    end

	ulx.fancyLogAdmin( eCaller, '#A изменил #s (#i) скиллы для #T', sSkill, nNode, tPlayers )
end
local method = ulx.command( CATEGORY, 'ulx '..command, Action, '!'..command )
method:addParam{ type=ULib.cmds.PlayersArg }
method:addParam{ type=ULib.cmds.StringArg, hint = 'Класс Навыка', ULib.cmds.optional, ULib.cmds.takeRestOfLine }
method:addParam{ type=ULib.cmds.NumArg, min = 0, default = 0, max = 1000, hint = 'Ноды', ULib.cmds.optional, ULib.cmds.round }
method:defaultAccess( ULib.ACCESS_SUPERADMIN )
method:help( 'Изменить Skill игроку' )

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------
local command = 'setskill'
local function Action( eCaller, tPlayers, sSkill, nNode )
    
    for _, ply in ipairs( tPlayers ) do 
        ply:AddSkill( sSkill, nNode ) 
    end

	ulx.fancyLogAdmin( eCaller, '#A добавил #s (#i) скиллы для #T', sSkill, nNode, tPlayers )
end
local method = ulx.command( CATEGORY, 'ulx '..command, Action, '!'..command )
method:addParam{ type=ULib.cmds.PlayersArg }
method:addParam{ type=ULib.cmds.StringArg, hint = 'Класс Навыка', ULib.cmds.optional, ULib.cmds.takeRestOfLine }
method:addParam{ type=ULib.cmds.NumArg, min = -1000, default = 0, max = 1000, hint = 'Ноды', ULib.cmds.optional, ULib.cmds.round }
method:defaultAccess( ULib.ACCESS_SUPERADMIN )
method:help( 'Добавить Skill игроку' )