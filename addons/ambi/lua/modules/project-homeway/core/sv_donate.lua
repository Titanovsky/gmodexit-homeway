hook.Add( 'IGS.PlayerDonate', 'Ambi.Homeway.DonateX', function( ePly, nSum )
    if ( Ambi.Homeway.Config.donate_x <= 1 ) or ( Ambi.Homeway.Config.donate_x > 5 ) then return end

    Ambi.Homeway.Config.donate_x = math.floor( Ambi.Homeway.Config.donate_x )
    
    local x = Ambi.Homeway.Config.donate_x - 1
    local add = math.floor( nSum * x )
	ePly:AddIGSFunds( add, 'Умножение x'..Ambi.Homeway.Config.donate_x )

	Ambi.Homeway.NotifyAll( 'Сейчас акция Донат x'..Ambi.Homeway.Config.donate_x, 15, NOTIFY_ACCEPT )

    for _, ply in ipairs( player.GetAll() ) do
        ply:ChatSend( '~W~ 🤑 Игроку ~HOMEWAY_BLUE~ '..ePly:Name()..' ~W~ добавлены ~G~ '..add..' ~W~ рублей за акцию ~AMBI~ x'..Ambi.Homeway.Config.donate_x )
    end
end )