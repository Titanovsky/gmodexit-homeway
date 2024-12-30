local C, GUI, Draw, UI = Ambi.Packages.Out( '@d' )

local W, H = ScrW(), ScrH()
local COLOR_PANEL = Color( 0, 0, 0, 200 ) 

local SOUND_CLICK = 'ambi/ui/click_tower_unite.wav'

-- ---------------------------------------------------------------------------------------------------------------------------------------
function Ambi.Homeway.ShowPagePromocodes( vguiMain )
    local main = vguiMain

    main.back:SetVisible( true )
    main:Clear()
    
    local panel = GUI.DrawPanel( main, main:GetWide() * .25, main:GetTall() * .25, 0, 0, function( self, w, h )
        Draw.Box( w, h, 0, 0, C.HOMEWAY_BLACK, 6 )
    end )
    panel:Center()

    local subpanel = GUI.DrawPanel( panel, panel:GetWide() - 16, panel:GetTall() - 16, 8, 8, function( self, w, h )
    end )

    local activate = GUI.DrawButton( subpanel, subpanel:GetWide(), subpanel:GetTall() / 2, 0, 0, nil, nil, nil, function()
        surface.PlaySound( SOUND_CLICK )

        panel:Clear()
        panel:SetSize( main:GetWide() * .75, main:GetTall() * .5 )
        panel:Center()

        local subpanel = GUI.DrawPanel( panel, panel:GetWide() - 16, panel:GetTall() - 16, 8, 8, function( self, w, h )
            Draw.Box( w, h, 0, 0, C.HOMEWAY_BLUE_DARK, 6 )

            Draw.SimpleText( w / 2, 4, 'Промокод', UI.SafeFont( '32 Montserrat SemiBold' ), C.FLAT_GREEN, 'top-center' )
            Draw.SimpleText( w / 2, 44, '• Введите промокод в белое поле', UI.SafeFont( '24 Montserrat' ), C.HOMEWAY_WHITE, 'top-center' )
            Draw.SimpleText( w / 2, 44 + 24 + 4, '• Промокод от игрока можно вести до 2 часов игры', UI.SafeFont( '24 Montserrat' ), C.HOMEWAY_WHITE, 'top-center' )
        end )

        local promo = GUI.DrawTextEntry( subpanel, 300, 36, 0, 0, UI.SafeFont( '32 Montserrat' ), C.BLACK, nil, C.AMBI_GRAY, 'Вводить сюда', false, false )
        promo:Center()

        local send = GUI.DrawButton( subpanel, 240, 40, 0, 0, nil, nil, nil, function()
            surface.PlaySound( SOUND_CLICK )

            net.Start( 'ambi_homeway_activate_user_promocode' )
                net.WriteString( tostring( promo:GetValue() ) )
            net.SendToServer()
    
            Ambi.Homeway.RemoveF4Menu()
        end, function( self, w, h ) 
            Draw.Box( w, h, 0, 0, COLOR_PANEL, 8 )
    
            Draw.SimpleText( w / 2, h / 2, 'Активировать', UI.SafeFont( '36 Montserrat' ), C.HOMEWAY_WHITE, 'center' )
        end )
        send:Center()
        send:SetY( subpanel:GetTall() - 40 - 12 )
    end, function( self, w, h ) 
        Draw.Box( w, h, 0, 0, C.HOMEWAY_BLUE_DARK, 6 )

        Draw.SimpleText( w / 2, h / 2, 'Ввести промокод', UI.SafeFont( '28 Montserrat' ), C.FLAT_GREEN, 'center' )
    end )

    local make = GUI.DrawButton( subpanel, subpanel:GetWide(), subpanel:GetTall() / 2 - 8, 0, activate:GetTall() + 8, nil, nil, nil, function()
        surface.PlaySound( SOUND_CLICK )

        panel:Clear()
        panel:SetSize( main:GetWide() * .75, main:GetTall() * .5 )
        panel:Center()

        local subpanel = GUI.DrawPanel( panel, panel:GetWide() - 16, panel:GetTall() - 16, 8, 8, function( self, w, h )
            Draw.Box( w, h, 0, 0, C.HOMEWAY_BLUE_DARK, 6 )

            Draw.SimpleText( w / 2, 4, 'Создать Промокод', UI.SafeFont( '32 Montserrat SemiBold' ), C.FLAT_YELLOW, 'top-center' )
            Draw.SimpleText( w / 2, 44, '1. Введите промокод в белое поле', UI.SafeFont( '24 Montserrat' ), C.HOMEWAY_WHITE, 'top-center' )
            Draw.SimpleText( w / 2, 75, '2. Максимум '..Ambi.Homeway.Config.promocode_user_max_len..' и минимум '..Ambi.Homeway.Config.promocode_user_min_len..' символов', UI.SafeFont( '24 Montserrat' ), C.HOMEWAY_WHITE, 'top-center' )
        end )

        local promo = GUI.DrawTextEntry( subpanel, 300, 36, 0, 0, UI.SafeFont( '32 Montserrat' ), C.BLACK, nil, C.AMBI_GRAY, 'Вводить сюда', false, false )
        promo:Center()

        local send = GUI.DrawButton( subpanel, 140, 40, 0, 0, nil, nil, nil, function()
            surface.PlaySound( SOUND_CLICK )

            local promocode = tostring( promo:GetValue() )
            local len = utf8.len( promocode )
            if ( len > Ambi.Homeway.Config.promocode_user_max_len ) then Ambi.Homeway.Notify( 'Промокод больше '..Ambi.Homeway.Config.promocode_user_max_len..' символов', 5, NOTIFY_ERROR ) return end
            if ( len < Ambi.Homeway.Config.promocode_user_min_len ) then Ambi.Homeway.Notify( 'Промокод меньше '..Ambi.Homeway.Config.promocode_user_min_len..' символов', 5, NOTIFY_ERROR ) return end

            net.Start( 'ambi_homeway_make_user_promocode' )
                net.WriteString( promocode )
            net.SendToServer()
    
            Ambi.Homeway.RemoveF4Menu()
        end, function( self, w, h ) 
            Draw.Box( w, h, 0, 0, COLOR_PANEL, 8 )
    
            Draw.SimpleText( w / 2, h / 2, 'Окей', UI.SafeFont( '36 Montserrat' ), C.HOMEWAY_WHITE, 'center' )
        end )
        send:Center()
        send:SetY( subpanel:GetTall() - 40 - 12 )
    end, function( self, w, h ) 
        Draw.Box( w, h, 0, 0, C.HOMEWAY_BLUE_DARK, 6 )

        Draw.SimpleText( w / 2, h / 2, 'Создать', UI.SafeFont( '36 Montserrat' ), C.FLAT_YELLOW, 'center' )
    end )
end