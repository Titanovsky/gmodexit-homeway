hook.Add( '[Ambi.DarkRP.CanDropWeapon]', 'Ambi.Homeway.WeaponsToItems', function( ePly, sClass, eWeapon )
    local item = Ambi.Inv.GetItem( sClass )
    if not item then ePly:Notify( 'Нет аналога этого оружия в предметах для инвентаря!', 5, NOTIFY_ERROR ) return false end

    local pos, ang = Ambi.General.Utility.GetFrontPos( ePly, 44 ), ePly:EyeAngles()

    ePly:StripWeapon( sClass )

    local ent = ents.Create( 'inv_item' )
    ent:SetPos( pos )
    ent:SetAngles( ang )
    ent:SetItem( sClass, 1 )
    ent:Spawn()
    ent:CPPISetOwner( ePly ) 

    ePly:Notify( 'Вы выкинули оружие', 3, NOTIFY_SUCCESS )

    hook.Call( '[Ambi.Homeway.DroppedWeapon]', nil, ePly, ent, eWeapon )

    return false
end )