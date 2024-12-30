local C, GUI, Draw, UI, CL = Ambi.Packages.Out( '@d, ContentLoader' )

local W, H = ScrW(), ScrH()
local C_BACK = Color( 20, 20, 20, 235 )
local COLOR_PANEL = Color( 0, 0, 0, 220 ) 

-- ---------------------------------------------------------------------------------------------------------------------------------------
function Ambi.Homeway.FilterPlayersOnJobs( bLocalPlayerOnFirst )
    local result = {}
    if bLocalPlayerOnFirst then result[ 1 ] = LocalPlayer() end

    local players = player.GetAll()

    for class, _ in SortedPairs( Ambi.DarkRP.GetJobs() ) do
        for _, ply in ipairs( players ) do
            if bLocalPlayerOnFirst and ( ply == LocalPlayer() ) then continue end
            if ( ply:GetJob() == class ) then result[ #result + 1 ] = ply end
        end
    end

    return result
end

local function GetPrivRankTextAndColor( ePly )
    local text = ''
    local color = C.WHITE

    if Ambi.Homeway.Config.ranks_convert[ ePly:GetUserGroup() ] then
        text, color = Ambi.Homeway.Config.ranks_convert[ ePly:GetUserGroup() ].header, Ambi.Homeway.Config.ranks_convert[ ePly:GetUserGroup() ].color
    elseif ePly:IsPremium() then
        text, color = 'PREMIUM', C.AU_PURPLE
    elseif ePly:IsVIP() then
        text, color = 'VIP', C.AMBI_YELLOW
    end

    return text, color
end

-- ---------------------------------------------------------------------------------------------------------------------------------------
function Ambi.Homeway.ShowTab()
    surface.PlaySound( 'ambi/ui/hover4.wav' )

    local main = GUI.DrawPanel( nil, W, H, 0, 0, function( self, w, h ) 
        Draw.Box( w, h, 0, 0, COLOR_PANEL )
    end )
    main:SetAlpha( 0 )
    main:AlphaTo( 255, 0.25, 0, function() end )
    
    local panel = GUI.DrawPanel( main, W * .64, H / 1.1, 0, 0, function( self, w, h ) 
        Draw.SimpleText( w / 2, -14, 'HOMEWAY', UI.SafeFont( '64 Montserrat SemiBold' ), C.HOMEWAY_BLUE, 'top-center', 1, C.BLACK )
        Draw.SimpleText( w / 2, 40, game.GetIPAddress(), UI.SafeFont( '24 Montserrat' ), C.HOMEWAY_BLUE, 'top-center', 1, C.BLACK )

        local time = os.time() 
        Draw.SimpleText( 4, 72 - 28, os.date( '%H:%M', time ), UI.SafeFont( '30 Montserrat' ), C.HOMEWAY_BLUE, 'top-left', 1, C.BLACK )
        Draw.SimpleText( 70, 72 - 22, os.date( '%d.%m.%Y', time ), UI.SafeFont( '22 Montserrat' ), C.HOMEWAY_BLUE, 'top-left', 1, C.BLACK )

        Draw.SimpleText( w - 4, 72 - 28, #player.GetAll()..' / 100', UI.SafeFont( '30 Montserrat' ), C.HOMEWAY_BLUE, 'top-right', 1, C.BLACK )
    end )
    panel.OnKeyCodePressed = function( self, nKey )
        if ( nKey == KEY_F4 ) or ( nKey == KEY_TAB ) then Ambi.Homeway.CloseTab() return end
    end

    panel:Center()

    local subpanel = GUI.DrawPanel( panel, panel:GetWide(), panel:GetTall() - 72, 0, 72, function( self, w, h ) 
        Draw.Box( w, h, 0, 0, C.HOMEWAY_BLACK, 8 )
    end )

    local players = GUI.DrawScrollPanel( subpanel, subpanel:GetWide() - 24, subpanel:GetTall() - 24, 12, 12, function( self, w, h ) 
        Draw.Box( w, h, 0, 0, C.HOMEWAY_BLUE_DARK, 6 )
    end )

    players:GetVBar():SetSize( 0 )

    local actions = {}
    for i, ply in ipairs( Ambi.Homeway.FilterPlayersOnJobs( true ) ) do
        local panel = GUI.DrawPanel( players, players:GetWide(), 44, 0, 44 * ( i - 1 ), function( self, w, h ) 
            if not IsValid( ply ) then self:Remove() return end
        end )

        local id, name, team_name, team_color = ply:EntIndex(), utf8.sub( ply:Name(), 1, 26 ), ply:TeamName(), ply:TeamColor()
        local time = math.floor( ply:GetTime() / 60 / 60 )
        time = ( time > 0 ) and time..' ч' or ''

        local priv_rank, color_priv_rank = GetPrivRankTextAndColor( ply )

        local info = GUI.DrawButton( panel, panel:GetWide() - 4, panel:GetTall() - 2 - 4, 2, 2, nil, nil, nil, function( self )
        end, function( self, w, h ) 
            if not IsValid( ply ) then self:Remove() return end

            Draw.Box( w, h, 0, 0, self.color_background, 6 )

            Draw.SimpleText( 42, h / 2 - 2, name, UI.SafeFont( '28 Montserrat' ), C.ABS_WHITE, 'center-left', 1, C.ABS_BLACK )
            Draw.SimpleText( w / 2, h / 2, team_name, UI.SafeFont( '28 Montserrat Light' ), team_color, 'center', 1, C.ABS_BLACK )
            Draw.SimpleText( w * .75, h / 2, priv_rank, UI.SafeFont( '24 Montserrat SemiBold' ), color_priv_rank, 'center', 1, C.ABS_BLACK )

            Draw.SimpleText( w - 12, h / 2, ply:Ping(), UI.SafeFont( '24 Montserrat Light' ), C.ABS_WHITE, 'center-right', 1, C.ABS_BLACK )

            Draw.SimpleText( w - 12 - 32, h / 2, time, UI.SafeFont( '24 Montserrat Light' ), C.ABS_WHITE, 'center-right', 1, C.ABS_BLACK )

            if ply:IsBot() then
                Draw.SimpleText( 8, h / 2, '•', UI.SafeFont( '44 Ambi' ), C.HOMEWAY_BLUE, 'center-left' )
            end
        end )
        info.color_background = COLOR_PANEL

        GUI.OnCursor( info, function()
            info.color_background = ColorAlpha( COLOR_PANEL, 150 )

            -- surface.PlaySound( 'ambi/ui/hover4.wav' )
            info:SetCursor( 'arrow' )

            if ( #actions > 0 ) then
                for i, panel in ipairs( actions ) do panel:Remove() end
            end
            actions = {}

            local goto_btn = GUI.DrawButton( info, 54, 24, info:GetWide() - 54 - 4, info:GetTall() - 24 - 4, nil, nil, nil, function( self )
                surface.PlaySound( 'ambi/ui/click5.mp3' )

                LocalPlayer():ConCommand( 'ulx goto "'..ply:Name()..'"' )
            end, function( self, w, h ) 
                Draw.Box( w, h, 0, 0, COLOR_PANEL, 6 )
                Draw.SimpleText( w / 2, h / 2, 'Goto', UI.SafeFont( '20 Montserrat' ), C.ABS_WHITE, 'center', 1, C.ABS_BLACK )
            end )
            actions[ #actions + 1 ] = goto_btn

            local offset_x = goto_btn:GetWide() + 2
            local bring_btn = GUI.DrawButton( info, 54, 24, info:GetWide() - 54 - 4 - offset_x, info:GetTall() - 24 - 4, nil, nil, nil, function( self )
                surface.PlaySound( 'ambi/ui/click5.mp3' )

                LocalPlayer():ConCommand( 'ulx bring "'..ply:Name()..'"' )
            end, function( self, w, h ) 
                Draw.Box( w, h, 0, 0, COLOR_PANEL, 6 )
                Draw.SimpleText( w / 2, h / 2, 'Bring', UI.SafeFont( '20 Montserrat' ), C.ABS_WHITE, 'center', 1, C.ABS_BLACK )
            end )
            actions[ #actions + 1 ] = bring_btn

            local offset_x = offset_x + bring_btn:GetWide() + 2
            local return_btn = GUI.DrawButton( info, 54, 24, info:GetWide() - 54 - 4 - offset_x, info:GetTall() - 24 - 4, nil, nil, nil, function( self )
                surface.PlaySound( 'ambi/ui/click5.mp3' )

                LocalPlayer():ConCommand( 'ulx return "'..ply:Name()..'"' )
            end, function( self, w, h ) 
                Draw.Box( w, h, 0, 0, COLOR_PANEL, 6 )
                Draw.SimpleText( w / 2, h / 2, 'Return', UI.SafeFont( '20 Montserrat' ), C.ABS_WHITE, 'center', 1, C.ABS_BLACK )
            end )
            actions[ #actions + 1 ] = return_btn

            local offset_x = offset_x + return_btn:GetWide() + 2
            local kick_btn = GUI.DrawButton( info, 54, 24, info:GetWide() - 54 - 4 - offset_x, info:GetTall() - 24 - 4, nil, nil, nil, function( self )
                surface.PlaySound( 'ambi/ui/click5.mp3' )

                LocalPlayer():ConCommand( 'ulx kick "'..ply:Name()..'" "!"' )
            end, function( self, w, h ) 
                Draw.Box( w, h, 0, 0, COLOR_PANEL, 6 )
                Draw.SimpleText( w / 2, h / 2, 'Kick', UI.SafeFont( '20 Montserrat' ), C.ABS_WHITE, 'center', 1, C.ABS_BLACK )
            end )
            actions[ #actions + 1 ] = kick_btn

            local offset_x = offset_x + kick_btn:GetWide() + 2
            local btn_id = GUI.DrawButton( info, 54, 24, info:GetWide() - 54 - 4 - offset_x, info:GetTall() - 24 - 4, nil, nil, nil, function( self )
            end, function( self, w, h ) 
                Draw.Box( w, h, 0, 0, COLOR_PANEL, 6 )
                Draw.SimpleText( w / 2, h / 2, 'ID '..ply:EntIndex(), UI.SafeFont( '20 Montserrat' ), C.ABS_WHITE, 'center', 1, C.ABS_BLACK )
            end )
            actions[ #actions + 1 ] = btn_id

            if ( ply != LocalPlayer() ) then
                offset_x = offset_x + btn_id:GetWide() + 2
                local gag = GUI.DrawButton( info, 54, 24, info:GetWide() - 54 - 4 - offset_x, info:GetTall() - 24 - 4, nil, nil, nil, function()
                    surface.PlaySound( 'ambi/ui/click5.mp3' )

                    if ply:IsMuted() then
                        ply:SetMuted( false )
                    else
                        ply:SetMuted( true )
                    end
                end, function( self, w, h ) 
                    if not IsValid( ply ) then self:Remove() return end
    
                    Draw.Box( w, h, 0, 0, COLOR_PANEL, 6 )
                    Draw.SimpleText( w / 2, h / 2, ply:IsMuted() and 'UnGag' or 'Gag', UI.SafeFont( '16 Montserrat' ), C.ABS_WHITE, 'center', 1, C.ABS_BLACK )
                end )

                actions[ #actions + 1 ] = gag
            end
        end, function()
            info.color_background = COLOR_PANEL
        end )

        if ply:IsBot() then continue end

        local avatar = GUI.DrawTDLib( 'DPanel', info )
        avatar:SetSize( 32, 32 )
        avatar:SetPos( 4, 2 )
        avatar:CircleAvatar()
        avatar:SetPlayer( ply, 32 )

        local avatar_button = GUI.DrawButton( avatar, avatar:GetWide(), avatar:GetTall(), 0, 0, nil, nil, nil, function()
            ply:ShowProfile()

            chat.AddText( C.ABS_WHITE, 'https://steamcommunity.com/profiles/'..ply:SteamID64() )
        end, function( self, w, h ) 
        end )
        local sid = ply:SteamID()
        avatar_button.DoRightClick = function() 
            chat.AddText( C.HOMEWAY_BLUE, '• ', C.ABS_WHITE, sid, C.HOMEWAY_BLUE, ' ('..ply:Nick()..')' )
            SetClipboardText( sid ) 
        end
    end

    Ambi.Homeway.tab = main
end

function Ambi.Homeway.CloseTab()
    if IsValid( Ambi.Homeway.tab ) then 
        Ambi.Homeway.tab:AlphaTo( 0, 0.25, 0, function() Ambi.Homeway.tab:Remove() end )
        gui.EnableScreenClicker( false )
    end
end

hook.Add( 'ScoreboardShow', 'Ambi.Homeway.Tab', function()
    if IsValid( Ambi.Homeway.tab ) then return false end
    
    Ambi.Homeway.ShowTab()
    gui.EnableScreenClicker( true ) 

	return false
end )

hook.Add( 'ScoreboardHide', 'Ambi.Homeway.Tab', function()
    Ambi.Homeway.CloseTab()
    
	return false
end )