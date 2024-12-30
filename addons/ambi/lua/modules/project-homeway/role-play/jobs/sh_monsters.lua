local C = Ambi.Packages.Out( 'colors' )
local AddJob = Ambi.DarkRP.AddJob
local SimpleAddJob = Ambi.DarkRP.SimpleAddJob

-- ----------------------------------------------------------------------------------------------------------------------------
local CATEGORY = 'Сверхи'

AddJob( 'j_yagami', { 
    name = 'Ягами Лайт', 
    category = CATEGORY, 
    description = 'Избавь город от преступности и построй свой собственный новый мир!', 
    color = Color(71, 71, 71),
    max = 1,
    demote = true,
    models = {'models/konnie/jumpforce/lightyagami.mdl'},
    weapons = {
        'death_note',
    },
    spawns = Ambi.Homeway.Config.default_spawns,
    is_premium = true,
    salary = 500,
} )

AddJob( 'j_scientist', { 
    name = 'Злой Учёный', 
    category = CATEGORY, 
    description = 'Создаёт разные вирусы', 
    color = Color(71, 71, 71),
    max = 3,
    demote = true,
    models = {'models/player/kleiner.mdl'},
    weapons = {
        'stunstick',
    },
    spawns = Ambi.Homeway.Config.default_spawns,
    --is_premium = true,
    salary = 0,
} )

AddJob( 'j_maniac', { 
    name = 'Маньяк', 
    category = CATEGORY, 
    description = 'Маньяк — это безжалостный и хитроумный преступник, который принимает активное участие в охоте на своих жертв, используя свои умения и логику, чтобы запугивать и устранять своих противников. Он играет в игру «кошки-мышки», и его основная цель — создать хаос и страдание в городе. Маньяк обладаем уникальными способностями, которые делают его опасным противником, но также привлекают внимание правоохранительных органов.', 
    color = Color(71, 71, 71),
    max = 4,
    demote = true,
    models = {'models/drarxangel/postal/gimp_2.mdl'},
    weapons = {
        'arccw_melee_knife',
    },
    spawns = Ambi.Homeway.Config.default_spawns,
    is_vip = true,
    salary = 200,
} )

AddJob( 'j_donate_shadow', { 
    name = 'Тень', 
    category = CATEGORY, 
    description = 'Тень — это безжалостный и хитроумный преступник, который принимает активное участие в охоте на своих жертв, используя свои умения и логику, чтобы запугивать и устранять своих противников. Он играет в игру «кошки-мышки», и его основная цель — создать хаос и страдание в городе. Маньяк обладаем уникальными способностями, которые делают его опасным противником, но также привлекают внимание правоохранительных органов.', 
    color = Color(71, 71, 71),
    max = 1,
    demote = true,
    models = {'models/raincoat.mdl'},
    whitelist_steamid = {
        [ 'STEAM_0:0:26183405' ] = true,
    },
    weapons = {
        'arccw_melee_knife',
        'gmod_camera',
        'weapon_deagle_bornbeast',
        'weapon_cuff_rope',
    },
    spawns = Ambi.Homeway.Config.default_spawns,
    salary = 0,
} )