local C, GUI, Draw, UI = Ambi.Packages.Out( '@d' )

local W, H = ScrW(), ScrH()
local COLOR_PANEL = Color( 0, 0, 0, 200 ) 

local SETTINGS = { 
    { type = 'checkbox', cmd = 'r_3dsky', text = 'Вкл/Выкл 3Д Скайбокс (+FPS)', Action = function() local cmd = GetConVar( 'r_3dsky' ) cmd:SetInt( tonumber( not cmd:GetBool() ) ) end },
    { type = 'checkbox', cmd = 'ambi_disable_render_unfocus', text = 'Вкл/Выкл чёрный экран при смене фокусы с игры на другое', Action = function() local cmd = GetConVar( 'ambi_disable_render_unfocus' ) cmd:SetInt( tonumber( not cmd:GetBool() ) ) end },
    { type = 'button', text = 'Остановить звуки', Action = function() RunConsoleCommand( 'stopsound' ) RunConsoleCommand( 'snd_restart' ) end },
    { type = 'button', text = 'Убрать все декали', Action = function() RunConsoleCommand( 'r_cleardecals' ) end },
}

-- ---------------------------------------------------------------------------------------------------------------------------------------
local function DrawPanel( nID, vguiPanel )
    local setting = SETTINGS[ nID ]
    local type = setting.type

    if ( type == 'checkbox' ) then
        return GUI.DrawCheckBox( vguiPanel, 6, 0, UI.SafeFont( '40 Montserrat' ), C.WHITE, setting.text, GetConVar( setting.cmd ):GetBool(), setting.cmd, true )
    end

    if ( type == 'button' ) then
        local w = Draw.GetTextSizeX( UI.SafeFont( '40 Montserrat' ), setting.text ) + 16
        return GUI.DrawButton( vguiPanel, w, vguiPanel:GetTall(), 0, 0, nil, nil, nil, function()
            surface.PlaySound( 'ambi/ui/click_tower_unite.wav' )

            setting.Action()
        end, function( self, w, h ) 
            Draw.Box( w - 8, h - 8, 4, 4, C.HOMEWAY_BLUE_DARK, 6 )

            Draw.SimpleText( 8, h / 2, setting.text, UI.SafeFont( '40 Montserrat' ), C.HOMEWAY_WHITE, 'center-left' )
        end )
    end
end

-- ---------------------------------------------------------------------------------------------------------------------------------------
function Ambi.Homeway.ShowPageSettings( vguiMain )
    local main = vguiMain

    main.back:SetVisible( true )
    main:Clear()
    
    local panel = GUI.DrawScrollPanel( main, main:GetWide(), main:GetTall(), 0, 0, function( self, w, h )
        Draw.Box( w, h, 0, 0, C.HOMEWAY_BLACK, 6 )
    end )

    for i, setting in ipairs( SETTINGS ) do
        local panel = GUI.DrawPanel( panel, panel:GetWide(), 44, 0, ( i - 1 ) * ( 44 + 4 ), function( self, w, h ) 
        end )

        DrawPanel( i, panel )
    end
end