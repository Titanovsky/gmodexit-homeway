BotLog = Ambi.Discord.Bot.Create( 'MTI3MjQ3MDQxNjM4MzgwMzQ0Mw.GPtDVG.d-llmocZyhtxNXsOmZzky5wtqeJpjNrq7HpMzc' )

local C = Ambi.General.Global.Colors

-- --------------------------------------------------------------------------------------------------------------------------
local function GetStatusText()
    local players = player.GetHumans()
    local all_players = ''

    for i, ply in ipairs( players ) do
        all_players = all_players..'\n'..i..'. \''..ply:Name()..'\'\t['..ply:GetJobTable().name..']\t('..ply:SteamID()..')'
    end

    return string.format( 
[[```lua
%s (%s)
'%s'

Онлайн: %s
%s```]], GetHostName(), os.date( '%H:%M  %d.%m.%Y', os.time() ), game.GetIPAddress(), #players, all_players )
end

-- --------------------------------------------------------------------------------------------------------------------------
timer.Create( 'Ambi.Homeway.DiscordStatusServer', 60 * 2, 0, function() 
    BotLog:EditMessage( '1264798165475917835', '1277188994765164604', GetStatusText() )
end )

hook.Add( 'IGS.PlayerDonate', 'Ambi.Homeway.DiscordLog', function( ePly, nSum )
    local tab = {
        'Ахуенный',
        'Самый лучший',
        'Имбовый',
        'Крутой',
        'Бесстрашный',
        'Лучший',
        'Бомбезный',
        'Вайбовый',
    }

    local random_epitet = table.Random( tab )

    local text = string.format( [[👑 %s игрок [%s (%s)](%s) задонатил **%i** и помог серверу! %s]], random_epitet, ePly:Name(), ePly:SteamID(), 'https://steamcommunity.com/profiles/'..ePly:SteamID64(), nSum, ( Ambi.Homeway.Config.donate_x > 1 ) and 'АКЦИЯ Донат **x'..Ambi.Homeway.Config.donate_x..'**' or '' )

    BotLog:SendMessage( '1284551742435889292', text, nil, true )
    BotLog:SendMessage( '1273117168053260348', text, nil, true )
    BotLog:SendMessage( '1264798634818670692', text, nil, true )
end )

hook.Add( '[Ambi.Homeway.Auth]', 'Ambi.Homeway.DiscordLog', function( ePly, IsFirst ) 
    local name = ePly:Name()
    local time = os.time()
    local sid, ip, sid64 = ePly:SteamID(), ePly:IPAddress(), ePly:SteamID64()

    if IsFirst then 
        BotLog:SendMessage( '1273143369199255604', string.format( [[✅ Зарегистрировался ```lua
        SteamID: '%s'
        SteamID64Owner: '%s'
        IP: '%s'
        Name: '%s'
        Time: '%s'```
        %s]], sid, ePly:OwnerSteamID64(), ip, name, os.date( '%X  %d.%m.%Y', time ), 'https://steamcommunity.com/profiles/'..sid64 ) )
    end

    name = name..' ('..sid..')'
    local add_text = IsFirst and 'впервые' or ''
    local emoji = IsFirst and '⭐' or '✅'

    BotLog:SendMessage( '1264816568467198023', string.format( [[%s Игрок [%s (%s)](%s) авторизовался %s]], emoji, ePly:Name(), ePly:SteamID(), 'https://steamcommunity.com/profiles/'..ePly:SteamID64(), add_text ), nil, true )
end )

hook.Add( '[Ambi.Homeway.MakeUserPromocode]', 'Ambi.Homeway.DiscordLog', function( sSteamID, sPromocode, ePly ) 
    if not ePly then return end

    BotLog:SendMessage( '1272677671888748556', string.format( [[💥 Игрок [%s (%s)](%s) создал промокод **%s**]], ePly:Name(), ePly:SteamID(), 'https://steamcommunity.com/profiles/'..ePly:SteamID64(), sPromocode ), nil, true )
end )

-- --------------------------------------------------------------------------------------------------------------------------------------------
hook.Add( '[Ambi.Promocode.Activated]', 'Ambi.Homeway.DiscordLog', function( ePly, tPromocode ) 
    if not ePly then return end

    BotLog:SendMessage( '1272677671888748556', string.format( [[😎 Игрок [%s (%s)](%s) ввёл промокод **%s** от (%s)]], ePly:Name(), ePly:SteamID(), 'https://steamcommunity.com/profiles/'..ePly:SteamID64(), tPromocode.promocode, tPromocode.steamid ), nil, true )
end )

-- --------------------------------------------------------------------------------------------------------------------------------------------
hook.Add( '[Ambi.DarkRP.ChatSayOOC]', 'Ambi.Homeway.DiscordLog', function( ePly, sText ) 
    BotLog:SendMessage( '1264803277241974835', string.format( [[💬 [%s](%s): %s]], ePly:Name(), 'https://steamcommunity.com/profiles/'..ePly:SteamID64(), sText ), nil, true )
end )

hook.Add( '[Ambi.DarkRP.Advert]', 'Ambi.Homeway.DiscordLog', function( ePly, sText ) 
    BotLog:SendMessage( '1264803277241974835', string.format( [[📢 [%s](%s): %s]], ePly:Name(), 'https://steamcommunity.com/profiles/'..ePly:SteamID64(), sText  ), nil, true )
end )

hook.Add( '[Ambi.DarkRP.Broadcast]', 'Ambi.Homeway.DiscordLog', function( ePly, sText ) 
    BotLog:SendMessage( '1264803277241974835', string.format( [[🔔 [%s](%s): %s]], ePly:Name(), 'https://steamcommunity.com/profiles/'..ePly:SteamID64(), sText  ), nil, true )
end )

hook.Add( '[Ambi.DarkRP.SetRPName]', 'Ambi.Homeway.DiscordLog', function( ePly, sRPName, sOldName ) 
    if not ePly:IsAuth() then return end
    
    BotLog:SendMessage( '1272926374058790978', string.format( [[✔️ Игрок [(%s)](%s) изменил имя с **%s** на **%s**]], ePly:SteamID(), 'https://steamcommunity.com/profiles/'..ePly:SteamID64(), sOldName, sRPName ), nil, true )
end )

hook.Add( '[Ambi.DarkRP.PlayerArrested]', 'Ambi.Homeway.DiscordLog', function( ePly, ePolice ) 
    if IsValid( ePolice ) then
        BotLog:SendMessage( '1277048672479215729', string.format( [[🔒 %s [%s (%s)](%s) арестовал [%s (%s)](%s)]], ePolice:GetJobTable().name, ePolice:Name(), ePolice:SteamID(), 'https://steamcommunity.com/profiles/'..ePolice:SteamID64(), ePly:Name(), ePly:SteamID(), 'https://steamcommunity.com/profiles/'..ePly:SteamID64() ), nil, true )
    else
        BotLog:SendMessage( '1277048672479215729', string.format( [[🔒 **Сервер** арестовал [%s (%s)](%s)]], ePly:Name(), ePly:SteamID(), 'https://steamcommunity.com/profiles/'..ePly:SteamID64() ), nil, true )
    end
end )

hook.Add( '[Ambi.DarkRP.PlayerUnArrested]', 'Ambi.Homeway.DiscordLog', function( ePly, ePolice ) 
    if IsValid( ePolice ) then
        BotLog:SendMessage( '1277048672479215729', string.format( [[🔓 %s [%s (%s)](%s) освободил [%s (%s)](%s)]], ePolice:GetJobTable().name, ePolice:Name(), ePolice:SteamID(), 'https://steamcommunity.com/profiles/'..ePolice:SteamID64(), ePly:Name(), ePly:SteamID(), 'https://steamcommunity.com/profiles/'..ePly:SteamID64() ), nil, true )
    else
        BotLog:SendMessage( '1277048672479215729', string.format( [[🔓 **Сервер** освободил [%s (%s)](%s)]], ePly:Name(), ePly:SteamID(), 'https://steamcommunity.com/profiles/'..ePly:SteamID64() ), nil, true )
    end
end )

hook.Add( '[Ambi.DarkRP.DemotedJob]', 'Ambi.Homeway.DiscordLog', function( eCaller, ePly )
    if IsValid( eCaller ) then
        BotLog:SendMessage( '1277067752351207486', string.format( [[⭕ [%s (%s)](%s) уволил [%s (%s)](%s)]], eCaller:Name(), eCaller:SteamID(), 'https://steamcommunity.com/profiles/'..eCaller:SteamID64(), ePly:Name(), ePly:SteamID(), 'https://steamcommunity.com/profiles/'..ePly:SteamID64() ), nil, true )
    else
        BotLog:SendMessage( '1277067752351207486', string.format( [[⭕ **Сервер** уволил [%s (%s)](%s)]], ePly:Name(), ePly:SteamID(), 'https://steamcommunity.com/profiles/'..ePly:SteamID64() ), nil, true )
    end
end )

hook.Add( '[Ambi.DarkRP.SetJob]', 'Ambi.Homeway.DiscordLog', function( ePly, sClass, _, sOldClass, tJob ) 
    if not ePly:IsAuth() then return end
    
    local post_text = Ambi.DarkRP.GetJob( sOldClass or '' ) and 'из работы **'..Ambi.DarkRP.GetJob( sOldClass ).name..' ('..sOldClass..')**' or ''
    BotLog:SendMessage( '1277067752351207486', string.format( [[💼 [%s (%s)](%s) стал **%s (%s)** %s]], ePly:Name(), ePly:SteamID(), 'https://steamcommunity.com/profiles/'..ePly:SteamID64(), tJob.name, sClass, post_text ), nil, true )
end )

hook.Add( '[Ambi.DarkRP.BuyShopItem]', 'Ambi.Homeway.DiscordLog', function( ePly, eObj, sClass, bForce, tItem )
    local text = string.format( [[💸 Игрок [%s (%s)](%s) купил %s]], ePly:Name(), ePly:SteamID(), 'https://steamcommunity.com/profiles/'..ePly:SteamID64(), tItem.name )

    BotLog:SendMessage( '1282122594828681246', text, nil, true )
end )

-- --------------------------------------------------------------------------------------------------------------------------------------------
hook.Add( '[Ambi.Homeway.ArcCWKillWelrod]', 'Ambi.Homeway.DiscordLog', function( ePly, eVictim )
    local name = eVictim:IsPlayer() and eVictim:Name() or tostring( eVictim )

    local text = string.format( [[🎯 Игрок **%s** ёбнул **%s** с помощью [Убивашки](https://ltdfoto.ru/images/2024/09/14/UBIVASKA1.png)]], ePly:Name(), name )

    BotLog:SendMessage( '1284394039352758282', text )
end )

hook.Add( '[Ambi.Homeway.ArcCWKillGauss]', 'Ambi.Homeway.DiscordLog', function( ePly, eVictim )
    local name = eVictim:IsPlayer() and eVictim:Name() or tostring( eVictim )

    local text = string.format( [[🧿 Игрок **%s** аннигилировал **%s** с помощью [Гаусски](https://ltdfoto.ru/images/2024/09/14/GAUSSKA.png)]], ePly:Name(), name )

    BotLog:SendMessage( '1284394039352758282', text )
end )

-- --------------------------------------------------------------------------------------------------------------------------------------------
hook.Add( 'PlayerInitialSpawn', 'Ambi.Homeway.DiscordLog', function( ePly ) 
    local name = ePly:Name()
    local time = os.time()
    local sid, ip, sid64 = ePly:SteamID(), ePly:IPAddress(), ePly:SteamID64()

    BotLog:SendMessage( '1273113034168074377', string.format( [[✅ Подключился ```lua
    SteamID: '%s'
    SteamID64Owner: '%s'
    IP: '%s'
    Name: '%s'
    Time: '%s'```
    %s]], sid, ePly:OwnerSteamID64(), ip, name, os.date( '%X  %d.%m.%Y', time ), 'https://steamcommunity.com/profiles/'..sid64 ) )
end )

hook.Add( 'PlayerDisconnected', 'Ambi.Homeway.DiscordLog', function( ePly ) 
    local name = ePly:Name()
    local time = os.time()
    local sid, ip, sid64 = ePly:SteamID(), ePly:IPAddress(), ePly:SteamID64()

    BotLog:SendMessage( '1273113034168074377', string.format( [[❌ Отключился ```lua
    SteamID: '%s'
    IP: '%s'
    Name: '%s'
    Time: '%s'```
    %s]], sid, ip, name, os.date( '%X  %d.%m.%Y', time ), 'https://steamcommunity.com/profiles/'..sid64 ) )

    name = name..' ('..sid..')'

    BotLog:SendMessage( '1264816568467198023', string.format( [[❌ Игрок [%s (%s)](%s) отключился]], ePly:Name(), ePly:SteamID(), 'https://steamcommunity.com/profiles/'..ePly:SteamID64() ), nil, true )
end )

hook.Add( 'PlayerDeath', 'Ambi.Homeway.DiscordLog', function( ePly, eInf, eAttacker ) 
    local attacker_text = ''
    local ply_text = ePly:Name()..' ('..ePly:SteamID()..')'

    if IsValid( eAttacker ) then
        attacker_text = eAttacker:IsPlayer() and 'от **'..eAttacker:Name()..' ('..eAttacker:SteamID()..')** с '..( IsValid( eAttacker:GetActiveWeapon() ) and eAttacker:GetActiveWeapon():GetClass() or 'none' ) or 'от **'..tostring( eAttacker )..'**'
    end

    BotLog:SendMessage( '1264816594136072296', string.format( [[<a:dance2:1273125319905378304> Игрок **%s** умер %s]], ply_text, attacker_text ) )
end )

hook.Add( 'PlayerSpawnedSENT', 'Ambi.Homeway.DiscordLog', function( ePly, eObj )
    local text = string.format( [[🗳️ Игрок [%s (%s)](%s) заспавнил энтитю **%s**]], ePly:Name(), ePly:SteamID(), 'https://steamcommunity.com/profiles/'..ePly:SteamID64(), tostring( eObj ) )

    BotLog:SendMessage( '1284489641818587196', text, nil, true )
end )

hook.Add( 'PlayerSpawnedNPC', 'Ambi.Homeway.DiscordLog', function( ePly, eObj )
    local text = string.format( [[🧛‍♂️ Игрок [%s (%s)](%s) заспавнил NPC **%s**]], ePly:Name(), ePly:SteamID(), 'https://steamcommunity.com/profiles/'..ePly:SteamID64(), tostring( eObj ) )

    BotLog:SendMessage( '1284489641818587196', text, nil, true )
end )

hook.Add( 'PlayerSpawnedVehicle', 'Ambi.Homeway.DiscordLog', function( ePly, eObj )
    local text = string.format( [[🏎️ Игрок [%s (%s)](%s) заспавнил машину **%s**]], ePly:Name(), ePly:SteamID(), 'https://steamcommunity.com/profiles/'..ePly:SteamID64(), tostring( eObj ) )

    BotLog:SendMessage( '1284489641818587196', text, nil, true )
end )

hook.Add( 'PlayerSpawnedSWEP', 'Ambi.Homeway.DiscordLog', function( ePly, eObj )
    local text = string.format( [[🔪 Игрок [%s (%s)](%s) заспавнил энтитю **%s**]], ePly:Name(), ePly:SteamID(), 'https://steamcommunity.com/profiles/'..ePly:SteamID64(), tostring( eObj ) )

    BotLog:SendMessage( '1284489680099737660', text, nil, true )
end )

hook.Add( 'PlayerGiveSWEP', 'Ambi.Homeway.DiscordLog', function( ePly, sClass )
    local text = string.format( [[⚔️ Игрок [%s (%s)](%s) выдал себе **%s**]], ePly:Name(), ePly:SteamID(), 'https://steamcommunity.com/profiles/'..ePly:SteamID64(), sClass )

    BotLog:SendMessage( '1284489680099737660', text, nil, true )
end )

-- --------------------------------------------------------------------------------------------------------------------------------------------
hook.Add( '[Ambi.ComputerClub.Started]', 'Ambi.Homeway.DiscordLog', function( sGame )
    local game = Ambi.ComputerClub.Get( sGame )

    BotLog:SendMessage( '1274404096740294757', string.format( [[🏪 Началась игра **"%s"** на %i минут]], game.header, math.floor( game.time / 60 ) ) )
end )

hook.Add( '[Ambi.ComputerClub.Stoped]', 'Ambi.Homeway.DiscordLog', function( sGame )
    local game = Ambi.ComputerClub.Get( sGame )

    BotLog:SendMessage( '1274404096740294757', string.format( [[🛑 Игра **"%s"** окончена]], game.header ) )
end )

hook.Add( '[Ambi.ComputerClub.PreparedStart]', 'Ambi.Homeway.DiscordLog', function( ePly )
    local text = ePly:Name()..' ('..ePly:SteamID()..')'
    BotLog:SendMessage( '1274404096740294757', string.format( [[🤗 Игрок **%s** вступил в игру]], text ) )
end )

hook.Add( '[Ambi.ComputerClub.Spawn]', 'Ambi.Homeway.DiscordLog', function( ePly )
    local text = ePly:Name()..' ('..ePly:SteamID()..')'
    BotLog:SendMessage( '1274404096740294757', string.format( [[👈 Игрок **%s** покинул игру (Spawn)]], text ) )
end )

hook.Add( '[Ambi.ComputerClub.Disconnected]', 'Ambi.Homeway.DiscordLog', function( ePly )
    local text = ePly:Name()..' ('..ePly:SteamID()..')'
    BotLog:SendMessage( '1274404096740294757', string.format( [[👈 Игрок **%s** покинул игру (Вышел с сервера)]], text ) )
end )

hook.Add( '[Ambi.ComputerClub.Death]', 'Ambi.Homeway.DiscordLog', function( ePly )
    local text = ePly:Name()..' ('..ePly:SteamID()..')'
    BotLog:SendMessage( '1274404096740294757', string.format( [[👈 Игрок **%s** покинул игру (Смерть)]], text ) )
end )

-- --------------------------------------------------------------------------------------------------------------------------------------------
hook.Add( '[Ambi.Homeway.SetRank]', 'Ambi.Homeway.DiscordLog', function( ePly, sRank, nHours )
    local text = ( nHours == -1 ) and 'навсегда' or 'на **'..nHours..'** часов'
    local name = ePly:Name()..' ('..ePly:SteamID()..')'

    BotLog:SendMessage( '1275383928005459988', string.format( [[💛 Игрок **%s** получил ранг **%s** %s]], name, sRank, text ) )
end )

hook.Add( '[Ambi.Homeway.SetRankOffline]', 'Ambi.Homeway.DiscordLog', function( sSteamID, sRank, nHours )
    local text = ( nHours == -1 ) and 'навсегда' or 'на **'..nHours..'** часов'

    BotLog:SendMessage( '1275383928005459988', string.format( [[💛 Игрок **%s** получил *оффлайн* ранг **%s** %s]], sSteamID, sRank, text ) )
end )

hook.Add( '[Ambi.Homeway.RemoveRank]', 'Ambi.Homeway.DiscordLog', function( ePly )
    local name = ePly:Name()..' ('..ePly:SteamID()..')'

    BotLog:SendMessage( '1275383928005459988', string.format( [[🛑 У игрока **%s** удалён ранг]], name ) )
end )

hook.Add( '[Ambi.Homeway.RemoveRankOffline]', 'Ambi.Homeway.DiscordLog', function( sSteamID )
    BotLog:SendMessage( '1275383928005459988', string.format( [[🛑 У игрока **%s** удалён *в оффлайне* ранг]], sSteamID ) )
end )

-- --------------------------------------------------------------------------------------------------------------------------------------------
hook.Add( '[Ambi.Homeway.FactoryPutWarehouse]', 'Ambi.Homeway.DiscordLog', function( ePly, eWarehouse, tInfo, sClass )
    Ambi.Homeway.FactoryWarehouseLog = Ambi.Homeway.FactoryWarehouseLog or {}
    Ambi.Homeway.FactoryWarehouseLog[ ePly:SteamID() ] = Ambi.Homeway.FactoryWarehouseLog[ ePly:SteamID() ] or {}
    Ambi.Homeway.FactoryWarehouseLog[ ePly:SteamID() ][ sClass ] = Ambi.Homeway.FactoryWarehouseLog[ ePly:SteamID() ][ sClass ] or 0

    Ambi.Homeway.FactoryWarehouseLog[ ePly:SteamID() ][ sClass ] = Ambi.Homeway.FactoryWarehouseLog[ ePly:SteamID() ][ sClass ] + 1

    local all_count = 0
    for _, count in pairs( Ambi.Homeway.FactoryWarehouseLog[ ePly:SteamID() ] ) do
        all_count = all_count + count
    end

    local text = string.format( [[🏭 Игрок [%s (%s)](%s) сделал **%s** (%i) на заводе. Всего: %i]], ePly:Name(), ePly:SteamID(), 'https://steamcommunity.com/profiles/'..ePly:SteamID64(), tInfo.header, Ambi.Homeway.FactoryWarehouseLog[ ePly:SteamID() ][ sClass ], all_count )

    BotLog:SendMessage( '1282122394315653141', text, nil, true )
end )

hook.Add( '[Ambi.Homeway.MineDestroyRock]', 'Ambi.Homeway.DiscordLog', function( ePly, eWarehouse, tInfo, sClass )
    Ambi.Homeway.MineLog = Ambi.Homeway.MineLog or {}
    Ambi.Homeway.MineLog[ ePly:SteamID() ] = Ambi.Homeway.MineLog[ ePly:SteamID() ] or 0

    Ambi.Homeway.MineLog[ ePly:SteamID() ] = Ambi.Homeway.MineLog[ ePly:SteamID() ] + 1

    local text = string.format( [[🛤️ Игрок [%s (%s)](%s) раздробил камень (%i)]], ePly:Name(), ePly:SteamID(), 'https://steamcommunity.com/profiles/'..ePly:SteamID64(), Ambi.Homeway.MineLog[ ePly:SteamID() ] )

    BotLog:SendMessage( '1282122394315653141', text, nil, true )
end )

hook.Add( '[Ambi.Homeway.PutCactusWarehouse]', 'Ambi.Homeway.DiscordLog', function( ePly, nCount )
    Ambi.Homeway.CactusesLog = Ambi.Homeway.CactusesLog or {}
    Ambi.Homeway.CactusesLog[ ePly:SteamID() ] = Ambi.Homeway.CactusesLog[ ePly:SteamID() ] or 0

    Ambi.Homeway.CactusesLog[ ePly:SteamID() ] = Ambi.Homeway.CactusesLog[ ePly:SteamID() ] + nCount

    local text = string.format( [[🌵 Игрок [%s (%s)](%s) собрал %i (%i) кактусов]], ePly:Name(), ePly:SteamID(), 'https://steamcommunity.com/profiles/'..ePly:SteamID64(), nCount, Ambi.Homeway.CactusesLog[ ePly:SteamID() ] )

    BotLog:SendMessage( '1282122745878024242', text, nil, true )
end )

hook.Add( '[Ambi.Homeway.PutApplesWarehouse]', 'Ambi.Homeway.DiscordLog', function( ePly, nRedApples, nGreenApples )
    Ambi.Homeway.ApplesLog = Ambi.Homeway.ApplesLog or {}
    Ambi.Homeway.ApplesLog[ ePly:SteamID() ] = Ambi.Homeway.ApplesLog[ ePly:SteamID() ] or { 0, 0 }

    Ambi.Homeway.ApplesLog[ ePly:SteamID() ][ 1 ] = Ambi.Homeway.ApplesLog[ ePly:SteamID() ][ 1 ] + nRedApples
    Ambi.Homeway.ApplesLog[ ePly:SteamID() ][ 2 ] = Ambi.Homeway.ApplesLog[ ePly:SteamID() ][ 2 ] + nGreenApples

    local text = string.format( [[📦 Игрок [%s (%s)](%s) собрал 🍎 %i (%i) и 🍏 %i (%i)]], ePly:Name(), ePly:SteamID(), 'https://steamcommunity.com/profiles/'..ePly:SteamID64(), nRedApples, Ambi.Homeway.ApplesLog[ ePly:SteamID() ][ 1 ], nGreenApples, Ambi.Homeway.ApplesLog[ ePly:SteamID() ][ 2 ] )

    BotLog:SendMessage( '1282122745878024242', text, nil, true )
end )

hook.Add( '[Ambi.Homeway.PutPrisonWarehouse]', 'Ambi.Homeway.DiscordLog', function( ePly, nCount )
    Ambi.Homeway.PrisonWarehouseLog = Ambi.Homeway.PrisonWarehouseLog or {}
    Ambi.Homeway.PrisonWarehouseLog[ ePly:SteamID() ] = Ambi.Homeway.PrisonWarehouseLog[ ePly:SteamID() ] or 0

    Ambi.Homeway.PrisonWarehouseLog[ ePly:SteamID() ] = Ambi.Homeway.PrisonWarehouseLog[ ePly:SteamID() ] + nCount

    local text = string.format( [[👨‍🔧 Заключённый [%s (%s)](%s) изготовил металл. конструкцию (%i)]], ePly:Name(), ePly:SteamID(), 'https://steamcommunity.com/profiles/'..ePly:SteamID64(), Ambi.Homeway.PrisonWarehouseLog[ ePly:SteamID() ] )

    BotLog:SendMessage( '1282122745878024242', text, nil, true )
end )

hook.Add( '[Ambi.Metz.Sale]', 'Ambi.Homeway.DiscordLog', function( ePly, eBuyer, nMetz, nMoney )
    Ambi.Homeway.MetzLog = Ambi.Homeway.MetzLog or {}
    Ambi.Homeway.MetzLog[ ePly:SteamID() ] = Ambi.Homeway.MetzLog[ ePly:SteamID() ] or 0

    Ambi.Homeway.MetzLog[ ePly:SteamID() ] = Ambi.Homeway.MetzLog[ ePly:SteamID() ] + nMetz

    local text = string.format( [[🌈 Игрок [%s (%s)](%s) продал %i кг Metz (%i)]], ePly:Name(), ePly:SteamID(), 'https://steamcommunity.com/profiles/'..ePly:SteamID64(), nMetz, Ambi.Homeway.MetzLog[ ePly:SteamID() ] )

    BotLog:SendMessage( '1282122698369273948', text, nil, true )
end )

hook.Add( '[Ambi.Homeway.SaleWeed]', 'Ambi.Homeway.DiscordLog', function( ePly, nAmount, nMoney )
    Ambi.Homeway.WeedLog = Ambi.Homeway.WeedLog or {}
    Ambi.Homeway.WeedLog[ ePly:SteamID() ] = Ambi.Homeway.WeedLog[ ePly:SteamID() ] or 0

    Ambi.Homeway.WeedLog[ ePly:SteamID() ] = Ambi.Homeway.WeedLog[ ePly:SteamID() ] + nAmount

    local text = string.format( [[☘️ Игрок [%s (%s)](%s) продал %i кг таинственной травки (%i)]], ePly:Name(), ePly:SteamID(), 'https://steamcommunity.com/profiles/'..ePly:SteamID64(), nAmount, Ambi.Homeway.WeedLog[ ePly:SteamID() ] )

    BotLog:SendMessage( '1282122698369273948', text, nil, true )
end )

hook.Add( '[Ambi.Homeway.NarkoWin]', 'Ambi.Homeway.DiscordLog', function( ePly, nMoney)
    Ambi.Homeway.NarkoLog = Ambi.Homeway.NarkoLog or {}
    Ambi.Homeway.NarkoLog[ ePly:SteamID() ] = Ambi.Homeway.NarkoLog[ ePly:SteamID() ] or 0

    Ambi.Homeway.NarkoLog[ ePly:SteamID() ] = Ambi.Homeway.NarkoLog[ ePly:SteamID() ] + 1

    local text = string.format( [[🗳️ Игрок [%s (%s)](%s) принёс пакетик и получил **%i$** (%i)]], ePly:Name(), ePly:SteamID(), 'https://steamcommunity.com/profiles/'..ePly:SteamID64(), nMoney, Ambi.Homeway.NarkoLog[ ePly:SteamID() ] )

    BotLog:SendMessage( '1282122698369273948', text, nil, true )
end )

hook.Add( '[Ambi.RobObj.Stealed]', 'Ambi.Homeway.DiscordLog', function( ePly, nMoney)
    Ambi.Homeway.RobObj = Ambi.Homeway.RobObj or {}
    Ambi.Homeway.RobObj[ ePly:SteamID() ] = Ambi.Homeway.RobObj[ ePly:SteamID() ] or 0

    Ambi.Homeway.RobObj[ ePly:SteamID() ] = Ambi.Homeway.RobObj[ ePly:SteamID() ] + 1

    local text = string.format( [[🔰 Игрок [%s (%s)](%s) ограбил груз с золотом на **%i$** (%i)]], ePly:Name(), ePly:SteamID(), 'https://steamcommunity.com/profiles/'..ePly:SteamID64(), nMoney, Ambi.Homeway.RobObj[ ePly:SteamID() ] )

    BotLog:SendMessage( '1282122698369273948', text, nil, true )
end )

-- --------------------------------------------------------------------------------------------------------------------------------------------
hook.Add( '[Ambi.OldOrgs2.Created]', 'Ambi.Homeway.DiscordLog', function( eLeader, nID, sName )
    local text = string.format( [[💫 Игрок [%s (%s)](%s) создал организацию **%s** (%i)]], eLeader:Name(), eLeader:SteamID(), 'https://steamcommunity.com/profiles/'..eLeader:SteamID64(), sName, nID )

    BotLog:SendMessage( '1282536058667532430', text, nil, true )
end )

hook.Add( '[Ambi.OldOrgs2.AcceptInvite]', 'Ambi.Homeway.DiscordLog', function( eMember, nID, sRank )
    local name = AmbOrgs2.Orgs[ nID ].Name
    local text = string.format( [[😇 Игрок [%s (%s)](%s) присоединился в организацию **%s** (%i) на ранг **%s**]], eMember:Name(), eMember:SteamID(), 'https://steamcommunity.com/profiles/'..eMember:SteamID64(), name, nID, sRank )

    BotLog:SendMessage( '1282536058667532430', text, nil, true )
end )

hook.Add( '[Ambi.OldOrgs2.LeavedOrg]', 'Ambi.Homeway.DiscordLog', function( eMember, nID )
    local name = AmbOrgs2.Orgs[ nID ].Name
    local text = string.format( [[⛔ Игрок [%s (%s)](%s) вышел из организации **%s** (%i)]], eMember:Name(), eMember:SteamID(), 'https://steamcommunity.com/profiles/'..eMember:SteamID64(), name, nID )

    BotLog:SendMessage( '1282536058667532430', text, nil, true )
end )

hook.Add( '[Ambi.OldOrgs2.InvitedOrg]', 'Ambi.Homeway.DiscordLog', function( eLeader, eMember, nID )
    local name = AmbOrgs2.Orgs[ nID ].Name
    local text = string.format( [[🟢 Лидер [%s (%s)](%s) пригласил [%s (%s)](%s) во фракцию **%s** (%i)]], eLeader:Name(), eLeader:SteamID(), 'https://steamcommunity.com/profiles/'..eLeader:SteamID64(), eMember:Name(), eMember:SteamID(), 'https://steamcommunity.com/profiles/'..eMember:SteamID64(), name, nID )

    BotLog:SendMessage( '1282536058667532430', text, nil, true )
end )

hook.Add( '[Ambi.OldOrgs2.RemoveOrg]', 'Ambi.Homeway.DiscordLog', function( nID, tOldOrg )
    local name = tOldOrg.Name
    local text = string.format( [[❌ Фракция **%s** (%i) удалена]], name, nID )

    BotLog:SendMessage( '1282536058667532430', text, nil, true )
end )

hook.Add( '[Ambi.OldOrgs2.ChangeRanks]', 'Ambi.Homeway.DiscordLog', function( eLeader, nID, sRanks )
    local name = AmbOrgs2.Orgs[ nID ].Name
    local text = string.format( [[💍 Лидер [%s (%s)](%s) фракции **%s** (%i) задал ранги: **%s**]], eLeader:Name(), eLeader:SteamID(), 'https://steamcommunity.com/profiles/'..eLeader:SteamID64(), name, nID, sRanks )

    BotLog:SendMessage( '1282536058667532430', text, nil, true )
end )

hook.Add( '[Ambi.OldOrgs2.ChangeFlags]', 'Ambi.Homeway.DiscordLog', function( eLeader, nID, nFlag )
    local str_text = ''
    if ( nFlag == 1 ) then str_text = 'Зам. Ничего не может'
    elseif ( nFlag == 2 ) then str_text = 'Зам. Может приглашать'
    elseif ( nFlag == 3 ) then str_text = 'Зам. Может приглашать и увольнять'
    end

    local name = AmbOrgs2.Orgs[ nID ].Name
    local text = string.format( [[🏳️ Лидер [%s (%s)](%s) фракции **%s** (%i) изменил флаг на **%i** (%s)]], eLeader:Name(), eLeader:SteamID(), 'https://steamcommunity.com/profiles/'..eLeader:SteamID64(), name, nID, nFlag, str_text )

    BotLog:SendMessage( '1282536058667532430', text, nil, true )
end )

hook.Add( '[Ambi.OldOrgs2.SetRank]', 'Ambi.Homeway.DiscordLog', function( ePly, eMember, nID, sRank )
    local begin_str = ( AmbOrgs2.Orgs[ nID ].LeaderID == ePly:SteamID() ) and 'Лидер' or 'Заместительы'
    local name = AmbOrgs2.Orgs[ nID ].Name
    local text = string.format( [[🏅 %s [%s (%s)](%s) фракции **%s** (%i) изменил ранг [%s (%s)](%s) у на **%s**]], begin_str, ePly:Name(), ePly:SteamID(), 'https://steamcommunity.com/profiles/'..ePly:SteamID64(), name, nID, eMember:Name(), eMember:SteamID(), 'https://steamcommunity.com/profiles/'..eMember:SteamID64(), sRank )

    BotLog:SendMessage( '1282536058667532430', text, nil, true )
end )

hook.Add( '[Ambi.OldOrgs2.UnInvited]', 'Ambi.Homeway.DiscordLog', function( eLeader, eMember, nID )
    local name = AmbOrgs2.Orgs[ nID ].Name
    local text = string.format( [[🔴 Лидер [%s (%s)](%s) фракции **%s** (%i) выгнал [%s (%s)](%s)]], eLeader:Name(), eLeader:SteamID(), 'https://steamcommunity.com/profiles/'..eLeader:SteamID64(), name, nID, eMember:Name(), eMember:SteamID(), 'https://steamcommunity.com/profiles/'..eMember:SteamID64() )

    BotLog:SendMessage( '1282536058667532430', text, nil, true )
end )

-- --------------------------------------------------------------------------------------------------------------------------------------------
hook.Add( '[Ambi.Duel.BetPlace]', 'Ambi.Homeway.DiscordLog', function( ePly, nBet, eDuelist )
    local text = string.format( [[💵 Игрок [%s (%s)](%s) поставил **%i** на [%s (%s)](%s)]], ePly:Name(), ePly:SteamID(), 'https://steamcommunity.com/profiles/'..ePly:SteamID64(), nBet, eDuelist:Name(), eDuelist:SteamID(), 'https://steamcommunity.com/profiles/'..eDuelist:SteamID64() )

    BotLog:SendMessage( '1284102769745072139', text, nil, true )
end )

hook.Add( '[Ambi.Duel.BetWin]', 'Ambi.Homeway.DiscordLog', function( ePly, nMoney, eWinner )
    local text = string.format( [[💰 Игрок [%s (%s)](%s) выиграл **%i**]], ePly:Name(), ePly:SteamID(), 'https://steamcommunity.com/profiles/'..ePly:SteamID64(), nMoney )

    BotLog:SendMessage( '1284102769745072139', text, nil, true )
end )

hook.Add( '[Ambi.Duel.BetLoss]', 'Ambi.Homeway.DiscordLog', function( ePly, nMoney, eWinner )
    local text = string.format( [[🔴 Игрок [%s (%s)](%s) потерял **%i**]], ePly:Name(), ePly:SteamID(), 'https://steamcommunity.com/profiles/'..ePly:SteamID64(), nMoney )

    BotLog:SendMessage( '1284102769745072139', text, nil, true )
end )

hook.Add( '[Ambi.Duel.PreparedStart]', 'Ambi.Homeway.DiscordLog', function( eDuelist1, eDuelist2, nAward, nHealth, nArmor, sGun )
    local text = string.format( [[🎯 Игрок [%s (%s)](%s) позвал на дуэль [%s (%s)](%s) с **%s** оружием, здоровьем **%i**, бронёй **%i** и наградой **%i**]], eDuelist1:Name(), eDuelist1:SteamID(), 'https://steamcommunity.com/profiles/'..eDuelist1:SteamID64(), eDuelist2:Name(), eDuelist2:SteamID(), 'https://steamcommunity.com/profiles/'..eDuelist2:SteamID64(), sGun, nHealth, nArmor, nAward )

    BotLog:SendMessage( '1284102769745072139', text, nil, true )
end )

hook.Add( '[Ambi.Duel.Started]', 'Ambi.Homeway.DiscordLog', function( eDuelist1, eDuelist2, nAward, nHealth, nArmor, sGun )
    BotLog:SendMessage( '1284102769745072139', '🟢 Дуэль началась', nil, true )
end )

hook.Add( '[Ambi.Duel.End]', 'Ambi.Homeway.DiscordLog', function( eWinner, eLoser, nAward )
    local text = string.format( [[👑 Игрок [%s (%s)](%s) победил и залутал **%i**]], eWinner:Name(), eWinner:SteamID(), 'https://steamcommunity.com/profiles/'..eWinner:SteamID64(), nAward )

    BotLog:SendMessage( '1284102769745072139', text, nil, true )
end )

-- --------------------------------------------------------------------------------------------------------------------------------------------
hook.Add( '[Ambi.Homeway.UsedChest]', 'Ambi.Homeway.DiscordLog', function( ePly, eChest, sRewardItem, tItem )
    local text = string.format( [[📦 Игрок [%s (%s)](%s) открыл **%s** и получил **%s**]], ePly:Name(), ePly:SteamID(), 'https://steamcommunity.com/profiles/'..ePly:SteamID64(), Ambi.Homeway.chest_types[ eChest.nw_Chest ].header, tItem.name )

    BotLog:SendMessage( '1286770554791133235', text, nil, true )
end )

-- --------------------------------------------------------------------------------------------------------------------------------------------
hook.Add( '[Ambi.Homeway.Looting]', 'Ambi.Homeway.DiscordLog', function( ePly, sItem, eLoot )
    local header = ( sItem == 'none' ) and 'Ничего' or Ambi.Inv.GetItem( sItem ).name
    local text = string.format( [[💠 Игрок [%s (%s)](%s) залутал **%s**]], ePly:Name(), ePly:SteamID(), 'https://steamcommunity.com/profiles/'..ePly:SteamID64(), header )

    BotLog:SendMessage( '1286770520162832404', text, nil, true )
end )

-- --------------------------------------------------------------------------------------------------------------------------------------------
hook.Add( '[Ambi.ULX.adduser]', 'Ambi.Homeway.DiscordLog', function( calling_ply, target_ply, group_name, nHours )
    local owner = IsValid( calling_ply ) and calling_ply:Name()..' ('..calling_ply:SteamID()..')' or 'Сервер'
    local name = target_ply:Name()..' ('..target_ply:SteamID()..')'

    BotLog:SendMessage( '1275405838504165377', string.format( [[💛 **%s** задал для **%s** ранг %s на %i часов ]], owner, name, group_name, nHours ) )
end )

hook.Add( '[Ambi.ULX.removeuser]', 'Ambi.Homeway.DiscordLog', function( calling_ply, target_ply )
    local owner = IsValid( calling_ply ) and calling_ply:Name()..' ('..calling_ply:SteamID()..')' or 'Сервер'
    local name = target_ply:Name()..' ('..target_ply:SteamID()..')'

    BotLog:SendMessage( '1275405838504165377', string.format( [[💛 **%s** удалил ранг для **%s** ]], owner, name ) )
end )

hook.Add( '[Ambi.ULX.jail]', 'Ambi.Homeway.DiscordLog', function( calling_ply, eTarget, nMinutes, sReason )
    local owner = IsValid( calling_ply ) and calling_ply:Name()..' ('..calling_ply:SteamID()..')' or 'Сервер'
    local name = eTarget:Name()..' ('..eTarget:SteamID()..')'

    BotLog:SendMessage( '1275405838504165377', string.format( [[⭕ **%s** отправил в джайл **%s** на %i минут. Причина: **%s** ]], owner, name, nMinutes, sReason ) )
end )

hook.Add( '[Ambi.ULX.unjail]', 'Ambi.Homeway.DiscordLog', function( calling_ply, eTarget, sReason )
    local owner = IsValid( calling_ply ) and calling_ply:Name()..' ('..calling_ply:SteamID()..')' or 'Сервер'
    local name = eTarget:Name()..' ('..eTarget:SteamID()..')'

    BotLog:SendMessage( '1275405838504165377', string.format( [[✳️ **%s** вытащил из джайла **%s**. Причина: **%s** ]], owner, name, sReason ) )
end )

hook.Add( '[Ambi.ULX.warn]', 'Ambi.Homeway.DiscordLog', function( eCaller, eTarget, sReason )
    local owner = IsValid( eCaller ) and eCaller:Name()..' ('..eCaller:SteamID()..')' or 'Сервер'
    local name = eTarget:Name()..' ('..eTarget:SteamID()..')'

    BotLog:SendMessage( '1275405838504165377', string.format( [[🔺 **%s** выдал варн **%s**. Причина: **%s** ]], owner, name, sReason ) )
end )

hook.Add( '[Ambi.ULX.unwarn]', 'Ambi.Homeway.DiscordLog', function( eCaller, eTarget, nID, sReason, tWarn ) 
    local owner = IsValid( eCaller ) and eCaller:Name()..' ('..eCaller:SteamID()..')' or 'Сервер'
    local name = eTarget:Name()..' ('..eTarget:SteamID()..')'

    BotLog:SendMessage( '1275405838504165377', string.format( [[◻️ **%s** убрал %i варн у **%s**. Причина: **%s**.  
    Выдан: %s
    Дата: %s
    Причина: %s]], owner, nID, name, sReason, tWarn.warner, os.date( '%X  %d.%m.%Y', tWarn.date ), tWarn.reason ) )
end )

hook.Add( '[Ambi.ULX.removewarns]', 'Ambi.Homeway.DiscordLog', function( eCaller, eTarget, sReason ) 
    local owner = IsValid( eCaller ) and eCaller:Name()..' ('..eCaller:SteamID()..')' or 'Сервер'
    local name = eTarget:Name()..' ('..eTarget:SteamID()..')'

    BotLog:SendMessage( '1275405838504165377', string.format( [[🤍 **%s** убрал все варны у **%s**. Причина: **%s**]], owner, name, sReason ) )
end )

hook.Add( '[Ambi.ULX.dwarn]', 'Ambi.Homeway.DiscordLog', function( eCaller, eTarget, sReason )
    local owner = IsValid( eCaller ) and eCaller:Name()..' ('..eCaller:SteamID()..')' or 'Сервер'
    local name = eTarget:Name()..' ('..eTarget:SteamID()..')'

    BotLog:SendMessage( '1275405838504165377', string.format( [[🔺⭐ **%s** выдал донат варн **%s**. Причина: **%s** ]], owner, name, sReason ) )
end )

hook.Add( '[Ambi.ULX.undwarn]', 'Ambi.Homeway.DiscordLog', function( eCaller, eTarget, nID, sReason, tWarn ) 
    local owner = IsValid( eCaller ) and eCaller:Name()..' ('..eCaller:SteamID()..')' or 'Сервер'
    local name = eTarget:Name()..' ('..eTarget:SteamID()..')'

    BotLog:SendMessage( '1275405838504165377', string.format( [[◻️⭐ **%s** убрал %i донат варн у **%s**. Причина: **%s**.  
    Выдан: %s
    Дата: %s
    Причина: %s]], owner, nID, name, sReason, tWarn.warner, os.date( '%X  %d.%m.%Y', tWarn.date ), tWarn.reason ) )
end )

hook.Add( '[Ambi.ULX.removedwarns]', 'Ambi.Homeway.DiscordLog', function( eCaller, eTarget, sReason ) 
    local owner = IsValid( eCaller ) and eCaller:Name()..' ('..eCaller:SteamID()..')' or 'Сервер'
    local name = eTarget:Name()..' ('..eTarget:SteamID()..')'

    BotLog:SendMessage( '1275405838504165377', string.format( [[🤍⭐ **%s** убрал все донат варны у **%s**. Причина: **%s**]], owner, name, sReason ) )
end )

hook.Add( '[Ambi.ULX.adminwarn]', 'Ambi.Homeway.DiscordLog', function( eCaller, eTarget, sReason )
    local owner = IsValid( eCaller ) and eCaller:Name()..' ('..eCaller:SteamID()..')' or 'Сервер'
    local name = eTarget:Name()..' ('..eTarget:SteamID()..')'

    BotLog:SendMessage( '1275405838504165377', string.format( [[🔺⭕ **%s** выдал админ варн **%s**. Причина: **%s** ]], owner, name, sReason ) )
end )

hook.Add( '[Ambi.ULX.unadminwarn]', 'Ambi.Homeway.DiscordLog', function( eCaller, eTarget, nID, sReason, tWarn ) 
    local owner = IsValid( eCaller ) and eCaller:Name()..' ('..eCaller:SteamID()..')' or 'Сервер'
    local name = eTarget:Name()..' ('..eTarget:SteamID()..')'

    BotLog:SendMessage( '1275405838504165377', string.format( [[◻️⭕ **%s** убрал %i админ варн у **%s**. Причина: **%s**.  
    Выдан: %s
    Дата: %s
    Причина: %s]], owner, nID, name, sReason, tWarn.warner, os.date( '%X  %d.%m.%Y', tWarn.date ), tWarn.reason ) )
end )

hook.Add( '[Ambi.ULX.removeadminwarns]', 'Ambi.Homeway.DiscordLog', function( eCaller, eTarget, sReason ) 
    local owner = IsValid( eCaller ) and eCaller:Name()..' ('..eCaller:SteamID()..')' or 'Сервер'
    local name = eTarget:Name()..' ('..eTarget:SteamID()..')'

    BotLog:SendMessage( '1275405838504165377', string.format( [[🤍⭕ **%s** убрал все админ варны у **%s**. Причина: **%s**]], owner, name, sReason ) )
end )