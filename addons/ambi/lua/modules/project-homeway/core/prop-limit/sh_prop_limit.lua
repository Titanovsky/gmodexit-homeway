local PLAYER = FindMetaTable( 'Player' )

-- ---------------------------------------------------------------------------------------------------------------------------------------
function PLAYER:GetPropsLimit()
    local count = 120

    if ( self:GetTime() > 60 * 20 ) then count = count + 40 end
    if self:IsSeniorStaff() then count = count + 1000 end
    if self:IsStaff() then count = count + 600 end
    if self:IsPremium() then count = count + 450 end
    if self:IsVIP() then count = count + 200 end

    return count
end

function PLAYER:HasPropsLimit()
    return ( self:GetCount( 'props' ) >= self:GetPropsLimit() )
end