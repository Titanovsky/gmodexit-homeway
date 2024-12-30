local C, GUI, Draw, UI, CL = Ambi.Packages.Out( '@d, ContentLoader' )

local W, H = ScrW(), ScrH()
local COLOR_PANEL = Color( 0, 0, 0, 220 ) 
local COLOR_PANEL2 = Color(15, 29, 37, 220 ) 
local COLOR_TEXT = Color(46, 46, 46)

local SOUND_CLICK = 'ambi/ui/click_tower_unite.wav'

-- ---------------------------------------------------------------------------------------------------------------------------------------
local function SetupOnChangeCursor( vguiPanel, cTextColorDefault, cTextColor, cBackgroundDefault, cBackground )
    vguiPanel.color_text = cTextColorDefault
    vguiPanel.color_background = cBackgroundDefault

    GUI.OnCursor( vguiPanel, function( self ) 
        surface.PlaySound( 'ambi/ui/hover7.wav' )

        self.color_text = cTextColor
        self.color_background = cBackground
    end, function( self ) 
        self.color_text = cTextColorDefault
        self.color_background = cBackgroundDefault
    end )
end

local function ShowMainPanel( vguiMain )
    local main = vguiMain

    main:Clear()

    local ply_time_h = math.floor( LocalPlayer():GetTime() / 60 / 60 )

    local panel1 = GUI.DrawButton( main, main:GetWide() * .32, main:GetTall() * .45, 0, 0, nil, nil, nil, function()
        surface.PlaySound( SOUND_CLICK )

        Ambi.Homeway.RemoveF4Menu()

        UI.Chat.Send( '~HOMEWAY_BLUE~ • ~W~ Вы играете на сервере ~HOMEWAY_BLUE~ Homeway' )
        UI.Chat.Send( '~HOMEWAY_BLUE~ • ~W~ '..game.GetIPAddress() )
    end, function( self, w, h ) 
        Draw.Box( w, h, 0, 0, self.color_background, 6 )

        Draw.Material( w * .75, h, w / 2 - (w * .75 / 2), 0, CL.Material( 'hw_f4menu_page_1' ) )

        Draw.SimpleText( 4, 64, LocalPlayer():Name(), UI.SafeFont( '32 Montserrat Light' ), COLOR_TEXT, 'top-left' )
        Draw.SimpleText( 4, 64 + 26, LocalPlayer():GetMoney()..'$', UI.SafeFont( '24 Montserrat' ), C.GREEN, 'top-left' )
        Draw.SimpleText( 4, 64 + 26 * 2, ply_time_h..' часов', UI.SafeFont( '24 Montserrat Medium' ), COLOR_TEXT, 'top-left' )

        Draw.SimpleText( 4, h - 4, game.IsDedicated() and game.GetIPAddress() or '', UI.SafeFont( '18 Montserrat SemiBold' ), COLOR_TEXT, 'bottom-left' )
    end )
    SetupOnChangeCursor( panel1, C.WHITE, C.HOMEWAY_BLUE, C.HOMEWAY_WHITE, Color( 213, 220, 223) )

    local panel2 = GUI.DrawButton( main, main:GetWide() * .15, main:GetTall() * .2, panel1:GetWide() + 20, 0, nil, nil, nil, function()
        surface.PlaySound( SOUND_CLICK )

        Ambi.Homeway.ShowPageStats( vguiMain )
    end, function( self, w, h ) 
        Draw.Box( w, h, 0, 0, self.color_background, 6 )

        Draw.Material( w, h, w - w * 0.8, h - h * 0.8, CL.Material( 'hw_f4menu_icon_stats' ) )

        Draw.SimpleText( 8, 8, 'Статистика', UI.SafeFont( '22 Montserrat Medium' ), self.color_text, 'top-left' )
    end )
    SetupOnChangeCursor( panel2, C.WHITE, C.HOMEWAY_BLUE, COLOR_PANEL, COLOR_PANEL2 )

    local panel3 = GUI.DrawButton( main, main:GetWide() * .15, main:GetTall() * .2, panel1:GetWide() + panel2:GetWide() + (20 * 2), 0, nil, nil, nil, function()
        Ambi.Homeway.ShowPageInventory( vguiMain )

        surface.PlaySound( SOUND_CLICK )
    end, function( self, w, h ) 
        Draw.Box( w, h, 0, 0, self.color_background, 6 )

        Draw.Material( w, h, w - w * 0.8, h - h * 0.8, CL.Material( 'hw_f4menu_icon_backpack' ) )

        Draw.SimpleText( 8, 8, 'Инвентарь', UI.SafeFont( '22 Montserrat Medium' ), self.color_text, 'top-left' )
    end )
    SetupOnChangeCursor( panel3, C.WHITE, C.HOMEWAY_BLUE, COLOR_PANEL, COLOR_PANEL2 )

    local panel4 = GUI.DrawButton( main, main:GetWide() * .15, main:GetTall() * .2, panel1:GetWide() + panel2:GetWide() + panel3:GetWide() + (20 * 3), 0, nil, nil, nil, function()
        Ambi.Homeway.ShowPageJobs( vguiMain )

        surface.PlaySound( SOUND_CLICK )
    end, function( self, w, h ) 
        Draw.Box( w, h, 0, 0, self.color_background, 6 )

        Draw.Material( w, h, w - w * .8, h - h * .8, CL.Material( 'hw_f4menu_icon_job' ) )

        Draw.SimpleText( 8, 8, 'Работы', UI.SafeFont( '22 Montserrat Medium' ), self.color_text, 'top-left' )
    end )
    SetupOnChangeCursor( panel4, C.WHITE, C.HOMEWAY_BLUE, COLOR_PANEL, COLOR_PANEL2 )

    -- border
    local online, max = #player.GetHumans(), game.MaxPlayers()
    local panel5 = GUI.DrawButton( main, main:GetWide() - (panel1:GetWide() + panel2:GetWide() + panel3:GetWide() + panel4:GetWide() + (20 * 4)), main:GetTall() * .2, panel1:GetWide() + panel2:GetWide() + panel3:GetWide() + panel4:GetWide() + (20 * 4), 0, nil, nil, nil, function()
        if IsValid( Ambi.Homeway.tab ) then return end

        Ambi.Homeway.RemoveF4Menu()

        Ambi.Homeway.ShowTab()

        surface.PlaySound( SOUND_CLICK )
    end, function( self, w, h ) 
        Draw.Box( w, h, 0, 0, self.color_background, 6 )

        Draw.Material( w, h, w - w * .8, h - h * .8, CL.Material( 'hw_f4menu_icon_planet' ) )

        Draw.SimpleText( 8, 8, 'Сервер', UI.SafeFont( '22 Montserrat Medium' ), self.color_text, 'top-left' )

        Draw.SimpleText( w - 2, 4, '•', UI.SafeFont( '28 Ambi' ), C.GREEN, 'top-right' )
        Draw.SimpleText( w - 20, 4, online, UI.SafeFont( '24 Ambi' ), C.WHITE, 'top-right' )
    end )
    SetupOnChangeCursor( panel5, C.WHITE, C.HOMEWAY_BLUE, COLOR_PANEL, COLOR_PANEL2 )

    local panel6 = GUI.DrawButton( main, main:GetWide() * .15, main:GetTall() * .2, panel1:GetWide() + 20, panel1:GetTall() - main:GetTall() * .2, nil, nil, nil, function()
        Ambi.Homeway.ShowPageNavigation( vguiMain )

        surface.PlaySound( SOUND_CLICK )
    end, function( self, w, h ) 
        Draw.Material( w, h, 0, 0, CL.Material( 'hw_f4menu_bg_blue' ), self.color_background )

        Draw.Material( w, h, -w + w * .75, h - h * .75, CL.Material( 'hw_f4menu_icon_nav_blue' ) )

        Draw.SimpleText( w - 4, 4, 'Навигация', UI.SafeFont( '24 Montserrat Medium' ), self.color_text, 'top-right', 1, C.BLACK )
    end )
    SetupOnChangeCursor( panel6, C.WHITE, C.HOMEWAY_BLUE, C.WHITE, ColorAlpha( C.WHITE, 150 ) )

    local panel7 = GUI.DrawButton( main, main:GetWide() * .15, main:GetTall() * .2, panel1:GetWide() + panel2:GetWide() + (20 * 2), panel1:GetTall() - main:GetTall() * .2, nil, nil, nil, function()
        Ambi.Homeway.ShowPageSettings( vguiMain )

        surface.PlaySound( SOUND_CLICK )
    end, function( self, w, h ) 
        Draw.Material( w, h, 0, 0, CL.Material( 'hw_f4menu_bg_green' ), self.color_background )

        Draw.Material( w, h, -w + w * .75, h - h * .75, CL.Material( 'hw_f4menu_icon_gears_green' ) )

        Draw.SimpleText( w - 4, 4, 'Настройки', UI.SafeFont( '24 Montserrat Medium' ), self.color_text, 'top-right', 1, C.BLACK )
    end )
    SetupOnChangeCursor( panel7, C.WHITE, C.HOMEWAY_BLUE, C.WHITE, ColorAlpha( C.WHITE, 150 ) )

    local panel8 = GUI.DrawButton( main, main:GetWide() * .15, main:GetTall() * .2, panel1:GetWide() + panel2:GetWide() + panel3:GetWide() + (20 * 3), panel1:GetTall() - main:GetTall() * .2, nil, nil, nil, function()
        Ambi.Homeway.ShowPageAnimation( vguiMain )

        surface.PlaySound( SOUND_CLICK )
    end, function( self, w, h ) 
        Draw.Material( w, h, 0, 0, CL.Material( 'hw_f4menu_bg_purple' ), self.color_background )

        Draw.Material( w, h, -w + w * .8, h - h * .9, CL.Material( 'hw_f4menu_icon_dancing_purple' ) )

        Draw.SimpleText( w - 4, 4, 'Анимации', UI.SafeFont( '24 Montserrat Medium' ), self.color_text, 'top-right', 1, C.BLACK )
    end )
    SetupOnChangeCursor( panel8, C.WHITE, C.HOMEWAY_BLUE, C.WHITE, ColorAlpha( C.WHITE, 150 ) )

    -- border
    local panel9 = GUI.DrawButton( main, main:GetWide() - (panel1:GetWide() + panel2:GetWide() + panel3:GetWide() + panel4:GetWide() + (20 * 4)), main:GetTall() * .2, panel1:GetWide() + panel2:GetWide() + panel3:GetWide() + panel4:GetWide() + (20 * 4), panel1:GetTall() - main:GetTall() * .2, nil, nil, nil, function()
        Ambi.Homeway.ShowPageGuide( vguiMain )

        surface.PlaySound( SOUND_CLICK )
    end, function( self, w, h ) 
        Draw.Material( w, h, 0, 0, CL.Material( 'hw_f4menu_bg_orange' ), self.color_background )

        Draw.Material( w, h, -w + w * .8, h - h * .9, CL.Material( 'hw_f4menu_icon_question_orange' ) )

        Draw.SimpleText( w - 4, 4, 'Помощь', UI.SafeFont( '24 Montserrat Medium' ), self.color_text, 'top-right', 1, C.BLACK )
    end )
    SetupOnChangeCursor( panel9, C.WHITE, C.HOMEWAY_BLUE, C.WHITE, ColorAlpha( C.WHITE, 150 ) )

    local panel10 = GUI.DrawButton( main, main:GetWide() * .32, main:GetTall() * .2, 0, panel1:GetTall() + 20, nil, nil, nil, function()
        Ambi.Homeway.ShowPageShop( vguiMain )

        surface.PlaySound( SOUND_CLICK )
    end, function( self, w, h ) 
        Draw.Box( w, h, 0, 0, self.color_background, 6 )

        Draw.SimpleText( w / 2, 0, 'МАГАЗИН', UI.SafeFont( '32 Montserrat SemiBold' ), self.color_text, 'top-center' )

        Draw.Material( w * .3, h * .75, w / 2 - (w * .3) / 2, h - h * .75, CL.Material( 'hw_f4menu_icon_shop' ) )
    end )
    SetupOnChangeCursor( panel10, C.HOMEWAY_WHITE, C.HOMEWAY_BLUE, C.HOMEWAY_BLACK, COLOR_PANEL2 )

    local panel11 = GUI.DrawButton( main, main:GetWide() * .32, main:GetTall() * .2, panel10:GetWide() + 20, panel1:GetTall() + 20, nil, nil, nil, function()
        Ambi.Homeway.RemoveF4Menu()
        IGS.UI()

        surface.PlaySound( SOUND_CLICK )
    end, function( self, w, h ) 
        Draw.Box( w, h, 0, 0, self.color_background, 6 )

        Draw.Material( w * .5, h, w - w * .45, h - h * .75, CL.Material( 'hw_f4menu_icon_gold' ) )

        Draw.SimpleText( w / 2 + self.x_text, -6, 'ДОНАТ', UI.SafeFont( '46 Montserrat SemiBold' ), self.color_text, 'top-center' )

        self.rainbow_color = HSVToColor( ( CurTime() * 100 ) % 360, 1, 1 )

        Draw.Box( w - 32, 6, 16, 46 - 4, self.rainbow_color, 6 )
    end )
    SetupOnChangeCursor( panel11, C.BLACK, C.HOMEWAY_BLUE, C.HOMEWAY_WHITE, C.WHITE )
    panel11.x_text = 0
    panel11.x_text_left = false
    timer.Create( 'f4menu_donate_change_x_text', 0.02, 0, function() 
        if not IsValid( panel11 ) then timer.Remove( 'f4menu_donate_change_x_text' ) return end

        local x = panel11.x_text
        if ( x > 45 ) then panel11.x_text_left = true end
        if ( x < -45 ) then panel11.x_text_left = false end

        x = x + (1 * ( panel11.x_text_left and -1 or 1 ))
        panel11.x_text = x
    end )

    -- border
    local panel12 = GUI.DrawButton( main, main:GetWide() - (panel10:GetWide() + panel11:GetWide() + (20 * 2)), main:GetTall() * .2, panel10:GetWide() + panel11:GetWide() + (20 * 2), panel1:GetTall() + 20, nil, nil, nil, function()
        Ambi.Homeway.RemoveF4Menu()
        gui.OpenURL( Ambi.ChatCommands.Config.url_content )

        surface.PlaySound( SOUND_CLICK )
    end, function( self, w, h ) 
        Draw.Box( w, h, 0, 0, self.color_background, 6 )

        Draw.SimpleText( 12, 4, 'Скачать Контент', UI.SafeFont( '36 Montserrat SemiBold' ), self.color_text, 'top-left' )
    end )
    SetupOnChangeCursor( panel12, C.WHITE, C.RU_RED, COLOR_PANEL, COLOR_PANEL2 )

    local panel13 = GUI.DrawButton( main, main:GetWide() * .32, main:GetTall() * .2, 0, panel1:GetTall() + panel10:GetTall() + (20 * 2), nil, nil, nil, function()
        Ambi.Homeway.RemoveF4Menu()
        
        gui.OpenURL( 'https://docs.google.com/document/d/17yinWfQsSSjkMktY5hoVnx5jzP98fYCp-MoZlaieSCM' )

        surface.PlaySound( SOUND_CLICK )
    end, function( self, w, h ) 
        Draw.Box( w, h, 0, 0, self.color_background, 6 )

        Draw.Material( 128, 128, 0, 0, CL.Material( 'hw_f4menu_icon_rules' ) )
        --todo text changer
        Draw.SimpleText( w - 32, 4, 'ПРАВИЛА', UI.SafeFont( '36 Montserrat SemiBold' ), self.color_text, 'top-right', 1, C.BLACK )
    end )
    SetupOnChangeCursor( panel13, C.WHITE, C.HOMEWAY_BLUE, COLOR_PANEL, COLOR_PANEL2 )

    local online = 0
    if LocalPlayer():HasOrg() then
        for k, v in pairs( player.GetAll() ) do
            if v:HasOrg() and ( v:GetOrgID() == LocalPlayer():GetOrgID() ) then online = online + 1 end
        end
    end
    local panel14 = GUI.DrawButton( main, main:GetWide() * .15, main:GetTall() * .2, panel13:GetWide() + 20, panel1:GetTall() + panel10:GetTall() + (20 * 2), nil, nil, nil, function()
        Ambi.Homeway.RemoveF4Menu()

        if LocalPlayer():GetNWBool( 'amb_players_orgs' ) then 
            RunConsoleCommand( 'ambi_org2_menu' ) 
        else
            Ambi.Homeway.Notify( 'Вступите или создайте организацию (NPC у спавна)', 10, NOTIFY_ERROR )
        end

        surface.PlaySound( SOUND_CLICK )
    end, function( self, w, h ) 
        Draw.Box( w, h, 0, 0, self.color_background, 6 )

        Draw.SimpleText( 4, 4, 'Организация', UI.SafeFont( '22 Montserrat Medium' ), self.color_text, 'top-left', 1, C.BLACK )

        if ( online > 0 ) then
            Draw.SimpleText( 4, h - 12, '•', UI.SafeFont( '40 Montserrat Medium' ), C.GREEN, 'bottom-left', 1, C.BLACK )
            Draw.SimpleText( 24, h - 16, online, UI.SafeFont( '28 Montserrat Medium' ), C.WHITE, 'bottom-left', 1, C.BLACK )
        end

        Draw.Material( w * 0.75, h * .75, w - w * .75 + 14, h - h * .75 + 14, CL.Material( 'hw_f4menu_icon_party' ) )
    end )
    SetupOnChangeCursor( panel14, C.WHITE, C.HOMEWAY_BLUE, COLOR_PANEL, COLOR_PANEL2 )

    local panel15 = GUI.DrawButton( main, main:GetWide() * .15, main:GetTall() * .2, panel13:GetWide() + panel14:GetWide() + (20 * 2), panel1:GetTall() + panel10:GetTall() + (20 * 2), nil, nil, nil, function()
        Ambi.Homeway.ShowPageDaily( vguiMain )

        surface.PlaySound( SOUND_CLICK )
    end, function( self, w, h ) 
        Draw.Box( w, h, 0, 0, self.color_background, 6 )

        Draw.SimpleText( 4, 4, 'Задания', UI.SafeFont( '28 Montserrat Medium' ), self.color_text, 'top-left', 1, C.BLACK )

        Draw.Material( w * 0.75, h * .75, w - w * .75 + 14, h - h * .75 + 14, CL.Material( 'hw_f4menu_icon_target' ) )
    end )
    SetupOnChangeCursor( panel15, C.WHITE, C.HOMEWAY_BLUE, COLOR_PANEL, COLOR_PANEL2 )

    local panel16 = GUI.DrawButton( main, main:GetWide() * .15, main:GetTall() * .2, panel13:GetWide() + panel14:GetWide() + panel15:GetWide() + (20 * 3), panel1:GetTall() + panel10:GetTall() + (20 * 2), nil, nil, nil, function()
        Ambi.Homeway.RemoveF4Menu()
        LocalPlayer():ConCommand( 'say /report' )

        surface.PlaySound( SOUND_CLICK )
    end, function( self, w, h ) 
        Draw.Box( w, h, 0, 0, self.color_background, 6 )

        Draw.SimpleText( 4, 4, 'Репорт', UI.SafeFont( '28 Montserrat Medium' ), self.color_text, 'top-left', 1, C.BLACK )

        Draw.Material( w * 0.75, h * .75, w - w * .75 + 14, h - h * .75 + 14, CL.Material( 'hw_f4menu_icon_report' ) )
    end )
    SetupOnChangeCursor( panel16, C.WHITE, C.HOMEWAY_BLUE, COLOR_PANEL, COLOR_PANEL2 )

    -- border
    local panel17 = GUI.DrawButton( main, main:GetWide() - (panel13:GetWide() + panel14:GetWide() + panel16:GetWide() + panel15:GetWide() + (20 * 4)), main:GetTall() * .2, panel13:GetWide() + panel14:GetWide() + panel16:GetWide() + panel15:GetWide() + (20 * 4), panel1:GetTall() + panel10:GetTall() + (20 * 2), nil, nil, nil, function()
        Ambi.Homeway.ShowPageNews( vguiMain )

        surface.PlaySound( SOUND_CLICK )
    end, function( self, w, h ) 
        Draw.Box( w, h, 0, 0, self.color_background, 6 )

        Draw.SimpleText( 4, 4, 'Новости', UI.SafeFont( '28 Montserrat Medium' ), self.color_text, 'top-left', 1, C.BLACK )

        Draw.Material( w * 0.75, h * .75, w - w * .75 + 14, h - h * .75 + 14, CL.Material( 'hw_f4menu_icon_news' ) )
    end )
    SetupOnChangeCursor( panel17, C.WHITE, C.HOMEWAY_BLUE, COLOR_PANEL, COLOR_PANEL2 )

    local panel18 = GUI.DrawButton( main, main:GetWide() * .32, main:GetTall() - (panel1:GetTall() + panel10:GetTall() + panel13:GetTall() + (20 * 2) + 10), 0, panel1:GetTall() + panel10:GetTall() + panel13:GetTall() + (20 * 2) + 10, nil, nil, nil, function()
        Ambi.Homeway.RemoveF4Menu()

        local url = Ambi.ChatCommands.Config.url_discord

        gui.OpenURL( url )
        SetClipboardText( url )

        UI.Chat.Send( '~HOMEWAY_BLUE~ • Набор в администрацию через дискорд' )

        surface.PlaySound( SOUND_CLICK )
    end, function( self, w, h ) 
        Draw.Box( w, h, 0, 0, self.color_background, 6 )

        Draw.Material( 64, 64, w - 64, 0, CL.Material( 'hw_f4menu_icon_vacancy' ) )

        Draw.SimpleText( 16, h / 2 - 4, 'ВАКАНСИИ', UI.SafeFont( '36 Montserrat SemiBold' ), self.color_text, 'center-left' )
    end )
    SetupOnChangeCursor( panel18, C.BLACK, C.WHITE, C.UK_WHITE, C.BLACK )

    local panel19 = GUI.DrawButton( main, main:GetWide() * .32, main:GetTall() - (panel1:GetTall() + panel10:GetTall() + panel13:GetTall() + (20 * 2) + 10), panel18:GetWide() + 20, panel1:GetTall() + panel10:GetTall() + panel13:GetTall() + (20 * 2) + 10, nil, nil, nil, function()
        Ambi.Homeway.RemoveF4Menu()

        local url = Ambi.ChatCommands.Config.url_discord

        gui.OpenURL( url )
        SetClipboardText( url )

        UI.Chat.Send( '~HOMEWAY_BLUE~ • ~W~ Дискорд: ~HOMEWAY_BLUE~ '..url )

        surface.PlaySound( SOUND_CLICK )
    end, function( self, w, h ) 
        Draw.Box( w, h, 0, 0, self.color_background, 6 )

        Draw.Material( 64, 64, w - 64, h / 2 - 32, CL.Material( 'hw_f4menu_icon_discord' ), self.color_text )

        Draw.SimpleText( 16, h / 2 - 4, 'Discord', UI.SafeFont( '36 Montserrat Medium' ), self.color_text, 'center-left' )
    end )
    SetupOnChangeCursor( panel19, C.HOMEWAY_BLUE, C.WHITE, COLOR_PANEL, COLOR_PANEL2 )

    -- border
    local panel20 = GUI.DrawButton( main, main:GetWide() - (panel18:GetWide() + panel19:GetWide() + (20 * 2)), main:GetTall() - (panel1:GetTall() + panel10:GetTall() + panel13:GetTall() + (20 * 2) + 10), panel18:GetWide() + panel19:GetWide() + (20 * 2), panel1:GetTall() + panel10:GetTall() + panel13:GetTall() + (20 * 2) + 10, nil, nil, nil, function()
        Ambi.Homeway.ShowPagePromocodes( vguiMain )

        surface.PlaySound( SOUND_CLICK )
    end, function( self, w, h ) 
        Draw.Box( w, h, 0, 0, self.color_background, 6 )

        Draw.Material( 64, 64, w - 64, 0, CL.Material( 'hw_f4menu_icon_referals' ) )

        Draw.SimpleText( 16, h / 2 - 4, 'Промокоды', UI.SafeFont( '36 Montserrat Medium' ), self.color_text, 'center-left' )
    end )
    SetupOnChangeCursor( panel20, C.HOMEWAY_BLUE, C.WHITE, COLOR_PANEL, COLOR_PANEL2 )
end

-- ---------------------------------------------------------------------------------------------------------------------------------------
function Ambi.Homeway.ShowF4Menu( nPage )
    if not LocalPlayer():Alive() then return end
    if not LocalPlayer():IsAuth() then return end

    if IsValid( Ambi.Homeway.f4menu ) then Ambi.Homeway.f4menu:Remove() end  

    surface.PlaySound( 'ambi/ui/hover4.wav' )

    local frame = GUI.DrawFrame( nil, W, H, 0, 0, '', true, false, false, function( self, w, h ) 
        if not LocalPlayer():Alive() then Ambi.Homeway.RemoveF4Menu() return end

        Draw.Box( w, h, 0, 0, COLOR_PANEL )

        if not self.main then return end

        Draw.Material( w, h, 0, 0, CL.Material( 'hw_f4menu_background' ) )
        Draw.Material( 128, 128, w / 2 - 128 / 2, 24, CL.Material( 'hw_watermark2' ) )
    end )
    frame.cant_remove = true
    frame:SetAlpha( 0 )
    frame:AlphaTo( 255, 0.45, 0, function() frame.cant_remove = false end )
    frame.OnKeyCodePressed = function( self, nKey )
        if ( nKey == KEY_F4 ) or ( nKey == KEY_SPACE ) or ( nKey == KEY_TAB ) and ( not Ambi.Homeway.f4menu.cant_remove ) then Ambi.Homeway.RemoveF4Menu() return end
    end
    frame.OnRemove = function()
        timer.Create( 'Ambi.Homeway.DarkRPF4Menu', 0.25, 1, function() end )
    end

    local main = GUI.DrawPanel( frame, frame:GetWide() * .64, frame:GetTall() * .64, 0, 0, function( self, w, h ) 
        -- Draw.Box( w, h, 0, 0, COLOR_PANEL ) -- debug
    end ) 
    main:Center()
    frame.main = main

    local back = GUI.DrawButton( frame, main:GetWide() * .1, 40, main:GetX(), main:GetY() - 40 - 6, nil, nil, nil, function( self )
        self:SetVisible( false )

        surface.PlaySound( SOUND_CLICK )

        ShowMainPanel( main )
    end, function( self, w, h ) 
        Draw.Box( w, h, 0, 0, COLOR_PANEL, 6 )

        Draw.SimpleText( w / 2, h / 2, '<<', UI.SafeFont( '64 Montserrat' ), C.HOMEWAY_BLUE, 'center' )
    end )
    back:SetVisible( false )
    main.back = back

    ShowMainPanel( main )

    Ambi.Homeway.f4menu = frame

    return Ambi.Homeway.f4menu
end
concommand.Add( 'ambi_hw_f4', Ambi.Homeway.ShowF4Menu )

function Ambi.Homeway.HasF4Menu()
    return IsValid( Ambi.Homeway.f4menu )
end

function Ambi.Homeway.RemoveF4Menu()
    if IsValid( Ambi.Homeway.f4menu ) then 
        Ambi.Homeway.f4menu.cant_remove = true
        Ambi.Homeway.f4menu:AlphaTo( 0, 0.25, 0, function() surface.PlaySound( 'ambi/ui/hover5.wav' ) Ambi.Homeway.f4menu:Remove() end )
    end
end

-- ---------------------------------------------------------------------------------------------------------------------------------------
hook.Add( 'PlayerButtonDown', 'Ambi.Homeway.ShowF4Menu', function( _, nButton ) 
    if not input.IsKeyDown( KEY_F4 ) then return end
    if timer.Exists( 'Ambi.Homeway.DarkRPF4Menu' ) then return end

    timer.Create( 'Ambi.Homeway.DarkRPF4Menu', 0.25, 1, function() end )

    Ambi.Homeway.ShowF4Menu()
end )