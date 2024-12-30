local C, SQL = Ambi.Packages.Out( 'colors, sql' )

local DB_ORGS = 'ambi_orgs2' --! check sv_orgs2.lua for correctly names of bases
local DB_PLAYERS = 'ambi_orgs2_player' --! check sv_orgs2.lua for correctly names of bases

-- ---------------------------------------------------------------------------------------------------------------------
util.AddNetworkString( 'amb_orgs_control_ranks' )
net.Receive( 'amb_orgs_control_ranks', function( len, caller ) 
    if caller:GetNWBool('amb_players_orgs') ~= true then caller:Kick('HIGHT PING (>320)') return end 

    local ranks = net.ReadString()
    if utf8.len( ranks ) > 124 or utf8.len( ranks ) < 4 then return end -- V
    local id = net.ReadUInt( 14 )

    if AmbOrgs2.Orgs[id].LeaderID ~= caller:SteamID() then return end

    AmbOrgs2.updateOrg( id, 'Ranks', ranks )

    caller:SetNWString( 'amb_players_orgs_rank', AmbOrgs2.Orgs[id].Ranks[1] )

    SQL.Update( DB_PLAYERS, 'Rank', AmbOrgs2.Orgs[id].Ranks[1], 'SteamID', caller:SteamID() )

    hook.Call( '[Ambi.OldOrgs2.ChangeRanks]', nil, caller, id, ranks )
end )

util.AddNetworkString( 'amb_orgs_control_flags' )
net.Receive( 'amb_orgs_control_flags', function( len, caller ) 
    if caller:GetNWBool('amb_players_orgs') ~= true then caller:Kick('HIGHT PING (>320)') return end

    local flag = net.ReadUInt( 3 )
    local id = tonumber( caller:GetNWInt('amb_players_orgs_id') )

    if AmbOrgs2.Orgs[id].LeaderID ~= caller:SteamID() then return end

    -- print('\nDADADA: '..tostring(flag)) -- debug

    AmbOrgs2.updateOrg( id, 'Org_Flag', flag )

    hook.Call( '[Ambi.OldOrgs2.ChangeFlags]', nil, caller, id, flag )
end )

util.AddNetworkString( 'amb_orgs_control_set_rank' )
net.Receive( 'amb_orgs_control_set_rank', function( len, caller ) 
    local member = net.ReadEntity()
    local rank = net.ReadString()
    local id = tonumber( member:GetNWInt('amb_players_orgs_id') )

    if AmbOrgs2.Orgs[id].LeaderID ~= caller:SteamID() then return end

    member:SetNWString( 'amb_players_orgs_rank', rank )
    SQL.Update( DB_PLAYERS, 'Rank', rank, 'SteamID', member:SteamID() )

    hook.Call( '[Ambi.OldOrgs2.SetRank]', nil, caller, member, id, rank )
end )

util.AddNetworkString( 'amb_orgs_control_uninvite' )
net.Receive( 'amb_orgs_control_uninvite', function( len, caller ) 
    local member = net.ReadUInt( 8 )
    member = Entity( member )
    local id = tonumber( member:GetNWInt('amb_players_orgs_id') )

    if AmbOrgs2.Orgs[id].Org_Flag == 2 then -- зам может приглашать и увольнять
        if AmbOrgs2.Orgs[id].LeaderID ~= caller:SteamID() or caller:GetNWString('amb_players_orgs_rank') ~= AmbOrgs2.Orgs[id].Ranks[2] then return end
    else
        if AmbOrgs2.Orgs[id].LeaderID ~= caller:SteamID() then return end
    end

    member:ChatPrint('Вас исключили!')
    AmbOrgs2.leaveOrg( member )

    hook.Call( '[Ambi.OldOrgs2.UnInvited]', nil, caller, member, id )
end )