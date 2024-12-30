--[[
	org_flag:
		1 - Зам ничего не может
		2 - Зам может только приглашать
		3 - Зам может приглашать и удалять из организации
]]

local C, SQL = Ambi.Packages.Out( 'colors, sql' )
local DB_ORGS = SQL.CreateTable( 'ambi_orgs2', 'ID, Name, RegDate, LeaderName, LeaderID, OrgFlag, Warehouse, Color, Ranks' )
local DB_PLAYERS = SQL.CreateTable( 'ambi_orgs2_player', 'SteamID, OrgID, Rank' )

-- ---------------------------------------------------------------------------------------------------------------------------------------------
local function debugTab()
    PrintTable( AmbOrgs2.Orgs )
end

local function checkMoney( leader, money )
    return ( leader:GetMoney() >= money )
end

local function erroris( ply, str )
    ply:ChatSend( C.AMBI_RED, '[Ошибка] ', C.AMBI_WHITE, str)
end

local function findID(n)
    n = n or 1
    local id = #AmbOrgs2.Orgs + n

    return AmbOrgs2.Orgs[id] and findID(n + 1) or id
end

-- ---------------------------------------------------------------------------------------------------------------------------------------------
function AmbOrgs2.createOrg( name, leader, org_flag, cColor, sRanks )
    local color = tostring( cColor.r )..','..tostring( cColor.g )..','..tostring( cColor.b )

    if leader:GetNWBool('amb_players_orgs') then erroris( leader, 'Вы состоите в организации!') return end

    local id = findID()
    org_flag = tonumber( org_flag )

    AmbOrgs2.saveOrg( id, name, leader, org_flag, color, sRanks )
    leader:ChatSend( C.AMBI, '[•] ', C.AMBI_WHITE, 'Вы создали организацию: '..name )
    leader:ChatSend( C.AMBI, '[•] ', C.AMBI_WHITE, 'ID вашей организации: '..id )

    AmbOrgs2.initPlayer( leader, id, 'Лидер' )

    timer.Simple( 2, function() 
        local col = string.Explode(',', AmbOrgs2.Orgs[id].Color )
        col = Color( col[1], col[2], col[3] )

        for _, ply in ipairs( player.GetAll() ) do
            ply:ChatSend( C.AMBI_GREEN, '[•] ', C.AMBI_WHITE, 'Игрок ', C.AMBI_GRAY, AmbOrgs2.Orgs[id].LeaderName, C.AMBI_WHITE, ' создал организацию: ', col, AmbOrgs2.Orgs[id].Name )
        end
    end )

    hook.Call( '[Ambi.OldOrgs2.Created]', nil, leader, id, name, sRanks, org_flag, cColor )
end

function AmbOrgs2.initPlayer( ePly, id, rank )
    id = tonumber( id )
    if not AmbOrgs2.Orgs[id] then return end

    local name = AmbOrgs2.Orgs[id].Name
    local sid = ePly:SteamID()

    ePly:SetNWBool( 'amb_players_orgs', true )
    ePly:SetNWInt( 'amb_players_orgs_id', id )
    ePly:SetNWString( 'amb_players_orgs_rank', rank )
    ePly:SetNWString( 'amb_players_orgs_name', name )

    local org_id = ePly:GetNWInt('amb_players_orgs_id')
    local rank = ePly:GetNWString('amb_players_orgs_rank')

    SQL.Get( DB_PLAYERS, 'SteamID', 'SteamID', sid, function()
        SQL.Update( DB_PLAYERS, 'OrgID', org_id, 'SteamID', sid )
        SQL.Update( DB_PLAYERS, 'Rank', rank, 'SteamID', sid )
    end, function() 
        SQL.Insert( DB_PLAYERS, 'SteamID, OrgID, Rank', '%s, %i, %s', sid, org_id, rank )
    end )

    ePly:ChatSend( '~AMBI_GRAY~ [•] ~W~ У вас сохранился клан: '..org_id )
end

function AmbOrgs2.leaveOrg( eMember )
    if eMember:GetNWBool( 'amb_players_orgs' ) == false then return end

    local id = tonumber( eMember:GetNWInt( 'amb_players_orgs_id' ) )

    if AmbOrgs2.Orgs[id].Ranks[1] then
        if eMember:GetNWString( 'amb_players_orgs_rank' ) == AmbOrgs2.Orgs[id].Ranks[1] then
            eMember:SetNWString( 'amb_players_orgs_rank', '_' )
            return AmbOrgs2.removeOrg( id ) -- if eMember is leader, should to remove org
        end
    end

    eMember:ChatSend( C.AMBI, '[•] ', C.AMBI_BLUE, 'Вы покинули организацию ', C.AMBI, AmbOrgs2.Orgs[id].Name )

    SQL.Delete( DB_PLAYERS, 'SteamID', eMember:SteamID() )

    eMember:SetNWBool( 'amb_players_orgs', false )
    eMember:SetNWInt( 'amb_players_orgs_id', 0 )
    eMember:SetNWString( 'amb_players_orgs_rank', '' )

    for _, ply in ipairs( player.GetAll() ) do
        if ( ply:GetNWInt('amb_players_orgs_id') ~= id ) then continue end

        ply:ChatSend( C.AMBI, '[•] ', C.AMBI_GRAY, eMember:Nick(), C.AMBI_WHITE, ' Покинул организацию' )
    end

    hook.Call( '[Ambi.OldOrgs2.LeavedOrg]', nil, eMember, id )
end

function AmbOrgs2.inviteOrg( leader, eMember )
    local id = tonumber( eMember:GetNWInt( 'amb_players_orgs_id' ) )
    local id_leader = tonumber( leader:GetNWInt( 'amb_players_orgs_id' ) )

    eMember:SendLua('AmbOrgs2.toInvite( "'..AmbOrgs2.Orgs[id_leader].Name..'", "'..leader:Nick()..'", '..id_leader..' )')

    hook.Call( '[Ambi.OldOrgs2.InvitedOrg]', nil, leader, eMember, id )
end

function AmbOrgs2.demoteOrg( leader, eMember )
    local id = tonumber( eMember:GetNWInt( 'amb_players_orgs_id' ) )
    local id_leader = tonumber( leader:GetNWInt( 'amb_players_orgs_id' ) )

    if AmbOrgs2.Orgs[id_leader].LeaderID ~= leader:SteamID() then erroris( leader, 'Вы не лидер!' ) return end
    if AmbOrgs2.Orgs[id].LeaderID ~= leader:SteamID() then erroris( leader, 'Игрок не в вашей организации!' ) return end

    AmbOrgs2.leaveOrg( eMember )

    hook.Call( '[Ambi.OldOrgs2.DemotedOrg]', nil, leader, eMember, id )
end

function AmbOrgs2.init()
    local orgs = SQL.SelectAll( DB_ORGS )
    if not orgs then return end

    local org = {}
    
    for k, org_sql_tab in pairs( orgs ) do
        org[ k ] = tonumber( org_sql_tab.ID ) -- because sql's value is not number
    end

    for k, v in pairs( org ) do
        v = tonumber( v )

        AmbOrgs2.Orgs[ v ] = orgs[ k ]

        local ranks = string.Explode( ';', orgs[ k ].Ranks )

        AmbOrgs2.Orgs[ v ].Ranks = {
            ranks[1],
            ranks[2],
            ranks[3],
            ranks[4]
        }
    end

    net.Start( 'amb_send_org' )
        net.WriteTable( AmbOrgs2.Orgs )
    net.Broadcast()

    MsgN('\n[AmbOrgs2] Table with Organizations has done!')
end

function AmbOrgs2.initClient( receiver )
    net.Start( 'amb_send_org' )
        net.WriteTable( AmbOrgs2.Orgs )
    net.Send( receiver )
end

function AmbOrgs2.saveOrg( id, name, leader, org_flag, color, ranks )
    SQL.Get( DB_ORGS, 'ID', 'ID', id, function()
        SQL.Update( DB_ORGS, 'Name', name, 'ID', id )
        SQL.Update( DB_ORGS, 'RegDate', os.time(), 'ID', id )
        SQL.Update( DB_ORGS, 'LeaderName', leader:Nick(), 'ID', id )
        SQL.Update( DB_ORGS, 'LeaderID', leader:SteamID(), 'ID', id )
        SQL.Update( DB_ORGS, 'OrgFlag', org_flag, 'ID', id )
        SQL.Update( DB_ORGS, 'Warehouse', warehouse, 'ID', id )
        SQL.Update( DB_ORGS, 'Color', color, 'ID', id )
        SQL.Update( DB_ORGS, 'Ranks', ranks, 'ID', id )
        SQL.Update( DB_ORGS, 'ID', id, 'ID', id )
    end, function() 
        SQL.Insert( 
            DB_ORGS, 
            'ID, Name, RegDate, LeaderName, LeaderID, OrgFlag, Warehouse, Color, Ranks', 
            '%i, %s, %i, %s, %s, %i, %i, %s, %s',
            id, name, os.time(), leader:Nick(), leader:SteamID(), org_flag, 0, color, ranks
        )
    end )

    AmbOrgs2.init()
end

function AmbOrgs2.removeOrg( id )
    for _, ply in ipairs( player.GetAll() ) do
        ply:ChatSend( C.AMBI, '[•] ', C.AMBI_WHITE, 'Организация ', C.AMBI_RED, AmbOrgs2.Orgs[id].Name, C.AMBI_WHITE, ' распущена!' )

        if ( ply:GetNWInt( 'amb_players_orgs_id' ) ~= id ) then continue end
            
        AmbOrgs2.leaveOrg( ply )
    end

    local old_org = {}
    for key, value in pairs( AmbOrgs2.Orgs[ id ] ) do
        old_org[ key ] = value
    end

    AmbOrgs2.Orgs[ id ] = nil

    SQL.Delete( DB_ORGS, 'ID', id )
    
    AmbOrgs2.init()

    hook.Call( '[Ambi.OldOrgs2.RemoveOrg]', nil, id, old_org )
end

function AmbOrgs2.updateOrg( id, sKey, anyValue )
    if not SQL.Update( DB_ORGS, sKey, anyValue, 'ID', id ) then return end

    AmbOrgs2.init()
end

-- ---------------------------------------------------------------------------------------------------------------------------
hook.Add( 'PostGamemodeLoaded', 'AmbOrgs2.OrgInitHook', function()
    timer.Simple( 2, AmbOrgs2.init )
end )

hook.Add( 'PlayerInitialSpawn', 'AmbiOrgs2.OrgInitHook', function( ePly )
    AmbOrgs2.initClient( ePly )

    -- if ePly is or was in an org
    local rank = SQL.Select( DB_PLAYERS, 'Rank', 'SteamID', ePly:SteamID() )
    if not rank then return end

    local id = SQL.Select( DB_PLAYERS, 'OrgID', 'SteamID', ePly:SteamID() )

    if AmbOrgs2.Orgs[ tonumber( id ) ] then
        AmbOrgs2.initPlayer( ePly, id, rank )

        ePly:ChatSend( '~AMBI~ [•] ~W~ Вы состоите в клане!')
    else
        ePly:ChatSend( '~AMBI~ [•] ~W~ Ваш клан был удалён!')

        SQL.Delete( DB_PLAYERS, 'SteamID', ePly:SteamID() )
    end
end )

-- ---------------------------------------------------------------------------------------------------------------------------
util.AddNetworkString( 'amb_register_org' )
util.AddNetworkString( 'amb_leave_org' )
util.AddNetworkString( 'amb_invite_org' )
util.AddNetworkString( 'amb_invite_org_cmd' )
util.AddNetworkString( 'amb_send_org' )

net.Receive( 'amb_register_org', function( len, eCaller )
    if eCaller:GetNWBool( 'amb_players_orgs' ) then return end

    if checkMoney( eCaller, AmbOrgs2.cost_for_org ) == false then return end
    eCaller:AddMoney( -AmbOrgs2.cost_for_org )

    local name = net.ReadString()
    if #name <= 0 or utf8.len(name) > 100 then return end

    local color = net.ReadColor()

    AmbOrgs2.createOrg( name, eCaller, 1, color, 'Лидер;Заместитель;Офицер;Боец' )
end )

net.Receive( 'amb_leave_org', function( len, eCaller )
    if not eCaller:GetNWBool( 'amb_players_orgs' ) then return end

    AmbOrgs2.leaveOrg( eCaller )
end )

net.Receive( 'amb_invite_org', function( len, eCaller )
    local ePly = eCaller -- игрок сам пирнимает приглашение (вот так работает)

    if ePly:GetNWBool( 'amb_players_orgs' ) then erroris( eCaller, 'Игрок уже находится в организации!' ) return end

    local id = net.ReadUInt( 14 )
    -- if ( eCaller:GetNWInt('amb_players_orgs_id') ~= id ) then return end
    --print( id ) -- debug
    --print( AmbOrgs2.Orgs[id].Ranks[1] ) -- debug

    AmbOrgs2.initPlayer( ePly, id, AmbOrgs2.Orgs[id].Ranks[4] )

    for _, ply in ipairs( player.GetAll() ) do
        if ( ply:GetNWInt('amb_players_orgs_id') ~= id ) then continue end

        ply:ChatSend( C.AMBI, '[•] ', C.AMBI_GRAY, ePly:Nick(), C.AMBI_WHITE, ' Вступил в организацию!' )
    end

    hook.Call( '[Ambi.OldOrgs2.AcceptInvite]', nil, ePly, id, AmbOrgs2.Orgs[id].Ranks[4] )
end )

net.Receive( 'amb_invite_org_cmd', function( len, eCaller )
    local eMember = net.ReadEntity()

    if IsValid( eMember ) == false then return end
    if eMember:IsPlayer() == false then return end

    local id_leader = tonumber( eCaller:GetNWInt( 'amb_players_orgs_id' ) )

    if AmbOrgs2.Orgs[id_leader].OrgFlag == 2 or AmbOrgs2.Orgs[id_leader].OrgFlag == 3 then -- зам может приглашать и увольнять
        if AmbOrgs2.Orgs[id_leader].LeaderID ~= eCaller:SteamID() or eCaller:GetNWString('amb_players_orgs_rank') ~= AmbOrgs2.Orgs[id].Ranks[2] then return end
    else
        if AmbOrgs2.Orgs[id_leader].LeaderID ~= eCaller:SteamID() then erroris( eCaller, 'Вы не имеете право!' ) return end
    end

    if eMember:GetNWBool( 'amb_players_orgs' ) then erroris( eCaller, 'Игрок уже в организации!' ) return end

    AmbOrgs2.inviteOrg( eCaller, eMember )
end )