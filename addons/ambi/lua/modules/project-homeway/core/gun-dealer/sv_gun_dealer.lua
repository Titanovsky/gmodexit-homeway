net.AddString( 'ambi_homeway_gun_dealer_buy' )
net.Receive( 'ambi_homeway_gun_dealer_buy', function( _, ePly ) 
    local has_ent = false
    for _, ent in ipairs( ents.FindInSphere( ePly:GetPos(), 100 ) ) do
        if ( ent:GetClass() == 'npc_gun_dealer' ) then has_ent = true break end
    end
    if not has_ent then return end

    local i = net.ReadUInt( 6 )
    local item = Ambi.Homeway.Config.weapons_list_gundealer_npc[ i ]
    if not item then return end

    local cost = Ambi.Homeway.GetGunDealerWeaponCost( i )

    if ePly:HasWeapon( item.class ) then return end
    if not ePly:Alive() then return end
    if not ePly:CanSpendMoney( cost ) then return end

    ePly:AddMoney( -cost )
    ePly:Give( item.class, true )

    if not ePly:GetWeapon( item.class ) then return end

    local type = ePly:GetWeapon( item.class ):GetPrimaryAmmoType()
    if type then ePly:SetAmmo( ePly:GetAmmoCount( type ) + item.ammo, type ) end

    ePly:ChatSend( '~HOMEWAY_BLUE~ • ~W~ Вы купили ~HOMEWAY_BLUE~ '..item.header..' ~W~ у Дэйва' )
    ePly:EmitSound( 'ambi/money/send2.ogg' )

    hook.Call( '[Ambi.Homeway.BuyWeaponGunDealer]', nil, ePly, item, ePly:GetWeapon( item.class ) )
end )

-- ---------------------------------------------------------------------------------------------------------------------------------------в