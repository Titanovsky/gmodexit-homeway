local C, GUI, Draw, UI, CL = Ambi.Packages.Out( '@d, ContentLoader' )
local W, H = ScrW(), ScrH()

-- ---------------------------------------------------------------------------------------------------------------------------------------
hook.Add( 'HUDPaint', 'Ambi.Homeway.Watermark', function()
    if Ambi.Homeway.HasF4Menu() then return end
    if IsValid( Ambi.Homeway.tab ) then return end
    if not LocalPlayer():IsAuth() then return end

    --Draw.Material( 128, 128, W - 128 - 12, 12, CL.Material( 'hw_watermark1' ) )
    --Draw.Material( 128, 128, W - 128 - 12, 12, CL.Material( 'hw_watermark2' ) )
    --Draw.Material( 128, 128, W - 128 - 12, 12, CL.Material( 'hw_watermark3' ) )
    --Draw.Material( 128, 128, W - 128 - 12, 12, CL.Material( 'hw_watermark4' ) )
    Draw.Material( 128, 128, W - 128 - 12, 12, CL.Material( 'hw_watermark4_128' ) )

    Draw.Box( 130, 22, W - 130 - 9, 130, C.HOMEWAY_BLACK, 6 )
    Draw.SimpleText( W - 75, 130, os.date( '%H:%M  %d.%m.%Y', os.time() ), UI.SafeFont( '20 Montserrat' ), C.HOMEWAY_BLUE, 'top-center', 1, C.ABS_BLACK )

    local global_text = Ambi.Homeway.Config.global_string_text
    local global_color = Ambi.Homeway.Config.global_string_color

    if ( Ambi.Homeway.Config.global_string_type == 1 ) then
        global_text = 'Тех. Работы (может быть рестарт)' 
        global_color = C.FLAT_RED
    elseif ( Ambi.Homeway.Config.global_string_type == 2 ) then
        global_text = 'NonRP Time' 
        global_color = C.AMBI_PURPLE
    end

    Draw.SimpleText( W / 2, 40, global_text, UI.SafeFont( '40 Montserrat Medium' ), global_color, 'top-center', 1, C.ABS_BLACK )    
end )