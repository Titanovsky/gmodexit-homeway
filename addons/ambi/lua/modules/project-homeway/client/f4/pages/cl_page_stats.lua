local C, GUI, Draw, UI = Ambi.Packages.Out( '@d' )

local W, H = ScrW(), ScrH()
local COLOR_PANEL = Color( 0, 0, 0, 200 ) 

local STATS = { -- ShowText, cuz just a var joining to server make errors
    { ShowText = function() return game.GetIPAddress() end, Action = function() SetClipboardText( game.GetIPAddress() ) end },
    { ShowText = function() return LocalPlayer():Name() end, Action = function() SetClipboardText( LocalPlayer():Name() ) end },
    { ShowText = function() return LocalPlayer():SteamID() end, Action = function() SetClipboardText( LocalPlayer():SteamID() ) end },
    { ShowText = function() return math.floor( LocalPlayer():GetTime() / 60 )..' минут ('..math.floor( LocalPlayer():GetTime() / 60 / 60 )..' ч)' end, Action = function() SetClipboardText( LocalPlayer():GetTime() / 60 ) end },
    { ShowText = function() return 'За сегодня: '..math.floor( LocalPlayer():GetTimeToday() / 60 )..' минут ('..math.floor( LocalPlayer():GetTimeToday() / 60 / 60 )..' ч)' end, Action = function() SetClipboardText( LocalPlayer():GetTimeToday() / 60 ) end },
    { ShowText = function() return LocalPlayer():GetUserGroup() end, Action = function() SetClipboardText( LocalPlayer():SteamID() ) end },
}

-- ---------------------------------------------------------------------------------------------------------------------------------------
function Ambi.Homeway.ShowPageStats( vguiMain )
    local main = vguiMain

    main.back:SetVisible( true )
    main:Clear()
    
    local panel = GUI.DrawScrollPanel( main, main:GetWide(), main:GetTall(), 0, 0, function( self, w, h )
        Draw.Box( w, h, 0, 0, C.HOMEWAY_BLACK, 6 )
    end )

    for i, stat in ipairs( STATS ) do
        local text = stat.ShowText and stat.ShowText() or ''

        local btn = GUI.DrawButton( panel, panel:GetWide(), 44, 0, ( i - 1 ) * ( 44 + 4 ), nil, nil, nil, stat.Action, function( self, w, h ) 
            Draw.Box( w, h, 0, 0, C.HOMEWAY_BLUE_DARK, 6 )

            Draw.SimpleText( 4, h / 2, i..'. '..text, UI.SafeFont( '40 Montserrat' ), C.HOMEWAY_WHITE, 'center-left' )
        end )
    end
end