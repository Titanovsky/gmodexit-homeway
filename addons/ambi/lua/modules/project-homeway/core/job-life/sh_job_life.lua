local PLAYER = FindMetaTable( 'Player' )

function PLAYER:GetJobLife()
    return self.nw_JobLife or 0
end