local CATEGORY = '[Ambi]'
local PLAYER = FindMetaTable( 'Player' )

-- ---------------------------------------------------------------------------------------------------------------------------------------
function PLAYER:IsAdminMode()
    return self.nw_AdminMode
end

-- ---------------------------------------------------------------------------------------------------------------------------------------
local command = 'admin'
local function Action( eCaller )
    if not IsValid( eCaller ) then return end

    local text = ''
    if self.nw_AdminMode then
        text = 'выключил'

        self.nw_AdminMode = false
    else
        text = 'включил'

        self.nw_AdminMode = true
    end

	ulx.fancyLogAdmin( eCaller, '#A '..text..' админ режим' )
end
local method = ulx.command( CATEGORY, 'ulx '..command, Action, '!'..command )
method:addParam{ type=ULib.cmds.PlayersArg }
method:defaultAccess( ULib.ACCESS_SUPERADMIN )
method:help( 'Войти/выйти из админ режима' )

local command = 'spawn'
local function Action( eCaller, tPlayers )
    for _, ply in ipairs( tPlayers ) do ply:Spawn() end

	ulx.fancyLogAdmin( eCaller, '#A заспавнил #T', tPlayers )
end
local method = ulx.command( CATEGORY, 'ulx '..command, Action, '!'..command )
method:addParam{ type=ULib.cmds.PlayersArg }
method:defaultAccess( ULib.ACCESS_SUPERADMIN )
method:help( 'Заспавнить игроков' )

local command = 'setmodel'
local function Action( eCaller, tPlayers, sValue )
    if not util.IsValidModel( sValue ) then return end
    
    for _, ply in ipairs( tPlayers ) do ply:SetModel( sValue ) end

	ulx.fancyLogAdmin( eCaller, '#A изменил модель #T на #s', tPlayers, sValue )
end
local method = ulx.command( CATEGORY, 'ulx '..command, Action, '!'..command )
method:addParam{ type=ULib.cmds.PlayersArg }
method:addParam{ type=ULib.cmds.StringArg, hint = 'Модель', ULib.cmds.optional, ULib.cmds.takeRestOfLine }
method:defaultAccess( ULib.ACCESS_SUPERADMIN )
method:help( 'Изменить модель игроков' )

local command = 'kill'
local function Action( eCaller, tPlayers )
    for _, ply in ipairs( tPlayers ) do ply:Kill() end

	ulx.fancyLogAdmin( eCaller, '#A убил #T', tPlayers )
end
local method = ulx.command( CATEGORY, 'ulx '..command, Action, '!'..command )
method:addParam{ type=ULib.cmds.PlayersArg }
method:defaultAccess( ULib.ACCESS_SUPERADMIN )
method:help( 'Убить игроков' )

local command = 'giveweapon'
local function Action( eCaller, tPlayers, sValue )
    for _, ply in ipairs( tPlayers ) do 
        ply:Give( sValue ) 
        ply:GetWeapon( sValue ).cannot_drop = true -- for DarkRP
    end

	ulx.fancyLogAdmin( eCaller, '#A дал оружие #s для #T', sValue, tPlayers )
end
local method = ulx.command( CATEGORY, 'ulx '..command, Action, '!'..command )
method:addParam{ type=ULib.cmds.PlayersArg }
method:addParam{ type=ULib.cmds.StringArg, hint = 'Класс оружия', ULib.cmds.optional, ULib.cmds.takeRestOfLine }
method:defaultAccess( ULib.ACCESS_SUPERADMIN )
method:help( 'Дать оружие игрокам' )

local command = 'getweapons'
local function Action( eCaller, ePly )
    local weps = ePly:GetWeapons()
    local Print = IsValid( eCaller ) and function( sText ) eCaller:ChatSend( '~WHITE~ '..sText ) end or print

    Print( ePly:Nick()..' ('..ePly:SteamID()..'):' )
    for i, wep in ipairs( weps ) do
        Print( i..'. '..wep:GetClass() )
    end
end
local method = ulx.command( CATEGORY, 'ulx '..command, Action, '!'..command )
method:addParam{ type=ULib.cmds.PlayerArg }
method:defaultAccess( ULib.ACCESS_SUPERADMIN )
method:help( 'Посмотреть список оружия' )

local command = 'dropweapon'
local function Action( eCaller, tPlayers )
    for _, ply in ipairs( tPlayers ) do ply:DropWeapon() end

	ulx.fancyLogAdmin( eCaller, '#A выкинул текущее оружие у #T', tPlayers )
end
local method = ulx.command( CATEGORY, 'ulx '..command, Action, '!'..command )
method:addParam{ type=ULib.cmds.PlayersArg }
method:defaultAccess( ULib.ACCESS_SUPERADMIN )
method:help( 'Выкинуть текущее оружие у игроков' )
