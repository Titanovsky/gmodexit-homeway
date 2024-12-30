net.AddString( 'ambi_homeway_factory_machine_make', function( _, ePly ) 
    local id = net.ReadUInt( 12 )
    local obj = Entity( id )
    if not IsValid( obj ) or ( obj:GetClass() ~= 'factory_machine' ) then return end

    local item = net.ReadString()
    ePly.factory_prefab = item

    obj:EmitSound( 'physics/metal/metal_canister_impact_soft2.wav' )
    local ed = EffectData()
        ed:SetEntity( obj )
    util.Effect( "entity_remove", ed, true, true )

    ePly:Notify( 'Заготовка '..Ambi.Homeway.Config.factory_items[ item ].header..' сделана, иди к верстаку', 6, 2 )

    obj:StartReload()
end )