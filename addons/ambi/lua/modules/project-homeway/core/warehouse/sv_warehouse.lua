net.AddString( 'ambi_homeway_warehouse_take_wep', function( _, ePly ) 
    local obj

    for _, ent in ipairs( ents.FindInSphere( ePly:GetPos(), 120 ) ) do
        if ( ent:GetClass() == 'warehouse' ) then obj = ent break end
    end

    if not IsValid( obj ) then ePly:Kick( '[Warehouse] Подозрение в читерстве #1' ) return end

    local wh = Ambi.Homeway.GetWarehouse( obj:GetWarehouse() )
    if not wh then return end

    local id = net.ReadUInt( 6 )
    local wep = wh.items[ id ]
    if not wep then return end
    if ePly:HasWeapon( wep.class ) then ePly:Kick( '[Warehouse] Подозрение в читерстве #2' ) return end

    local count = obj:GetWeaponCount( id )
    if ( count <= 0 ) then ePly:Kick( '[Warehouse] Подозрение в читерстве #3' ) return end

    if not wh.jobs[ ePly:GetJob() ] then ePly:Kick( '[Warehouse] Подозрение в читерстве #4' ) return end

    ePly:Give( wep.class, true )
    ePly:GetWeapon( wep.class ).cannot_drop = true
    ePly:GetWeapon( wep.class ).job_weapon = true
    ePly:Notify( 'Ты взял '..wep.header, 4 )

    for _, ply in ipairs( player.GetAll() ) do
        if wh.jobs[ ply:GetJob() ] then 
            ply:ChatSend( '~HOMEWAY_BLUE~ • ~W~ '..ePly:GetJobTable().name..' ~HOMEWAY_BLUE~ '..ePly:Name()..' ~W~ взял со склада ~HOMEWAY_BLUE~ '..wep.header )
        end
    end

    obj:SetWeaponCount( id, count - 1 )
end )

net.AddString( 'ambi_homeway_warehouse_buy_wep', function( _, ePly ) 
    local obj

    for _, ent in ipairs( ents.FindInSphere( ePly:GetPos(), 120 ) ) do
        if ( ent:GetClass() == 'warehouse' ) then obj = ent break end
    end

    if not IsValid( obj ) then ePly:Kick( '[Warehouse] Подозрение в читерстве #5' ) return end

    local wh = Ambi.Homeway.GetWarehouse( obj:GetWarehouse() )
    if not wh then return end

    local id = net.ReadUInt( 6 )
    local wep = wh.items[ id ]
    if not wep then return end
    if not wep.cost then return end

    local count = obj:GetWeaponCount( id )
    if wep.max and ( count >= wep.max ) then ePly:Kick( '[Warehouse] Подозрение в читерстве #6' ) return end

    if not wh.leaders[ ePly:GetJob() ] then ePly:Kick( '[Warehouse] Подозрение в читерстве #7' ) return end
    if ( ePly:GetMoney() < wep.cost ) then ePly:Kick( '[Warehouse] Подозрение в читерстве #8' ) return end

    ePly:Notify( 'Ты купил '..wep.header, 4, 2 )
    ePly:AddMoney( -wep.cost )

    obj:SetWeaponCount( id, obj:GetWeaponCount( id ) + 1 )

    local post_text = wep.max and obj:GetWeaponCount( id )..'/'..wep.max or obj:GetWeaponCount( id )

    for _, ply in ipairs( player.GetAll() ) do
        if wh.jobs[ ply:GetJob() ] then 
            ply:ChatSend( '~HOMEWAY_BLUE~ • ~W~ '..ePly:GetJobTable().name..' ~W~ закупил ~HOMEWAY_BLUE~ '..wep.header..' ~W~ на склад ~HOMEWAY_BLUE~ ('..post_text..')' )
        end
    end

    obj:AddMoney( wep.cost )
end )

--todo
net.AddString( 'ambi_homeway_warehouse_buy_medkits', function( _, ePly ) 
    local obj

    for _, ent in ipairs( ents.FindInSphere( ePly:GetPos(), 120 ) ) do
        if ( ent:GetClass() == 'warehouse' ) then obj = ent break end
    end

    if not IsValid( obj ) then ePly:Kick( '[Warehouse] Подозрение в читерстве #5' ) return end

    local wh = Ambi.Homeway.GetWarehouse( obj:GetWarehouse() )
    if not wh then return end

    local id = net.ReadUInt( 6 )
    local wep = wh.items[ id ]
    if not wep then return end
    if not wep.cost then return end

    local count = obj:GetWeaponCount( id )
    if wep.max and ( count >= wep.max ) then ePly:Kick( '[Warehouse] Подозрение в читерстве #6' ) return end

    if not wh.leaders[ ePly:GetJob() ] then ePly:Kick( '[Warehouse] Подозрение в читерстве #7' ) return end
    if ( ePly:GetMoney() < wep.cost ) then ePly:Kick( '[Warehouse] Подозрение в читерстве #8' ) return end

    ePly:Notify( 'Ты купил '..wep.header, 4, 2 )
    ePly:AddMoney( -wep.cost )

    obj:SetWeaponCount( id, obj:GetWeaponCount( id ) + 1 )

    local post_text = wep.max and obj:GetWeaponCount( id )..'/'..wep.max or obj:GetWeaponCount( id )

    for _, ply in ipairs( player.GetAll() ) do
        if wh.jobs[ ply:GetJob() ] then 
            ply:ChatSend( '~HOMEWAY_BLUE~ • ~W~ '..ePly:GetJobTable().name..' ~W~ закупил ~HOMEWAY_BLUE~ '..wep.header..' ~W~ на склад ~HOMEWAY_BLUE~ ('..post_text..')' )
        end
    end

    obj:AddMoney( wep.cost )
end )

hook.Add( '[Ambi.DarkRP.SetJob]', 'Ambi.Homeway.ResetWarehouse', function( ePly, sClass, _, sOldClass ) 
    if ( sOldClass == 'j_sheriff' ) then
        for _, warehouse in ipairs( ents.FindByClass( 'warehouse' ) ) do
            if ( warehouse:GetWarehouse() == 'police' ) then 
                warehouse:SetWarehouse( 'police' ) 
                warehouse:Close()

                return 
            end
        end
    elseif ( sOldClass == 'j_mafia_leader' ) then
        for _, warehouse in ipairs( ents.FindByClass( 'warehouse' ) ) do
            if ( warehouse:GetWarehouse() == 'mafia' ) then 
                warehouse:SetWarehouse( 'mafia' ) 
                warehouse:Close() 
                
                return 
            end
        end
    elseif ( sOldClass == 'j_fbi_leader' ) then
        for _, warehouse in ipairs( ents.FindByClass( 'warehouse' ) ) do
            if ( warehouse:GetWarehouse() == 'fbi' ) then 
                warehouse:SetWarehouse( 'fbi' ) 
                warehouse:Close() 
                
                return 
            end
        end
    end
end )

hook.Add( 'PlayerDisconnected', 'Ambi.Homeway.ResetWarehouse', function( ePly ) 
    local job = ePly:GetJob()

    if ( job == 'j_sheriff' ) then
        for _, warehouse in ipairs( ents.FindByClass( 'warehouse' ) ) do
            if ( warehouse:GetWarehouse() == 'police' ) then 
                warehouse:SetWarehouse( 'police' ) 
                warehouse:Close() 

                return 
            end
        end
    elseif ( job == 'j_mafia_leader' ) then
        for _, warehouse in ipairs( ents.FindByClass( 'warehouse' ) ) do
            if ( warehouse:GetWarehouse() == 'mafia' ) then 
                warehouse:SetWarehouse( 'mafia' ) 
                warehouse:Close() 

                return 
            end
        end
    elseif ( job == 'j_fbi_leader' ) then
        for _, warehouse in ipairs( ents.FindByClass( 'warehouse' ) ) do
            if ( warehouse:GetWarehouse() == 'fbi' ) then 
                warehouse:SetWarehouse( 'fbi' ) 
                warehouse:Close() 
                
                return 
            end
        end
    end
end )