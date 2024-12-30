local C, GUI, Draw, UI, CL = Ambi.Packages.Out( '@d, ContentLoader' )

local W, H = ScrW(), ScrH()
local COLOR_PANEL = Color( 0, 0, 0, 200 ) 

-- ---------------------------------------------------------------------------------------------------------------------------------------
CL.CreateDir( 'homeway' )
CL.CreateDir( 'homeway/navigation' )

for i, nav in ipairs( Ambi.Homeway.Config.navigations ) do
    local icon = 'nav_icon'..i
    CL.DownloadMaterial( icon, 'homeway/navigation/'..icon..'.png', nav.icon_url )

    local preview = 'nav_preview'..i
    CL.DownloadMaterial( preview, 'homeway/navigation/'..preview..'.jpeg', nav.preview_url )
end

-- ---------------------------------------------------------------------------------------------------------------------------------------
function Ambi.Homeway.ShowPageNavigation( vguiMain )
    local main = vguiMain

    main.back:SetVisible( true )
    main:Clear()
    
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

    for i, nav in ipairs( Ambi.Homeway.Config.navigations ) do
        local item_panel = GUI.DrawPanel( panel_list_left, panel_list_left:GetWide() - 8, 36, 4, ( i - 1 ) * ( 36 + 4 ) + 4, function( self, w, h ) 
            Draw.Box( w, h, 0, 0, COLOR_PANEL, 8 )

            Draw.SimpleText( 46, h / 2, nav.header, UI.SafeFont( '28 Montserrat' ), C.HOMEWAY_WHITE, 'center-left' )

            Draw.Material( 32, 32, 4, 2, CL.Material( 'nav_icon'..i ), C.HOMEWAY_BLUE )
        end )

        local btn = GUI.DrawButton( item_panel, item_panel:GetWide(), item_panel:GetTall(), 0, 0, nil, nil, nil, function()
            Ambi.Homeway.RemoveF4Menu()
            Ambi.ESP.SetPoint( nav.header, nav.pos, CL.Material( 'nav_icon'..i ), C.HOMEWAY_BLUE )
        end, function( self, w, h ) 
        end )

        GUI.OnCursor( btn, function()
            panel_list_right.nav = nav
            panel_list_right.nav_id = i

            desc:SetText( '' )
            desc:InsertColorChange( C.HOMEWAY_WHITE.r, C.HOMEWAY_WHITE.g, C.HOMEWAY_WHITE.b, 255 )
            desc:AppendText( nav.desc )
        end )
    end
end