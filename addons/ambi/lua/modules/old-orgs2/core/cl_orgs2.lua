net.Receive( 'amb_send_org', function()
    local tab = net.ReadTable()
    AmbOrgs2.Orgs = nil
    AmbOrgs2.Orgs = tab

    print( '[AmbiOrg2] Sync' )
end )