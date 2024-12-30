local C = Ambi.Packages.Out( 'colors' )
local AddJob = Ambi.DarkRP.AddJob
local SimpleAddJob = Ambi.DarkRP.SimpleAddJob

local MODEL_GANGS = {
    'models/player/Group03/male_04.mdl',
    'models/player/Group03/male_02.mdl',
    'models/player/Group03/male_03.mdl',
    'models/player/Group03/male_01.mdl',
    'models/player/Group03/male_05.mdl',
    'models/player/Group03/male_06.mdl',
    'models/player/Group03/male_07.mdl',
    'models/player/Group03/male_08.mdl',
    'models/player/Group03/male_09.mdl'
}

-- ----------------------------------------------------------------------------------------------------------------------------
local CATEGORY = 'Бандиты'

AddJob( 'j_gang1', {
    crime = true,
    name = 'Бандит', 
    models = MODEL_GANGS,
    max = 6,
    category = CATEGORY,
    salary = 225,
    weapons = { 'money_checker' },
    color = Color(3, 64, 31),
    spawns = Ambi.Homeway.Config.default_spawns,
    description = 'Бандит — термин, который чаще всего ассоциируется с преступностью, но в определенных контекстах можно рассмотреть его в другом свете. В некоторых обществax и культурах бандиты могут восприниматься как люди, которые борются с системой или защищают своих близких, особенно если закон сам по себе проявляет несправедливость. В рамках таких сообществ некоторые бандиты могут выступать как своеобразные "народные герои", которые помогают угнетённым или защищают свою территорию от внешних угроз. Они могут устанавливать собственные правила и нормы, которые поддерживают порядок в их окружении, даже если действуют вне закона. Тем не менее, важно помнить, что даже в этом более позитивном свете бандитские действия все же часто соприкасаются с опасностями и рисками, как для самих участников, так и для общества в целом.', 
} )

AddJob( 'j_gang_spec', { 
    crime = true,
    name = 'Рецидивист', 
    models = MODEL_GANGS,
    max = 4,
    is_vip = true,
    color = Color(3, 64, 31),
    weapons = {
        'arccw_bizon',
        'money_checker',
    },
    category = CATEGORY,
    salary = 225,
    spawns = Ambi.Homeway.Config.default_spawns,
    description = 'Рецидивист — это персонаж, который имеет богатое криминальное прошлое и продолжает заниматься незаконной деятельностью в мире DarkRP. Несмотря на свою репутацию, этот персонаж может быть интересным и многослойным, с собственными целями и моральными принципами.',  
} )

AddJob( 'j_gang_elit', { 
    crime = true,
    name = 'Авторитет', 
    models = { 'models/player/gman_high.mdl' },
    max = 1,
    is_premium = true,
    lifes = 5,
    color = Color(3, 64, 31),
    hours = 3,
    spawns = Ambi.Homeway.Config.default_spawns,
    weapons = {
        'arccw_deagle357',
        'money_checker',
    },
    category = CATEGORY,
    salary = 650,
    description = 'Авторитет — это уважаемая фигура в криминальном мире, обладающая значительным влиянием и опытом. Он устанавливает связи между различными группировками и служит средоточием решений, когда требуется переговорить или разрешить конфликт. Авторитет по достоинству ценят как за способности к ведению бизнеса, так и за твердое следование своей морали и правилам. Его голос имеет вес, а доверие, которое он вызывает, позволяет ему управлять многими аспектами преступной жизни. Благодаря своей харизме и жизненному опыту, Авторитет способен влиять на мнения и поступки других, гарантируя соблюдение договоренностей и партнерских обязательств.',  
} )