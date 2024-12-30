--[[
	org_flag:
		1 - Зам ничего не может
		2 - Зам может только приглашать
		3 - Зам может приглашать и удалять из организации
]]

AmbOrgs2 = AmbOrgs2 or {}
AmbOrgs2.Orgs = AmbOrgs2.Orgs or {}

AmbOrgs2.cost_for_org = 32000

local PLAYER = FindMetaTable( 'Player' )

function PLAYER:HasOrg()
	return self:GetNWBool( 'amb_players_orgs' )
end

function PLAYER:GetOrgID()
	return self:GetNWInt( 'amb_players_orgs_id' )
end

function PLAYER:GetOrgRank()
	return self:GetNWString('amb_players_orgs_rank')
end