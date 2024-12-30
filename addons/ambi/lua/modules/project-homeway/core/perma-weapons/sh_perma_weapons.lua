local PLAYER = FindMetaTable( 'Player' )

function PLAYER:CheckPermaWeapon( nID )
    local item = Ambi.Homeway.Config.perma_weapons[ nID or '' ]
    if not item then return false end

    if self:IsFounder() then return true end
    if item.premium and self:IsPremium() then return true end
    if item.vip and self:IsVIP() then return true end
    if item.whitelist and item.whitelist[ self:SteamID() ] then return true end
    if item.igs and self:HasPurchase( item.igs ) then return true end

    return false
end