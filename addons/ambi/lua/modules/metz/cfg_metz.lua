Ambi.General.CreateModule( 'Metz' )

-- ---------------------------------------------------------------------------------------------------------------------------------------
Ambi.Metz.Config.draw_distance = 360 -- Дистанция отрисовки

-- ---------------------------------------------------------------------------------------------------------------------------------------
Ambi.Metz.Config.stove_consumption = 1 -- Stove consumption on heat amount.
Ambi.Metz.Config.stove_heat = 1 -- Stove heat amount.
Ambi.Metz.Config.stove_gas_storage = 600 -- Amount of gas inside.
Ambi.Metz.Config.stove_gas_storage_max = 600
Ambi.Metz.Config.stove_can_gravity_gun = true -- Can grab with gravity gun?
Ambi.Metz.Config.stove_can_take_damage = true -- Плита может принимать дамаг?
Ambi.Metz.Config.stove_explode_after_destruction = false -- Плита должна взорваться после уничтожения?
Ambi.Metz.Config.stove_health = 600
Ambi.Metz.Config.stove_health_max = 600
Ambi.Metz.Config.stove_model = 'models/props_c17/furnitureStove001a.mdl'
Ambi.Metz.Config.stove_explosion_damage = 100
Ambi.Metz.Config.stove_smoke_color = Color( 184, 184, 184 )
Ambi.Metz.Config.stove_indicator_color = Color( 144, 250, 180)

-- ---------------------------------------------------------------------------------------------------------------------------------------
Ambi.Metz.Config.gas_model = 'models/props_c17/canister01a.mdl' -- Путь к модельке
Ambi.Metz.Config.gas_amount = 600
Ambi.Metz.Config.gas_health = 60
Ambi.Metz.Config.gas_can_take_damage = true -- Может принимать дамаг?
Ambi.Metz.Config.gas_explode_after_destruction = false -- Должна взорваться после уничтожения?
Ambi.Metz.Config.gas_explosion_damage = 60
Ambi.Metz.Config.gas_indicator_color = Color( 255, 255, 255)
Ambi.Metz.Config.gas_text_color = Color( 235, 240, 76)

-- ---------------------------------------------------------------------------------------------------------------------------------------
Ambi.Metz.Config.pot_model = 'models/props_interiors/pot02a.mdl' -- Путь к модельке
Ambi.Metz.Config.pot_health = 60 -- Здоровье
Ambi.Metz.Config.pot_can_take_damage = true -- Может принимать дамаг?
Ambi.Metz.Config.pot_start_time = 70 -- Pot default time.
Ambi.Metz.Config.pot_macid_add_time = 20 -- Default time, which will be added to pot on collision with Muriatic Acid.
Ambi.Metz.Config.pot_sulfur_add_time = 20 -- Default time, which will be added to pot on collision with Liquid Sulfur.
Ambi.Metz.Config.pot_sulfur_max = 5 -- Максимальное количество сульфура
Ambi.Metz.Config.pot_macid_max = 10 -- Максимальное количество соляной кислоты

-- ---------------------------------------------------------------------------------------------------------------------------------------
Ambi.Metz.Config.iodine_jar_model = 'models/props_lab/jar01a.mdl'
Ambi.Metz.Config.iodine_jar_material = 'models/shiny'
Ambi.Metz.Config.iodine_jar_color = Color( 255, 127, 127, 255 )
Ambi.Metz.Config.iodine_jar_health = 60 -- Здоровье
Ambi.Metz.Config.iodine_jar_can_take_damage = true -- Может принимать дамаг?
Ambi.Metz.Config.iodine_jar_water_max = 10
Ambi.Metz.Config.iodine_jar_liquid_iodine_max = 10

-- ---------------------------------------------------------------------------------------------------------------------------------------
Ambi.Metz.Config.final_pot_model = 'models/props_c17/metalPot001a.mdl' -- Время готовки
Ambi.Metz.Config.final_pot_material = 'models/debug/debugwhite' -- Время готовки
Ambi.Metz.Config.final_pot_color = Color( 127, 255, 0, 255 ) -- Время готовки
Ambi.Metz.Config.final_pot_health = 60 -- Время готовки
Ambi.Metz.Config.final_pot_can_take_damage = true -- Время готовки
Ambi.Metz.Config.final_pot_red_phosphorus_max = 20 -- Максимальное количество Красного Фосфора
Ambi.Metz.Config.final_pot_crystal_iodine_max = 10 -- Максимальное количество Кристаллического Йода
Ambi.Metz.Config.final_pot_red_phosphorus_add_time = 15 -- Добавление секунд к времени готовки (add time * количество Красного Фосфора)
Ambi.Metz.Config.final_pot_crystal_iodine_add_time = 15 -- Добавление секунд к времени готовки (add time * количество Кристаллического Йода)
Ambi.Metz.Config.final_pot_time = 60 -- Время готовки

-- ---------------------------------------------------------------------------------------------------------------------------------------
Ambi.Metz.Config.ingredient_sulfur_model = 'models/props_lab/jar01b.mdl'
Ambi.Metz.Config.ingredient_sulfur_amount = 1
Ambi.Metz.Config.ingredient_sulfur_color = Color(243, 213, 19, 255)

Ambi.Metz.Config.ingredient_muratic_acid_model = 'models/props_junk/garbage_plasticbottle001a.mdl'
Ambi.Metz.Config.ingredient_muratic_acid_amount = 1
Ambi.Metz.Config.ingredient_muratic_acid_color = Color(160, 221, 99, 255)

Ambi.Metz.Config.ingredient_liquid_iodine_model = 'models/props_lab/jar01b.mdl'
Ambi.Metz.Config.ingredient_liquid_iodine_amount = 1
Ambi.Metz.Config.ingredient_liquid_iodine_color = Color(137, 69, 54, 255)

Ambi.Metz.Config.ingredient_water_model = 'models/props_junk/garbage_plasticbottle003a.mdl'
Ambi.Metz.Config.ingredient_water_amount = 1
Ambi.Metz.Config.ingredient_water_color = Color(133, 202, 219, 255)

Ambi.Metz.Config.ingredient_red_phosphor_model = 'models/props_junk/rock001a.mdl'
Ambi.Metz.Config.ingredient_red_phosphor_material = 'models/props_pipes/GutterMetal01a'
Ambi.Metz.Config.ingredient_red_phosphor_color = Color(180, 43, 28)

Ambi.Metz.Config.ingredient_crystal_iodine_model = 'models/props_junk/rock001a.mdl'
Ambi.Metz.Config.ingredient_crystal_iodine_material = 'models/props_c17/FurnitureMetal001a'
Ambi.Metz.Config.ingredient_crystal_iodine_color = Color( 255, 223, 127, 255 )

Ambi.Metz.Config.ingredient_metz_model = 'models/props_junk/rock001a.mdl'
Ambi.Metz.Config.ingredient_metz_material = 'models/debug/debugwhite'

-- ---------------------------------------------------------------------------------------------------------------------------------------
Ambi.Metz.Config.buyer_model = 'models/humans/group01/male_09.mdl'
Ambi.Metz.Config.buyer_name = 'Таинственный покупатель'
Ambi.Metz.Config.buyer_show_name = true
Ambi.Metz.Config.buyer_modifier = 800 -- Модификатор по заработку: M * Кол-во Метза = Итоговую сумму денег [НЕ СТАВЬТЕ ЕГО 0, ЕСЛИ ОН ВАМ НЕ НУЖЕН ПОСТАВЬТЕ 1]
Ambi.Metz.Config.buyer_can_to_pay = true -- Покупатель должен выплатить деньги [РАБОТАЕТ ТОЛЬКО С НОВЫМ DarkRP]
Ambi.Metz.Config.buyer_phrases_on_buy_metz = {
	'Афигеть!',
	'Чел, вари ещё и приходи обратно!',
	'Аааа... Держи деньги',
}
Ambi.Metz.Config.buyer_sounds_on_buy_metz = {
	'vo/npc/male01/yeah02.wav',
	'vo/npc/male01/finally.wav',
	'vo/npc/male01/oneforme.wav',
}