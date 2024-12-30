net.Receive( 'ambi_skills_sync', function() 
    LocalPlayer().skills = net.ReadTable() or {}
end )