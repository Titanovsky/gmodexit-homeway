local HOOKS = {
    'PlayerSay',
    'CanTool',
    'CanProperty',
    'CanUndo',
    'PlayerSpray',
    'PlayerCanHearPlayersVoice',
}

-- ---------------------------------------------------------------------------------------------------------------------------------------в
for _, value in ipairs( HOOKS ) do
    hook.Add( value, 'Ambi.Homeway.DeathScreenBlock', function( ePly )
        if not ePly:Alive() then return false end
    end )
end