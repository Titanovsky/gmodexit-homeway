local C, GUI, Draw, UI = Ambi.Packages.Out( '@d' )

local W, H = ScrW(), ScrH()
local COLOR_PANEL = Color( 0, 0, 0, 190 ) 
local COLOR_TEXT = Color(46, 46, 46)
local COLOR_PANEL_LIST = Color( 51, 54, 68)

-- ---------------------------------------------------------------------------------------------------------------------------------------
function Ambi.Homeway.OpenPermaSkinShop()
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

    local main = GUI.DrawPanel( frame, frame:GetWide() * .5, frame:GetTall() * .5, 0, 0, function( self, w, h ) 
        Draw.Box( w, h, 0, 0, C.HOMEWAY_BLACK, 8 )
    end ) 
    main:Center()

    local panel = GUI.DrawPanel( main, main:GetWide(), main:GetTall(), main:GetWide() / 2 - (main:GetWide() / 2), 0, function( self, w, h )
        Draw.Box( w, h, 0, 0, C.HOMEWAY_BLUE_DARK, 8 )
    end )

    local panel_list_left = GUI.DrawScrollPanel( panel, panel:GetWide() * .4, panel:GetTall(), 0, 0, function( self, w, h ) 
        Draw.Box( w, h, 0, 0, C.HOMEWAY_BLUE_DARK, 8 )
    end )

    local panel_list_right = GUI.DrawPanel( panel, panel:GetWide() - panel_list_left:GetWide() - 4, panel:GetTall() - 8, panel_list_left:GetWide(), 4, function( self, w, h ) 
        Draw.Box( w, h, 0, 0, COLOR_PANEL, 8 )

        if not self.nav then return end

        local nav = self.nav

        Draw.SimpleText( w / 2, 2, nav.header, UI.SafeFont( '28 Montserrat SemiBold' ), C.HOMEWAY_WHITE, 'top-center' )
        Draw.Material( w - 8, h * .4, 4, 36, CL.Material( 'nav_preview'..self.nav_id ), C.WHITE )
        --Draw.SimpleText( 4, 36 + h * .4 + 4, nav.desc, UI.SafeFont( '44 Montserrat Medium' ), C.HOMEWAY_WHITE, 'top-left' )
    end )

    local desc = GUI.DrawRichText( panel_list_right, panel_list_right:GetWide(), panel_list_right:GetTall(), 0, 36 + panel_list_right:GetTall() * .4 + 4, UI.SafeFont( '44 Montserrat Medium' ), '' )

    for i, item in ipairs( Ambi.Homeway.Config.perma_models ) do
        local item_panel = GUI.DrawPanel( panel_list_left, panel_list_left:GetWide() - 8, 36, 4, ( i - 1 ) * ( 36 + 4 ) + 4, function( self, w, h ) 
            Draw.Box( w, h, 0, 0, COLOR_PANEL, 8 )

            Draw.SimpleText( 46, h / 2, item.header, UI.SafeFont( '28 Montserrat' ), C.HOMEWAY_WHITE, 'center-left' )

            --Draw.Material( 32, 32, 4, 2, CL.Material( 'nav_icon'..i ), C.HOMEWAY_BLUE )
        end )

        GUI.DrawModel( item_panel, 32, 32, 0, 0, item.model )

        local btn = GUI.DrawButton( item_panel, item_panel:GetWide(), item_panel:GetTall(), 0, 0, nil, nil, nil, function()
            frame:Remove()
            IGS.UI()

            Ambi.Homeway.Notify( 'Покупаем перма скины, не дорого!', 10 )
        end, function( self, w, h ) 
        end )

        GUI.OnCursor( btn, function()
            panel_list_right:Clear()

            local mdl = GUI.DrawModel3D( panel_list_right, panel_list_right:GetWide(), panel_list_right:GetTall(), 0, 0, item.model )
            --mdl:SetCamPos(Vector(40, 40, 40))
            mdl:SetAnimated(true)
            mdl:GetEntity():SetSequence(mdl:GetEntity():LookupSequence("taunt_dance"))
        end )
    end
end
concommand.Add( 'ambi_hw_perma_skins_shop', Ambi.Homeway.OpenPermaSkinShop )