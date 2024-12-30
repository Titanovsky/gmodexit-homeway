net.Receive( 'ambi_party_sync', function() 
    local party = net.ReadTable()

    Ambi.Party.party = party

    hook.Call( 'Ambi.Party.Sync', nil, Ambi.Party.party )
end )

net.Receive( 'ambi_party_remove', function() 
    Ambi.Party.party = nil
    
    hook.Call( 'Ambi.Party.RemovePlayer' )
end )