function Ambi.Homeway.RaidWarehouse( ePly, eWarehouse )
    if ePly.raider then return end
    local wh = Ambi.Homeway.GetWarehouse( eWarehouse:GetWarehouse() )
    if not wh then return end

    if timer.Exists( 'Ambi.Homeway.RaidWarehouse:'..tostring( eWarehouse ) ) then return end
    if timer.Exists( 'Ambi.Homeway.RaidWarehouseDelay:'..tostring( eWarehouse ) ) then ePly:Notify( 'Ждите '..math.floor( timer.TimeLeft( 'Ambi.Homeway.RaidWarehouseDelay:'..tostring( eWarehouse ) ) )..' секунд', 4, NOTIFY_ERROR ) return end

    if not wh.raiders then return end

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

    for _, ply in ipairs( players ) do
        ply:ChatSend( '~FLAT_RED~ • ~W~ '..ePly:GetJobTable().name..' ~W~ начал рейд склада ~FLAT_RED~ '..wh.header )
        ply:Notify( ePly:GetJobTable().name..' начал рейд склада '..wh.header, 12 )
    end

    ePly:Notify( 'Не умирайте и не выходите с сервера '..Ambi.Homeway.Config.warehouse_raid_time..' минуты', 12 )
    ePly.raider = eWarehouse

    timer.Create( 'Ambi.Homeway.RaidWarehouse:'..tostring( eWarehouse ), Ambi.Homeway.Config.warehouse_raid_time * 60, 1, function() 
        timer.Create( 'Ambi.Homeway.RaidWarehouseDelay:'..tostring( eWarehouse ), Ambi.Homeway.Config.warehouse_raid_delay_win * 60, 1, function() end )
        ePly.raider = nil

        for _, obj in ipairs( ents.GetAll() ) do
            if ( obj:GetClass() == 'warehouse' ) and ( obj:GetWarehouse() == 'mafia' ) then
                for i, wep_mafia in ipairs( obj:GetItems() ) do
                    for j, wep_warehouse in ipairs( eWarehouse:GetItems() ) do
                        if ( wep_warehouse.class == wep_mafia.class ) then  
                            local count = wep_warehouse.count

                            obj:SetWeaponCount( i, obj:GetWeaponCount( i ) + count )
                            eWarehouse:SetWeaponCount( j, 0 )
                        end
                    end
                end

                break
            end
        end

        local money = eWarehouse:GetMoney()
        if ( money > 0 ) then
            ePly:AddMoney( money )
            ePly:Notify( 'Вы украли '..money..'$', 20 )

            eWarehouse:SetMoney( 0 )
        end

        for _, ply in ipairs( player.GetAll() ) do
            ply:ChatSend( '~FLAT_RED~ • ~W~ '..ePly:GetJobTable().name..' ~W~ успешно ~FLAT_GREEN~ зарейдил ~W~ склад ~FLAT_RED~ '..wh.header )
            ply:Notify( 'Рейд '..wh.header..' успешно закончился', 6, 2 )
        end
    end )
end

-- -------------------------------------------------------------------------------------------------------------------------
hook.Add( 'PlayerDeath', 'Ambi.Homeway.WarehouseRaid', function( ePly ) 
    if not ePly.raider then return end

    timer.Remove( 'Ambi.Homeway.RaidWarehouse:'..tostring( ePly.raider ) )

    for _, ply in ipairs( player.GetAll() ) do
        ply:ChatSend( '~FLAT_RED~ • ~W~ Рейд склада провалился, ~FLAT_RED~ '..ePly:Name()..' ~W~ погиб' )
    end

    ePly.raider = nil

    timer.Create( 'Ambi.Homeway.RaidWarehouseDelay:'..tostring( ePly.raider ), Ambi.Homeway.Config.warehouse_raid_delay_lose * 60, 1, function() end )
end )

hook.Add( '[Ambi.DarkRP.SetJob]', 'Ambi.Homeway.WarehouseRaid', function( ePly ) 
    if not ePly.raider then return end

    timer.Remove( 'Ambi.Homeway.RaidWarehouse:'..tostring( ePly.raider ) )

    for _, ply in ipairs( player.GetAll() ) do
        ply:ChatSend( '~FLAT_RED~ • ~W~ Рейд склада провалился, ~FLAT_RED~ '..ePly:Name()..' ~W~ сменил профу' )
    end

    ePly.raider = nil

    timer.Create( 'Ambi.Homeway.RaidWarehouseDelay:'..tostring( ePly.raider ), Ambi.Homeway.Config.warehouse_raid_delay_lose * 60, 1, function() end )
end )

hook.Add( 'PlayerDisconnected', 'Ambi.Homeway.WarehouseRaid', function( ePly ) 
    if not ePly.raider then return end

    timer.Remove( 'Ambi.Homeway.RaidWarehouse:'..tostring( ePly.raider ) )

    for _, ply in ipairs( player.GetAll() ) do
        ply:ChatSend( '~FLAT_RED~ • ~W~ Рейд склада провалился, ~FLAT_RED~ '..ePly:Name()..' ~W~ вышел' )
    end

    timer.Create( 'Ambi.Homeway.RaidWarehouseDelay:'..tostring( ePly.raider ), Ambi.Homeway.Config.warehouse_raid_delay_lose * 60, 1, function() end )
end )