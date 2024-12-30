local C, GUI, Draw, UI, Lang, CL, Notify = Ambi.Packages.Out( '@d, Language, ContentLoader, Notify' )
local W, H = ScrW(), ScrH()
local MAX_ID = 32
local COLOR_PANEL = Color( 38, 38, 38 )
local ERROR_ICONS = { 1, 2, 3, 4, 5, 6 } -- the first six numbers are error icon.

local notifies = {}

-- ---------------------------------------------------------------------------------------------------------------------------------------
local function GetID()
    for i = 1, MAX_ID do
        if not notifies[ i ] then return i end
    end

    return 1
end

-- ---------------------------------------------------------------------------------------------------------------------------------------
Notify.Add( 3, 'Homeway Notify', 'Homeway', function( tVars )
    local time = tVars.time or 2
    local text = tVars.text or ''
    local type = tVars.type or 0
    local color = COLOR_PANEL -- main panel
    local color_text = C.HOMEWAY_WHITE
    local color_icon = C.HOMEWAY_WHITE
    local color_icon_panel = C.HOMEWAY_BLUE -- small panel for icon
    local color_line = C.HOMEWAY_BLUE
    local sound = 'ambi/ui/click12.wav'
    local icon = CL.Material( 'notify1_8' )

    local font = UI.SafeFont( '32 Montserrat' )
    local size = Draw.GetTextSizeX( font, text ) + 12

    if ( type == 1 ) then 
        sound = 'ambi/ui/error3.wav'
        icon = CL.Material( 'notify1_2' )
        color_line = C.FLAT_RED
        color_icon_panel = C.FLAT_RED
    elseif ( type == 2 ) then
        --sound = 'ambi/ui/beep3_l4d.wav'
        sound = 'ambi/ui/click9.wav'
        icon = CL.Material( 'notify1_32' )
        color_line = C.FLAT_GREEN
        color_icon_panel = C.FLAT_GREEN
    end

    local ID = GetID()
    notifies[ ID ] = true
    local name_timer = 'Ambi.Homeway.TimeNotifySend'..ID
    local margin_line_x = 36
    local start = CurTime()

    local panel = GUI.DrawPanel( nil, size + 32 + 4, 32 + 6, W, H - ( 38 + 4 ) * ID - 120, function( self, w, h ) 
        Draw.Box( w, h, 0, 0, color, 4 )
        Draw.Box( 36, h, 0, 0, color_icon_panel, 4, { true, false, true, false } )

        Draw.Material( 32, 32, 2, 3, icon, color_icon )
        Draw.SimpleText( 40, h / 2 - 2, text, font, color_text, 'center-left', 1, C.ABS_BLACK )

        -- Time
        local time_now = timer.TimeLeft( name_timer )
       -- if not time_now then self:Remove() return end -- can be call bug

        local wpos = Lerp( ( CurTime() - start ) / time, w - margin_line_x, 0 )
        Draw.Box( wpos, 4, margin_line_x, h - 4, color_line )
    end )
    panel.OnRemove = function()
        notifies[ ID ] = false 
    end
    panel:MoveTo( W - size - margin_line_x - 8, panel:GetY(), 0.35, 0, 1, function() end )

    if not tVars.dont_play_sound then surface.PlaySound( sound ) end

    timer.Create( name_timer, time, 1, function()
        if not IsValid( panel ) then notifies[ ID ] = false return end

        panel:MoveTo( W, panel:GetY(), 0.35, 0, -1, function( self ) 
            panel:Remove()
        end )
    end )

    MsgC( color_icon_panel, '[Notify] ', C.WHITE, text )
    print('')
end, 'type, time, text' )

Notify.AddSimpleInterface( 3, 'type', 'time', 'text' )

-- ---------------------------------------------------------------------------------------------------------------------------------------
function Ambi.Homeway.Notify( sText, nTime, nType, bDontPlaySound )
    Notify.Draw( 3, { type = nType, time = nTime, text = sText, dont_play_sound = bDontPlaySound } )
end

-- ---------------------------------------------------------------------------------------------------------------------------------------
net.Receive( 'ambi_homeway_notify', function()
    local text = net.ReadString()
    local time = net.ReadUInt( 9 )
    local type = net.ReadUInt( 3 )
    local dont_play_sound = net.ReadBool()

    Ambi.Homeway.Notify( text, time, type, dont_play_sound )
end )
