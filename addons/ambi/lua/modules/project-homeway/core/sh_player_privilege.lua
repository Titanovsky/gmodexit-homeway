local PLAYER = FindMetaTable( 'Player' )

-- ---------------------------------------------------------------------------------------------------------------------------------------
function PLAYER:IsVIP()
    return self:IsPrivilege( 'vip' ) or self:IsPrivilege( 'premium' ) or self:IsRedStaff()
end

function PLAYER:IsPremium()
    return self:IsPrivilege( 'premium' ) or self:IsRedStaff()
end