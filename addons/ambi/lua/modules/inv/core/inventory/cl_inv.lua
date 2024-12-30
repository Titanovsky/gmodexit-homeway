Ambi.Inv.inventories = Ambi.Inv.inventories or {}

net.Receive( 'ambi_inv_send_inv_to_client', function()
    local tab = net.ReadTable()

    Ambi.Inv.inventories[ tab.key ] = tab.inv

    Ambi.Inv.Log( 'Инвентарь ('..tab.key..') получен' )

    hook.Call( '[Ambi.Inv.Sync]', nil, tab.key, Ambi.Inv.inventories[ tab.key ] )

    if Ambi.Inv.Config.debug then
        print('\n----------------------------------------------------------------')
        PrintTable( Ambi.Inv.inventories[ tab.key ].items )
    end
end )