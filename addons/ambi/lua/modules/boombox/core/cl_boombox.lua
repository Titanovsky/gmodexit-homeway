Ambi.BoomBox.boomboxes = Ambi.BoomBox.boomboxes or {}

local C, GUI, Draw, UI, CL = Ambi.Packages.Out( '@d, ContentLoader' )
local W, H = ScrW(), ScrH()

local null_entities = {} --! DONT RESAVE THIS FILE, WHEN SERVER IS WORKING!

local cvar_type = CreateClientConVar( 'ambi_boombox_3d', '1', true )

-- ---------------------------------------------------------------------------------------------------------------------------------------
function Ambi.BoomBox.OpenMenu( eBoomBox )
    local boombox = eBoomBox -- just it's simple and easy
    if ( boombox:GetClass() ~= Ambi.BoomBox.Config.ent_class ) then return end

    local frame = GUI.DrawFrame( nil, W / 2.4, H / 1.4, 0, 0, '', true, true, true, function( self, w, h ) 
        if not IsValid( boombox ) then self:Remove() return end
        if not LocalPlayer():Alive() then self:Remove() return end

        Draw.Box( w, h, 0, 0, C.AMBI_BLACK, 8 )
        Draw.Box( w, 32, 0, 0, C.AMBI, 8 )
    end )
    frame.OnRemove = function()
        if not IsValid( boombox ) then return end

        net.Start( 'ambi_boombox_close_menu' )
            net.WriteEntity( boombox )
        net.SendToServer()
    end
    frame:Center()

    -- local search = GUI.DrawTextEntry( frame, frame:GetWide(), 32, 0, 28, UI.SafeFont( '32 Ambi' ), C.BLACK, '', C.AMBI_GRAY, 'Press here a name' ) --todo for future

    local panels = GUI.DrawScrollPanel( frame, frame:GetWide(), frame:GetTall() - 32 - 64, 0, 32, function( self, w, h ) 
        Draw.Box( w, h, 0, 0, C.AMBI_BLACK, 8 )
    end )

    for i = 1, #Ambi.BoomBox.Config.radio do
        local radiostation = GUI.DrawButton( panels, panels:GetWide() - 8 * 2, 54, 8, ( 54 + 8 ) * ( i - 1 ) + 8, nil, nil, nil, function()
            net.Start( 'ambi_boombox_play_radio' )
                net.WriteEntity( boombox )
                net.WriteUInt( i, 10 )
            net.SendToServer()

            frame:Remove()
        end, function( self, w, h ) 
            Draw.Box( w, h, 0, 0, C.PANEL, 8 )

            Draw.SimpleText( w / 2, h / 2, Ambi.BoomBox.Config.radio[ i ].header, UI.SafeFont( '42 Ambi' ), C.ABS_WHITE, 'center', 1, C.ABS_BLACK )
        end )
    end

    local stop = GUI.DrawButton( frame, 150, 40, frame:GetWide() / 2 - 150 / 2, frame:GetTall() - 40 - 8, nil, nil, nil, function()
        net.Start( 'ambi_boombox_stop' )
            net.WriteEntity( boombox )
        net.SendToServer()

        frame:Remove()
    end, function( self, w, h ) 
        Draw.Box( w, h, 0, 0, C.RED, 8 )

        Draw.SimpleText( w / 2, h / 2, 'STOP', UI.SafeFont( '45 Ambi' ), C.BLACK, 'center' )
    end )
end

function Ambi.BoomBox.PlayRadio( eBoomBox, nID )
    local boombox = eBoomBox 
    if not IsValid( boombox ) or ( boombox:GetClass() ~= Ambi.BoomBox.Config.ent_class ) then return end

    local radio = Ambi.BoomBox.Config.radio[ nID ]
    if not radio then return end

    local channel_type = cvar_type:GetBool() and '3d' or 'mono'
    sound.PlayURL( radio.url, channel_type, function( audioChannel, nError, sError ) 
        if not IsValid( audioChannel ) then UI.Chat.Send(  '~RU_PINK~ [BoomBox] ~WHITE~ Ошибка: '..sError..' ['..nError..']' ) return end

        audioChannel:SetPos( boombox:GetPos() )
        audioChannel:SetVolume( 0.5 )
        audioChannel:Set3DEnabled( true )
        audioChannel:Set3DFadeDistance( 300, 0 )
        audioChannel:Play()

        Ambi.BoomBox.boomboxes[ boombox ] = audioChannel

        -- ===================================================================================== -
        local name = 'Ambi.BoomBox.FollowSoundFor'..tostring( boombox )
        timer.Create( name, 1, 0, function() 
            if not IsValid( audioChannel ) or not IsValid( boombox ) then 
                if IsValid( audioChannel ) then 
                    audioChannel:Stop() 
                    audioChannel = nil 
                    timer.Remove( name ) 
                end
                
                return 
            end

            audioChannel:SetPos( boombox:GetPos() )

            if not LocalPlayer():CheckDistance( boombox, 300 * 4 ) then
                audioChannel:SetVolume( 0 )
            else
                audioChannel:SetVolume( 1 )
            end
        end )
    end )
end

-- ---------------------------------------------------------------------------------------------------------------------------------------
hook.Add( 'NetworkEntityCreated', 'Ambi.BoomBox.SyncWithNULLEntities', function( eObj )
    local radio = null_entities[ eObj:EntIndex() ]

    if radio then 
        print( '[BoomBox] Sync from NULL entities: '..tostring( eObj ) )
        Ambi.BoomBox.PlayRadio( eObj, radio )
        null_entities[ eObj:EntIndex() ] = nil
    end
end )

-- ---------------------------------------------------------------------------------------------------------------------------------------
net.Receive( 'ambi_boombox_open_menu', function() 
    Ambi.BoomBox.OpenMenu( net.ReadEntity() )
end )

net.Receive( 'ambi_boombox_play_radio_sync', function() 
    local boombox = net.ReadUInt( 14 )
    boombox = ( IsValid( Entity( boombox ) ) and Entity( boombox ) ~= NULL ) and Entity( boombox ) or boombox -- Entity or integer, workaround for NULL entity

    local id = net.ReadUInt( 10 )

    if isnumber( boombox ) then
        null_entities[ boombox ] = nID
        print( '[BoomBox] Cached NULL entity ('..boombox..') to table' )
    else
        Ambi.BoomBox.PlayRadio( boombox, id )
    end
end )

net.Receive( 'ambi_boombox_stop_sync', function() 
    local boombox = net.ReadEntity()
    if not IsValid( Ambi.BoomBox.boomboxes[ boombox ] ) then return end

    Ambi.BoomBox.boomboxes[ boombox ]:Stop()
    Ambi.BoomBox.boomboxes[ boombox ] = nil
end )