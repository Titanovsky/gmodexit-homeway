function Ambi.Homeway.GetGunDealersCount()
    return Ambi.DarkRP.GetJobPlayersCount( 'j_gundealer' ) + Ambi.DarkRP.GetJobPlayersCount( 'j_gundealer_vip' ) + Ambi.DarkRP.GetJobPlayersCount( 'j_gundealer_premium' )
end

function Ambi.Homeway.GetGunDealerWeaponCost( nID )
    local cost = Ambi.Homeway.Config.weapons_list_gundealer_npc[ nID ].cost
    
    return ( Ambi.Homeway.GetGunDealersCount() > 0 ) and cost + ( cost * .3 ) or cost
end