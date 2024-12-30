hook.Add( '[Ambi.DarkRP.TryArrestObject]', 'Ambi.Homeway.PayForObjects', function( ePolice, eObj )
    if not eObj.nw_ShopClass then return end

    local can = Ambi.Homeway.Config.arrest_objects[ eObj:GetClass() ]
    if not can then return end

    local item = Ambi.DarkRP.GetShopItem( eObj.nw_ShopClass )
    if not item then return end

    if IsValid( ePolice ) then 
        local cost = math.floor( item.price / 4 )
        ePolice:Notify( 'Вы изъяли '..item.name..'  +'..cost..'$', 8 ) 
        ePolice:AddMoney( cost )
    end

    eObj:Remove()
end )