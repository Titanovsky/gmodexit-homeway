Ambi.Promocode.players = Ambi.Promocode.players or {}

net.Receive( 'ambi_promocode_sync', function() 
    local steamid = net.ReadString()
    local promocodes = net.ReadTable()
    
    Ambi.Promocode.players[ steamid ] = promocodes
end )