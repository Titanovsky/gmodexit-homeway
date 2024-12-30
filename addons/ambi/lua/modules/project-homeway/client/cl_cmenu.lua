local C, GUI, Draw, UI, CL = Ambi.Packages.Out( '@d, ContentLoader' )
local W, H = ScrW(), ScrH()

local COLOR_CONTEXT = Color( 255, 255, 255, 200 )
local COLOR_LAWS = Color( 0, 0, 0, 240 )

local icons_donate = {
    'icon16/star.png',
    'icon16/lightning.png',
    'icon16/heart.png',
    'icon16/male.png',
    'icon16/ruby.png',
    'icon16/world.png',
    'icon16/cake.png',
    'icon16/pill_add.png',
    'icon16/wand.png',
    'icon16/rainbow.png',
    'icon16/rosette.png'
}

local text_pin = {
    '❖',
    '✩',
    '✪',
    '✿',
    '(͡° ͜ʖ ͡°)'
}

local icons = {
    ['shop'] = 'icon16/star.png',
    ['sellalldoors'] = 'icon16/door_open.png',
    ['ammo'] = 'icon16/bullet_black.png',
    ['advert'] = 'icon16/eye.png',
    ['money'] = 'icon16/money_delete.png',
    ['change_money'] = 'icon16/money.png',
    ['lockdown_open'] = 'icon16/bell_add.png',
    ['lockdown_close'] = 'icon16/bell_delete.png',
    ['dropweapon'] = 'icon16/arrow_down.png'
}

local pnl
local pnl2

-- ---------------------------------------------------------------------------------------------------------------------------------------
local function SetupPanel( vguiPanel )
    vguiPanel:SetFont( UI.SafeFont( '18 Montserrat' ) )
    vguiPanel:SetTextColor( C.HOMEWAY_BLUE )
    vguiPanel.Paint = function( self, w, h )
        Draw.Box( w, h, 0, 0, C.HOMEWAY_BLACK )
    end
end

-- ---------------------------------------------------------------------------------------------------------------------------------------
function Ambi.Homeway.OpenContextMenu( bLeft )
    if not LocalPlayer():IsAuth() then return end
    if ( LocalPlayer():Alive() == false ) then return end
    if ValidPanel( pnl ) then return pnl:Remove() end
    if ValidPanel( pnl2 ) then return pnl2:Remove() end

    amb_context_menu = vgui.Create( 'DMenu' )
    amb_context_menu.Paint = function( self, w, h )
        draw.RoundedBox( 0, 0, 0, w, h, COLOR_CONTEXT )
    end

    amb_context_menu.OnRemove = function()
        if ValidPanel( pnl2 ) then pnl2:Remove() end
    end
    
    pnl = amb_context_menu

    if ( LocalPlayer():GetJob() == 'j_mafia_leader' ) then
        local sub_demote, ed = amb_context_menu:AddSubMenu( 'Мафия' )
        ed:SetImage( 'icon16/user_delete.png' )

        local info_warehouses = sub_demote:AddOption( 'Узнать инфу о складах', function()
            RunConsoleCommand( 'say', '/infowarehouses' )
        end )
        info_warehouses:SetImage( 'icon16/user.png' )
        SetupPanel( info_warehouses )
        
        local info_warehouses = sub_demote:AddOption( 'Узнать можно рейдить ФБР склад', function()
            RunConsoleCommand( 'say', '/canraidfbi' )
        end )
        info_warehouses:SetImage( 'icon16/user.png' )
        SetupPanel( info_warehouses )

        local info_warehouses = sub_demote:AddOption( 'Узнать можно рейдить ПУ склад', function()
            RunConsoleCommand( 'say', '/canraidpolice' )
        end )
        info_warehouses:SetImage( 'icon16/user.png' )
        SetupPanel( info_warehouses )
    
        ed:SetFont( UI.SafeFont( '18 Montserrat' ) )
        ed:SetTextColor( C.HOMEWAY_BLUE )
        ed.Paint = function( self, w, h )
            Draw.Box( w, h, 0, 0, C.HOMEWAY_BLACK )
        end
    end

    if LocalPlayer():IsMayor() then
        local is_lockdown = GetConVar( 'ambi_darkrp_lockdown' ):GetBool()

        if Ambi.DarkRP.Config.cmenu_show_lockdown then
            local lockdown = amb_context_menu:AddOption( is_lockdown and 'Ком. Час [Выкл]' or 'Ком. Час [Вкл]', function()
                if is_lockdown then
                    if not GetConVar( 'ambi_darkrp_lockdown' ):GetBool() then return end

                    RunConsoleCommand( 'say', '/'..Ambi.DarkRP.Config.goverment_lockdown_command )
                else 
                    Ambi.DarkRP.OpenBoxMenu( 'Причина', 'Включить', '', function( sReason )
                        if GetConVar( 'ambi_darkrp_lockdown' ):GetBool() then return end

                        RunConsoleCommand( 'say', '/'..Ambi.DarkRP.Config.goverment_lockdown_command..' '..sReason )
                    end )
                end
            end )
            lockdown:SetImage( is_lockdown and icons.lockdown_close or icons.lockdown_open )
            SetupPanel( lockdown )
        end

        if Ambi.DarkRP.Config.cmenu_show_laws then
            local sub_setlaw, ed = amb_context_menu:AddSubMenu( 'Изменить Законы' )
            ed:SetImage( 'icon16/book.png' )
            for i, law in ipairs( Ambi.DarkRP.Laws() ) do
                local setlaw = sub_setlaw:AddOption( '['..i..'] '..law, function()
                    Ambi.DarkRP.OpenBoxMenu( 'Закон '..i, 'Изменить', "", function( sLaw ) 
                        RunConsoleCommand( 'say', '/'..Ambi.DarkRP.Config.goverment_laws_set_command..' '..i..' '..sLaw )
                    end )
                end )
                setlaw:SetImage( 'icon16/bullet_go.png' )
                SetupPanel( setlaw )
            end
            SetupPanel( ed )

            local clearlaws = amb_context_menu:AddOption( 'Очистить Законы', function()
                RunConsoleCommand( 'say', '/'..Ambi.DarkRP.Config.goverment_laws_clear_command )
            end )
            clearlaws:SetImage( 'icon16/book_addresses.png' )
            SetupPanel( clearlaws )
        end

        if Ambi.DarkRP.Config.cmenu_show_license then
            local givelicense = amb_context_menu:AddOption( 'Выдать Лицензию на Оружие', function()
                RunConsoleCommand( 'say', '/'..Ambi.DarkRP.Config.goverment_license_gun_command )
            end )
            givelicense:SetImage( 'icon16/page_add.png' )
            SetupPanel( givelicense )

            local removelicense = amb_context_menu:AddOption( 'Отобрать Лицензию на Оружие', function()
                RunConsoleCommand( 'say', '/'..Ambi.DarkRP.Config.goverment_license_gun_remove_command )
            end )
            removelicense:SetImage( 'icon16/page_delete.png' )
            SetupPanel( removelicense )

            local checklicense = amb_context_menu:AddOption( 'Проверить Лицензию на Оружие', function()
                RunConsoleCommand( 'say', '/'..Ambi.DarkRP.Config.goverment_license_gun_check_command )
            end )
            checklicense:SetImage( 'icon16/page_error.png' )
            SetupPanel( checklicense )
        end
    end

    amb_context_menu:AddSpacer()

    if Ambi.DarkRP.Config.cmenu_show_donate then
        local delay = 0
        local pin = table.Random( text_pin )
        local donate = amb_context_menu:AddOption( pin..' Магазин '..pin, function() 
            RunConsoleCommand( 'say', '/donate' )
            surface.PlaySound( 'ui/buttonclick.wav' )
        end )
        donate:SetImage( icons.shop )
        donate:SetFont( UI.SafeFont( '22 Ambi' ) )
        donate.Think = function()
            donate:SetTextColor( HSVToColor(  ( CurTime() * 22 ) % 360, 1, 1 ) )
            if ( CurTime() > delay ) then
                delay = CurTime() + 1.25
                donate:SetImage( table.Random( icons_donate ) )
            end
        end
        donate.OnCursorEntered = function()
            surface.PlaySound( 'ui/buttonrollover.wav' )
        end
        donate.Paint = function( self, w, h )
            Draw.Box( w, h, 0, 0, C.HOMEWAY_BLACK )
        end

        local permaweapons = amb_context_menu:AddOption( 'Перма Оружия', function() 
            RunConsoleCommand( 'ambi_hw_perma_weapons' )
        end )
        SetupPanel( permaweapons )

        local permamodels = amb_context_menu:AddOption( 'Перма Скины', function() 
            RunConsoleCommand( 'ambi_hw_perma_models' )
        end )
        SetupPanel( permamodels )

        local thirdview = amb_context_menu:AddOption( 'Вкл/Выкл Вид от 3 Лица', function() 
            RunConsoleCommand( 'ambi_hw_third_view' )
        end )
        SetupPanel( thirdview )

        amb_context_menu:AddSpacer()
    end

    if LocalPlayer():IsPolice() then
        if Ambi.DarkRP.Config.cmenu_show_wanted then
            local sub_wanted, ed = amb_context_menu:AddSubMenu( 'Розыск' )
            ed:SetImage( "icon16/group_edit.png" )
            for _, ply in ipairs( player.GetAll() ) do
                if ( LocalPlayer() == ply ) or ply:IsArrested() or ( ply:Alive() == false ) then continue end

                local wanted = sub_wanted:AddOption( ply:Nick(), function()
                    if not IsValid( ply ) then return end
                    if not Ambi.DarkRP.Config.police_system_enable then return end
                    if not Ambi.DarkRP.Config.police_system_wanted_enable then return end
                    if not LocalPlayer():IsPolice() then return end

                    if ply:IsWanted() then
                        net.Start( 'ambi_darkrp_police_wanted' )
                            net.WriteEntity( ply )
                            net.WriteString( '' )
                        net.SendToServer()
                    else
                        Ambi.DarkRP.OpenBoxMenu( "Причина", "Объявить", "", function( sReason ) 
                            if not LocalPlayer():IsPolice() then return end
                            if not Ambi.DarkRP.Config.police_system_enable then return end
                            if not Ambi.DarkRP.Config.police_system_wanted_enable then return end
                            if not IsValid( ply ) then return end
                            if ( utf8.len( sReason ) > 32 ) then return end
                            if ply:IsWanted() or ply:IsArrested() then return end

                            net.Start( 'ambi_darkrp_police_wanted' )
                                net.WriteEntity( ply )
                                net.WriteString( sReason )
                            net.SendToServer()
                        end )
                    end
                end )
                wanted:SetImage( ply:IsWanted() and 'icon16/user_delete.png' or 'icon16/user_add.png' )
                SetupPanel( wanted )
            end
            SetupPanel( ed )
        end

        if Ambi.DarkRP.Config.cmenu_show_warrant then
            local sub, ed = amb_context_menu:AddSubMenu( 'Ордер на Обыск' )
            ed:SetImage( 'icon16/group_edit.png' )
            for _, ply in ipairs( player.GetAll() ) do
                --if ( LocalPlayer() == ply ) then continue end

                local warrant = sub:AddOption( ply:Nick(), function()
                    local delay = LocalPlayer():GetDelay( 'AmbiDarkRPWarrantDelay' )
                    if not delay then LocalPlayer():SetDelay( 'AmbiDarkRPWarrantDelay', Ambi.DarkRP.Config.police_system_warrant_delay + 1 ) else chat.AddText( C.ERROR, '•  ', C.ABS_WHITE, 'Подождите: '..tostring( delay ) ) return end

                    if ply:HasWarrant() then
                        if not LocalPlayer():IsPolice() then return end
                        if not Ambi.DarkRP.Config.police_system_enable then return end
                        if not Ambi.DarkRP.Config.police_system_warrant_enable then return end
                        if not IsValid( ply ) then return end

                        net.Start( 'ambi_darkrp_police_warrant' )
                            net.WriteEntity( ply )
                            net.WriteString( '' )
                        net.SendToServer()
                    else
                        Ambi.DarkRP.OpenBoxMenu( "Причина", "Объявить", "", function( sReason ) 
                            if not LocalPlayer():IsPolice() then return end
                            if not Ambi.DarkRP.Config.police_system_enable then return end
                            if not Ambi.DarkRP.Config.police_system_warrant_enable then return end
                            if not IsValid( ply ) then return end
                            if ( utf8.len( sReason ) > 32 ) then return end

                            net.Start( 'ambi_darkrp_police_warrant' )
                                net.WriteEntity( ply )
                                net.WriteString( sReason )
                            net.SendToServer()
                        end )
                    end
                end )
                warrant:SetImage( ply:HasWarrant() and 'icon16/user_delete.png' or 'icon16/user_add.png' )
                SetupPanel( warrant )
            end
            SetupPanel( ed )
        end

        amb_context_menu:AddSpacer()
    end

    local inv = amb_context_menu:AddOption( 'Инвентарь', function() 
        local main = Ambi.Homeway.ShowF4Menu().main
        Ambi.Homeway.ShowPageInventory( main )
    end )
    inv:SetImage( 'icon16/briefcase.png' )
    SetupPanel( inv )

    local anim = amb_context_menu:AddOption( 'Анимации', function() 
        local main = Ambi.Homeway.ShowF4Menu().main
        Ambi.Homeway.ShowPageAnimation( main )
    end )
    anim:SetImage( 'icon16/user_female.png' )
    SetupPanel( anim )

    local promo = amb_context_menu:AddOption( 'Промокоды', function() 
        local main = Ambi.Homeway.ShowF4Menu().main
        Ambi.Homeway.ShowPagePromocodes( main )
    end )
    promo:SetImage( 'icon16/anchor.png' )
    SetupPanel( promo )

    local nav = amb_context_menu:AddOption( 'Навигация (GPS)', function() 
        local main = Ambi.Homeway.ShowF4Menu().main
        Ambi.Homeway.ShowPageNavigation( main )
    end )
    nav:SetImage( 'icon16/map.png' )
    SetupPanel( nav )

    local kits = amb_context_menu:AddOption( 'Kits', function() 
        RunConsoleCommand( 'ambi_hw_kits' ) 

        RunConsoleCommand( 'say', '/kits' )
    end )
    kits:SetImage( 'icon16/bricks.png' )
    SetupPanel( kits )

    local report = amb_context_menu:AddOption( 'Подать жалобу', function() 
        RunConsoleCommand( 'say', '/report' ) 
    end )
    report:SetImage( 'icon16/cancel.png' )
    SetupPanel( report )

    if Ambi.DarkRP.Config.doors_sell_all_doors_can and Ambi.DarkRP.Config.cmenu_show_sellalldoors then
        local sellalldoors = amb_context_menu:AddOption( 'Продать Все Двери', function() 
            RunConsoleCommand( 'say', '/'..Ambi.DarkRP.Config.doors_sell_all_command ) 
        end )
        sellalldoors:SetImage( icons.sellalldoors )
        SetupPanel( sellalldoors )
    end

    if Ambi.DarkRP.Config.buy_auto_ammo_enable and Ambi.DarkRP.Config.cmenu_show_buyautoammo then
        local ammo = amb_context_menu:AddOption( 'Купить Патроны', function() 
            RunConsoleCommand( 'say', '/'..Ambi.DarkRP.Config.buy_auto_ammo_command )
        end ) 
        ammo:SetImage( icons.ammo )
        SetupPanel( ammo )

        local ammo2 = amb_context_menu:AddOption( 'Купить Патроны (x10)', function() 
            RunConsoleCommand( 'say', '/'..Ambi.DarkRP.Config.buy_auto_ammo_command..' 10' )
        end ) 
        ammo2:SetImage( 'icon16/bullet_star.png' )
        SetupPanel( ammo2 )
    end

    if Ambi.DarkRP.Config.advert_enable and Ambi.DarkRP.Config.cmenu_show_advert then
        local advert = amb_context_menu:AddOption( 'Подать Рекламу', function() 
            Ambi.DarkRP.OpenBoxMenu( 'Реклама', 'Подать', '', function( str ) RunConsoleCommand( 'say', '/advert '..str ) end )
        end )
        advert:SetImage( icons.advert )
        advert:SetFont( UI.SafeFont( '18 Montserrat' ) )
        advert:SetTextColor( C.HOMEWAY_BLUE )
        advert.Paint = function( self, w, h )
            Draw.Box( w, h, 0, 0, C.HOMEWAY_BLACK )
        end
    end

    amb_context_menu:AddSpacer()

    if Ambi.DarkRP.Config.cmenu_show_demote then 
        local sub_demote, ed = amb_context_menu:AddSubMenu( 'Уволить' )
        ed:SetImage( 'icon16/user_delete.png' )
        local demote_front = sub_demote:AddOption( 'Игрок Напротив', function()
            RunConsoleCommand( 'say', '/'..Ambi.DarkRP.Config.jobs_demote_command )
        end )
        demote_front:SetImage( 'icon16/user.png' )
        SetupPanel( demote_front )
        
        for _, ply in pairs( player.GetAll() ) do
            if ( LocalPlayer() == ply ) then continue end
            if ( ply:Job() == Ambi.DarkRP.Config.jobs_class ) then continue end

            local demote = sub_demote:AddOption( ply:Nick(), function()
                if not IsValid( ply ) then chat.AddText( C.ERROR, '•  ', C.ABS_WHITE, 'Игрок вышел с сервера!' ) return end
                if ( ply:Job() == Ambi.DarkRP.Config.jobs_class ) then chat.AddText( C.ERROR, '•  ', C.ABS_WHITE, 'Игрок в стандартной работе, его нельзя уволить!' ) return end
                if not LocalPlayer():GetDelay( 'AmbiDarkRPDemote' ) then LocalPlayer():SetDelay( 'AmbiDarkRPDemote', 1 ) else return end

                net.Start( 'ambi_darkrp_demote_player' )
                    net.WriteEntity( ply )
                net.SendToServer()
            end )
            demote:SetImage( 'icon16/bullet_delete.png' )
            demote:SetFont( UI.SafeFont( '18 Montserrat' ) )
            demote:SetTextColor( C.HOMEWAY_BLUE )
            demote.Paint = function( self, w, h )
                Draw.Box( w, h, 0, 0, C.HOMEWAY_BLACK )
            end
        end
        ed:SetFont( UI.SafeFont( '18 Montserrat' ) )
        ed:SetTextColor( C.HOMEWAY_BLUE )
        ed.Paint = function( self, w, h )
            Draw.Box( w, h, 0, 0, C.HOMEWAY_BLACK )
        end
    end

    amb_context_menu:AddSpacer()

    if Ambi.DarkRP.Config.cmenu_show_givemoney then
        local givemoney = amb_context_menu:AddOption( 'Передать Деньги', function() 
            if ( LocalPlayer():GetMoney() <= 0 ) then chat.AddText( C.ERROR, '•  ', C.ABS_WHITE, 'У вас нет денег!' ) return end

            local ply = LocalPlayer():GetEyeTrace().Entity
            if not IsValid( ply ) or not ply:IsPlayer() then chat.AddText( C.ERROR, '•  ', C.ABS_WHITE, 'Нельзя передать деньги!' ) return end
            if ( LocalPlayer():Distance( ply ) > Ambi.DarkRP.Config.money_give_distance ) then chat.AddText( C.ERROR, '•  ', C.ABS_WHITE, 'Нельзя передать деньги на таком расстояний!' ) return end

            Ambi.DarkRP.OpenBoxMenu( 'Сумма', 'Передать', '', function( summ ) RunConsoleCommand( 'say', '/'..Ambi.DarkRP.Config.money_give_command..' '..summ ) end )
        end )
        givemoney:SetImage( icons.money )
        SetupPanel( givemoney )
    end

    if Ambi.DarkRP.Config.cmenu_show_dropmoney then
        local dropmoney = amb_context_menu:AddOption( 'Выкинуть Деньги', function() 
            if ( LocalPlayer():GetMoney() <= 0 ) then chat.AddText( C.ERROR, '•  ', C.ABS_WHITE, 'У вас нет денег!' ) return end

            Ambi.DarkRP.OpenBoxMenu( 'Сумма', 'Выкинуть', '', function( summ ) RunConsoleCommand( 'say', '/'..Ambi.DarkRP.Config.money_drop_command..' '..summ ) end )
        end )
        dropmoney:SetImage( icons.change_money )
        SetupPanel( dropmoney )
    end

    local showlaws = amb_context_menu:AddOption( 'Показать законы', function() 
        Ambi.Homeway.OpenLawsMenu()
    end )
    showlaws:SetImage( 'icon16/note.png' )
    SetupPanel( showlaws )

    amb_context_menu:AddSpacer()

    if Ambi.DarkRP.Config.cmenu_show_dropgun then
        local dropgun = amb_context_menu:AddOption( 'Выкинуть оружие', function() 
            RunConsoleCommand( 'say', '/'..Ambi.DarkRP.Config.weapon_drop_command )
        end )
        dropgun:SetImage( icons.dropweapon )
        SetupPanel( dropgun )
    end

    amb_context_menu:Open()

    local posx = bLeft and 4 or ( W / 2 - amb_context_menu:GetWide() / 2 )
    local posy = bLeft and ( H / 2 - amb_context_menu:GetTall() / 2 ) or ( H - amb_context_menu:GetTall() - 8 )
    amb_context_menu:SetPos( posx, posy )

    return amb_context_menu
end

function Ambi.Homeway.OpenBoxMenu( sTitle, sBtn, sText, func )
    local amb_context_framebox = vgui.Create( 'DFrame' )
    amb_context_framebox:SetTitle( sTitle )
    amb_context_framebox:ShowCloseButton( true )
    amb_context_framebox:MakePopup()
    amb_context_framebox:SetSize( 250, 100 )
    amb_context_framebox:Center()
    amb_context_framebox:SetKeyboardInputEnabled( true )
    amb_context_framebox:SetMouseInputEnabled( true )
    amb_context_framebox.Paint = function( self, w, h )
        --draw.RoundedBox ( 0, 0, 0, w, h, C.ABS_WHITE )
        --draw.RoundedBox ( 0, 1, 1, w-2, h-2, C.ABS_BLACK )
    end
 
    local amb_context_framebox_te = vgui.Create( 'DTextEntry', amb_context_framebox )
    amb_context_framebox_te:SetPos( 25, 25 )
    amb_context_framebox_te:SetSize( 210, 30 )
    amb_context_framebox_te:SetMultiline( false )
    amb_context_framebox_te:SetAllowNonAsciiCharacters( true )
    amb_context_framebox_te:SetText( sText )
    amb_context_framebox_te:SetEnterAllowed( true )
 
    local amb_context_framebox_btn = vgui.Create( 'DButton', amb_context_framebox )
    amb_context_framebox_btn:SetText( sBtn )
    amb_context_framebox_btn:SetSize( 110, 20 )
    amb_context_framebox_btn:SetPos( 75, 70 )
    amb_context_framebox_btn.DoClick = function()
        func( amb_context_framebox_te:GetValue() )
        amb_context_framebox:Remove()
    end

    amb_context_framebox.Think = function( self )
        if input.IsKeyDown( KEY_ENTER ) then
            func( amb_context_framebox_te:GetValue() )
            self:Remove()
        end
    end
end

-- ---------------------------------------------------------------------------------------------------------------------------------------
hook.Add( 'OnContextMenuOpen', 'Ambi.Homeway.OpenContexMenu', function()
    timer.Simple( 0, function() Ambi.Homeway.OpenContextMenu( true ) end )
end )

hook.Add( 'OnContextMenuClose', 'Ambi.Homeway.CloseContexMenu', function()
    if ValidPanel( pnl2 ) then pnl2:Remove() end
end )