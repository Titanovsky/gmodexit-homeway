local function StartGame()
    timer.Create( 'Ambi.Homeway.StartGame', Ambi.Homeway.Config.computer_club_start_game_delay * 60, 1, function() 
        if ( #player.GetHumans() <= 2 ) then StartGame() return end

        Ambi.Homeway.NotifyAll( 'Через 2 минуты игра "Deathmatch" в комп. клубе', 10 )

        timer.Create( 'Ambi.Homeway.StartGame', 60 * 2, 1, function() 
            Ambi.ComputerClub.Start( 'dm' ) 

            StartGame()
        end )
    end )
end

StartGame()

hook.Add( 'ShowTeam', 'Ambi.Homeway.QuitFromGame', function( ePly ) 
    if not ePly:IsPlayingInComputerClub() then return end  

    local game = Ambi.ComputerClub.GetCurrentGame()
    if not game then return end

    for i, ply in ipairs( game.players ) do
        if ( ply ~= ePly ) then continue end

        ePly:SetPlayInComputerClub( false )
        table.remove( game.players, i )
        Ambi.ComputerClub.Get( game.class ).EndAction( ePly )

        break
    end
end )