hook.Add( '[Ambi.ComputerClub.Started]', 'Ambi.Homeway.NotifyAll', function( sGame )
    local game = Ambi.ComputerClub.Get( sGame )

    Ambi.Homeway.NotifyAll( 'Началась игра "DeathMatch" в Комп. Клубе!', 10 )
end )