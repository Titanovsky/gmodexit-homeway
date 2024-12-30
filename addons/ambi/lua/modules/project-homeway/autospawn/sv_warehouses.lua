if not Ambi.AutoSpawn then return end

local Add = Ambi.AutoSpawn.Add

local MAP = 'rp_bangclaw'

Add( 'warehouse_fbi', 'warehouse', 'Ящик для FBI', MAP, Vector( -1106, -2238, 373 ), Angle( 0, -138, 1 ), function( eObj )
    eObj:SetWarehouse( 'fbi' )
end )

Add( 'warehouse_police', 'warehouse', 'Ящик для Police', MAP, Vector( 4261, -1127, 108 ), Angle( 0, 90, 0 ), function( eObj )
    eObj:SetWarehouse( 'police' )
end )

Add( 'warehouse_mafia', 'warehouse', 'Ящик для Mafia', MAP, Vector( 5863, -2137, 236 ), Angle( 0, -180, 0 ), function( eObj )
    eObj:SetWarehouse( 'mafia' )
end )

Add( 'warehouse_mayor', 'warehouse', 'Ящик для Мэрии', MAP, Vector( 654, 2663, 180 ), Angle( 0, -90, 0 ), function( eObj )
    eObj:SetWarehouse( 'mayor' )
end )

local MAP = 'rp_bangclaw_drp_winter_v1'

Add( 'warehouse_fbi', 'warehouse', 'Ящик для FBI', MAP, Vector( -1106, -2238, 373 ), Angle( 0, -138, 1 ), function( eObj )
    eObj:SetWarehouse( 'fbi' )
end )

Add( 'warehouse_police', 'warehouse', 'Ящик для Police', MAP, Vector( 4261, -1127, 108 ), Angle( 0, 90, 0 ), function( eObj )
    eObj:SetWarehouse( 'police' )
end )

Add( 'warehouse_mafia', 'warehouse', 'Ящик для Mafia', MAP, Vector( 5863, -2137, 236 ), Angle( 0, -180, 0 ), function( eObj )
    eObj:SetWarehouse( 'mafia' )
end )

Add( 'warehouse_mayor', 'warehouse', 'Ящик для Мэрии', MAP, Vector( 654, 2663, 180 ), Angle( 0, -90, 0 ), function( eObj )
    eObj:SetWarehouse( 'mayor' )
end )