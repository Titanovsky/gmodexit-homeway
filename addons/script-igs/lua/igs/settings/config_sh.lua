
IGS.C.CURRENCY_NAME = "Рубли" -- Фановое название. Можете изменить
IGS.C.CURRENCY_SIGN = "Руб"


IGS.C.CurrencyPlurals = {
	"Рубль",  -- 1 алкобакс
	"Рубля", -- 3 алкобакса
	"Рублей" -- 5 алкобаксов
}

IGS.C.MENUBUTTON = KEY_F6

IGS.C.COMMANDS = {
	["donate"] = true,
	["донат"]  = true,
	['donat']  = true,
}


--[[-------------------------------------------------------------------------
	Донат инвентарь
---------------------------------------------------------------------------]]
-- Если отключить, вкладка инвентаря исчезнет, а предметы при покупке сразу будут активироваться
-- Станут недоступны некоторые методы, вроде :SetItems(, так как используют инвентарь
IGS.C.Inv_Enabled = false

-- Разрешить выбрасывать предметы с инвентаря на пол
-- Это позволит игрокам покупать донат подарки для друзей или вам делать донат раздачи
IGS.C.Inv_AllowDrop = false



if SERVER then return end -- не смотрите так на меня :)


-- Показывать ли уведомление о новых предметах в донат меню
-- Выглядит вот так https://img.qweqwe.ovh/1526574184864.png
IGS.C.NotifyAboutNewItems = false


-- Эта иконка будет отображена для предмета, если для него не будет установлена кастомная через :SetIcon()
-- Отображается вот тут: https://img.qweqwe.ovh/1494088609445.png
IGS.C.DefaultIcon = "https://ltdfoto.ru/images/2024/08/21/gmod_XNJZoSQgfT.png"


-- Отобразится тут: https://img.qweqwe.ovh/1492621941731.png
-- В конце каждой "}" и строки должна быть запятая. Будьте внимательны!!
IGS.C.Help = {
	{
		TITLE = "Как пополнить свой донат-счет?",
		TEXT  = "Инструкция по пополнению открывается по нажатию на '+' в верхнем левом углу"
	},
	{
		TITLE = "Как открыть меню админки?",
		TEXT  = "Просто введите !menu в чат"
	},
	{
		TITLE = "Могу ли я купить что-то особое, чего нет в списке?",
		TEXT  = "Возможно. Заходите в /discord в раздел Донат"
	},
}




-- Уберите "--" с начала строки, чтобы отключить появление определенного фрейма
IGS.C.DisabledFrames = {
	["faq_and_help"] = true, -- Чат бот (страница помощи)
	-- ["profile"]      = true, -- Страница профиля игрока (с транзакциями)
	-- ["purchases"]    = true, -- Активные покупки
}


-- Оставьте так, если не уверены
-- Инфо: https://vk.cc/6xaFOe
IGS.C.DATE_FORMAT = "%d.%m.%y %H:%M:%S"
IGS.C.DATE_FORMAT_SHORT = "%d.%m.%y"

local C = Ambi.Packages.Out( 'colors' )

local function InitColors()
	IGS.S.COLORS.FRAME_HEADER        = C.HOMEWAY_BLACK -- Фон верхушки фреймов в т.ч. пополнения счета и т.д. https://img.qweqwe.ovh/1491950958825.png
	IGS.S.COLORS.ACTIVITY_BG         = C.HOMEWAY_BLUE_DARK -- Фон в каждой вкладке (основной) https://img.qweqwe.ovh/1509370647204.png
	IGS.S.COLORS.TAB_BAR             = C.HOMEWAY_BLACK -- Фон таб бара https://img.qweqwe.ovh/1509370669492.png

	IGS.S.COLORS.PASSIVE_SELECTIONS  = C.HOMEWAY_BLACK -- Фон панели тегов, цвет кнопки с балансом, верхушки таблиц, не выделенные кнопки https://img.qweqwe.ovh/1509370720597.png
	IGS.S.COLORS.INNER_SELECTIONS    = C.HOMEWAY_BLACK -- Фон иконок на плашках, фон панелек последних покупок... https://img.qweqwe.ovh/1509370766148.png

	IGS.S.COLORS.SOFT_LINE           = Color( 255, 0, 0, 0)-- Линия между секциями, типа "Информация" и "Описание" в инфе об итеме
	IGS.S.COLORS.HARD_LINE           = Color( 255, 0, 0, 0) -- Обводки панелей

	IGS.S.COLORS.HIGHLIGHTING        = C.HOMEWAY_BLUE   -- Обводка кнопок, цвет текста не активной кнопки
	IGS.S.COLORS.HIGHLIGHT_INACTIVE  = C.HOMEWAY_BLUE -- Цвет иконки неактивной кнопки таббара, мигающая иконка на фрейме помощи https://img.qweqwe.ovh/1509371884592.png

	IGS.S.COLORS.TEXT_HARD           = Color(255,255,255) -- Заголовки, выделяющиеся тексты https://img.qweqwe.ovh/1509372019687.png
	IGS.S.COLORS.TEXT_SOFT           = Color(255,255,255) -- Описания, значения чего-то
	IGS.S.COLORS.TEXT_ON_HIGHLIGHT   = Color(255,255,255) -- Цвет текста на выделенных кнопках

	IGS.S.COLORS.LOG_SUCCESS         = Color(76,217,100)  -- В логах пополнения цвет успешных операций
	IGS.S.COLORS.LOG_ERROR           = Color(255,45,85)   -- В логах пополнения цвет ошибок
	IGS.S.COLORS.LOG_NORMAL          = Color(255,255,255) -- В логах пополнения обычные записи

	IGS.S.COLORS.ICON                = Color(255,255,255) -- цвет иконок на плашечках
end

hook.Add( 'IGS.Initialized', 'IGS.ColorsLoad', function()
	InitColors()
end )