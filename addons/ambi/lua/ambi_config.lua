--[[
    Ambi Eco — платформа (экосистема) для создания проектов в игре Garry's Mod

    Github: https://github.com/Titanovsky/ambi-eco
    Documentation: https://titanovskyteam.gitbook.io/ambi-eco
--]]

-- --------------------------------------------------------------------------------------------------------------------------------------
Ambi.Config.dev = true -- Включить режим разработки?
Ambi.Config.language = 'ru' -- Язык сервера

-- --------------------------------------------------------------------------------------------------------------------------------------
--* Важные
Ambi.ConnectModule( 'net', 'Инструмент разработчика: Заменяет функций' )
Ambi.ConnectModule( 'content-loader', 'Интерфейс по работе с контентом из интернета для клинета' )
Ambi.ConnectModule( 'configurator', 'Простая система изменения конфигов' )
Ambi.ConnectModule( 'base-fonts', 'Регистрация шрифтов из Ambi Fonts и Ambi Fonts Extended' )
Ambi.ConnectModule( 'base-notify', 'Регистрация уведомлений' )
Ambi.ConnectModule( 'base-sounds', 'Регистрация звуков из Ambi Sounds и Ambi Sounds Extended' )
Ambi.ConnectModule( 'dev-panels', 'Инструмент разработчика: Важные менюшки' )

-- --------------------------------------------------------------------------------------------------------------------------------------
--* Желательные
Ambi.ConnectModule( 'chatcommands', 'Система чатовых команд' )
Ambi.ConnectModule( 'multihud', 'Систему подключения/отключения разных худов' )
Ambi.ConnectModule( 'infohud', 'Худ для показа информаций о энтити' )
Ambi.ConnectModule( 'player-freeze', 'Специфичная заморозка игрока' )
Ambi.ConnectModule( 'process', 'Система однопоточных процессов для игроков' )
Ambi.ConnectModule( 'autospawn', 'Система спавна энтитей после загрузки сервера' )
Ambi.ConnectModule( 'disable-render-unfocus', 'Отключения рендера, когда игра свёрнута' )

-- --------------------------------------------------------------------------------------------------------------------------------------
Ambi.ConnectModule( 'darkrp' )
Ambi.ConnectModule( 'time' )
Ambi.ConnectModule( 'whitelist' )
Ambi.ConnectModule( 'image', 'Модуль для отправки скринов через чат' )
Ambi.ConnectModule( 'inv' )
Ambi.ConnectModule( 'quest' )
--Ambi.ConnectModule( 'skills' )
Ambi.ConnectModule( 'esp' )
Ambi.ConnectModule( 'whitelist', 'Белый список для захода на сервер' )
--Ambi.ConnectModule( 'fog-opti' )
Ambi.ConnectModule( 'render-distance-opti' )
--Ambi.ConnectModule( 'physenv-opti' )
Ambi.ConnectModule( 'boombox' )
--Ambi.ConnectModule( 'pixel-battle' )
Ambi.ConnectModule( 'metz' )
Ambi.ConnectModule( 'privilege' )
Ambi.ConnectModule( 'statistic' )
Ambi.ConnectModule( 'crack-door-multigame' )
Ambi.ConnectModule( 'date' )
Ambi.ConnectModule( 'my-pets' )
Ambi.ConnectModule( 'kit' )
Ambi.ConnectModule( 'daily' )
Ambi.ConnectModule( 'promocode' )
Ambi.ConnectModule( 'discord' )
Ambi.ConnectModule( 'warn' )
Ambi.ConnectModule( 'fishing' )
Ambi.ConnectModule( 'computer-club' )
Ambi.ConnectModule( 'territory' )
Ambi.ConnectModule( 'party' )
--Ambi.ConnectModule( 'custom-shop' )
Ambi.ConnectModule( 'spy' )
Ambi.ConnectModule( 'old-orgs2' )
Ambi.ConnectModule( 'duel' )
Ambi.ConnectModule( 'rob-obj' )

Ambi.ConnectModule( 'project-homeway', 'Homeway (DarkRP)' )