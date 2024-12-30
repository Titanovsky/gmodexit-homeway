Ambi.BoomBox.boomboxes = Ambi.BoomBox.boomboxes or {}

local PLAYER = FindMetaTable( 'Player' )

-- ---------------------------------------------------------------------------------------------------------------------------------------
function PLAYER:GetBoomBox()
    return self.owned_boombox
end

function PLAYER:BoomBoxKick( sReason )
    if Ambi.BoomBox.Config.can_kick then 
        self:Kick( '[BoomBox] '..sReason )

        hook.Call( '[Ambi.BoomBox.Kicked]', nil, self, sReason )
    end
end

-- ---------------------------------------------------------------------------------------------------------------------------------------
hook.Add( 'PlayerInitialSpawn', 'Ambi.BoomBox.Sync', function( ePly ) 
    timer.Simple( 1, function() -- workaround
        for boombox, id in pairs( Ambi.BoomBox.boomboxes ) do
            net.Start( 'ambi_boombox_play_radio_sync' )
                net.WriteEntity( boombox )
                net.WriteUInt( id, 10 )
            net.Send( ePly )
        end
    end )
end )

hook.Add( 'PlayerDisconnected', 'Ambi.BoomBox.RemoveUser', function( ePly ) 
    local boombox = ePly:GetBoomBox()
    if IsValid( boombox ) then boombox:RemoveUser( ePly ) end
end )

hook.Add( 'EntityRemoved', 'Ambi.BoomBox.RemoveUser', function( eBoomBox ) 
    if ( eBoomBox:GetClass() ~= Ambi.BoomBox.Config.ent_class ) then return end

    local user = eBoomBox:GetUser()
    if user then eBoomBox:RemoveUser( user ) end

    net.Start( 'ambi_boombox_stop_sync' )
        net.WriteEntity( boombox )
    net.Broadcast()

    Ambi.BoomBox.boomboxes[ eBoomBox ] = nil
end )

-- ---------------------------------------------------------------------------------------------------------------------------------------
net.Receive( 'ambi_boombox_close_menu', function( _, ePly ) 
    local boombox = net.ReadEntity()

    if not IsValid( boombox ) then ePly:BoomBoxKick( 'Отправка несуществующего бумбокса!' ) return end
    if not boombox:GetUser() or ( ePly ~= boombox:GetUser() ) then ePly:BoomBoxKick( 'Отправка бумбокса без User или с другим User!' ) return end

    boombox:RemoveUser( ePly )

    hook.Call( '[Ambi.BoomBox.PlayerClosedMenu]', nil, ePly, boombox )
end )

net.Receive( 'ambi_boombox_play_radio', function( _, ePly ) 
    local boombox = net.ReadEntity()
    local id = net.ReadUInt( 10 )
    
    local station = Ambi.BoomBox.Config.radio[ id ]
    if not station then ePly:BoomBoxKick( 'Отправка несуществующего ID для таблицы с радиостанциями' ) return end

    if not IsValid( boombox ) then ePly:BoomBoxKick( 'Отправка несуществующего бумбокса!' ) return end
    if not boombox:GetUser() or ( ePly ~= boombox:GetUser() ) then ePly:BoomBoxKick( 'Отправка бумбокса без User или с другим User!' ) return end

    if ( hook.Call( '[Ambi.BoomBox.CanPlayerPlayRadio]', nil, ePly, boombox, id, station ) == false ) then return end

    boombox:SetPlayRadio( true, id )

    Ambi.BoomBox.boomboxes[ boombox ] = id

    net.Start( 'ambi_boombox_stop_sync' )
        net.WriteEntity( boombox )
    net.Broadcast()

    net.Start( 'ambi_boombox_play_radio_sync' )
        net.WriteUInt( boombox:EntIndex(), 14 ) -- workaround for NULL entity
        net.WriteUInt( id, 10 )
    net.Broadcast()

    ePly:ChatSend( '~RU_PINK~ [BoomBox] ~WHITE~ Вы включили радиостанцию: ~RU_PINK~ '..station.header )

    hook.Call( '[Ambi.BoomBox.PlayerPlayRadio]', nil, ePly, boombox, id, station )
end )

net.Receive( 'ambi_boombox_stop', function( _, ePly ) 
    local boombox = net.ReadEntity()

    if not IsValid( boombox ) then ePly:BoomBoxKick( 'Отправка несуществующего бумбокса!' ) return end
    if not boombox:GetUser() or ( ePly ~= boombox:GetUser() ) then ePly:BoomBoxKick( 'Отправка бумбокса без User или с другим User!' ) return end

    if ( hook.Call( '[Ambi.BoomBox.CanPlayerStop]', nil, ePly, boombox ) == false ) then return end

    boombox:SetPlayRadio( false )

    Ambi.BoomBox.boomboxes[ boombox ] = nil

    net.Start( 'ambi_boombox_stop_sync' )
        net.WriteEntity( boombox )
    net.Broadcast()

    ePly:ChatSend( '~RU_PINK~ [BoomBox] ~WHITE~ Вы выключили бумбокс ('..boombox:EntIndex()..')' )

    hook.Call( '[Ambi.BoomBox.PlayerStopped]', nil, ePly, boombox )
end )