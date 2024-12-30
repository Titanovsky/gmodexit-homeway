Ambi.Homeway.warehouses = Ambi.Homeway.warehouses or {}

Ambi.Homeway.warehouses[ 'fbi' ] = {
    header = 'FBI',
    color = Color( 51, 104, 164),
    items = {
        { header = 'TMP', class = 'arccw_tmp', count = 10, max = 100, cost = 100 },
        { header = 'MP5', class = 'arccw_mp5', count = 10, max = 100, cost = 100 },
        { header = 'Авто Дробовик', class = 'arccw_m1014', max = 50, count = 5, cost = 100 },
        { header = 'M4A1', class = 'arccw_m4a1', count = 5, max = 20, cost = 100 },
        { header = 'G3A3', class = 'arccw_g3a3', count = 0, max = 20, cost = 300 },
        { header = 'AWP', class = 'arccw_awm', count = 0, max = 5, cost = 500 },
        { header = 'Пулемёт', class = 'arccw_minimi', count = 0, max = 5, cost = 2000 },
    },
    ammo = 2000,
    medkits = 20,
    armor = 20,

    ammo_buy = {
        cost = 150,
        add = 250,
    },

    medkits_buy = {
        cost = 400,
        add = 4,
    },

    armor_buy = {
        cost = 500,
        add = 4,
    },

    leaders = { 
        [ 'j_fbi_leader' ] = true,
    },
    jobs = {
        [ 'j_fbi_leader' ] = true,
        [ 'j_fbi1' ] = true,
        [ 'j_fbi2' ] = true,
        [ 'j_fbi_spec' ] = true,
        [ 'j_fbi_inspector' ] = true,
    },
    raiders = {
        [ 'j_mafia_leader' ] = true,
    }
}

Ambi.Homeway.warehouses[ 'mafia' ] = {
    header = 'Мафия',
    color = Color( 134, 67, 173),
    items = {
        { header = 'DoubleBarrel', class = 'arccw_db', count = 5, cost = 500 },
        { header = 'Бизон', class = 'arccw_bizon', count = 0, cost = 1000 },
        { header = 'AK-47', class = 'arccw_ak47', count = 0, cost = 3500 },
        
        { header = 'AUG Para', class = 'arccw_augpara', count = 0 },
        { header = 'Famas', class = 'arccw_famas', count = 0 },
        { header = 'TMP', class = 'arccw_tmp', count = 0 },
        { header = 'MP5', class = 'arccw_mp5', count = 0 },
        { header = 'Авто Дробовик', class = 'arccw_m1014', count = 0 },
        { header = 'Скаут', class = 'arccw_scout', count = 0 },

        { header = 'AWP', class = 'arccw_awm', count = 0 },
        { header = 'Пулемёт', class = 'arccw_minimi', count = 0, max = 5, cost = 2000 },
    },

    leaders = { 
        [ 'j_mafia_leader' ] = true,
    },
    jobs = {
        [ 'j_mafia_leader' ] = true,
        [ 'j_mafia1' ] = true,
        [ 'j_mafia2' ] = true,
        [ 'j_mafia_spec' ] = true,
        [ 'j_mafia_elite' ] = true,
    },
}

Ambi.Homeway.warehouses[ 'police' ] = {
    header = 'Полиция',
    color = Color( 110, 159, 214),
    items = {
        { header = 'AUG Para', class = 'arccw_augpara', count = 10, max = 100, cost = 100 },
        { header = 'Famas', class = 'arccw_famas', count = 5, max = 100, cost = 100 },
        { header = 'TMP', class = 'arccw_tmp', count = 3, max = 80, cost = 300 },
        { header = 'MP5', class = 'arccw_mp5', count = 3, max = 80, cost = 300 },
        { header = 'Авто Дробовик', class = 'arccw_m1014', count = 3, max = 50, cost = 400 },
        { header = 'Револьвер', class = 'arccw_ragingbull', count = 2, max = 50, cost = 500 },
        { header = 'Скаут', class = 'arccw_scout', count = 0, max = 50, cost = 500 },
        { header = 'M4A1', class = 'arccw_m4a1', count = 0, max = 50, cost = 600 },
    },
    ammo = 2000,
    medkits = 20,
    armor = 20,

    ammo_buy = {
        cost = 50,
        add = 150,
    },

    medkits_buy = {
        cost = 200,
        add = 4,
    },

    armor_buy = {
        cost = 100,
        add = 4,
    },

    leaders = { 
        [ 'j_sheriff' ] = true,
        [ 'j_mayor' ] = true,
    },
    jobs = {
        [ 'j_sheriff' ] = true,
        [ 'j_police1' ] = true,
        [ 'j_police2' ] = true,
        [ 'j_police3' ] = true,
        [ 'j_swat' ] = true,
        [ 'j_swat_elite' ] = true,
        [ 'j_jugger' ] = true,
    },
    raiders = {
        [ 'j_mafia_leader' ] = true,
    }
}

Ambi.Homeway.warehouses[ 'mayor' ] = {
    header = 'Мэрия',
    color = Color( 193, 93, 76),
    items = {
        { header = 'Famas', class = 'arccw_famas', count = 5, max = 50 },
        { header = 'TMP', class = 'arccw_tmp', count = 3, max = 50 },
        { header = 'MP5', class = 'arccw_mp5', count = 3, max = 50 },
        { header = 'Авто Дробовик', class = 'arccw_m1014', count = 3, max = 50 },
    },
    ammo = 500,
    medkits = 5,
    armor = 5,

    ammo_buy = {
        cost = 50,
        add = 150,
    },

    medkits_buy = {
        cost = 200,
        add = 4,
    },

    armor_buy = {
        cost = 100,
        add = 4,
    },

    leaders = { 
        [ 'j_mayor' ] = true,
    },
    jobs = {
        [ 'j_bodyguard' ] = true,
    },
    raiders = {
        [ 'j_mafia_leader' ] = true,
    }
}

function Ambi.Homeway.GetWarehouse( sWarehouse )
    return Ambi.Homeway.warehouses[ sWarehouse or '' ]
end