local C, GUI, Draw, UI = Ambi.Packages.Out( '@d' )

local W, H = ScrW(), ScrH()
local COLOR_PANEL = Color( 0, 0, 0, 200 ) 

-- ---------------------------------------------------------------------------------------------------------------------------------------
function Ambi.Homeway.ShowPageTodo( vguiMain )
    local main = vguiMain

    main.back:SetVisible( true )
    main:Clear()
    
    local panel = GUI.DrawScrollPanel( main, main:GetWide(), main:GetTall(), 0, 0, function( self, w, h )
        Draw.SimpleText( w / 2, h / 2, 'Данная страница в разработке!', UI.SafeFont( '64 Montserrat SemiBold' ), C.FLAT_RED, 'center' )
    end )
end