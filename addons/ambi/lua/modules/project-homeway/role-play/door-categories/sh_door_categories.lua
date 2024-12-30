-- Полная информация по созданию категорий для дверей --> https://titanovskyteam.gitbook.io/darkrp/getting-started/create-door-category

if not Ambi.DarkRP then return end

local AddCategory = Ambi.DarkRP.AddDoorCategory

-- ----------------------------------------------------------------------------------------------------------------------------
AddCategory( 'Мэрия', {'j_bodyguard', 'j_clerk', 'j_mayor',} ) -- вот здесь
AddCategory( 'Полицейский Участок', { 'j_police1', 'j_police2', 'j_police3', 'j_swat', 'j_sheriff', 'j_swat_elite', 'j_jugger', 'j_bodyguard', 'j_clerk', 'j_mayor', } )
AddCategory( 'Тюрьма', { 'j_police3', 'j_sheriff', 'j_swat_elite', 'j_jugger', 'j_mayor', } )
AddCategory( 'Мафия', { 'j_mafia1', 'j_mafia2', 'j_mafia_leader', 'j_mafia_spec', 'j_mafia_elite', } )
AddCategory( 'Компьютерный клуб', {  } )
AddCategory( 'Штаб-квартира FBI', { 'j_fbi1', 'j_fbi2', 'j_fbi_leader', 'j_fbi_spec', 'j_fbi_inspector', } )