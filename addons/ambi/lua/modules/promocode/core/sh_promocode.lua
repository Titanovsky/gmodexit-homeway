local PLAYER = FindMetaTable( 'Player' ) 

-- --------------------------------------------------------------------------------------------------------------------------------------
function PLAYER:GetPromocode( sPromocode )
    sPromocode = string.ForceLower( sPromocode or '' )

    if SERVER then return self.promocodes[ sPromocode ] end

    if not Ambi.Promocode.players[ self:SteamID() ] then Ambi.Promocode.players[ self:SteamID() ] = {} end
    return Ambi.Promocode.players[ self:SteamID() ][ sPromocode ]
end

function PLAYER:GetPromocodes()
    if SERVER then return self.promocodes end

    if not Ambi.Promocode.players[ self:SteamID() ] then Ambi.Promocode.players[ self:SteamID() ] = {} end
    return Ambi.Promocode.players[ self:SteamID() ]
end