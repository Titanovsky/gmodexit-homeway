Ambi.General.CreateModule( 'RobObj' )

-- ---------------------------------------------------------------------------------------------------------------------------------------------
Ambi.RobObj.Config.min_online = 200 -- Сколько нужно онлайна. UPD 22.12.2024 почему поставил 200, чтобы вырубить эту систему к хуям (карту новую поставили, там не подходит)

Ambi.RobObj.Config.rewards = { -- Награды
    -- Если груз спасут никто не украдёт. Рандомно от min до max
    min_money_save = 50,
    max_money_save = 200,

    -- Если груз украдут. Рандомно от min до max
    min_money_rob = 8000,
    max_money_rob = 20000
}

Ambi.RobObj.Config.delays = {
    -- Задержка рандомно от min и до max между приездом груза в город
    min_delay = 60 * 15,
    max_delay = 60 * 30,

    time_rob = 60 * 10, -- Время сколько будет идти ивент

    time_rob_object = 60 * 2 -- Сколько будет грабить игрок объект?
}

Ambi.RobObj.Config.object = {
    class = 'rob_object',
    name = 'Золото',
    hp = 2500, -- Здоровье
    places = { -- Количество, а также место
        { pos = Vector( 3162, -3117, -212 ), ang = Angle( 0, 180, 0 ) },
        { pos = Vector( 3236, -3117, -212 ), ang = Angle( 0, 180, 0 ) },
    }
}

Ambi.RobObj.Config.security = {
    turn_on = true,
    repeat_spawn = true, -- нужно им ещё раз появится? (время time_rob / 2)
    guns = {
        'arccw_sg552',
    },
    models = {
        'models/mark2580/payday2/pd2_bulldozer_combine.mdl'
    },
    dmg = 1.5, -- На сколько умножится дамаг на игрока от NPC
    min_hp = 300,
    max_hp = 500,
    places = {
        { pos = Vector( 3208, -3206, -232 ), ang = Angle( 0, 80, 0 ) },
        { pos = Vector( 2743, -3282, -232 ), ang = Angle( 0, 80, 0 ) },
        { pos = Vector( 3399, -3147, -232 ), ang = Angle( 0, 0, 0 ) },
        { pos = Vector( 3213, -2994, -232 ), ang = Angle( 0, 0, 0 ) },
        { pos = Vector( 2063, -3775, -232 ), ang = Angle( 0, 0, 0 ) },
        { pos = Vector( 3053, -3124, -232 ), ang = Angle( 0, 0, 0 ) },
    }
}

Ambi.RobObj.Config.can_rob_jobs = {
    [ 'j_mafia1' ] = true,
    [ 'j_mafia2' ] = true,
    [ 'j_mafia_leader' ] = true,
    [ 'j_mafia_spec' ] = true,
    [ 'j_mafia_elite' ] = true,

    [ 'j_gang1' ] = true,
    [ 'j_gang_spec' ] = true,
    [ 'j_gang_elit' ] = true,
}