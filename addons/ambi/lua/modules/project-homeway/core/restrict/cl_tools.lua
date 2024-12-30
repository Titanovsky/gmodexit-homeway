local C, GUI, Draw, UI = Ambi.Packages.Out( '@d' )
local W, H = ScrW(), ScrH()

local COLOR_PANEL = Color( 0, 0, 0, 200 )

hook.Add( 'PostReloadToolsMenu', 'Ambi.Homeway.HideAndReskinTools', function() 
    -- Tools
    local toolPanelList = g_SpawnMenu.ToolMenu.ToolPanels[1].List
    local categories = toolPanelList.pnlCanvas:GetChildren()
    local construction = categories[ 2 ]:GetChildren()
    local render = categories[ 4 ]:GetChildren()
    local building = categories[ 5 ]:GetChildren()

    for k, col in ipairs( categories ) do
        if ( k == 1 ) or ( k == 3 ) then col:Remove() end
    end

    for _, panel in ipairs( construction ) do
        if Ambi.DarkRP.Config.restrict_tools[ panel.Name ] then panel:Remove() end
    end

    for _, panel in ipairs( render ) do
        if Ambi.DarkRP.Config.restrict_tools[ panel.Name ] then panel:Remove() end
    end

    construction[ 1 ]:SetText( '' )
    construction[ 1 ].Paint = function( self, w, h ) 
        draw.RoundedBox( 4, 0, 0, w, h, C.HOMEWAY_BLACK )
        Draw.Text( w / 2, h / 2, 'Строительство', UI.SafeFont( '16 Montserrat SemiBold' ), C.HOMEWAY_BLUE, 'center' )
    end

    for i, panel in ipairs( construction ) do
        panel:SetTextColor( C.HOMEWAY_BLACK )
        panel:SetFont( UI.SafeFont( '15 Montserrat' ) )
        -- panel.Paint = function( self, w, h ) 
        --     Draw.Box( w, h, 0, 0, C.HOMEWAY_BLACK )
        --     Draw.Text( 4, h / 2, panel:GetText(), UI.SafeFont( '14 Montserrat' ), C.HOMEWAY_BLUE, 'center-left' )
        -- end
    end
end )