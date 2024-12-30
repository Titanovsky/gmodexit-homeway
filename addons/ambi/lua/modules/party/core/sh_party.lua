local PLAYER = FindMetaTable( 'Player' )

-- --------------------------------------------------------------------------------------------------------------------------------------------
function PLAYER:GetParty()
    if not self:HasParty() then return end
    if SERVER then return Ambi.Party.Get( self.party ) end

    return Ambi.Party.party
end

function PLAYER:HasParty()
    if SERVER then return tobool( self.party ) end

    return tobool( Ambi.Party.party )
end

function PLAYER:IsPartyLeader()
    local party = self:GetParty()
    if not party then return false end

    return ( party.leader == self )
end