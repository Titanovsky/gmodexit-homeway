local PLAYER = FindMetaTable( 'Player' )

function PLAYER:IsMafia()
    return ( self:GetJobTable().category == 'Мафия' )
end

function PLAYER:IsFBI()
    return ( self:GetJobTable().category == 'ФБР' )
end