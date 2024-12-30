Ambi.ComputerClub.games = Ambi.ComputerClub.games or {}

local PLAYER = FindMetaTable( 'Player' )

-- --------------------------------------------------------------------------------------------------------------------------------------------
function PLAYER:IsPlayingInComputerClub()
    return self.nw_IsPlayingInComputerClub
end

function PLAYER:GetPseudoHealth()
    return self.nw_PseudoHealth or 0
end

function PLAYER:GetPseudoArmor()
    return self.nw_PseudoArmor or 0
end

-- --------------------------------------------------------------------------------------------------------------------------------------------
function Ambi.ComputerClub.Make( sClass, sHeader, sCategory, sDescription, nTime, fStartAction, fEndAction )
    if not sClass then return end

    Ambi.ComputerClub.games[ sClass ] = {
        header = sHeader or '',
        category = sCategory or 'other',
        desc = sDescription or '',
        time = nTime or 1,
        StartAction = fStartAction or function() end,
        EndAction = fEndAction or function() end,
    }

    print( '[Computer Club] Make game: '..sClass )

    return sClass
end

function Ambi.ComputerClub.Get( sClass )
    return Ambi.ComputerClub.games[ sClass or '' ]
end