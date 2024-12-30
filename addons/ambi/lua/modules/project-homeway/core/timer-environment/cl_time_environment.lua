net.Receive( 'ambi_homeway_time_environment', function() 
    render.RedownloadAllLightmaps( true )

    timer.Simple( 0.1, Ambi.Homeway.Retexture )
end )