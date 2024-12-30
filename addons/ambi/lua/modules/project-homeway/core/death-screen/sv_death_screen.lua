local RANDOM_SOUNDS = {
    'vo/npc/Barney/ba_pain02.wav',
    'vo/npc/Barney/ba_pain03.wav',
    'vo/npc/Barney/ba_pain04.wav',
    'vo/npc/Barney/ba_pain02.wav',
    'vo/npc/female01/pain04.wav',
    'vo/npc/male01/pain07.wav',
    'vo/npc/male01/pain06.wav',
    'vo/coast/odessa/male01/nlo_cubdeath01.wav',
    'vo/ravenholm/monk_pain04.wav',
}

net.AddString( 'ambi_homeway_spawn_from_die', function( _, ePly ) 
    if ePly:Alive() then return end --todo kick
    
    ePly:Spawn()
end )

net.AddString( 'ambi_homeway_show_death_screen' )

hook.Add( 'PlayerDeath', 'Ambi.Homeway.DeathScreen', function( ePly ) 
    net.Start( 'ambi_homeway_show_death_screen' )
    net.Send( ePly )
end )

hook.Add( 'PlayerDeathSound', "Ambi.Homeway.DeathScreen", function( ePly )
    local snd = table.Random( RANDOM_SOUNDS )

	ePly:EmitSound( snd )

	return true
end )