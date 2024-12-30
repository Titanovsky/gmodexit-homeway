local Add = Ambi.Inv.AddItem
local STACK = 1000

local function SetSkin( ePly, sModel )
    ePly:SetModel( sModel )
    ePly:RunCommand( 'act forward' )
    ePly:SetJobHands()
    ePly:Notify( 'Вы надели временную одежду', 8, NOTIFY_ACCEPT )

    return true
end

local function AddSkin( sClass, sHeader, sModel )
    Add( sClass, 'Скин: '..sHeader, STACK, 'Скины', 'Даёт временный скин (пропадёт после смерти)', 'https://i.postimg.cc/5ymb9GBq/skin-alyx.png', function( ePly ) 
        return SetSkin( ePly, sModel )
    end )
end

-- ---------------------------------------------------------------------------------------------------------------------------------------
local CATEGORY = 'Скины'

AddSkin( 'skin_gman', 'G-Man', 'models/player/gman_high.mdl' )
AddSkin( 'skin_saul_goodman', 'Соул Гудман', 'models/player/griffbo/saulgoodman.mdl' )
AddSkin( 'skin_medic_anime', 'Секси Тянка', 'models/player/luka_nurse.mdl' )
AddSkin( 'skin_leet', 'Leet', 'models/player/leet.mdl' )
AddSkin( 'skin_alyx', 'Аликс', 'models/player/alyx.mdl' )
AddSkin( 'skin_business1', 'Деловой Китаец', 'models/humans/jacketntie/male_05.mdl' )
AddSkin( 'skin_business2', 'Деловой Мужик', 'models/humans/jacketntie/male_07.mdl' )
AddSkin( 'skin_business3', 'Деловой Дэйв', 'models/humans/jacketntie/male_09.mdl' )
AddSkin( 'skin_scientist', 'Кляйнерс', 'models/player/kleiner.mdl' )
AddSkin( 'skin_ded', 'Чёрный Дед', 'models/player/eli.mdl' )
AddSkin( 'skin_chell', 'Челл', 'models/player/p2_chell.mdl' )
AddSkin( 'skin_narko', 'Наркоман', 'models/player/soldier_stripped.mdl' )