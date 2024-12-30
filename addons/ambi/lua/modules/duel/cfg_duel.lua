Ambi.General.CreateModule( 'Duel' )

-- ---------------------------------------------------------------------------------------------------------------------------------------
Ambi.Duel.Config.min_award = 500
Ambi.Duel.Config.max_award = 100000

Ambi.Duel.Config.max_health = 400

Ambi.Duel.Config.delay = 40
Ambi.Duel.Config.time_duel = 60 * 2
Ambi.Duel.Config.time_accept = 15
Ambi.Duel.Config.delay_start = 6

Ambi.Duel.Config.bet = true
Ambi.Duel.Config.bet_max = 10000 -- максимальное количество денег
Ambi.Duel.Config.bet_delay = 60 * 2 -- задержка на игрока

Ambi.Duel.Config.places = { 
    [1] = { pos = Vector( 2718, 2592, 129 ), ang = Angle( 5, 40, 0 ) },
    [2] = { pos = Vector( 1999, 1679, 129 ), ang = Angle( 7, -135, 0 ) },
    ['end'] = { pos = Vector( 2279, 1404, 146 ), ang = Angle( 0, 90, 0 ) },
}

Ambi.Duel.Config.access_guns = {
    'arccw_ak47',
    'arccw_m4a1',
    'arccw_m107',
    'arccw_m1014',
    'arccw_awm',
    'arccw_deagle50',
    'arccw_ruger',
    'arccw_sg550',
    'arccw_contender',
    'arccw_rpg7',
    'arccw_g3a3',
    'arccw_melee_fists',

    'weapon_crossbow',
    'weapon_357',
    'weapon_stunstick',
    'weapon_smg1',
}