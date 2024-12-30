-- Исключительно серверная информация, которую невозможно похитить обычным путём!
-- ВАЖНО! НЕ СООБЩАЙТЕ НИКОМУ ИНФУ ОТСЮДА!

-- ------------------------------------------------------------------------------------------------------------------------------
Ambi.Discord.Config.bot_chat_enable = false -- Вкл/Выкл чат бота ( между серверов и текстовым каналом )
Ambi.Discord.Config.bot_chat_from_gmod_in_discord = false -- Вкл/Выкл из Gmod в Дискорд
Ambi.Discord.Config.bot_chat_from_discord_in_gmod = false -- Вкл/Выкл из Дискорда в Gmod
Ambi.Discord.Config.bot_chat_token = '' -- Токен Бота -- ПОТРЕБУЕТСЯ РЕСТАРТ ПРИ ИЗМЕНЕНИЙ!
Ambi.Discord.Config.bot_chat_id = '' -- ID Дискорда бота, это важно, чтобы он сам у себя не читал сообщения
Ambi.Discord.Config.bot_chat_channel_id = '1264803277241974835' -- ID номер текстового канала, куда будут отправляться сообщения и будут браться с него (Бот должен иметь право туда отправлять сообщения и читать его)
Ambi.Discord.Config.bot_chat_delay_send = 0.75 -- Задержка отправки из сервера на канал сообщений (Обязательно должна быть)
Ambi.Discord.Config.bot_chat_delay_receive = 1 -- Задержка приёма из канала на сервер сообщений (Обязательно должна быть)

Ambi.Discord.Config.bot_chat_commands_enable = false -- Включить выполнения команд в чате
Ambi.Discord.Config.bot_chat_commands_users = { -- Discord ID юзеров, у которых будут команды выполняться, ID бота не вставляйте сюда!
    -- [ 'ID' ] = true, -- Про кавычки и запятую не забываем!
    [ '475626347952209920' ] = true, -- Titanovsky
    [ '587277766248890372' ] = true, -- Asuna
}

-- ------------------------------------------------------------------------------------------------------------------------------
Ambi.Discord.Config.bot_logs_enable = false -- Вкл/Выкл лог бота ( логгирую информацию в текстовый канал )
Ambi.Discord.Config.bot_logs_token = '' -- Токен Бота для Логов -- ПОТРЕБУЕТСЯ РЕСТАРТ ПРИ ИЗМЕНЕНИЙ!

Ambi.Discord.Config.bot_logs_player_connecting_enable = false -- Включить логи игроков, которые подключаются
Ambi.Discord.Config.bot_logs_player_connecting_channel_id = '1264816568467198023'
Ambi.Discord.Config.bot_logs_player_connecting_delay = 2

Ambi.Discord.Config.bot_logs_player_disconnected_enable = true -- Включить лог игроков, которые отключились
Ambi.Discord.Config.bot_logs_player_disconnected_channel_id = '1264816568467198023'
Ambi.Discord.Config.bot_logs_player_disconnected_delay = 1

Ambi.Discord.Config.bot_logs_player_initialized_enable = true -- Включить лог игроков, которые появились на сервере
Ambi.Discord.Config.bot_logs_player_initialized_channel_id = '1264816568467198023'
Ambi.Discord.Config.bot_logs_player_initialized_delay = 2