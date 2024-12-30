local PLAYER = FindMetaTable( 'Player' )

function PLAYER:IsAuth()
    return self.nw_Auth
end