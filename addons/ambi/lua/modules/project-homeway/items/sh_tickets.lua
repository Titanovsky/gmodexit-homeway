local Add = Ambi.Inv.AddItem

-- ---------------------------------------------------------------------------------------------------------------------------------------
local CATEGORY = 'Билеты - Перма Оружия'
local STACK = 100

local function AddTicket( sClass, sName )
    return Add( 'ticket_'..sClass, 'Билет: '..sName, STACK, CATEGORY, 'Получить перма вещь', 'https://i.postimg.cc/hPSKZDnC/ticket-perma-skin-bibizyana.png', function( ePly ) 
        IGS.PlayerActivateItem( ePly, sClass )
        ePly:Notify( 'Ты получил Перма '..sName, 15, NOTIFY_ACCEPT )
    
        return true
    end )
end

AddTicket( 'perma_wep_deagle', 'Deagle' )
AddTicket( 'perma_wep_ak47', 'AK-47' )
AddTicket( 'perma_wep_awp', 'AWP' )
AddTicket( 'perma_wep_m14', 'Пулемёт' )
AddTicket( 'perma_wep_rpg', 'RPG-7' )
AddTicket( 'perma_wep_ss2_doubleshtg', '[SS2] Двустволка' )
AddTicket( 'perma_wep_ss2_colt', '[SS2] Кольты' )
AddTicket( 'perma_wep_ss2_uzi', '[SS2] Узи' )
AddTicket( 'perma_wep_ss2_rocket', '[SS2] Rocket Launcher' )
AddTicket( 'perma_wep_cf_deagle', '[CF] Deagle' )
AddTicket( 'perma_wep_cf_m4a1', '[CF] M4A1' )
AddTicket( 'perma_wep_cf_ak47', '[CF] AK-47' )

AddTicket( 'perma_skin_soul_goodman', 'Соул Гудман' )
AddTicket( 'perma_skin_eft_partisan', 'EFT Дед' )
AddTicket( 'perma_skin_murder', 'Маньяк' )
AddTicket( 'perma_skin_gang_beast', 'Гомункул' )
AddTicket( 'perma_skin_coal', 'Сухарик' )
AddTicket( 'perma_skin_skelet', 'Дрыщ' )
AddTicket( 'perma_skin_bibizyana', 'Бибизьян' )
AddTicket( 'perma_skin_madara', 'Мадара Учиха' )
AddTicket( 'perma_skin_yagami', 'Ягами Лайт' )
AddTicket( 'perma_skin_whore', 'Пошлая' )