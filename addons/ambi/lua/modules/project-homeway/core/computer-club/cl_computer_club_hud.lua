local C, GUI, Draw, UI = Ambi.Packages.Out( '@d' )
local W, H = ScrW(), ScrH()

-- --------------------------------------------------------------------------------------------------------------------------------------------
hook.Add( 'HUDPaint', 'Ambi.ComputerClub.HUD', function() 
    if not LocalPlayer():IsPlayingInComputerClub() then return end
    
    Draw.SimpleText( 32, 32, '[F2] Покинуть игру', UI.SafeFont( '32 Montserrat' ), C.HOMEWAY_BLUE, 'top-left', 1, C.ABS_BLACK )
    Draw.SimpleText( 32, 60, 'в чат /cancel', UI.SafeFont( '24 Montserrat' ), C.AMBI_GRAY, 'top-left', 1, C.ABS_BLACK )
end )