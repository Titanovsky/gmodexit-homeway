local PLAYER = FindMetaTable( 'Player' )

function PLAYER:IsJail()
    return self.nw_Jail
end