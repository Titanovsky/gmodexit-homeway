local C, GUI, Draw, UI, CL = Ambi.Packages.Out( '@d, ContentLoader' )

local W, H = ScrW(), ScrH()
local COLOR_PANEL = Color( 12, 12, 12, 250 ) 

function Ambi.Homeway.ShowDeathScreen()
    local ready = false
    local time = 10
    local panel

    if LocalPlayer():IsSuperAdmin() then time = 0
    elseif LocalPlayer():IsVIP() then time = 5
    elseif LocalPlayer():IsPremium() then time = 0
    end

    timer.Create( 'Ambi.Homeway.DeathScreen', time, 1, function() ready = true end )

    local frame = GUI.DrawFrame( nil, W, H, 0, 0, '', true, false, false, function( self, w, h ) 
        Draw.Blur( self, 1 )
        Draw.Box( w, h, 0, 0, COLOR_PANEL )
        Draw.Box( w, h, 0, 0, COLOR_PANEL )

        Draw.SimpleText( w / 2, 12, 'ВЫ БЕЗ СОЗНАНИЯ', UI.SafeFont( '100 Montserrat SemiBold' ), C.HOMEWAY_WHITE, 'top-center' )
        --Draw.Material( W, H, 0, 0, CL.Material( 'death_screen' ) )
    end )
    frame.OnKeyCodePressed = function( self, nKey )
        if ready then 
            if LocalPlayer():Alive() then self:Remove() end

            surface.PlaySound( 'ambi/ui/beep1_l4d.wav' ) 

            self:AlphaTo( 0, 1.25, 0.56, function() self:Remove() end )
            ready = false
            self:SetMouseInputEnabled( false )
            self:SetKeyboardInputEnabled( false )
            gui.EnableScreenClicker( false )
            panel:Remove()
            
            net.Start( 'ambi_homeway_spawn_from_die' )
            net.SendToServer()
            return 
        end
    end

    panel = GUI.DrawPanel( frame, W, H, 0, 0, function( self, w, h )
        if not ready then 
            Draw.SimpleText( w / 2, h / 2, timer.Exists( 'Ambi.Homeway.DeathScreen' ) and math.floor( timer.TimeLeft( 'Ambi.Homeway.DeathScreen' ) ) or '', UI.SafeFont( '64 Montserrat' ), C.BLUE, 'center' )
        else
            Draw.SimpleText( w / 2, h / 2, 'Нажмите любую кнопку, чтобы воскреснуть', UI.SafeFont( '46 Montserrat' ), C.HOMEWAY_WHITE, 'center' )
        end

        if LocalPlayer():Alive() then
            frame:Remove()

            return
        end
    end )
end

net.Receive( 'ambi_homeway_show_death_screen', function() 
    --local job = net.ReadUInt( 8 )

    timer.Simple( 0.1, function() Ambi.Homeway.ShowDeathScreen() end )
end )