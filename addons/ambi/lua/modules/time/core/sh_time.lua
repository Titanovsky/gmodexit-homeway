local PLAYER = FindMetaTable( 'Player' )

-- ---------------------------------------------------------------------------------------------------------------------------------------
function PLAYER:GetTime()
    return self.nw_Time or 0
end

function PLAYER:GetTimeToday()
    return self.nw_TimeToday or 0
end