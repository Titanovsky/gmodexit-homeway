local Add = Ambi.Promocode.Add

-- --------------------------------------------------------------------------------------------------------------------------------------
Add( 'sfstars13', 'Server', 'SF Stars', '', function( ePly ) 
    ePly:ChatSend( '~HOMEWAY_BLUE~ • ~W~ Вы получаете 100 рублей, 15.000$ и 5 Сундуков в инвентарь!' )
    ePly:Notify( 'Промокод активирован!', 10, NOTIFY_ACCEPT )
    ePly:AddIGSFunds( 100, 'Спасибо SF STARs!' )
    ePly:AddMoney( 15000 )

    ePly:AddInvItemOrDrop( 'chest', 1 )
    ePly:AddInvItemOrDrop( 'chest_money', 1 )
    ePly:AddInvItemOrDrop( 'chest_food', 1 )
    ePly:AddInvItemOrDrop( 'chest_boost', 1 )
    ePly:AddInvItemOrDrop( 'chest_weapons', 1 )
end )

hook.Add( '[Ambi.Promocode.CanActivate]', 'Ambi.Homeway.BlockDonatePromocodes', function( ePly, tPromocode )
    if ( tPromocode.promocode ~= 'sfstars13' ) then return end
    if ( ePly:GetTime() >= 60 * 60 * 5 ) then ePly:Notify( 'Промокод доступен для новичков', 10, NOTIFY_ERROR ) return false end
end )