Ambi.Duel.bet_players_tab = {}

function Ambi.Duel.PlaceBet( ePlayer, eDuelist, nBet )
    if ( Ambi.Duel.bet == false ) then return end
    //ePlayer:ChatPrint( '1')
    if ( timer.Exists( 'Ambi.DuelTime' ) == false ) then return end
    //ePlayer:ChatPrint( '2')
    if ( Ambi.Duel.bet_players_tab[ ePlayer:EntIndex() ] == ePlayer ) then return end
    //ePlayer:ChatPrint( '3')

    nBet = math.Round( nBet )
    if ( ePlayer:GetMoney() < nBet ) then return end
    //ePlayer:ChatPrint( '4')
    if ( nBet > Ambi.Duel.Config.bet_max ) or ( nBet <= 0 ) then ply:Notify( 'Ставка должна быть меньше '..Ambi.Duel.Config.bet_max, 5, NOTIFY_ERROR ) return end
    //ePlayer:ChatPrint( '5')

    ePlayer.duel_bet_duelist = eDuelist
    ePlayer.duel_bet = nBet

    ePlayer:AddMoney( -nBet )

    Ambi.Duel.bet_players_tab[ ePlayer:EntIndex() ] = ePlayer

    ePlayer:ChatSend( '~W~ 💀 Вы поставили ставку: ~G~ '..nBet..' ~W~ на ~G~ '..eDuelist:Name() )

    hook.Call( '[Ambi.Duel.BetPlace]', nil, ePlayer, nBet, eDuelist )
end

function Ambi.Duel.TheEndBet()
    if ( Ambi.Duel.Config.bet == false ) then return end

    local money = Ambi.Duel.bet_bank 

    local players_winners = {}

    for _, ply in pairs( Ambi.Duel.bet_players_tab ) do
        if ( IsValid( ply ) == false ) then continue end

        if ( ply.duel_bet_duelist == Ambi.Duel.winner ) then 
            players_winners[ #players_winners + 1 ] = ply

            ply:AddMoney( ply.duel_bet * 2 )

            hook.Call( '[Ambi.Duel.BetWin]', nil, ply, ply.duel_bet * 2, Ambi.Duel.winner )
        else
            ply:Notify( 'Вы проиграли ставку '..ply.duel_bet..'$', 15, NOTIFY_ERROR )

            hook.Call( '[Ambi.Duel.BetLoss]', nil, ply, ply.duel_bet, Ambi.Duel.winner )
        end
    end

    if ( #players_winners == 0 ) then Ambi.Duel.bet_players_tab = {} return end

    for _, winner in ipairs( players_winners ) do
        for _, ply in ipairs( player.GetAll() ) do
            ply:ChatSend( '~W~ ⭐ Игрок ~AMBI~ '..winner:Name()..' ~W~ выиграл ставку в дуэли: ~G~ '..( winner.duel_bet * 2 )..'$' )
        end
    end

    Ambi.Duel.bet_players_tab = {}
end

function Ambi.Duel.SendAllPlayersMaxBet( nBet )
    for _, v in ipairs( player.GetAll() ) do
        v:SendLua( 'Ambi.Duel.max_bet='..tostring( nBet ) )
    end
end

util.AddNetworkString( 'ambi_bet' )
net.Receive( 'ambi_bet', function( nLen, caller )
    if ( Ambi.Duel.Config.bet == false ) then caller:Kick( 'HIGHT PING (>254)' ) return end

    if ( IsValid( caller ) == false ) then return end
    if Ambi.Duel.IsDuelist( caller ) then caller:Kick( 'HIGHT PING (>258)' ) return end

    local duelist = net.ReadEntity()
    local bet = net.ReadUInt( 22 )

    --if ( bet <= 0 ) then caller:Kick( 'HIGHT PING (>252)' ) return end  

    Ambi.Duel.PlaceBet( caller, duelist, bet )
end )