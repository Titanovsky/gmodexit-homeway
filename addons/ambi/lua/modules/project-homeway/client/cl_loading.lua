local C, GUI, Draw, UI, CL = Ambi.Packages.Out( '@d, ContentLoader' )

local W, H = ScrW(), ScrH()
local COLOR_PANEL = Color( 0, 0, 0, 220 ) 

function Ambi.Homeway.LoadingMenu( nTime )
    local frame = GUI.DrawFrame( nil, W, H, 0, 0, '', true, false, false, function( self, w, h ) 
        if not LocalPlayer():Alive() then self:Remove() return end

        Draw.Box( w, h, 0, 0, COLOR_PANEL )
    end )

    timer.Create( 'Ambi.Homeway.LoadingMenu', nTime, 1, function() 
        if IsValid( frame ) then frame:Remove() end
    end )

    local main = GUI.DrawPanel( frame, frame:GetWide() * .4, frame:GetTall() * .06, 0, 0, function( self, w, h ) 
        Draw.Box( w, h, 0, 0, C.HOMEWAY_BLACK, 8 )

        local timeLeft = timer.TimeLeft('Ambi.Homeway.LoadingMenu') or 0

        local targetWidth = (timeLeft / nTime) * w 
        local currentWidth = (currentWidth or targetWidth)

        -- Плавно интерполируем ширину
        currentWidth = Lerp(0.1, currentWidth, targetWidth)

        Draw.Box( w - 8, h - 8, 4, 4, C.HOMEWAY_BLUE_DARK, 6)
        Draw.Box( w - currentWidth - 8, h - 8, 4, 4, C.HOMEWAY_BLUE, 6)

        -- Draw.SimpleText( w / 2, h / 2, math.Round( timeLeft ), UI.SafeFont( '64 Montserrat Medium' ), C.ABS_BLACK, 'center' )
    end ) 
    main:Center()
end