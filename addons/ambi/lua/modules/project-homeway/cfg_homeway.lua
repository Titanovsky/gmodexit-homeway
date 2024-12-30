Ambi.General.CreateModule( 'Homeway' )

-- --------------------------------------------------------------------------------------------------------------------------------------------
Ambi.Homeway.Config.global_string_type = 0 -- 0: Параметры ниже, 1: Тех. работы, 2: НонРП тайм
Ambi.Homeway.Config.global_string_text = ''
Ambi.Homeway.Config.global_string_color = Color( 231, 103 ,103)

Ambi.Homeway.Config.donate_x = 2 -- находится на sv_feature.lua
--
Ambi.Homeway.Config.news = {
    header = 'Осеннее Обновление',
    desc = '• Мы заканчиваем череду глобальных изменений и назовём её - Осеннее Обновление. Акция: X2 Донат, Убивашка, создание вируса в лаборатории, новая подработка, причём здесь Honkai Impact, анимации, организации, дуэли, ограбления поезда с золотом и кучу всего.',
    preview_url = 'https://i.postimg.cc/15Gx0p6b/promo-alive2024.png',
    url = 'https://vk.com/@-226604825-autumn-global-update'
}

Ambi.Homeway.Config.auth = {
    pos = Vector( 1196, 70, 900 ),
    ang = Angle( 28, -47, 0 ),
    music = 'ambi/homeway/rufus_du_sol_on_my_knees_skeler_remix.wav',
}

Ambi.Homeway.Config.narko_money = { min = 2000, max = 4500 }
Ambi.Homeway.Config.narko_delay = 60 * 3
Ambi.Homeway.Config.narko_spawns = {
    { pos = Vector( 5478, -1618, 88 ), ang = Angle( 0, -72, 0 ) },
    { pos = Vector( 310, 1280, 85 ), ang = Angle( 0, -72, 0 ) },
    { pos = Vector( 2157, 497, 72 ), ang = Angle( 0, -72, 0 ) },
    { pos = Vector( 3064, 2409, 76 ), ang = Angle( 0, -72, 0 ) },
    { pos = Vector( 5981, -1037, 80 ), ang = Angle( 0, -72, 0 ) },
    { pos = Vector( 5754, -2768, 199 ), ang = Angle( 0, -72, 0 ) },
    { pos = Vector( 2685, -4025, -219 ), ang = Angle( 0, -72, 0 ) },
}

Ambi.Homeway.Config.mayor_god_time = 60 * 3

Ambi.Homeway.Config.factory_auto_fill = 60 * 2
Ambi.Homeway.Config.factory_work_delay = 60 * 5
Ambi.Homeway.Config.factory_work_delay_count = 60
Ambi.Homeway.Config.factory_machine_delay = 20
Ambi.Homeway.Config.factory_workbench_delay = 5
Ambi.Homeway.Config.factory_bonus = 250
Ambi.Homeway.Config.factory_warehouse_spawn_box_delay = 60 * 5
Ambi.Homeway.Config.factory_items = {
    [ 'arccw_mp5' ] = { cost = 150, time = 2, header = 'MP5' },
    [ 'arccw_tmp' ] = { cost = 150, time = 3, header = 'TMP' },
    [ 'arccw_augpara' ] = { cost = 200, time = 4, header = 'AUG Para' },
    [ 'arccw_scout' ] = { cost = 250, time = 5, header = 'Scout' },
    [ 'arccw_m4a1' ] = { cost = 300, time = 5, header = 'M4A1' },
    [ 'arccw_ragingbull' ] = { cost = 500, time = 10, header = 'Револьвер' },
    [ 'arccw_awm' ] = { cost = 300, time = 15, header = 'AWP' },
}

Ambi.Homeway.Config.mine_work_delay = 60 * 5
Ambi.Homeway.Config.mine_work_delay_count = 300
Ambi.Homeway.Config.mine_reload_rock = 25 -- Сколько секунд перезагружается камень
Ambi.Homeway.Config.mine_costs = {
    [ 'stone' ] = 8,
    [ 'charcoal' ] = 16,
    [ 'ore_iron' ] = 30,
    [ 'ruby' ] = 150,
}

Ambi.Homeway.Config.color_blue = Color( 79, 194, 248 )
Ambi.Homeway.Config.color_black = Color( 36, 36, 36 )
Ambi.Homeway.Config.color_blue_dark = Color( 51, 54, 68)
Ambi.Homeway.Config.color_white = Color( 240, 240, 240 )

Ambi.Homeway.Config.warehouse_raid_time = 3 -- в минутах сколько длится рейд?
Ambi.Homeway.Config.warehouse_raid_delay_win = 10 -- сколько задержка в минутах после удачного рейда?
Ambi.Homeway.Config.warehouse_raid_delay_lose = 15 -- сколько задержка в минутах после неудачного рейда?
Ambi.Homeway.Config.warehouse_raid_online_defenders = 2 -- сколько должно быть игроков в онлайне у фракции защитников
Ambi.Homeway.Config.warehouse_raid_online_raiders = 3 -- сколько должно быть игроков в онлайне у фракции, которая рейдит

Ambi.Homeway.Config.superadmins = {
    [ 'STEAM_0:1:95303327' ] = 'Titanovsky',
    [ 'STEAM_0:0:506794397' ] = 'Asuna',
}

Ambi.Homeway.Config.founder_assistants = {
    [ 'STEAM_0:0:197573002' ] = 'tochka',
    [ 'STEAM_0:1:594871770' ] = 'papich',
}

Ambi.Homeway.Config.head_admin = {
    [ 'STEAM_0:1:571013464' ] = 'Malax',
}

Ambi.Homeway.Config.warn_time_remove = 6 -- Через сколько часов варн снимется относительно своей даты
Ambi.Homeway.Config.warn_max = 6 -- На каком варне игрок получит бан на 4 дня
Ambi.Homeway.Config.warn_block_goverment_jobs = 3 -- На каком варне игрок не сможет зайти за ГОС работы

Ambi.Homeway.Config.rainbow_printer = {
    delay = 20, -- задержка в секундах
    max_update = 8, -- не должно быть равно или больше delay
    minus_delay_on_update = 2, -- при каждой обнове на сколько секунд будет отниматься у delay
    money = 220, -- раз в delay сколько будет производить зелени
    multiply_money_on_update = 35, -- multiply_money_on_update * max_update + Random( min_random_money, max_random_money ) = Деньги
    start_hp = 600,
    max_hp = 2000,
    damage = 5, -- Сколько дамага будет наносится за напечатывания денег

    repair_kit_add_hp = 150,
}

Ambi.Homeway.Config.hospital = {
    enable = true, -- система будет работать?
    min_hp = 75, -- сколько нужно ХП, чтобы выйти из госпиталя
    spawn_hp = 45, -- после смерти сколько будет ХП
    points = { -- точки спавна
        Vector( 1968, -2915, 132 ),
        Vector( 1853, -2930, 137 ),
        Vector( 1703, -2949, 137 ),
        Vector( 1894, -2697, 133 ),
    }
}

Ambi.Homeway.Config.computer_club_start_game_delay = 25 -- Задержка в минутах между автоматическим началом игры

Ambi.Homeway.Config.promocode_user_time_limit = 2 -- Через сколько часов игры на сервере нельзя будет вводить юзерские промики
Ambi.Homeway.Config.promocode_user_max_len = 12
Ambi.Homeway.Config.promocode_user_min_len = 4
Ambi.Homeway.Config.promocode_user_time_receiver = 5 -- Сколько минут должен ждать игрок перед получение награды от промокода
Ambi.Homeway.Config.promocode_user_time_maker = 10 -- Сколько минут должен ждать создатель промокода перед получение награды от промокода
Ambi.Homeway.Config.promocode_time_vk = 25 -- Сколько минут промик от ВК

Ambi.Homeway.Config.loot_delay = 60 * 3
Ambi.Homeway.Config.loot_items = {
    'none',
    'none',
    'none',
    'none',
    'none',

    'chest',
    'chest',
    'chest',

    'chest_money',
    'chest_money',

    'chest_food',
    'chest_food',

    'chest_boost',
    'chest_boost',

    'chest_skins',
    'chest_skins',
    'chest_skins',

    'chest_weapons',
}

Ambi.Homeway.Config.show_use_button = { -- у каких энтити должна появится кнопка "Нажмите Е"
    [ 'prop_door_rotating' ] = 'Открыть/Закрыть дверь',
    [ 'gun_dealer' ] = 'Купить оружие',
    [ 'applejack_tree' ] = 'Взять яблоки',
    [ 'applejack_warehouse' ] = 'Положить яблоки',
    [ 'cactus' ] = 'Срезать кактус',
    [ 'cactus_warehouse' ] = 'Положить кактусы',
    [ 'double_or_nothing' ] = 'Играть',
    [ 'redsushi_slot' ] = 'Играть',
    [ 'wheel_of_luck' ] = 'Играть',
    [ 'item_healthcharger' ] = 'Зажмите и выздоравливайте',
    [ 'ent_rainbow_printer' ] = 'Забрать деньги (На R вкл/выкл)',
    [ 'ent_rainbow_printer_vip' ] = 'Забрать деньги (На R вкл/выкл)',
    [ 'ent_rainbow_printer_premium' ] = 'Забрать деньги (На R вкл/выкл)',
    [ 'npc_questgiver' ] = 'Взять квест',
    [ 'chest' ] = 'Открыть сундук',
    [ 'ent_pc' ] = 'Играть',
    [ 'warehouse' ] = 'Посмотреть/Рейдить (На R открыть/закрыть)',
    [ 'rob_object' ] = 'Надо уничтожить груз',
    [ 'news' ] = 'Посмотреть новости',
    [ 'loot' ] = 'Залутать',
    [ 'workbench' ] = 'Открыть верстак',
}

Ambi.Homeway.Config.arrest_objects = { -- объекты для изъятия
    [ 'metz_water' ] = true,
    [ 'metz_liquid_iodine' ] = true,
    [ 'metz_gas_cylinder' ] = true,
    [ 'metz_iodine_jar' ] = true,
    [ 'metz_sulfur' ] = true,
    [ 'metz_phosphor_pot' ] = true,
    [ 'metz_stove' ] = true,
    [ 'metz_muratic_acid' ] = true,
    [ 'metz_final_pot' ] = true,
    [ 'metz_sulfur' ] = true,

    [ 'ent_rainbow_kit_repair' ] = true,
    [ 'ent_rainbow_printer' ] = true,
    [ 'ent_rainbow_silencer' ] = true,
    [ 'ent_rainbow_upgrader' ] = true,
}

Ambi.Homeway.Config.block_buildings = {
    [ 'models/ambi/homeway/buildings/hw_industrial.mdl' ] = true,
    [ 'models/ambi/homeway/buildings/hw_hospital.mdl' ] = true,
}

Ambi.Homeway.Config.ranks_convert = {
    [ 'superadmin' ] = { header = 'Новый Год 2025', color = Color( 69, 139, 237) },
    [ 'founder-assistant' ] = { header = 'Founder\'s Assistant', color = Color( 247, 190, 136) },
    [ 'head-admin' ] = { header = 'The Head Admin', color = Color( 239, 78, 78) },
    [ 'sub-head-admin' ] = { header = 'Sub-Head Admin', color = Color( 203, 120, 120) },
    [ 'senior-admin' ] = { header = 'Senior Admin', color = Color( 2, 78, 242) },
    [ 'd-senior-curator' ] = { header = 'Senior Curator', color = Color( 215, 34, 134) },
    [ 'dcurator' ] = { header = 'Curator', color = Color( 174, 120, 181) },
    [ 'admin' ] = { header = 'Administrator', color = Color( 58, 223, 80) },
    [ 'junior-admin' ] = { header = 'Junior Admin', color = Color( 127, 58, 223) },
    [ 'dsadmin' ] = { header = 'SAdmin', color = Color( 184, 212, 0) },
    [ 'senior-moder' ] = { header = 'Senior Moderator', color = Color( 2, 153, 53) },
    [ 'moder' ] = { header = 'Moderator', color = Color( 189, 32, 200) },
    [ 'dmoder' ] = { header = 'D-Moder', color = Color( 176, 210, 239) },
    [ 'helper' ] = { header = 'Helper', color = Color( 255, 255, 255) },
    [ 'dsupport' ] = { header = 'Support', color = Color( 255, 255, 255) },
}

Ambi.Homeway.Config.navigations = {
    { header = 'Мэрия', pos = Vector( 1113, 1855, 119 ),  desc = 'Сердце города, где принимаются важные решения и скрываются мрачные секреты власти.', icon_url = 'https://ltdfoto.ru/images/2024/08/05/building.png', preview_url = 'https://ltdfoto.ru/images/2024/08/05/gmod_j6VQT121us.jpg' },
    { header = 'Полицейское Управление', pos = Vector( 3836, -769, 121 ), desc = 'Оазис справедливости, где защищают порядок, но не все тайны остаются раскрытыми.', icon_url = 'https://ltdfoto.ru/images/2024/08/05/police.png', preview_url = 'https://ltdfoto.ru/images/2024/08/05/gmod_V8VAAhZvx0.jpg' },
    { header = 'Штаб ФБР', pos = Vector( -1163, -2105, 118 ), desc = 'Точка сборки агентов, готовых раскрыть преступления и защитить жителей города.', icon_url = 'https://ltdfoto.ru/images/2024/08/08/fbi.png', preview_url = 'https://i.imgur.com/hjalvCC.jpeg' },
    { header = 'Торговый Центр', pos = Vector( 2546, -596, 136 ), desc = 'Гудящие коридоры, наполненные шумом покупок.', icon_url = 'https://ltdfoto.ru/images/2024/08/08/mall.png', preview_url = 'https://i.imgur.com/vlSXeIa.jpeg' },
    { header = 'Компьютерный Клуб', pos = Vector( 23, -1232, 117 ), desc = 'Клуб, наполненный адреналином и азартом, где за игровыми столами кроются победы.', icon_url = 'https://ltdfoto.ru/images/2024/08/08/computer.png', preview_url = 'https://i.imgur.com/OfK1UIH.jpeg' },
    { header = 'Шахта', pos = Vector( -746, -1862, -183 ), desc = 'Глубокий мир, наполненный звуками труда. Свет фонарей пробивается сквозь завесу мрака и опасности.', icon_url = 'https://ltdfoto.ru/images/2024/08/08/pickaxe.png', preview_url = 'https://i.imgur.com/Wi0vE2g.jpeg' },
    { header = 'Оружейный Завод', pos = Vector( 795, -1788, 95 ), desc = 'Убежище серых стен и бесконечных конвейеров, где орудие рождается в тяжёлых условиях.', icon_url = 'https://ltdfoto.ru/images/2024/08/08/factory.png', preview_url = 'https://i.imgur.com/4afAmkJ.jpeg' },
    { header = 'Сбор Яблок', pos = Vector( 2529, -3111, 65 ), desc = 'Простая и честная работа с небольшой оплатой.', icon_url = 'https://ltdfoto.ru/images/2024/08/08/garden.png', preview_url = 'https://i.imgur.com/XRzOcBF.png' },
    { header = 'Отель', pos = Vector( 2835, -2214, 98 ), desc = 'Пятиэтажное здание, где пересекаются судьбы новеньких в этом городе.', icon_url = 'https://ltdfoto.ru/images/2024/08/08/hotel1.png', preview_url = 'https://i.imgur.com/l4JRI31.jpeg' },
    { header = 'Общежитие', pos = Vector( -328, -344, 107 ), desc = 'Строение с двумя этажами с не самым лучшим контингентом.', icon_url = 'https://ltdfoto.ru/images/2024/08/08/hotel2.png', preview_url = 'https://i.imgur.com/Ab8L9W7.jpeg' },
    { header = 'Дом Мафии', pos = Vector( 5356, -2433, 118 ), desc = 'Лучше обходить его стороной.', icon_url = 'https://ltdfoto.ru/images/2024/08/08/revolver.png', preview_url = 'https://i.imgur.com/oLjUyW0.jpeg' },
}

Ambi.Homeway.Config.block_npc = { -- NPC которых нельзя убить/взорвать и прочую дичь вытворить
    [ 'gun_dealer' ] = true,
    [ 'npc_chief' ] = true,
    [ 'npc_dark_man' ] = true,
    [ 'npc_duelist' ] = true,
}

Ambi.Homeway.Config.changer_hostname_enable = false -- Включить смену названия сервера
Ambi.Homeway.Config.changer_hostname_delay = 500 -- Через секунд сколько будет меняться --! Требуется рестарт
Ambi.Homeway.Config.changer_hostname_phrases_a = {
    -- '',
    'ДОНАТ x2',
    -- 'НАБОР',
    -- 'FPS',
    -- 'БЫСТРО',
    -- 'БЫСТРАЯ ЗАГРУЗКА',
    -- 'ОБНОВКА',
}
Ambi.Homeway.Config.changer_hostname_phrases_b = {
    --'',
    'ПРОМОКОД',
    -- 'PREMIUM',
    -- 'ПРОМО',
    -- 'FREE',
    -- 'ЗАХОДИ',
    -- 'ДОНАТ',
}
Ambi.Homeway.Config.changer_hostname_phrases_c = {
    'РАЗДАЧА',
    -- 'МАФИЯ',
    -- 'КОПЫ',
    -- 'БЕСПЛАТНО',
    -- 'СЮДА',
}

Ambi.Homeway.Config.prison_work = { -- Обработка металл. конструкции
    delay = 15, -- Задержка
    min_reward = 10, -- Мин. награда
    max_reward = 25, -- Макс. награда
    bonus_for_player = 5, -- Сколько денег за игрока: бонус * количество игроков
}

Ambi.Homeway.Config.applejack = { -- Сбор яблок
    delay = 12, -- Задержка
    min_reward = 30, -- Мин. награда
    max_reward = 90, -- Макс. награда
    bonus_for_player = 30, -- Сколько денег за игрока: бонус * количество игроков
}
--
Ambi.Homeway.Config.cactus = { -- Сбор кактусов
    delay = 18, -- Задержка
    min_reward = 20, -- Мин. награда
    max_reward = 80, -- Макс. награда
    bonus_for_player = 50, -- Сколько денег за игрока: бонус * количество игроков
}

Ambi.Homeway.Config.weapons_list_gundealer_npc = { -- Таблица для NPC Оружейника. Притом, что если будут оружейники, цены повысятся на 30%
    { class = 'arccw_makarov', header = 'Макаров', desc = 'Крутая вещь', cost = 4000, ammo = 15 },
    { class = 'arccw_ruger', header = 'Рюгер', desc = 'Крутая вещь', cost = 5000, ammo = 15 },
    { class = 'arccw_m9', header = 'М92FS', desc = 'Крутая вещь', cost = 7000, ammo = 20 },
    { class = 'arccw_g18', header = 'Glock 18', desc = 'Крутая вещь', cost = 8000, ammo = 30 },
    { class = 'arccw_db_sawnoff', header = 'Двухстволка', desc = 'Крутая вещь', cost = 9000, ammo = 10 },
    { class = 'arccw_ump45', header = 'UMP 45', desc = 'Крутая вещь', cost = 15000, ammo = 35 },
    { class = 'arccw_galil556', header = 'Галил', desc = 'Крутая вещь', cost = 20000, ammo = 35 },
}

Ambi.Homeway.Config.default_spawns = {
    { map = 'rp_bangclaw', pos = Vector( -8, -3000, 121 ), ang = Angle( 0, 0, 0 ) },
    { map = 'rp_bangclaw', pos = Vector( -1, -2872, 122 ), ang = Angle( 0, 0, 0 ) },
    { map = 'rp_bangclaw', pos = Vector( 16, -2749, 125 ), ang = Angle( 0, 0, 0 ) },
    { map = 'rp_bangclaw', pos = Vector( -33, -2621, 125 ), ang = Angle( 0, 0, 0 ) },
    { map = 'rp_bangclaw', pos = Vector( -16, -2490, 129 ), ang = Angle( 0, 0, 0 ) },
    { map = 'rp_bangclaw', pos = Vector( 99, -2485, 125 ), ang = Angle( 0, 0, 0 ) },
    { map = 'rp_bangclaw', pos = Vector( 84, -2621, 122 ), ang = Angle( 0, 0, 0 ) },
    { map = 'rp_bangclaw', pos = Vector( 109, -2753, 119 ), ang = Angle( 0, 0, 0 ) },
    { map = 'rp_bangclaw', pos = Vector( 126, -2876, 117 ), ang = Angle( 0, 0, 0 ) },
    { map = 'rp_bangclaw', pos = Vector( 112, -2999, 119 ), ang = Angle( 0, 0, 0 ) },
    { map = 'rp_bangclaw', pos = Vector( 223, -3013, 116 ), ang = Angle( 0, 0, 0 ) },
    { map = 'rp_bangclaw', pos = Vector( 214, -2882, 110 ), ang = Angle( 0, 0, 0 ) },
    { map = 'rp_bangclaw', pos = Vector( 207, -2746, 115 ), ang = Angle( 0, 0, 0 ) },
    { map = 'rp_bangclaw', pos = Vector( 192, -2614, 113 ), ang = Angle( 0, 0, 0 ) },
    { map = 'rp_bangclaw', pos = Vector( 185, -2491, 118 ), ang = Angle( 0, 0, 0 ) },
    { map = 'rp_bangclaw', pos = Vector( 284, -2488, 118 ), ang = Angle( 0, 0, 0 ) },
    { map = 'rp_bangclaw', pos = Vector( 333, -2533, 112 ), ang = Angle( 0, 0, 0 ) },
    { map = 'rp_bangclaw', pos = Vector( 323, -2907, 116 ), ang = Angle( 0, 0, 0 ) },
    { map = 'rp_bangclaw', pos = Vector( 319, -3010, 113 ), ang = Angle( 0, 0, 0 ) },

    { map = 'rp_bangclaw_drp_winter_v1', pos = Vector( -8, -3000, 121 ), ang = Angle( 0, 0, 0 ) },
    { map = 'rp_bangclaw_drp_winter_v1', pos = Vector( -1, -2872, 122 ), ang = Angle( 0, 0, 0 ) },
    { map = 'rp_bangclaw_drp_winter_v1', pos = Vector( 16, -2749, 125 ), ang = Angle( 0, 0, 0 ) },
    { map = 'rp_bangclaw_drp_winter_v1', pos = Vector( -33, -2621, 125 ), ang = Angle( 0, 0, 0 ) },
    { map = 'rp_bangclaw_drp_winter_v1', pos = Vector( -16, -2490, 129 ), ang = Angle( 0, 0, 0 ) },
    { map = 'rp_bangclaw_drp_winter_v1', pos = Vector( 99, -2485, 125 ), ang = Angle( 0, 0, 0 ) },
    { map = 'rp_bangclaw_drp_winter_v1', pos = Vector( 84, -2621, 122 ), ang = Angle( 0, 0, 0 ) },
    { map = 'rp_bangclaw_drp_winter_v1', pos = Vector( 109, -2753, 119 ), ang = Angle( 0, 0, 0 ) },
    { map = 'rp_bangclaw_drp_winter_v1', pos = Vector( 126, -2876, 117 ), ang = Angle( 0, 0, 0 ) },
    { map = 'rp_bangclaw_drp_winter_v1', pos = Vector( 112, -2999, 119 ), ang = Angle( 0, 0, 0 ) },
    { map = 'rp_bangclaw_drp_winter_v1', pos = Vector( 223, -3013, 116 ), ang = Angle( 0, 0, 0 ) },
    { map = 'rp_bangclaw_drp_winter_v1', pos = Vector( 214, -2882, 110 ), ang = Angle( 0, 0, 0 ) },
    { map = 'rp_bangclaw_drp_winter_v1', pos = Vector( 207, -2746, 115 ), ang = Angle( 0, 0, 0 ) },
    { map = 'rp_bangclaw_drp_winter_v1', pos = Vector( 192, -2614, 113 ), ang = Angle( 0, 0, 0 ) },
    { map = 'rp_bangclaw_drp_winter_v1', pos = Vector( 185, -2491, 118 ), ang = Angle( 0, 0, 0 ) },
    { map = 'rp_bangclaw_drp_winter_v1', pos = Vector( 284, -2488, 118 ), ang = Angle( 0, 0, 0 ) },
    { map = 'rp_bangclaw_drp_winter_v1', pos = Vector( 333, -2533, 112 ), ang = Angle( 0, 0, 0 ) },
    { map = 'rp_bangclaw_drp_winter_v1', pos = Vector( 323, -2907, 116 ), ang = Angle( 0, 0, 0 ) },
    { map = 'rp_bangclaw_drp_winter_v1', pos = Vector( 319, -3010, 113 ), ang = Angle( 0, 0, 0 ) },
}

Ambi.Homeway.Config.hud_block_weapons = {
    [ 'weapon_physcannon' ] = true,
    [ 'weapon_bugbait' ] = true,
    [ 'weapon_crowbar' ] = true,
    [ 'weapon_stunstick' ] = true,
    [ 'weapon_fists' ] = true,
    [ 'weapon_physgun' ] = true,
    [ 'gmod_tool' ] = true,
    [ 'keys' ] = true,
    [ 'lockpick' ] = true,
    [ 'stunstick' ] = true,
    [ 'arrest_stick' ] = true,
    [ 'unarrest_stick' ] = true,
    [ 'weaponchecker' ] = true,
    [ 'keypadchecker' ] = true,
    [ 'gmod_camera' ] = true,
}

Ambi.Homeway.Config.weapon_selector = {}
Ambi.Homeway.Config.weapon_selector.font = '24 Montserrat SemiBold'
Ambi.Homeway.Config.weapon_selector.color_text = Ambi.Homeway.Config.color_blue
Ambi.Homeway.Config.weapon_selector.color_panel = Ambi.Homeway.Config.color_black
Ambi.Homeway.Config.weapon_selector.color_active_panel = Color( 100, 100, 100, 210 )
Ambi.Homeway.Config.weapon_selector.panel = {
    boxWidth = 130, -- ширина панельки
    boxHeight = 26, -- высота панельки
    paddingX = 4, -- оступ между панельками по X
    paddingY = 4, -- отступ между панельками по Y
    paddingGlobalY = 10, -- отступ всех панелек по Y от экрана
    paddingGlobalX = 0, -- отступ всех панелек по Y от экрана
    offsetX_Text = 4, -- отступ по X (слева) для текста 
    offsetY_Text = 0, -- отступ по Y (сверху) для текста
    max_name_Text = 12, -- сколько символов максимально может быть у текста?
}

Ambi.Homeway.Config.help_text = {
    { question = 'Как вести промокод?', answer = 'В F4, внизу кнопка Промокоды. Можно создать свой или ввести чужой (до 2 часов игры!), также ввести системный' },
    { question = 'Почему у меня всё в ERROR и эмо-текстурах?', answer = 'Тут может быть две причины. Во-первых, может не хватать CSS-контента. Вы можете найти инструкцию по его установке в интернете. Во-вторых, может не хватать нашего контента. Чтобы его загрузить: F4 -> Скачать Контент.' },
    { question = 'Где найти наши ссылки?', answer = 'Вы можете их найти в нашем Discord-сервере. Ссылка на который расположена в F4-меню.' },
    { question = 'Как настроить чат?', answer = 'Кликните по чату правой кнопкой мыши и настраивайте чат как хотите' },
    { question = 'С чего начать играть?', answer = 'Начните проходить первый квест. Также у нас есть гайд, который вы можете найти в нашем Discord-сервере.' },
    { question = 'Где мне приобрести донат?', answer = 'Нажмите на F6. Если вам нужен теневой или индивидуальный донат, вся информация об этом есть в соответствующем разделе Discord-сервера.' },
    { question = 'Как Приобрести дверь и добавить совладельца?', answer = 'Чтобы приобрести дверь, необходимо к ней подойти и нажать F2. Также и продать. Продать все двери можно через C-меню. Чтобы добавить совладельца: подходите к двери с ключами и нажимаете “R”.' },
    { question = 'Как приобрести патроны на оружие?', answer = 'C-Меню -> Купить Патроны. Обычное даёт 7 патронов. А x10, следовательно, 70 патронов.' },
    { question = 'Что такое задания (дейлики)?', answer = 'Дейлики можно посмотреть через F4 -> Задания. Это ежедневные миссии за которые даётся щедрая награда' },
    { question = 'Как включить вид от третьего лица?', answer = '3ье лицо можно включить/выключить через Кнопку “F7 или C-меню' },
    { question = 'Как подать жалобу на игрока?', answer = 'Команда “/report” в чат / C-меню -> Подать Жалобу / F4 -> Репорт.' },
    { question = 'Как подать жалобу на администратора?', answer = 'В нашем дискорде можете открыть тикет в канале “Жалобы”. Там же вы можете найти раздел с Предложениями и Баг-Репортами.' },
}

Ambi.Homeway.Config.perma_weapons = {
    { class = 'arccw_welrod', header = '• Убивашка', igs = 'perma_wep_weldor', delay = 1 },
    { class = 'arccw_gauss_rifle', header = '• Гаусска', igs = 'perma_wep_gauss', delay = 1 },
    { class = 'weapon_ak47_beast', header = 'CF Огненная AK-47', igs = 'perma_wep_cf_ak47', delay = 1 }, 
    { class = 'weapon_deagle_bornbeast', header = 'CF Дикий Дигл', igs = 'perma_wep_cf_deagle', delay = 1 },
    { class = 'weapon_m4a1_beast', header = 'CF M4A1', igs = 'perma_wep_cf_m4a1', delay = 1 },
    { class = 'arccw_hb3_verdict', header = 'Verdict', igs = 'perma_wep_hm_verdict', delay = 1 },
    { class = 'arccw_hb3_katana', header = 'Katana', igs = 'perma_wep_hm_katana', delay = 1 },
    { class = 'arccw_hb3_fan', header = 'Перо', igs = 'perma_wep_hm_fan', delay = 1 },
    { class = 'arccw_hb3_sickle', header = 'Уничтожитель', igs = 'perma_wep_hm_sickle', delay = 1 },
    { class = 'arccw_deagle357', header = 'Desert Eagle', igs = 'perma_wep_deagle', delay = 1 },
    { class = 'arccw_ak47', header = 'AK-47', igs = 'perma_wep_ak47', delay = 1, premium = true },
    { class = 'arccw_awm', header = 'AWP', igs = 'perma_wep_awp', delay = 1 },
    { class = 'arccw_m60', header = 'M60', igs = 'perma_wep_m14', delay = 1 },
    { class = 'arccw_rpg7', header = 'RPG', igs = 'perma_wep_rpg', delay = 1 },
    { class = 'arccw_gauss_rifle', header = 'Гаусска', igs = 'perma_wep_gauss', delay = 1 },
    { class = 'weapon_ss2_colt', header = '[SS2] Револьверы', igs = 'perma_wep_ss2_colt', delay = 1 },
    { class = 'weapon_ss2_doubleshotgun', header = '[SS2] Двустволка', igs = 'perma_wep_ss2_doubleshtg', delay = 1 },
    { class = 'weapon_ss2_uzi', header = '[SS2] Узи', igs = 'perma_wep_ss2_uzi', delay = 1 },
    { class = 'weapon_ss2_rocketlauncher', header = '[SS2] Rocker Launcher', igs = 'perma_wep_ss2_rocket', delay = 1 },
    { class = 'weapon_ss2_beamgun', header = 'Лазерка', igs = 'perma_laserka', delay = 1 },
}

Ambi.Homeway.Config.perma_models = {
    { model = 'models/Asuna_Yuuki/Sword_Art_Online/rstar/Asuna_Yuuki/Asuna_Yuuki.mdl', header = 'Асуна', delay = 1, whitelist = { [ 'STEAM_0:0:506794397' ] = true } },
    { model = 'models/new_neko_arthas.mdl', header = 'Пошлая', delay = 1, whitelist = { [ 'STEAM_0:1:594871770' ] = true }, igs = 'perma_skin_whore', },
    { model = 'models/cyanblue/overlord/aura/aura.mdl', header = 'Аура', delay = 1, whitelist = { [ 'STEAM_0:0:215026430' ] = true } },
    { model = 'models/cyanblue/overlord/mare/mare.mdl', header = 'Марэ', delay = 1, whitelist = { [ 'STEAM_0:0:786979569' ] = true } },
    { model = 'models/jazzmcfly/muffler/muffler.mdl', header = 'Дьяволица', delay = 1, whitelist = { [ 'STEAM_0:0:197573002' ] = true, [ 'STEAM_0:0:786979569' ] = true }, igs = 'perma_skin_diablo', },
    { model = 'models/aponia/honkai_impact/rstar/aponia/aponia.mdl', header = 'Апония', delay = 1, whitelist = { [ 'STEAM_0:0:786979569' ] = true }, igs = 'perma_skin_aponia', },

    { model = 'models/player/charple.mdl', header = 'Сухарик', delay = 1, igs = 'perma_skin_coal', premium = true },
    { model = 'models/player/zombie_classic.mdl', header = 'Zombie', delay = 1, igs = 'perma_skin_zombie', premium = true },
    { model = 'models/player/skeleton.mdl', header = 'Дрыщ', delay = 1, igs = 'perma_skin_skelet', premium = true },
    { model = 'models/player/griffbo/saulgoodman.mdl', header = 'Лучше Звоните Солу', delay = 1, igs = 'perma_skin_soul_goodman', premium = true },
    { model = 'models/risenshine/gang_beast.mdl', header = 'Гомункул', delay = 1, igs = 'perma_skin_gang_beast', bodygroups = '1111' },
    { model = 'models/models/dizze/colgate.mdl', header = 'Тюбик', delay = 1, igs = 'perma_skin_colgate' },
    { model = 'models/konnie/jumpforce/lightyagami.mdl', header = 'Ягами Лайт', delay = 1, igs = 'perma_skin_yagami' },
    { model = 'models/player/Tuubiii.mdl', header = '2B', delay = 1, igs = 'perma_skin_2b', bodygroups = '11111110' },
    { model = 'models/player/chimp/chimp.mdl', header = 'Бибизяна', delay = 1, igs = 'perma_skin_bibizyana'},
    { model = 'models/models/justagrox/groxv2/groxv2_pm.mdl', header = 'Grox', delay = 1, igs = 'perma_skin_crox' },
    { model = 'models/raincoat.mdl', header = 'Маньяк', delay = 1, igs = 'perma_skin_murder' },

    --Premium Skins:
    { model = 'models/player/combine_super_soldier.mdl', header = 'Супер Солдат', delay = 1, premium = true },
    { model = 'models/player/barney.mdl', header = 'Барни', delay = 1, premium = true },
    { model = 'models/player/breen.mdl', header = 'Мэр', delay = 1, premium = true },
    { model = 'models/player/p2_chell.mdl', header = 'Челл', delay = 1, premium = true },
    { model = 'models/player/soldier_stripped.mdl', header = 'Нарик', delay = 1, premium = true },
    { model = 'models/player/naruto/madara.mdl', header = 'Мадара Учиха', delay = 1, igs = 'perma_skin_madara', premium = true },

    { model = 'models/eft/bosses/partisan.mdl', header = 'EFT Дед', delay = 1, whitelist = { [ 'STEAM_0:0:26183405' ] = true }, igs = 'perma_skin_eft_partisan' },

    -- Halloween
    { model = 'models/player/zack/zackhalloween.mdl', header = 'Zack', delay = 1 },
    { model = 'models/player/monstermash/mm_bride.mdl', header = 'Bride', delay = 1 },
    { model = 'models/player/monstermash/mm_deer_haunter.mdl', header = 'Хантер', delay = 1 },
    { model = 'models/player/monstermash/mm_stein.mdl', header = 'Штейн', delay = 1 },
    { model = 'models/player/monstermash/mm_guest.mdl', header = 'Гость', delay = 1 },
    { model = 'models/player/monstermash/mm_headless_horseman.mdl', header = 'Безголовый Всадник', delay = 1 },
    { model = 'models/player/monstermash/mm_invisible_man.mdl', header = 'Невидимка', delay = 1 },
    { model = 'models/player/monstermash/mm_mad_scientist.mdl', header = 'Учёный', delay = 1 },
    { model = 'models/player/monstermash/mm_mummy.mdl', header = 'Муммия', delay = 1 },
    { model = 'models/player/monstermash/mm_nosferatu.mdl', header = 'Носферату', delay = 1 },
    { model = 'models/player/monstermash/mm_scarecrow.mdl', header = 'Пугало', delay = 1 },
    { model = 'models/monstermash/vampire_final.mdl', header = 'Вампир', delay = 1 },
    { model = 'models/monstermash/witch_final.mdl', header = 'Ведьма', delay = 1 },

    { model = 'models/player/alma/alma.mdl', header = 'Альма', delay = 1 },
    { model = 'models/player/fatty/fatty.mdl', header = 'Толстяк', delay = 1 },
    { model = 'models/player/biohazard/biohazard.mdl', header = 'БиоХазар', delay = 1 },
    { model = 'models/player/goblin/goblin.mdl', header = 'Лиза Барбоскина', delay = 1 },
    { model = 'models/player/grimreaper/grimreaper.mdl', header = 'Смэрт', delay = 1 },
    { model = 'models/player/monstermash/mm_banshee.mdl', header = 'Математичка', delay = 1 },
    { model = 'models/player/monstermash/mm_bloody_mary.mdl', header = 'Кровавая Мэри', delay = 1 },
    { model = 'models/player/monstermash/mm_zombie.mdl', header = 'Гуль', delay = 1 },
    { model = 'models/player/hellknight/hellknight.mdl', header = 'Doom', delay = 1 },
    { model = 'models/player/lycanwerewolf/lycanwerewolf.mdl', header = 'Оборотень', delay = 1 },
    { model = 'models/player/jrpc/jin.mdl', header = 'Солдат', delay = 1 },
    { model = 'models/player/hidden/hidden.mdl', header = 'Некромант', delay = 1 },
    { model = 'models/player/quake4pm/quake4pm.mdl', header = 'Quake 4', delay = 1 },
    { model = 'models/player/zsecurity/zsecurity.mdl', header = 'Z Security', delay = 1 },
    { model = 'models/player/fischer/fischer.mdl', header = 'Фишер', delay = 1 },
    { model = 'models/player/palpatine/palpatine.mdl', header = 'Палпатин', delay = 1 },
    { model = 'models/player/undead/undead.mdl', header = 'Бессмертный', delay = 1 },
    { model = 'models/player/verdugo/verdugo.mdl', header = 'Червь', delay = 1 },

    -- Новый год 2025
    { model = 'models/player/christmas/santa.mdl', header = 'Санта', delay = 1 },
    { model = 'models/player/dewobedil/vocaloid/yowane_haku/christmas_p.mdl', header = 'Youwane Haku', delay = 1 },
}

Ambi.Homeway.Config.sounds_on_spawn = {
    [ 'STEAM_0:1:612103930' ] = 'ambi/csz/zombie/laught3.ogg', -- биба
}

Ambi.Homeway.Config.props = {
    { model = 'models/props_c17/furnitureStove001a.mdl', category = 'Декор' },
    { model = 'models/props_c17/FurnitureFridge001a.mdl', category = 'Декор' },
    { model = 'models/props_wasteland/laundry_cart001.mdl', category = 'Декор' },
    { model = 'models/props_junk/meathook001a.mdl', category = 'Декор' },
    { model = 'models/props_junk/sawblade001a.mdl', category = 'Декор' },
    { model = 'models/props_junk/iBeam01a.mdl', category = 'Декор' },
    { model = 'models/Gibs/HGIBS.mdl', category = 'Декор' },
    { model = 'models/props_junk/MetalBucket02a.mdl', category = 'Декор' },
    { model = 'models/props_lab/binderredlabel.mdl', category = 'Декор' },
    { model = 'models/props_c17/SuitCase_Passenger_Physics.mdl', category = 'Декор' },
    { model = 'models/props_c17/BriefCase001a.mdl', category = 'Декор' },
    { model = 'models/props_junk/bicycle01a.mdl', category = 'Декор' },
    { model = 'models/maxofs2d/companion_doll.mdl', category = 'Декор' },
    { model = 'models/food/burger.mdl', category = 'Декор' },
    { model = 'models/food/hotdog.mdl', category = 'Декор' },
    { model = 'models/windingduke77/icons/alt arrow.mdl', category = 'Декор' },
    { model = 'models/windingduke77/icons/arrow.mdl', category = 'Декор' },
    { model = 'models/windingduke77/icons/bowling ball.mdl', category = 'Декор' },
    { model = 'models/windingduke77/icons/box.mdl', category = 'Декор' },
    { model = 'models/windingduke77/icons/code symbal.mdl', category = 'Декор' },
    { model = 'models/windingduke77/icons/copyright.mdl', category = 'Декор' },
    { model = 'models/windingduke77/icons/discord logo.mdl', category = 'Декор' },
    { model = 'models/windingduke77/icons/lighting bolt.mdl', category = 'Декор' },
    { model = 'models/windingduke77/icons/megaphone.mdl', category = 'Декор' },
    { model = 'models/windingduke77/icons/pay.mdl', category = 'Декор' },
    { model = 'models/windingduke77/icons/scale tilted.mdl', category = 'Декор' },
    { model = 'models/windingduke77/icons/scale.mdl', category = 'Декор' },
    { model = 'models/windingduke77/icons/warning sign.mdl', category = 'Декор' },

    { model = 'models/props_borealis/borealis_door001a.mdl', category = 'Конструкции' },
    { model = 'models/props_c17/fence01a.mdl', category = 'Конструкции' },
    { model = 'models/props_c17/fence01b.mdl', category = 'Конструкции' },
    { model = 'models/props_c17/fence03a.mdl', category = 'Конструкции' },
    { model = 'models/props_c17/gate_door01a.mdl', category = 'Конструкции' },
    { model = 'models/props_c17/gate_door02a.mdl', category = 'Конструкции' },
    { model = 'models/props_c17/signpole001.mdl', category = 'Конструкции' },
    { model = 'models/props_doors/door03_slotted_left.mdl', category = 'Конструкции' },
    { model = 'models/props_c17/metalladder001.mdl', category = 'Конструкции' },
    { model = 'models/props_lab/blastdoor001a.mdl', category = 'Конструкции' },
    { model = 'models/props_lab/blastdoor001b.mdl', category = 'Конструкции' },
    { model = 'models/props_lab/blastdoor001c.mdl', category = 'Конструкции' },
    { model = 'models/props_junk/wood_crate001a.mdl', category = 'Конструкции' },
    { model = 'models/props_junk/wood_crate002a.mdl', category = 'Конструкции' },
    { model = 'models/props_junk/wood_pallet001a.mdl', category = 'Конструкции' },
    { model = 'models/props_borealis/bluebarrel001.mdl', category = 'Конструкции' },
    { model = 'models/props_wasteland/kitchen_counter001b.mdl', category = 'Конструкции' },
    { model = 'models/props_wasteland/kitchen_counter001d.mdl', category = 'Конструкции' },
    { model = 'models/props_c17/canister01a.mdl', category = 'Конструкции' },
    { model = 'models/props_c17/canister02a.mdl', category = 'Конструкции' },
    { model = 'models/props_c17/concrete_barrier001a.mdl', category = 'Конструкции' },
    { model = 'models/props_c17/door01_left.mdl', category = 'Конструкции' },

    { model = 'models/props_c17/bench01a.mdl', category = 'Интерьер' },
    { model = 'models/props_c17/chair02a.mdl', category = 'Интерьер' },
    { model = 'models/props_c17/display_cooler01a.mdl', category = 'Интерьер' },
    { model = 'models/props_c17/FurnitureDrawer002a.mdl', category = 'Интерьер' },
    { model = 'models/props_c17/FurnitureDresser001a.mdl', category = 'Интерьер' },
    { model = 'models/props_c17/FurnitureFridge001a.mdl', category = 'Интерьер' },
    { model = 'models/props_interiors/Radiator01a.mdl', category = 'Интерьер' },
    { model = 'models/props_interiors/VendingMachineSoda01a.mdl', category = 'Интерьер' },
    { model = 'models/props_interiors/VendingMachineSoda01a_door.mdl', category = 'Интерьер' },
    { model = 'models/props_junk/PlasticCrate01a.mdl', category = 'Интерьер' },
    { model = 'models/props_junk/PlasticCrate01a.mdl', category = 'Интерьер' },
    { model = 'models/props_c17/shelfunit01a.mdl', category = 'Интерьер' },
    { model = 'models/props_combine/breenglobe.mdl', category = 'Интерьер' },
    { model = 'models/props_combine/breendesk.mdl', category = 'Интерьер' },
    { model = 'models/props_combine/breenchair.mdl', category = 'Интерьер' },
    { model = 'models/props_interiors/BathTub01a.mdl', category = 'Интерьер' },
    { model = 'models/props_interiors/Furniture_chair01a.mdl', category = 'Интерьер' },
    { model = 'models/props_interiors/Furniture_chair03a.mdl', category = 'Интерьер' },
    { model = 'models/props_interiors/Furniture_Couch01a.mdl', category = 'Интерьер' },
    { model = 'models/props_interiors/Furniture_Couch02a.mdl', category = 'Интерьер' },
    { model = 'models/props_interiors/Furniture_Desk01a.mdl', category = 'Интерьер' },
    { model = 'models/props_interiors/Furniture_Lamp01a.mdl', category = 'Интерьер' },
    { model = 'models/props_interiors/Furniture_shelf01a.mdl', category = 'Интерьер' },
    { model = 'models/props_interiors/Furniture_Vanity01a.mdl', category = 'Интерьер' },
    { model = 'models/props_interiors/pot01a.mdl', category = 'Интерьер' },
    { model = 'models/props_interiors/pot02a.mdl', category = 'Интерьер' },
    { model = 'models/props_c17/cashregister01a.mdl', category = 'Интерьер' },
    { model = 'models/props_c17/chair_kleiner03a.mdl', category = 'Интерьер' },
    { model = 'models/props_c17/chair_stool01a.mdl', category = 'Интерьер' },
    { model = 'models/props_c17/clock01.mdl', category = 'Интерьер' },
    { model = 'models/props_c17/computer01_keyboard.mdl', category = 'Интерьер' },
    { model = 'models/props_c17/doll01.mdl', category = 'Интерьер' },
    { model = 'models/props_c17/FurnitureToilet001a.mdl', category = 'Интерьер' },
    { model = 'models/props_c17/FurnitureSink001a.mdl', category = 'Интерьер' },
    { model = 'models/props_combine/breenchair.mdl', category = 'Интерьер' },
    { model = 'models/props_combine/breendesk.mdl', category = 'Интерьер' },
    { model = 'models/props_trainstation/bench_indoor001a.mdl', category = 'Интерьер' },
    { model = 'models/props_trainstation/traincar_seats001.mdl', category = 'Интерьер' },
    { model = 'models/props_lab/monitor01a.mdl', category = 'Интерьер' },
    { model = 'models/props/cs_assault/MoneyPallet.mdl', category = 'Интерьер' },
    { model = 'models/props/CS_militia/crate_extrasmallmill.mdl', category = 'Интерьер' },
    { model = 'models/props/CS_militia/dryer.mdl', category = 'Интерьер' },
    { model = 'models/props/CS_militia/gun_cabinet.mdl', category = 'Интерьер' },
    { model = 'models/props/CS_militia/haybale_target.mdl', category = 'Интерьер' },
    { model = 'models/props/CS_militia/haybale_target_02.mdl', category = 'Интерьер' },
    { model = 'models/props/CS_militia/haybale_target_03.mdl', category = 'Интерьер' },
    { model = 'models/props/CS_militia/toilet.mdl', category = 'Интерьер' },
    { model = 'models/props/cs_office/coffee_mug3.mdl', category = 'Интерьер' },
    { model = 'models/props/cs_office/computer.mdl', category = 'Интерьер' },
    { model = 'models/props/cs_office/computer_keyboard.mdl', category = 'Интерьер' },
    { model = 'models/props/cs_office/computer_mouse.mdl', category = 'Интерьер' },
    { model = 'models/props/cs_office/file_cabinet1.mdl', category = 'Интерьер' },
    { model = 'models/props/cs_office/file_cabinet1_group.mdl', category = 'Интерьер' },

    { model = 'models/props_c17/streetsign004e.mdl', category = 'Город' },
    { model = 'models/props_c17/streetsign004f.mdl', category = 'Город' },
    { model = 'models/props_junk/TrashDumpster01a.mdl', category = 'Город' },
    { model = 'models/props_trainstation/trashcan_indoor001a.mdl', category = 'Город' },
    { model = 'models/props_trainstation/trashcan_indoor001b.mdl', category = 'Город' },
    { model = 'models/props_wasteland/barricade002a.mdl', category = 'Город' },
    { model = 'models/props_wasteland/barricade001a.mdl', category = 'Город' },
    { model = 'models/props_c17/concrete_barrier001a.mdl', category = 'Город' },
    { model = 'models/props/cs_assault/pylon.mdl', category = 'Город' },
    { model = 'models/props_c17/streetsign001c.mdl', category = 'Город' },
    { model = 'models/props_c17/streetsign002b.mdl', category = 'Город' },
    { model = 'models/props_junk/garbage256_composite001a.mdl', category = 'Город' },
    { model = 'models/props_junk/TrafficCone001a.mdl', category = 'Город' },
    { model = 'models/props_junk/TrashBin01a.mdl', category = 'Город' },
    { model = 'models/props_vehicles/tire001c_car.mdl', category = 'Город' },
    { model = 'models/props_vehicles/tire001b_truck.mdl', category = 'Город' },
    { model = 'models/props_c17/gravestone003a.mdl', category = 'Город' },
    { model = 'models/props_c17/gravestone002a.mdl', category = 'Город' },
    { model = 'models/props_junk/CinderBlock01a.mdl', category = 'Город' },

    { model = 'models/hunter/blocks/cube025x025x025.mdl', category = 'Пластик' },
    { model = 'models/hunter/blocks/cube025x05x025.mdl', category = 'Пластик' },
    { model = 'models/hunter/blocks/cube025x075x025.mdl', category = 'Пластик' },
    { model = 'models/hunter/blocks/cube025x150x025.mdl', category = 'Пластик' },
    { model = 'models/hunter/blocks/cube025x2x025.mdl', category = 'Пластик' },
    { model = 'models/hunter/blocks/cube025x3x025.mdl', category = 'Пластик' },
    { model = 'models/hunter/blocks/cube025x5x025.mdl', category = 'Пластик' },
    { model = 'models/hunter/blocks/cube025x7x025.mdl', category = 'Пластик' },
    { model = 'models/hunter/blocks/cube05x05x025.mdl', category = 'Пластик' },
    { model = 'models/hunter/blocks/cube05x075x025.mdl', category = 'Пластик' },
    { model = 'models/hunter/blocks/cube05x1x025.mdl', category = 'Пластик' },
    { model = 'models/hunter/blocks/cube05x2x025.mdl', category = 'Пластик' },
    { model = 'models/hunter/blocks/cube05x4x025.mdl', category = 'Пластик' },
    { model = 'models/hunter/blocks/cube05x6x025.mdl', category = 'Пластик' },
    { model = 'models/hunter/blocks/cube05x05x05.mdl', category = 'Пластик' },
    { model = 'models/hunter/blocks/cube05x1x05.mdl', category = 'Пластик' },
    { model = 'models/hunter/blocks/cube05x105x05.mdl', category = 'Пластик' },
    { model = 'models/hunter/blocks/cube05x3x05.mdl', category = 'Пластик' },
    { model = 'models/hunter/blocks/cube05x4x05.mdl', category = 'Пластик' },
    { model = 'models/hunter/blocks/cube05x5x05.mdl', category = 'Пластик' },
    { model = 'models/hunter/blocks/cube05x7x05.mdl', category = 'Пластик' },
    { model = 'models/hunter/blocks/cube05x8x05.mdl', category = 'Пластик' },
    { model = 'models/hunter/blocks/cube075x075x025.mdl', category = 'Пластик' },
    { model = 'models/hunter/blocks/cube075x2x025.mdl', category = 'Пластик' },
    { model = 'models/hunter/blocks/cube075x4x025.mdl', category = 'Пластик' },
    { model = 'models/hunter/blocks/cube075x8x025.mdl', category = 'Пластик' },
    { model = 'models/hunter/blocks/cube075x075x075.mdl', category = 'Пластик' },
    { model = 'models/hunter/blocks/cube075x1x075.mdl', category = 'Пластик' },
    { model = 'models/hunter/blocks/cube075x2x075.mdl', category = 'Пластик' },
    { model = 'models/hunter/blocks/cube075x4x075.mdl', category = 'Пластик' },
    { model = 'models/hunter/blocks/cube075x5x075.mdl', category = 'Пластик' },
    { model = 'models/hunter/blocks/cube075x6x075.mdl', category = 'Пластик' },
    { model = 'models/hunter/blocks/cube075x7x075.mdl', category = 'Пластик' },
    { model = 'models/hunter/blocks/cube075x8x075.mdl', category = 'Пластик' },
    { model = 'models/hunter/blocks/cube075x1x1.mdl', category = 'Пластик' },
    { model = 'models/hunter/blocks/cube1x1x025.mdl', category = 'Пластик' },
    { model = 'models/hunter/blocks/cube1x1x05.mdl', category = 'Пластик' },
    { model = 'models/hunter/blocks/cube1x1x1.mdl', category = 'Пластик' },
    { model = 'models/hunter/blocks/cube1x150x1.mdl', category = 'Пластик' },
    { model = 'models/hunter/blocks/cube1x2x025.mdl', category = 'Пластик' },
    { model = 'models/hunter/blocks/cube125x125x025.mdl', category = 'Пластик' },
    { model = 'models/hunter/blocks/cube2x2x025.mdl', category = 'Пластик' },
    { model = 'models/hunter/blocks/cube150x150x025.mdl', category = 'Пластик' },
    { model = 'models/hunter/blocks/cube2x3x025.mdl', category = 'Пластик' },
    { model = 'models/hunter/blocks/cube2x4x025.mdl', category = 'Пластик' },
    { model = 'models/hunter/blocks/cube4x6x025.mdl', category = 'Пластик' },
    { model = 'models/hunter/blocks/cube8x8x025.mdl', category = 'Пластик' },
    { model = 'models/hunter/blocks/cube8x8x025.mdl', category = 'Пластик' },
    { model = 'models/hunter/plates/plate025.mdl', category = 'Пластик' },
    { model = 'models/hunter/plates/plate05.mdl', category = 'Пластик' },
    { model = 'models/hunter/plates/plate075.mdl', category = 'Пластик' },
    { model = 'models/hunter/plates/plate1.mdl', category = 'Пластик' },
    { model = 'models/hunter/plates/plate1x6.mdl', category = 'Пластик' },
    { model = 'models/hunter/plates/plate125.mdl', category = 'Пластик' },
    { model = 'models/hunter/plates/plate150.mdl', category = 'Пластик' },
    { model = 'models/hunter/plates/plate175.mdl', category = 'Пластик' },
    { model = 'models/hunter/plates/plate025x025.mdl', category = 'Пластик' },
    { model = 'models/hunter/plates/plate025x05.mdl', category = 'Пластик' },
    { model = 'models/hunter/plates/plate025x075.mdl', category = 'Пластик' },
    { model = 'models/hunter/plates/plate025x1.mdl', category = 'Пластик' },
    { model = 'models/hunter/plates/plate025x125.mdl', category = 'Пластик' },
    { model = 'models/hunter/plates/plate05x05.mdl', category = 'Пластик' },
    { model = 'models/hunter/plates/plate05x075.mdl', category = 'Пластик' },
    { model = 'models/hunter/plates/plate05x1.mdl', category = 'Пластик' },
    { model = 'models/hunter/plates/plate05x3.mdl', category = 'Пластик' },
    { model = 'models/hunter/plates/plate05x2.mdl', category = 'Пластик' },
    { model = 'models/hunter/plates/plate075x075.mdl', category = 'Пластик' },
    { model = 'models/hunter/plates/plate075x1.mdl', category = 'Пластик' },
    { model = 'models/hunter/plates/plate075x105.mdl', category = 'Пластик' },
    { model = 'models/hunter/plates/plate075x2.mdl', category = 'Пластик' },
    { model = 'models/hunter/plates/plate075x3.mdl', category = 'Пластик' },
    { model = 'models/hunter/plates/plate075x4.mdl', category = 'Пластик' },
    { model = 'models/hunter/plates/plate1x1.mdl', category = 'Пластик' },
    { model = 'models/hunter/plates/plate1x2.mdl', category = 'Пластик' },
    { model = 'models/hunter/plates/plate1x3.mdl', category = 'Пластик' },
    { model = 'models/hunter/plates/plate1x4.mdl', category = 'Пластик' },
    { model = 'models/hunter/plates/plate3x3.mdl', category = 'Пластик' },
    { model = 'models/hunter/plates/plate3x4.mdl', category = 'Пластик' },
    { model = 'models/hunter/plates/plate3x8.mdl', category = 'Пластик' },
    { model = 'models/hunter/plates/plate4x4.mdl', category = 'Пластик' },
    { model = 'models/hunter/plates/plate4x6.mdl', category = 'Пластик' },
    { model = 'models/hunter/plates/plate4x7.mdl', category = 'Пластик' },
    { model = 'models/hunter/plates/plate4x8.mdl', category = 'Пластик' },
    { model = 'models/hunter/plates/plate5x5.mdl', category = 'Пластик' },
    { model = 'models/hunter/plates/plate5x6.mdl', category = 'Пластик' },
    { model = 'models/hunter/plates/plate5x7.mdl', category = 'Пластик' },
    { model = 'models/hunter/plates/plate5x8.mdl', category = 'Пластик' },
    { model = 'models/hunter/plates/plate7x7.mdl', category = 'Пластик' },
    { model = 'models/hunter/triangles/025x025.mdl', category = 'Пластик' },
    { model = 'models/hunter/triangles/025x025mirrored.mdl', category = 'Пластик' },
    { model = 'models/hunter/triangles/05x05.mdl', category = 'Пластик' },
    { model = 'models/hunter/triangles/05x05mirrored.mdl', category = 'Пластик' },
    { model = 'models/hunter/triangles/075x075.mdl', category = 'Пластик' },
    { model = 'models/hunter/triangles/075x075mirrored.mdl', category = 'Пластик' },
    { model = 'models/hunter/triangles/1x1.mdl', category = 'Пластик' },
    { model = 'models/hunter/plates/tri1x1.mdl', category = 'Пластик' },
    { model = 'models/hunter/triangles/1x1mirrored.mdl', category = 'Пластик' },
    { model = 'models/hunter/triangles/05x05x05.mdl', category = 'Пластик' },
    { model = 'models/hunter/triangles/1x1x1.mdl', category = 'Пластик' },
    { model = 'models/hunter/triangles/1x05x1.mdl', category = 'Пластик' },
    { model = 'models/hunter/triangles/1x1x3.mdl', category = 'Пластик' },
    { model = 'models/hunter/triangles/2x2.mdl', category = 'Пластик' },
    { model = 'models/hunter/triangles/2x2mirrored.mdl', category = 'Пластик' },
    { model = 'models/hunter/triangles/3x3.mdl', category = 'Пластик' },
    { model = 'models/hunter/triangles/3x3mirrored.mdl', category = 'Пластик' },
    { model = 'models/hunter/triangles/4x4.mdl', category = 'Пластик' },
    { model = 'models/hunter/misc/squarecap1x1x1.mdl', category = 'Пластик' },
    { model = 'models/hunter/tubes/circle2x2.mdl', category = 'Пластик' },
    { model = 'models/hunter/tubes/circle2x2b.mdl', category = 'Пластик' },
    { model = 'models/hunter/tubes/circle2x2c.mdl', category = 'Пластик' },
    { model = 'models/hunter/tubes/circle2x2d.mdl', category = 'Пластик' },
    { model = 'models/hunter/tubes/circle4x4b.mdl', category = 'Пластик' },
    { model = 'models/hunter/tubes/circle4x4b.mdl', category = 'Пластик' },
    { model = 'models/hunter/tubes/circle4x4c.mdl', category = 'Пластик' },
    { model = 'models/hunter/tubes/circle4x4d.mdl', category = 'Пластик' },
    { model = 'models/hunter/tubes/tube1x1x1.mdl', category = 'Пластик' },
    { model = 'models/hunter/tubes/tube1x1x1b.mdl', category = 'Пластик' },
    { model = 'models/hunter/tubes/tube1x1x1c.mdl', category = 'Пластик' },
    { model = 'models/hunter/tubes/tube1x1x2.mdl', category = 'Пластик' },
    { model = 'models/hunter/tubes/tube1x1x1d.mdl', category = 'Пластик' },
    { model = 'models/hunter/tubes/tube1x1x2b.mdl', category = 'Пластик' },
    { model = 'models/hunter/tubes/tube1x1x2d.mdl', category = 'Пластик' },
    { model = 'models/hunter/tubes/tube1x1x3.mdl', category = 'Пластик' },
    { model = 'models/hunter/tubes/tube1x1x3c.mdl', category = 'Пластик' },
    { model = 'models/hunter/tubes/tube1x1x3d.mdl', category = 'Пластик' },
    { model = 'models/hunter/tubes/tube1x1x4.mdl', category = 'Пластик' },
    { model = 'models/hunter/tubes/tube1x1x4c.mdl', category = 'Пластик' },
    { model = 'models/hunter/tubes/tube1x1x5.mdl', category = 'Пластик' },
    { model = 'models/hunter/tubes/tube1x1x5c.mdl', category = 'Пластик' },
    { model = 'models/hunter/tubes/tube1x1x8.mdl', category = 'Пластик' },
    { model = 'models/hunter/tubes/tube2x2x1.mdl', category = 'Пластик' },

    { model = 'models/props_phx/construct/metal_plate1.mdl', category = 'Металл' },
    { model = 'models/props_phx/construct/metal_plate1_tri.mdl', category = 'Металл' },
    { model = 'models/props_phx/construct/metal_plate1x2.mdl', category = 'Металл' },
    { model = 'models/props_phx/construct/metal_plate1x2_tri.mdl', category = 'Металл' },
    { model = 'models/props_phx/construct/metal_plate2x4.mdl', category = 'Металл' },
    { model = 'models/props_phx/construct/metal_plate2x4_tri.mdl', category = 'Металл' },
    { model = 'models/props_phx/construct/metal_plate4x4.mdl', category = 'Металл' },
    { model = 'models/props_phx/construct/metal_plate4x4_tri.mdl', category = 'Металл' },
    { model = 'models/props_phx/construct/metal_tube.mdl', category = 'Металл' },
    { model = 'models/props_phx/construct/metal_tubex2.mdl', category = 'Металл' },
    { model = 'models/props_phx/construct/metal_angle360.mdl', category = 'Металл' },
    { model = 'models/props_phx/construct/metal_angle180.mdl', category = 'Металл' },
    { model = 'models/props_phx/construct/metal_angle90.mdl', category = 'Металл' },
    { model = 'models/props_phx/construct/metal_plate_curve360.mdl', category = 'Металл' },
    { model = 'models/props_phx/construct/metal_plate_curve180.mdl', category = 'Металл' },
    { model = 'models/props_phx/construct/metal_plate_curve360x2.mdl', category = 'Металл' },
    { model = 'models/props_phx/construct/metal_plate_curve180x2.mdl', category = 'Металл' },
    { model = 'models/props_phx/construct/metal_dome360.mdl', category = 'Металл' },
    { model = 'models/props_phx/construct/metal_dome180.mdl', category = 'Металл' },
    { model = 'models/phxtended/tri1x1solid.mdl', category = 'Металл' },
    { model = 'models/phxtended/bar1x.mdl', category = 'Металл' },
    { model = 'models/phxtended/bar2x.mdl', category = 'Металл' },
    { model = 'models/props_phx/construct/metal_wire1x1.mdl', category = 'Металл' },
    { model = 'models/props_phx/construct/metal_wire1x1x1.mdl', category = 'Металл' },
    { model = 'models/props_phx/construct/metal_wire1x2b.mdl', category = 'Металл' },
    { model = 'models/props_phx/construct/metal_wire1x2.mdl', category = 'Металл' },
    { model = 'models/props_phx/construct/metal_wire1x1x2b.mdl', category = 'Металл' },
    { model = 'models/props_phx/construct/metal_wire2x2x2b.mdl', category = 'Металл' },
    { model = 'models/props_phx/construct/metal_wire_angle360x1.mdl', category = 'Металл' },
    { model = 'models/props_phx/construct/metal_wire_angle180x1.mdl', category = 'Металл' },

    { model = 'models/props_phx/construct/glass/glass_plate1x1.mdl', category = 'Стекло' },
    { model = 'models/props_phx/construct/glass/glass_plate1x2.mdl', category = 'Стекло' },
    { model = 'models/props_phx/construct/glass/glass_plate2x2.mdl', category = 'Стекло' },
    { model = 'models/props_phx/construct/glass/glass_plate2x4.mdl', category = 'Стекло' },
    { model = 'models/props_phx/construct/glass/glass_plate4x4.mdl', category = 'Стекло' },
    { model = 'models/props_phx/construct/glass/glass_angle360.mdl', category = 'Стекло' },
    { model = 'models/props_phx/construct/glass/glass_angle180.mdl', category = 'Стекло' },
    { model = 'models/props_phx/construct/glass/glass_curve360x1.mdl', category = 'Стекло' },
    { model = 'models/props_phx/construct/glass/glass_curve180x1.mdl', category = 'Стекло' },
    { model = 'models/props_phx/construct/glass/glass_dome360.mdl', category = 'Стекло' },

    { model = 'models/props_phx/construct/windows/window1x1.mdl', category = 'Окна' },
    { model = 'models/props_phx/construct/windows/window1x2.mdl', category = 'Окна' },
    { model = 'models/props_phx/construct/windows/window2x2.mdl', category = 'Окна' },
    { model = 'models/props_phx/construct/windows/window2x4.mdl', category = 'Окна' },
    { model = 'models/props_phx/construct/windows/window4x4.mdl', category = 'Окна' },
    { model = 'models/props_phx/construct/windows/window_angle360.mdl', category = 'Окна' },
    { model = 'models/props_phx/construct/windows/window_angle180.mdl', category = 'Окна' },
    { model = 'models/props_phx/construct/windows/window_curve360x1.mdl', category = 'Окна' },
    { model = 'models/props_phx/construct/windows/window_curve180x1.mdl', category = 'Окна' },
    { model = 'models/props_phx/construct/windows/window_dome360.mdl', category = 'Окна' },
    { model = 'models/props_phx/construct/windows/window_dome180.mdl', category = 'Окна' },

    { model = 'models/halloween2015/hay_block.mdl', category = 'Halloween' },
    { model = 'models/halloween2015/hay_block_tower.mdl', category = 'Halloween' },
    { model = 'models/halloween2015/pumbkin_l_f00.mdl', category = 'Halloween' },
    { model = 'models/halloween2015/pumbkin_l_f01.mdl', category = 'Halloween' },
    { model = 'models/halloween2015/pumbkin_l_f02.mdl', category = 'Halloween' },
    { model = 'models/halloween2015/pumbkin_n_f00.mdl', category = 'Halloween' },
    { model = 'models/halloween2015/pumbkin_n_f01.mdl', category = 'Halloween' },
    { model = 'models/halloween2015/pumbkin_n_f02.mdl', category = 'Halloween' },
    { model = 'models/zerochain/props_fairground/gamesign_01.mdl', category = 'Halloween' },
    { model = 'models/zerochain/props_firework/fireworkbox_01.mdl', category = 'Halloween' },
    { model = 'models/zerochain/props_halloween/bonbon01.mdl', category = 'Halloween' },
    { model = 'models/zerochain/props_halloween/gravestone01.mdl', category = 'Halloween' },
    { model = 'models/zerochain/props_halloween/gravestone02.mdl', category = 'Halloween' },
    { model = 'models/zerochain/props_halloween/mexicanskull.mdl', category = 'Halloween' },
    { model = 'models/zerochain/props_halloween/oldcoffin.mdl', category = 'Halloween' },
    { model = 'models/zerochain/props_industrial/robotic_saw.mdl', category = 'Halloween' },
    { model = 'models/zerochain/props_halloween/witchcauldron.mdl', category = 'Halloween' },
    { model = 'models/halloween/alchtable.mdl', category = 'Halloween' },
    { model = 'models/halloween/archtop.mdl', category = 'Halloween' },
    { model = 'models/halloween/barrel_hlw.mdl', category = 'Halloween' },
    { model = 'models/halloween/candle.mdl', category = 'Halloween' },
    { model = 'models/halloween/cauldron.mdl', category = 'Halloween' },
    { model = 'models/halloween/cauldron2.mdl', category = 'Halloween' },
    { model = 'models/halloween/coffin_1.mdl', category = 'Halloween' },
    { model = 'models/halloween/cratesmall.mdl', category = 'Halloween' },
    { model = 'models/halloween/darktable.mdl', category = 'Halloween' },
    { model = 'models/halloween/dragon_hlw.mdl', category = 'Halloween' },
    { model = 'models/halloween/facetree.mdl', category = 'Halloween' },
    { model = 'models/halloween/fencelp.mdl', category = 'Halloween' },
    { model = 'models/halloween/gargouillestatue.mdl', category = 'Halloween' },
    { model = 'models/halloween/ghoultomb.mdl', category = 'Halloween' },
    { model = 'models/halloween/gate.mdl', category = 'Halloween' },
    { model = 'models/halloween/head_deco_1.mdl', category = 'Halloween' },
    { model = 'models/halloween/helltower.mdl', category = 'Halloween' },
    { model = 'models/halloween/horrorbook.mdl', category = 'Halloween' },
    { model = 'models/halloween/house.mdl', category = 'Halloween' },
    { model = 'models/halloween/lustre_1.mdl', category = 'Halloween' },
    { model = 'models/halloween/pumpkin4.mdl', category = 'Halloween' },
    { model = 'models/halloween/ufodeco.mdl', category = 'Halloween' },
    { model = 'models/vending_machine/elitehunterzmachine.mdl', category = 'Halloween' }, --

    { model = 'models/models_kit/xmas/xmastree_mini.mdl', category = 'Christmas 2025' },
    { model = 'models/models_kit/xmas/xmastree.mdl', category = 'Christmas 2025' },
    { model = 'models/grinchfox/foliage/christmastree.mdl', category = 'Christmas 2025' },
    { model = 'models/models_kit/xmas/giftbox_nano.mdl', category = 'Christmas 2025' },
    { model = 'models/griim/christmas/present_colourable.mdl', category = 'Christmas 2025' },
    { model = 'models/christmas_gift_boxes/christmas_gift_box_1.mdl', category = 'Christmas 2025' },
    { model = 'models/christmas_gift_boxes/christmas_gift_box_2.mdl', category = 'Christmas 2025' },
    { model = 'models/christmas_gift_boxes/christmas_gift_box_3.mdl', category = 'Christmas 2025' },
    { model = 'models/christmas_gift_boxes/christmas_gift_box_4.mdl', category = 'Christmas 2025' },
    { model = 'models/christmas_gift_boxes/snow_reindeer_box.mdl', category = 'Christmas 2025' },
    { model = 'models/christmas_gift_boxes/snow_reindeer_box_(box).mdl', category = 'Christmas 2025' },
    { model = 'models/christmas_gift_boxes/snow_reindeer_box_(top).mdl', category = 'Christmas 2025' },
}