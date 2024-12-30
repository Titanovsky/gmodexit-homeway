local C, GUI, Draw, UI = Ambi.Packages.Out( '@d' )

local W, H = ScrW(), ScrH()
local COLOR_PANEL = Color( 0, 0, 0, 200 ) 

-- ---------------------------------------------------------------------------------------------------------------------------------------
function Ambi.Homeway.ShowPageDaily( vguiMain )
    local main = vguiMain

    main.back:SetVisible( true )
    main:Clear()
    
    local panel = GUI.DrawScrollPanel( main, main:GetWide(), main:GetTall(), 0, 0, function( self, w, h )
        Draw.Box( w, h, 0, 0, C.HOMEWAY_BLACK, 6 )
    end )

    for id, daily in ipairs( Ambi.Daily.dailies ) do
        local desc = daily.players[ LocalPlayer():SteamID() ] 
        and daily.Description( daily ) 
        or ( daily.count > 1 and daily.Description( daily )..' ['..LocalPlayer()[ 'nw_DailyCount'..id ]..'/'..daily.count..']' or daily.Description( daily )  ) -- такая хуебина честно

        local color = daily.players[ LocalPlayer():SteamID() ] and C.AMBI_GREEN or C.AMBI_RED
        
        local panel_daily = GUI.DrawPanel( panel, panel:GetWide(), 32, 0, 40 + ( id - 1 ) * ( 28 + 2 ), function( self, w, h )
            Draw.SimpleText( 0, 0, '•', UI.SafeFont( '32 Ambi' ), color, 'top-left' )
            Draw.SimpleText( 24, 4, desc, UI.SafeFont( '28 Ambi' ), C.ABS_WHITE, 'top-left' )
        end )
    end
end