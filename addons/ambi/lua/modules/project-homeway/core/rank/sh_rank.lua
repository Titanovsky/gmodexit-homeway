local PLAYER = FindMetaTable( 'Player' )

local STAFF = {
    [ 'superadmin' ] = { header = 'Founder', color = Color( 245, 125, 6) },
    [ 'founder-assistant' ] = { header = 'Founder Assistant', color = Color( 78, 226, 191) },
    [ 'head-admin' ] = { header = 'The Head Admin', color = Color( 205, 45, 45) },
    [ 'sub-head-admin' ] = { header = 'Sub-Head Admin', color = Color( 246, 242, 12) },
    [ 'senior-admin' ] = { header = 'Senior Admin', color = Color( 2, 78, 242) },
    [ 'd-senior-curator' ] = { header = 'Senior Curator', color = Color( 215, 34, 134) },
    [ 'dcurator' ] = { header = 'Curator', color = Color( 174, 120, 181) },
    [ 'admin' ] = { header = 'Administrator', color = Color( 58, 223, 80) },
    [ 'junior-admin' ] = { header = 'Junior Admin', color = Color( 127, 58, 223) },
    [ 'dsadmin' ] = { header = 'SAdmin', color = Color( 184, 212, 0) },
    [ 'senior-moder' ] = { header = 'Senior Moderator', color = Color( 2, 153, 53) },
    [ 'moder' ] = { header = 'Moderator', color = Color( 189, 32, 200) },
    [ 'dmoder' ] = { header = 'Moder', color = Color( 18, 127, 222) },
    [ 'helper' ] = { header = 'Helper', color = Color( 217, 44, 102) },
    [ 'dsupport' ] = { header = 'Support', color = Color( 255, 255, 255) },
}

local FOUNDERS = {
    [ 'STEAM_0:1:95303327' ] = true, -- Titanovsky
    [ 'STEAM_0:0:506794397' ] = true, -- Asuna
}

local SUPERADMIN = {
    [ 'superadmin' ] = true,
    [ 'founder-assistant' ] = true,
}

local RED_STAFF = {
    [ 'superadmin' ] = true,
    [ 'founder-assistant' ] = true,
    [ 'head-admin' ] = true,
    [ 'sub-head-admin' ] = true,
}

local SENIOR_STAFF = {
    [ 'superadmin' ] = true,
    [ 'founder-assistant' ] = true,
    [ 'head-admin' ] = true,
    [ 'sub-head-admin' ] = true,
    [ 'senior-admin' ] = true,
    [ 'd-senior-curator' ] = true,
    [ 'admin' ] = true,
    [ 'dcurator' ] = true,
    [ 'junior-admin' ] = true,
}

local DONATE = {
    [ 'd-senior-curator' ] = true,
    [ 'dcurator' ] = true,
    [ 'dsadmin' ] = true,
    [ 'dmoder' ] = true,
    [ 'dsupport' ] = true,
}

-- ---------------------------------------------------------------------------------------------------------------------------------------
function PLAYER:GetRank()
    return self.nw_Rank or 'user'
end

function PLAYER:Rank()
    return self:GetRank()
end

function PLAYER:IsRank( sRank )
    return self:GetRank() == ( sRank or '' )
end

-- ---------------------------------------------------------------------------------------------------------------------------------------
function PLAYER:IsStaff()
    return STAFF[ self:GetUserGroup() ]
end

function PLAYER:IsSuperAdmin()
    return SUPERADMIN[ self:GetUserGroup() ]
end

function PLAYER:IsAdmin()
    return SENIOR_STAFF[ self:GetUserGroup() ]
end

function PLAYER:IsFounder()
    return self:IsSuperAdmin()
end

function PLAYER:IsRedStaff()
    return RED_STAFF[ self:GetUserGroup() ]
end

function PLAYER:IsSeniorStaff()
    return SENIOR_STAFF[ self:GetUserGroup() ]
end

function PLAYER:IsDonateStaff()
    return DONATE[ self:GetUserGroup() ]
end
