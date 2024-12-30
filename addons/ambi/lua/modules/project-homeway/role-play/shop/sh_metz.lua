local C = Ambi.Packages.Out( 'colors' )
local Add = Ambi.DarkRP.AddShopItem
local SimpleAddItem = Ambi.DarkRP.SimpleAddShopItem

-- ----------------------------------------------------------------------------------------------------------------------------
local CATEGORY = 'Metz' --

Add( 'stove', 
    {
        name = 'Плита',
        ent = 'metz_stove',
        model = 'models/props_c17/furniturestove001a.mdl',
        price = 10000,
        max = 1,
        allowed = { 'j_narko' },
        remove_after_set_job = true,
        
        category = CATEGORY
    }  
)

Add( 'gas', 
    {
        name = 'Газ',
        ent = 'metz_gas_cylinder',
        model = 'models/props_c17/canister01a.mdl',
        price = 3500,
        max = 2,
        allowed = { 'j_narko' },
        remove_after_set_job = true,
        
        category = CATEGORY
    }  
)

Add( 'jar', 
    {
        name = 'Банка для пластилина',
        ent = 'metz_iodine_jar',
        model = 'models/props_lab/jar01a.mdl',
        price = 500,
        max = 2,
        allowed = { 'j_narko' },
        remove_after_set_job = true,
        
        category = CATEGORY
    }  
)

Add( 'finalpot', 
    {
        name = 'Кастрюля',
        ent = 'metz_final_pot',
        model = 'models/props_c17/metalpot001a.mdl',
        price = 3500,
        max = 2,
        allowed = { 'j_narko' },
        remove_after_set_job = true,
        
        category = CATEGORY
    }  
)

Add( 'phosphorpot', 
    {
        name = 'Кастрюлька для Мэри',
        ent = 'metz_phosphor_pot',
        model = 'models/props_c17/metalpot001a.mdl',
        price = 1000, 
        max = 4,
        allowed = { 'j_narko' },
        remove_after_set_job = true,
        
        category = CATEGORY
    }  
)

Add( 'muraticacid', 
    {
        name = 'Спрайт',
        ent = 'metz_muratic_acid',
        model = 'models/props_junk/garbage_plasticbottle001a.mdl',
        price = 300,
        max = 5,
        allowed = { 'j_narko' },
        remove_after_set_job = true,
        
        category = CATEGORY
    }  
)

Add( 'water', 
    {
        name = 'Водичка',
        ent = 'metz_water',
        model = 'models/props_junk/garbage_plasticbottle003a.mdl',
        price = 300,
        max = 5,
        allowed = { 'j_narko' },
        remove_after_set_job = true,
        
        category = CATEGORY
    }  
)

Add( 'liquidsulfur', 
    {
        name = 'Мёд',
        ent = 'metz_sulfur',
        model = 'models/props_lab/jar01b.mdl',
        price = 300,
        max = 5,
        allowed = { 'j_narko' },
        remove_after_set_job = true,
        
        category = CATEGORY
    }  
)

Add( 'liquidiodine', 
    {
        name = 'Жидкий Пластилин',
        ent = 'metz_liquid_iodine',
        model = 'models/props_lab/jar01b.mdl',
        price = 300,
        max = 5,
        allowed = { 'j_narko' },
        remove_after_set_job = true,
        
        category = CATEGORY
    }  
)