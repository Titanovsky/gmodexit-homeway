local C, GUI, Draw, UI, CL = Ambi.Packages.Out( '@d, ContentLoader' )

local W, H = ScrW(), ScrH()
local COLOR_PANEL = Color( 0, 0, 0, 200 ) 

CL.DownloadMaterial( 'hw_news', 'homeway/f4menu/hw_news.png', Ambi.Homeway.Config.news.preview_url )

-- ---------------------------------------------------------------------------------------------------------------------------------------
function Ambi.Homeway.ShowPageNews( vguiMain )
    CL.DownloadMaterial( 'hw_news', 'homeway/f4menu/hw_news.png', Ambi.Homeway.Config.news.preview_url )

    local main = vguiMain

    main.back:SetVisible( true )
    main:Clear()
    
    local panel = GUI.DrawPanel( main, main:GetWide(), main:GetTall(), main:GetWide() / 2 - (main:GetWide() / 2), 0, function( self, w, h )
        Draw.Box( w, h, 0, 0, C.HOMEWAY_BLACK, 8 )
    end )

    local main = GUI.DrawPanel( panel, panel:GetWide() - 24, panel:GetTall() - 24, 12, 12, function( self, w, h ) 
        Draw.Box( w, h, 0, 0, self.color_bg, 8 )

        Draw.SimpleText( w / 2, 4, Ambi.Homeway.Config.news.header, UI.SafeFont( '32 Montserrat SemiBold' ), C.HOMEWAY_WHITE, 'top-center' )
    end )
    main.color_bg = C.HOMEWAY_BLUE_DARK

    local preview = GUI.DrawPanel( main, panel:GetWide() / 1.8, panel:GetTall() / 2, panel:GetWide() / 2 - ( panel:GetWide() / 1.8 ) / 2, 50, function( self, w, h ) 
        Draw.Material( w, h, 0, 0, CL.Material( 'hw_news' ) )
    end )

    local desc = GUI.DrawRichText( main, main:GetWide(), main:GetTall(), 0, 50 + preview:GetTall() + 4, UI.SafeFont( '28 Montserrat' ), C.WHITE, Ambi.Homeway.Config.news.desc )

    local btn = GUI.DrawButton( main, main:GetWide(), main:GetTall(), 0, 0, nil, nil, nil, function()
        gui.OpenURL( Ambi.Homeway.Config.news.url )

        Ambi.Homeway.RemoveF4Menu()
    end, function( self, w, h ) 
    end )

    GUI.OnCursor( btn, function()
        surface.PlaySound( 'ambi/ui/click5.mp3' )
    end )
end