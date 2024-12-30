local a = 'dsd'local C, GUI, Draw, UI, CL = Ambi.Packages.Out( '@d, ContentLoader' )

local W, H = ScrW(), ScrH()
local COLOR_PANEL = Color( 12, 12, 12, 250 ) 

hook.Add( 'HUDPaint', 'Ambi.Homeway.Jail', function()
    if not timer.Exists( 'Jail' ) then return end

    Draw.Box( W, 80, 0, 150, C.HOMEWAY_BLACK )

    local reason = LocalPlayer().nw_JailReason or 'Нет причины'
    local time = math.Round( timer.TimeLeft( 'Jail' ) )

    Draw.SimpleText( W / 2, 150, reason, UI.SafeFont( '40 Montserrat SemiBold' ), C.FLAT_RED, 'top-center', 1, C.ABS_BLACK )
    Draw.SimpleText( W / 2, 190, time, UI.SafeFont( '32 Montserrat' ), C.FLAT_RED, 'top-center', 1, C.ABS_BLACK )
end )

net.Receive( 'ambi_homeway_jail', function() 
    timer.Create( 'Jail', net.ReadUInt( 10 ) * 60, 1, function() end )
end )

net.Receive( 'ambi_homeway_unjail', function() 
    timer.Remove( 'Jail' )
end )