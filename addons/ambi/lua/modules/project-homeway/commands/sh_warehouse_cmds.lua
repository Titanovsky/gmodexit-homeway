local C = Ambi.General.Global.Colors
local Add = Ambi.ChatCommands.Add
local TYPE = 'Warehouse'

-- ---------------------------------------------------------------------------------------------------------------------------------------
Add( 'canraidfbi', TYPE, 'Узнать можно ли зарейдить ФБР', 1, function( ePly, tArgs ) 
    if ( ePly:GetJob() ~= 'j_mafia_leader' ) then return end

    local warehouse
    for _, obj in ipairs( ents.FindByClass( 'warehouse' ) ) do
        if ( obj:GetWarehouse() == 'fbi' ) then warehouse = obj break end
    end
    if not warehouse then return end

    local wh = Ambi.Homeway.GetWarehouse( warehouse:GetWarehouse() )
    if not wh then return end

    if timer.Exists( 'Ambi.Homeway.RaidWarehouse:'..tostring( warehouse ) ) then ePly:Notify( 'Этот склад уже рейдят', 4, NOTIFY_ERROR ) return end
    if timer.Exists( 'Ambi.Homeway.RaidWarehouseDelay:'..tostring( warehouse ) ) then ePly:Notify( 'Ждите '..math.floor( timer.TimeLeft( 'Ambi.Homeway.RaidWarehouseDelay:'..tostring( warehouse ) ) )..' секунд', 4, NOTIFY_ERROR ) return end

    local players = player.GetAll()

    local count_defenders = 0
    local count_raiders = 0
    local category_raiders = ePly:GetJobTable().category
    for _, ply in ipairs( players ) do
        if ( ply:GetJobTable().category == category_raiders ) then count_raiders = count_raiders + 1 end
        if wh.jobs[ ply:GetJob() ] then count_defenders = count_defenders + 1 end
    end
    if ( count_defenders < Ambi.Homeway.Config.warehouse_raid_online_defenders ) then ePly:Notify( 'Нужно '..Ambi.Homeway.Config.warehouse_raid_online_defenders..' игроков из фракции склада '..wh.header, 6, NOTIFY_ERROR ) return end
    if ( count_raiders < Ambi.Homeway.Config.warehouse_raid_online_raiders ) then ePly:Notify( 'Нужно '..Ambi.Homeway.Config.warehouse_raid_online_raiders..' игроков из вашей фракции', 6, NOTIFY_ERROR ) return end

    ePly:Notify( 'Можно рейдить склад FBI', 4, 2 )
end )

Add( 'canraidpolice', TYPE, 'Узнать можно ли зарейдить Полицию', 1, function( ePly, tArgs ) 
    if ( ePly:GetJob() ~= 'j_mafia_leader' ) then return end

    local warehouse
    for _, obj in ipairs( ents.FindByClass( 'warehouse' ) ) do
        if ( obj:GetWarehouse() == 'police' ) then warehouse = obj break end
    end
    if not warehouse then return end

    local wh = Ambi.Homeway.GetWarehouse( warehouse:GetWarehouse() )
    if not wh then return end

    if timer.Exists( 'Ambi.Homeway.RaidWarehouse:'..tostring( warehouse ) ) then ePly:Notify( 'Этот склад уже рейдят', 4, NOTIFY_ERROR ) return end
    if timer.Exists( 'Ambi.Homeway.RaidWarehouseDelay:'..tostring( warehouse ) ) then ePly:Notify( 'Ждите '..math.floor( timer.TimeLeft( 'Ambi.Homeway.RaidWarehouseDelay:'..tostring( warehouse ) ) )..' секунд', 4, NOTIFY_ERROR ) return end

    local players = player.GetAll()

    local count_defenders = 0
    local count_raiders = 0
    local category_raiders = ePly:GetJobTable().category
    for _, ply in ipairs( players ) do
        if ( ply:GetJobTable().category == category_raiders ) then count_raiders = count_raiders + 1 end
        if wh.jobs[ ply:GetJob() ] then count_defenders = count_defenders + 1 end
    end
    if ( count_defenders < Ambi.Homeway.Config.warehouse_raid_online_defenders ) then ePly:Notify( 'Нужно '..Ambi.Homeway.Config.warehouse_raid_online_defenders..' игроков из фракции склада '..wh.header, 6, NOTIFY_ERROR ) return end
    if ( count_raiders < Ambi.Homeway.Config.warehouse_raid_online_raiders ) then ePly:Notify( 'Нужно '..Ambi.Homeway.Config.warehouse_raid_online_raiders..' игроков из вашей фракции', 6, NOTIFY_ERROR ) return end

    ePly:Notify( 'Можно рейдить склад Полиции', 4, 2 )
end )

Add( 'infowarehouses', TYPE, 'Инфа о складах ФБР и Полиции', 1, function( ePly, tArgs ) 
    local warehouse_fbi
    local warehouse_police

    for _, obj in ipairs( ents.FindByClass( 'warehouse' ) ) do
        if ( obj:GetWarehouse() == 'police' ) then warehouse_police = obj end
        if ( obj:GetWarehouse() == 'fbi' ) then warehouse_fbi = obj end
    end
    if not warehouse_police then return end
    if not warehouse_fbi then return end

    ePly:ChatSend( '~R~ ------------------------------' )
    ePly:ChatSend( '~B~ Полиция:' )
    for i, wep in ipairs( Ambi.Homeway.GetWarehouse( 'police' ).items ) do
        local count = warehouse_police:GetWeaponCount( i )
        local max = wep.max and '/'..wep.max or ''

        ePly:ChatSend( '~B~ \t'..i..'. '..wep.header..' x'..count..max )
    end

    ePly:ChatSend( '' )

    ePly:ChatSend( '~AMBI~ ФБР:' )
    for i, wep in ipairs( Ambi.Homeway.GetWarehouse( 'fbi' ).items ) do
        local count = warehouse_fbi:GetWeaponCount( i )
        local max = wep.max and '/'..wep.max or ''
        
        ePly:ChatSend( '~AMBI~ \t'..i..'. '..wep.header..' x'..count..max )
    end

    ePly:ChatSend( '~R~ ------------------------------' )
end ) 