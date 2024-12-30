local C, GUI, Draw, UI, CL = Ambi.Packages.Out( '@d, ContentLoader' )

local W, H = ScrW(), ScrH()
local COLOR_PANEL = Color( 0, 0, 0, 190 ) 
local COLOR_TEXT = Color(46, 46, 46)
local COLOR_PANEL_LIST = Color( 51, 54, 68)
local KEYS = {
    [ KEY_F4 ] = true,
    [ KEY_SPACE ] = true,
    [ KEY_W ] = true,
    [ KEY_A ] = true,
    [ KEY_D ] = true,
    [ KEY_S ] = true,
    [ KEY_ESCAPE ] = true,
    [ KEY_TAB ] = true,
}

-- ---------------------------------------------------------------------------------------------------------------------------------------
function Ambi.Homeway.OpenGunDealerMenu()
    if not LocalPlayer():Alive() then return end

    local frame = GUI.DrawFrame( nil, W, H, 0, 0, '', true, false, false, function( self, w, h ) 
        if not LocalPlayer():Alive() then self:Remove() return end

        Draw.Blur( self, 2 )

        Draw.Box( w, h, 0, 0, COLOR_PANEL )

        if not self.main then return end
    end )
    frame.OnKeyCodePressed = function( self, nKey )
        self:Remove()
    end

    local close = GUI.DrawButton( frame, frame:GetWide(), frame:GetTall(), 0, 0, nil, nil, nil, function()
        frame:Remove()
    end, function( self, w, h ) 
    end )

    local main = GUI.DrawPanel( frame, frame:GetWide() * .28, frame:GetTall() * .64, 0, 0, function( self, w, h ) 
        Draw.Box( w, h, 0, 0, C.HOMEWAY_BLACK, 8 )

        Draw.SimpleText( w / 2, 6, 'Дэйв', UI.SafeFont( '46 Montserrat' ), C.BLUE, 'top-center' )

        if self.draw_anti_discont then
            Draw.SimpleText( w / 2, 46, 'Есть оружейники цены увеличены на 30%', UI.SafeFont( '22 Montserrat' ), C.FLAT_RED, 'top-center' )
        end
    end ) 
    main:Center()

    local panel_list = GUI.DrawScrollPanel( main, main:GetWide() - 20 * 2, main:GetTall() - 50 * 2, 20, 80, function( self, w, h ) 
        Draw.Box( w, h, 0, 0, C.HOMEWAY_BLUE_DARK, 8 )
    end )

    for i, item in ipairs( Ambi.Homeway.Config.weapons_list_gundealer_npc ) do
        local cost = Ambi.Homeway.GetGunDealerWeaponCost( i )

        if ( cost ~= item.cost ) then main.draw_anti_discont = true end

        local item_panel = GUI.DrawPanel( panel_list, panel_list:GetWide() - 8, 60, 4, ( i - 1 ) * ( 60 + 4 ) + 4, function( self, w, h ) 
            Draw.Box( w, h, 0, 0, COLOR_PANEL, 8 )

            Draw.SimpleText( 72, 4, item.header, UI.SafeFont( '26 Montserrat Medium' ), C.HOMEWAY_BLUE, 'top-left' )
            Draw.SimpleText( 72, 30, string.Comma( cost )..'$', UI.SafeFont( '20 Montserrat Light' ), C.HOMEWAY_BLUE, 'top-left' )
        end )

        GUI.DrawModel( item_panel, 64, 64, 4, 0, weapons.Get( item.class ).WorldModel )

        local buy = GUI.DrawButton( item_panel, item_panel:GetWide(), item_panel:GetTall(), 0, 0, nil, nil, nil, function()
            if LocalPlayer():HasWeapon( item.class ) then surface.PlaySound( 'ambi/ui/beep2_l4d.wav' ) return end
            if not LocalPlayer():Alive() then surface.PlaySound( 'ambi/ui/beep2_l4d.wav' ) return end
            if not LocalPlayer():CanSpendMoney( cost ) then surface.PlaySound( 'ambi/ui/beep2_l4d.wav' ) return end

            net.Start( 'ambi_homeway_gun_dealer_buy' )
                net.WriteUInt( i, 6 )
            net.SendToServer()
        end, function( self, w, h ) 
            --Draw.Box( w, h, 0, 0, COLOR_PANEL, 6 )
    
            if LocalPlayer():HasWeapon( item.class ) then
                Draw.SimpleText( w - 12, h / 2, 'ЕСТЬ', UI.SafeFont( '20 Montserrat Medium' ), C.AMBI_GRAY, 'center-right' )
            else
                Draw.SimpleText( w - 12, h / 2, 'КУПИТЬ', UI.SafeFont( '20 Montserrat Medium' ), LocalPlayer():CanSpendMoney( cost ) and C.HOMEWAY_BLUE or C.FLAT_RED, 'center-right' )
            end
        end )
        buy:SetTooltip( item.header..' ('..cost..'$) \n\n'..item.desc )
    end
end