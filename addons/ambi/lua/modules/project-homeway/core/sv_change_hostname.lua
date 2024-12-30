function Ambi.Homeway.ChangeHostname()
    if not Ambi.Homeway.Config.changer_hostname_enable then return end
    
    local hostname = '• Homeway 💙 '..table.Random( Ambi.Homeway.Config.changer_hostname_phrases_a )..' '..table.Random( Ambi.Homeway.Config.changer_hostname_phrases_b )..' '..table.Random( Ambi.Homeway.Config.changer_hostname_phrases_c )

    RunConsoleCommand( 'hostname', hostname )
    SetGlobalString( 'ServerName', hostname )
end

timer.Create( 'Ambi.Homeway.ChangeHostname', Ambi.Homeway.Config.changer_hostname_delay, 0, Ambi.Homeway.ChangeHostname )

-- --------------------------------------------------------------------------------------------------------------------------------------------
hook.Add( 'PostGamemodeLoaded', 'Ambi.Homeway.RemoveHostnameThink', function() 
    timer.Remove( 'HostnameThink' )
    Ambi.Homeway.ChangeHostname()
end )