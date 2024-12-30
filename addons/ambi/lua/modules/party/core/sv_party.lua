Ambi.Party.parties = Ambi.Party.parties or {}

local Gen = Ambi.Packages.Out( 'general' )

-- --------------------------------------------------------------------------------------------------------------------------------------------
function Ambi.Party.Create( sClass, eLeader, tData )
    if not sClass then Gen.Error( 'Party', 'sClass == nil' ) return end
    if not IsValid( eLeader ) or not eLeader:IsPlayer() then Gen.Error( 'Party', 'eLeader == nil or not a player' ) return end
    if eLeader:HasParty() then Gen.Error( 'Party', 'The player '..tostring( eLeader )..' already has a party' ) return end
    
    if ( hook.Call( '[Ambi.Party.CanCreate]', nil, sClass, eLeader, tData ) == false ) then return end

    if Ambi.Party.parties[ sClass ] then 
        Ambi.Party.Remove( sClass ) 

        if Ambi.Party.Get( sClass ) then return end
    end

    Ambi.Party.parties[ sClass ] = {
        class = sClass,
        members = {}, -- will add in AddPlayer
        leader = eLeader,
        data = tData or {}
    }

    Ambi.Party.AddPlayer( sClass, eLeader )

    hook.Call( '[Ambi.Party.Created]', nil, Ambi.Party.parties[ sClass ] )
end

function Ambi.Party.Remove( sClass )
    if not sClass then Gen.Error( 'Party', 'sClass == nil' ) return end
    if not Ambi.Party.parties[ sClass ] then Gen.Error( 'Party', 'The party '..sClass..' is not valid!' ) return end

    if ( hook.Call( '[Ambi.Party.CanRemove]', nil, Ambi.Party.parties[ sClass ] ) == false ) then return end

    for _, ply in ipairs( Ambi.Party.GetMembers( sClass ) ) do
        ply.party = nil -- здесь оригинальное удаление заместо Ambi.Party.RemovePlayer, так как из-за лидера происходит зацикливания
        Ambi.Party.Sync( ply, true )
    end

    Ambi.Party.parties[ sClass ] = nil

    hook.Call( '[Ambi.Party.Removed]', nil, sClass )
end

function Ambi.Party.Get( sClass )
    return Ambi.Party.parties[ sClass or '' ]
end

function Ambi.Party.GetMembers( sClass )
    if not sClass then Gen.Error( 'Party', 'sClass == nil' ) return end

    local party = Ambi.Party.Get( sClass )
    if not party then Gen.Error( 'Party', 'The party '..sClass..' is not valid!' ) return end

    return party.members
end

-- --------------------------------------------------------------------------------------------------------------------------------------------
function Ambi.Party.SetData( sClass, sKey, anyValue )
    if not sClass then Gen.Error( 'Party', 'sClass == nil' ) return end
    if not sKey then Gen.Error( 'Party', 'sKey == nil' ) return end
    if ( anyValue == nil ) then Gen.Error( 'Party', 'anyValue == nil' ) return end

    local party = Ambi.Party.Get( sClass )
    if not party then Gen.Error( 'Party', 'The party '..sClass..' is not valid!' ) return end

    if ( hook.Call( '[Ambi.Party.CanSetData]', nil, party, sKey, anyValue ) == false ) then return end

    party.data[ sKey ] = anyValue

    Ambi.Party.SyncMembers( sClass )

    hook.Call( '[Ambi.Party.SetData]', nil, party, sKey, anyValue )
end

function Ambi.Party.RemoveData( sClass, sKey )
    if not sClass then Gen.Error( 'Party', 'sClass == nil' ) return end
    if not sKey then Gen.Error( 'Party', 'sKey == nil' ) return end

    local party = Ambi.Party.Get( sClass )
    if not party then Gen.Error( 'Party', 'The party '..sClass..' is not valid!' ) return end

    if ( hook.Call( '[Ambi.Party.CanRemoveData]', nil, party, sKey ) == false ) then return end

    party.data[ sKey ] = nil

    Ambi.Party.SyncMembers( sClass )

    hook.Call( '[Ambi.Party.RemovedData]', nil, party, sKey )
end

function Ambi.Party.GetData( sClass, sKey )
    if not sClass then Gen.Error( 'Party', 'sClass == nil' ) return end
    if not sKey then Gen.Error( 'Party', 'sKey == nil' ) return end

    local party = Ambi.Party.Get( sClass )
    if not party then Gen.Error( 'Party', 'The party '..sClass..' is not valid!' ) return end

    return party.data[ sKey ]
end

-- --------------------------------------------------------------------------------------------------------------------------------------------
function Ambi.Party.AddPlayer( sClass, ePly )
    if not sClass then Gen.Error( 'Party', 'sClass == nil' ) return end
    if not IsValid( ePly ) or not ePly:IsPlayer() then Gen.Error( 'Party', 'ePly == nil or not a player' ) return end
    if ePly:HasParty() then Gen.Error( 'Party', 'The player '..tostring( ePly )..' already has a party' ) return end

    local party = Ambi.Party.Get( sClass )
    if not party then Gen.Error( 'Party', 'The party '..sClass..' is not valid!' ) return end
    if ( #party.members >= Ambi.Party.Config.max_players ) then return end

    if ( hook.Call( '[Ambi.Party.CanAddPlayer]', nil, party, ePly ) == false ) then return end

    ePly.party = sClass
    party.members[ #party.members + 1 ] = ePly

    Ambi.Party.SyncMembers( sClass )

    hook.Call( '[Ambi.Party.AddedPlayer]', nil, party, ePly )
end

function Ambi.Party.RemovePlayer( ePly )
    if not IsValid( ePly ) or not ePly:IsPlayer() then Gen.Error( 'Party', 'ePly == nil or not a player' ) return end

    local party = ePly:GetParty()
    if not party then Gen.Error( 'Party', 'The party is not valid!' ) return end

    local is_leader = ePly:IsPartyLeader()
    local class = party.class

    if ( hook.Call( '[Ambi.Party.CanRemovePlayer]', nil, party, ePly ) == false ) then return end

    ePly.party = nil
    Ambi.Party.Sync( ePly, true )

    for i, ply in ipairs( Ambi.Party.GetMembers( class ) ) do
        if ( ply == ePly ) then table.remove( party.members, i ) break end
    end

    hook.Call( '[Ambi.Party.RemovedPlayer]', nil, party, ePly )

    if is_leader or ( #party.members == 0 ) then 
        Ambi.Party.Remove( party.class )
    else
        Ambi.Party.SyncMembers( class )
    end
end

function Ambi.Party.TransferLeader( sClass, eMember )
    if not IsValid( eMember ) or not eMember:IsPlayer() then Gen.Error( 'Party', 'eMember == nil or not a player' ) return end

    local party = eMember:GetParty()
    if not party then Gen.Error( 'Party', 'The party is not valid!' ) return end

    if ( hook.Call( '[Ambi.Party.CanTransferLeader]', nil, party, eMember ) == false ) then return end

    for i, ply in ipairs( party.members ) do
        if ( eMember ~= ply ) then continue end

        local temp_leader = party.members[ 1 ] -- the first always is the leader
        party.members[ 1 ] = ply
        party.members[ i ] = temp_leader

        break
    end

    hook.Call( '[Ambi.Party.TransferedLeader]', nil, party, eMember )

    Ambi.Party.SyncMembers( sClass )
end

function Ambi.Party.Sync( ePly, bRemove )
    if not IsValid( ePly ) or not ePly:IsPlayer() then Gen.Error( 'Party', 'ePly == nil or not a player' ) return end

    local party = Ambi.Party.parties[ ePly.party ]

    if ( hook.Call( '[Ambi.Party.CanSync]', nil, party, ePly, bRemove ) == false ) then return end

    if bRemove then
        net.Start( 'ambi_party_remove' )
        net.Send( ePly )
    else
        if not party then Gen.Error( 'Party', 'The party '..ePly.party..' is not valid!' ) return end

        net.Start( 'ambi_party_sync' )
            net.WriteTable( party )
        net.Send( ePly )
    end

    hook.Call( '[Ambi.Party.Sync]', nil, party, ePly, bRemove )
end

function Ambi.Party.SyncMembers( sClass )
    local party = Ambi.Party.Get( sClass )
    if not party then return end

    for _, ply in ipairs( Ambi.Party.GetMembers( sClass ) ) do
        Ambi.Party.Sync( ply )
    end
end

-- --------------------------------------------------------------------------------------------------------------------------------------------
hook.Add( 'PlayerDisconnected', 'Ambi.Party.Remove', function( ePly ) 
    if not ePly:HasParty() then return end
    if ePly:IsPartyLeader() and ( not Ambi.Party.Config.remove_party_leader_disconnected ) then return end

    Ambi.Party.RemovePlayer( ePly )
end )

-- --------------------------------------------------------------------------------------------------------------------------------------------
net.AddString( 'ambi_party_sync' )
net.AddString( 'ambi_party_remove' )