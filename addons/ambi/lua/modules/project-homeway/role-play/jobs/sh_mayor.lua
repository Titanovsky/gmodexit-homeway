local C = Ambi.Packages.Out( 'colors' )
local AddJob = Ambi.DarkRP.AddJob
local SimpleAddJob = Ambi.DarkRP.SimpleAddJob

local WEAPONS_MAYOR = {
    'unarrest_stick',
    'stunstick',
}

-- ----------------------------------------------------------------------------------------------------------------------------
local CATEGORY = 'Мэрия'

AddJob( 'j_bodyguard', {
    name = 'Телохранитель Мэра', 
    category = CATEGORY, 
    description = 'Это специалист по обеспечению личной безопасности высокопрофильного должностного лица. Он несет ответственность за защиту мэра во время официальных мероприятий и в повседневной жизни, предотвращая возможные угрозы и риски. Работа телохранителя требует не только физической подготовки и навыков экстренного реагирования, но и способности быстро оценивать ситуации и принимать решения в условиях стресса. Важно также умение работать в команде и координироваться с другими службами безопасности. Телохранитель мэра должен быть предельно внимательным и проницательным, чтобы гарантировать безопасность своего подопечного и минимизировать риски.', 
    color = C.FLAT_DARK_RED, 
    max = 2, 
    demote_after_death = true, 
    weapons = {
        'stunstick',
    },
    salary = 200,
    spawns = Ambi.Homeway.Config.default_spawns,
    models = { 'models/player/combine_soldier_prisonguard.mdl' },
} )

AddJob( 'j_clerk', { 
    name = 'Секретарь', 
    category = CATEGORY, 
    description = 'Это ключевой сотрудник в администрации города, ответственный за организацию рабочего процесса мэра и управление документацией. Он выполняет функции, связанные с планированием встреч, координацией мероприятий и подготовкой отчетов. Секретарь взаимодействует с другими должностными лицами, представителями общественности и СМИ, обеспечивая эффективную коммуникацию и информационную поддержку. Эта роль требует высоких организационных навыков, умения работать в условиях многозадачности и внимательности к деталям. Секретарь мэра также часто выступает доверенным лицом, обладая доступом к конфиденциальной информации и принимая участие в принятии важных решений.', 
    color = C.FLAT_DARK_RED, 
    max = 2, 
    demote_after_death = true, 
    weapons = WEAPONS_MAYOR,
    salary = 350,
    models = { 'models/characters/gallaha.mdl' },
    spawns = Ambi.Homeway.Config.default_spawns,
    time = 20,
} )

AddJob( 'j_mayor', { 
    name = 'Мэр', 
    command = 'mayor', 
    category = CATEGORY, 
    description = 'Мэр — это высокопоставленный должностное лицо, представляющее исполнительную власть в муниципалитете или городе. Он отвечает за управление городскими службами, разработку и реализацию политики, а также за представление интересов граждан на местном уровне. Мэр координирует работу различных департаментов, контролирует бюджет и принимает решения, касающиеся социально-экономического развития региона. Эта роль требует отличных лидерских качеств, навыков коммуникации и способности реагировать на текущие проблемы, с которыми сталкиваются жители города. Мэр также может выступать посредником между общественностью и государственными структурами, стремясь обеспечивать прозрачность и вовлеченность граждан в управление.', 
    color = C.FLAT_DARK_RED, 
    max = 1, 
    demote_after_death = true, 
    mayor = true,
    weapons = WEAPONS_MAYOR,
    vote = true,
    salary = 1000,
    models = { 'models/player/breen.mdl' },
    time = 60 * 1,
    god_time = Ambi.Homeway.Config.mayor_god_time,

    PlayerDeath = function( ePly ) 
        Ambi.Homeway.NotifyAll( 'Мэр погиб!', 15 )

        Ambi.DarkRP.SetLockdown( false )
    end,

    PlayerSpawn = function( ePly )
        Ambi.DarkRP.SetLockdown( false )
    end,

    PlayerDisconnected = function( ePly )
        Ambi.Homeway.NotifyAll( 'Мэр покинул город', 15 )

        Ambi.DarkRP.SetLockdown( false )
    end,

    spawns = {
        { map = 'rp_bangclaw', pos = Vector( 1111, 1933, 133 ), ang = Angle( 0, 0, 0 ) },
    },
} )