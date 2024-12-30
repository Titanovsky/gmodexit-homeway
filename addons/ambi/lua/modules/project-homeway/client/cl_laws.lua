local C, GUI, Draw, UI, CL = Ambi.Packages.Out( '@d, ContentLoader' )

local W, H = ScrW(), ScrH()
local COLOR_PANEL = Color( 0, 0, 0, 190 ) 
local COLOR_TEXT = Color(46, 46, 46)
local COLOR_PANEL_LIST = Color( 51, 54, 68)

-- ---------------------------------------------------------------------------------------------------------------------------------------
function Ambi.Homeway.OpenLawsMenu()
    if not LocalPlayer():Alive() then return end

    local frame = GUI.DrawFrame( nil, W, H, 0, 0, '', true, false, false, function( self, w, h ) 
        if not LocalPlayer():Alive() then self:Remove() return end

        Draw.Blur( self, 2 )

        Draw.Box( w, h, 0, 0, COLOR_PANEL )

        if not self.main then return end
    end )
    frame.OnKeyCodePressed = function( self, nKey )
        self:Remove()
    end

    local close = GUI.DrawButton( frame, frame:GetWide(), frame:GetTall(), 0, 0, nil, nil, nil, function()
        frame:Remove()
    end, function( self, w, h ) 
    end )

    local main = GUI.DrawPanel( frame, frame:GetWide() * .5, frame:GetTall() * .75, 0, 0, function( self, w, h ) 
        Draw.Box( w, h, 0, 0, C.HOMEWAY_BLACK, 8 )

        Draw.SimpleText( w / 2, 6, 'Законы', UI.SafeFont( '46 Montserrat' ), C.BLUE, 'top-center' )
    end ) 
    main:Center()

    local panel_list = GUI.DrawScrollPanel( main, main:GetWide() - 20 * 2, main:GetTall() - 50 * 2, 20, 80, function( self, w, h ) 
        Draw.Box( w, h, 0, 0, C.HOMEWAY_BLUE_DARK, 8 )
    end )

    for i = 1, 9 do
        local law = Ambi.DarkRP.laws[ i ]
        local text = string.IsValid( law ) and i..'. '..law or ''

        local item_panel = GUI.DrawPanel( panel_list, panel_list:GetWide() - 8, 30, 4, ( i - 1 ) * ( 30 + 4 ) + 4, function( self, w, h ) 
            Draw.Box( w, h, 0, 0, COLOR_PANEL, 8 )

            Draw.SimpleText( 4, 4, text, UI.SafeFont( '26 Montserrat Medium' ), C.HOMEWAY_BLUE, 'top-left' )
        end )
    end
end