local C, GUI, Draw, UI, CL = Ambi.Packages.Out( '@d, ContentLoader' )

local W, H = ScrW(), ScrH()
local COLOR_PANEL = Color( 0, 0, 0, 220 ) 

function FadeOutSound(snd)
    local duration = 5 -- длительность затухания в секундах
    local fadeOutTime = duration
    local step = 0.02 -- шаг уменьшения громкости
    local initialVolume = snd:GetVolume()
    local timerName = 'Ambi.Homeway.AuthStopMusic'

    timer.Create(timerName, step, fadeOutTime / step, function()
        if IsValid(snd) then
            local newVolume = math.max(0, snd:GetVolume() - (initialVolume * step / fadeOutTime))
            snd:SetVolume(newVolume)
            
            if newVolume <= 0 then
                timer.Remove(timerName)

                RunConsoleCommand( 'stopsound' )
            end
        else
            timer.Remove(timerName)

            RunConsoleCommand( 'stopsound' )
        end
    end)
end

-- ---------------------------------------------------------------------------------------------------------------------------------------
function Ambi.Homeway.ShowAuth()
    RunConsoleCommand( 'hud_deathnotice_time', 0 )

    local a = true
    local b = 0

    sound.PlayFile( 'sound/'..Ambi.Homeway.Config.auth.music, 'mono', function( audioStation )
        if not IsValid( audioStation ) then return end
        if IsValid( Ambi.Homeway.music_auth ) then Ambi.Homeway.music_auth:Stop() end

        audioStation:Play()
        audioStation:SetVolume( .45 )

        timer.Simple( audioStation:GetLength(), function()
            a = true
        end )

        Ambi.Homeway.music_auth = audioStation
    end )

    hook.Add( 'CalcView', 'Ambi.Homeway.Auth', function( ePly, vPos, aAng, nFov )
        if not a then b = b + 0.36 end

        local view = {
            origin = a and Ambi.Homeway.Config.auth.pos or Vector( Ambi.Homeway.Config.auth.pos.x + b , Ambi.Homeway.Config.auth.pos.y, Ambi.Homeway.Config.auth.pos.z ),
            angles = Ambi.Homeway.Config.auth.ang,
            drawviewer = true
        }
    
        return view
    end )

    local frame = GUI.DrawFrame( nil, W, H, 0, 0, '', true, false, false, function( self, w, h ) 
        --Draw.Blur( self, 2 ) -- вот здеся
        --Draw.Box( w, h, 0, 0, COLOR_PANEL )
    end )
    frame.Close = function()
        if frame.cannot_close then return end
        frame.cannot_close = true

        frame:SetMouseInputEnabled( false )
        frame:SetKeyboardInputEnabled( false )
        gui.EnableScreenClicker( false )

        local panel_black = GUI.DrawPanel( nil, frame:GetWide(), frame:GetTall(), 0, 0, function( self, w, h )
            Draw.Box( w, h, 0, 0, C.HOMEWAY_BLACK )

            Draw.SimpleText( w / 2, h / 2, 'Приятной игры :)', UI.SafeFont( '64 Montserrat SemiBold' ), C.HOMEWAY_BLUE, 'center' )
        end )
        panel_black:SetAlpha( 0 )
        panel_black:AlphaTo( 255, 1.4, 0, function( self ) 
            frame:Remove()

            net.Start( 'ambi_homeway_auth' )
            net.SendToServer()

            panel_black:AlphaTo( 0, 3.4, 0, function( self ) 
                panel_black:Remove() 
            end ) 
        end )
    end
    frame.OnKeyCodePressed = function( self, nKey )
        if not a then 
            if IsValid( self.remove_button ) then self.remove_button:Remove() end
            self:Close() 
        end
    end
    frame.OnRemove = function()
        hook.Remove( 'CalcView', 'Ambi.Homeway.Auth' )
        if IsValid( Ambi.Homeway.music_auth ) then 
            FadeOutSound( Ambi.Homeway.music_auth )
        end
    end

    local panel_remove = GUI.DrawPanel( frame, frame:GetWide(), frame:GetTall(), 0, 0, function( self, w, h )
        Draw.Box( w, h, 0, 0, C.HOMEWAY_BLACK )
    end )
    panel_remove:AlphaTo( 0, 4.7, 0.55, function() 
        local panel_blick = GUI.DrawPanel( frame, W, H, 0, 0, function( self, w, h )
            Draw.Box( w, h, 0, 0, C.HOMEWAY_WHITE )
        end )
        panel_blick:AlphaTo( 0, 1.25, 0, function() 
            panel_blick:Remove() 
        end )

        local remove = GUI.DrawButton( frame, frame:GetWide(), frame:GetTall() - 80 * 2, 0, 80, nil, nil, nil, function( self )
            self:Remove()
            frame:Close()
        end, function( self, w, h ) 
            Draw.Material( 512, 512, w / 2 - 512 / 2, 30, CL.Material( 'hw_watermark3' ) )

            if self.show_hint then Draw.SimpleText( w / 2, h - 20, 'Нажмите любую клавишу', UI.SafeFont( '64 Montserrat SemiBold' ), C.HOMEWAY_BLUE, 'bottom-center', 1, C.ABS_BLACK ) end
        end )
        remove.show_hint = false
        frame.remove_button = remove

        timer.Simple( 4, function() 
            if not IsValid( remove ) then return end

            remove.show_hint = true
        end )

        panel_remove:Remove() 
        a = false
    end )

    local panel_top = GUI.DrawPanel( frame, frame:GetWide(), 80, 0, -80, function( self, w, h )
        Draw.Box( w, h, 0, 0, C.HOMEWAY_BLACK )
    end )

    local panel_bottom = GUI.DrawPanel( frame, frame:GetWide(), 80, 0, H, function( self, w, h )
        Draw.Box( w, h, 0, 0, C.HOMEWAY_BLACK )
    end )

    panel_top:MoveTo( 0, 0, 4.5, 0.6, -1, function() end )
    panel_bottom:MoveTo( 0, H - 80, 4.5, 0.6, -1, function() end )
end

-- ---------------------------------------------------------------------------------------------------------------------------------------в
hook.Add( 'InitPostEntity', 'Ambi.Homeway.ShowAuth', function()
    Ambi.Homeway.ShowAuth() 
end )

hook.Add( 'HUDShouldDraw', 'Ambi.Homeway.Auth', function( sName )
    if LocalPlayer().IsAuth and not LocalPlayer():IsAuth() then return false end

    if ( sName == 'CHudDeathNotice' ) then return false end
end )

