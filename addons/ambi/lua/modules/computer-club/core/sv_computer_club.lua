local PLAYER = FindMetaTable( 'Player' )

-- --------------------------------------------------------------------------------------------------------------------------------------------
function PLAYER:SetPlayInComputerClub( bPlay )
    self.nw_IsPlayingInComputerClub = bPlay

    hook.Call( '[Ambi.ComputerClub.SetPlay]', nil, self, bPlay )
end

function PLAYER:SetPseudoHealth( nCount )
    nCount = nCount or 0
    nCount = math.max( math.floor( nCount ), 0 )

    self.nw_PseudoHealth = nCount
end

function PLAYER:SetPseudoArmor( nCount )
    nCount = nCount or 0
    nCount = math.max( math.floor( nCount ), 0 )

    self.nw_PseudoArmor = nCount
end

function PLAYER:AddPseudoHealth( nCount )
    self:SetPseudoHealth( self:GetPseudoHealth() + ( nCount or 1 ) )
end

function PLAYER:AddPseudoArmor( nCount )
    self:SetPseudoArmor( self:GetPseudoArmor() + ( nCount or 1 ) )
end

-- --------------------------------------------------------------------------------------------------------------------------------------------
function Ambi.ComputerClub.Start( sGame )
    if Ambi.ComputerClub.game then return end
    
    local game = Ambi.ComputerClub.Get( sGame or '' )
    if not game then return end

    if ( hook.Call( '[Ambi.ComputerClub.CanStart]', nil, sGame, game ) == false ) then return end

    Ambi.ComputerClub.game = {
        class = sGame,
        players = {},
    }

    timer.Create( 'Ambi.ComputerClub.Game:'..sGame, game.time, 1, Ambi.ComputerClub.Stop )

    print( '[Computer Club] started "'..sGame..'" game' )

    hook.Call( '[Ambi.ComputerClub.Started]', nil, sGame )
end

function Ambi.ComputerClub.Stop()
    if not Ambi.ComputerClub.game then return end

    local class = Ambi.ComputerClub.game.class
    local game = Ambi.ComputerClub.Get( class )
    if not game then return end

    if ( hook.Call( '[Ambi.ComputerClub.CanStop]', nil, game ) == false ) then return end

    timer.Remove( 'Ambi.ComputerClub.Game:'..class )

    for _, ply in ipairs( Ambi.ComputerClub.game.players ) do
        ply:SetPlayInComputerClub( false )
        game.EndAction( ply )
    end

    Ambi.ComputerClub.game = nil

    print( '[Computer Club] stoped "'..class..'" game' )

    hook.Call( '[Ambi.ComputerClub.Stoped]', nil, class )
end

function Ambi.ComputerClub.PrepareStartPlayer( ePly )
    if not IsValid( ePly ) then return end
    if ePly:IsPlayingInComputerClub() then return end
    if not Ambi.ComputerClub.GetCurrentGame() then return end
    if ( hook.Call( '[Ambi.ComputerClub.CanPrepareStart]', nil, ePly ) == false ) then return end
    
    local game = Ambi.ComputerClub.Get( Ambi.ComputerClub.GetCurrentGame().class )
    if not game then return end

    ePly:SetPlayInComputerClub( true )
    game.StartAction( ePly, game )

    Ambi.ComputerClub.GetCurrentGame().players[ #Ambi.ComputerClub.GetCurrentGame().players + 1 ] = ePly

    hook.Call( '[Ambi.ComputerClub.PreparedStart]', nil, ePly )
end

function Ambi.ComputerClub.GetCurrentGame()
    return Ambi.ComputerClub.game
end

-- --------------------------------------------------------------------------------------------------------------------------------------------
hook.Add( 'EntityTakeDamage', 'Ambi.ComputerClub.Rules', function( ePly, dmgInfo )
	if not ePly:IsPlayer() then return end
    if not ePly:IsPlayingInComputerClub() then return end

    local damage = dmgInfo:GetDamage()

    ePly:AddPseudoHealth( -damage )

    hook.Call( '[Ambi.ComputerClub.PlayerTakePseudoDamage]', nil, ePly, dmgInfo )

    if ( ePly:GetPseudoHealth() <= 0 ) then
        hook.Call( '[Ambi.ComputerClub.PlayerPseudoDeath]', nil, ePly, dmgInfo )
    end

    return true
end )

hook.Add( 'PlayerDisconnected', 'Ambi.ComputerClub.Rules', function( ePly ) 
    if not ePly:IsPlayingInComputerClub() then return end

    local game = Ambi.ComputerClub.GetCurrentGame()
    for i, ply in ipairs( game.players ) do
        if ( ply == ePly ) then 
            ePly:SetPlayInComputerClub( false )
            table.remove( game.players, i )
            hook.Call( '[Ambi.ComputerClub.Disconnected]', nil, ePly, game )

            return
        end
    end
end )

hook.Add( 'PlayerSpawn', 'Ambi.ComputerClub.Rules', function( ePly ) 
    if not ePly:IsPlayingInComputerClub() then return end

    local game = Ambi.ComputerClub.GetCurrentGame()
    for i, ply in ipairs( game.players ) do
        if ( ply == ePly ) then 
            ePly:SetPlayInComputerClub( false )
            table.remove( game.players, i )
            hook.Call( '[Ambi.ComputerClub.Spawn]', nil, ePly, game )

            return
        end
    end
end )

hook.Add( 'PlayerDeath', 'Ambi.ComputerClub.Rules', function( ePly ) 
    if not ePly:IsPlayingInComputerClub() then return end

    local game = Ambi.ComputerClub.GetCurrentGame()
    for i, ply in ipairs( game.players ) do
        if ( ply == ePly ) then 
            ePly:SetPlayInComputerClub( false )
            table.remove( game.players, i )
            hook.Call( '[Ambi.ComputerClub.Death]', nil, ePly, game )

            return
        end
    end
end )