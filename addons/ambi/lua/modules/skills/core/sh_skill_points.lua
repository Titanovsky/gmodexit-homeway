local PLAYER = FindMetaTable( 'Player' )

function PLAYER:GetSkillPoints()
    return self.nw_SkillPoints or 0
end