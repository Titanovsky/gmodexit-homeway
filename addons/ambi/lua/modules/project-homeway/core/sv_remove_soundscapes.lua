hook.Add( 'InitPostEntity', 'Ambi.Homeway.RemoveSoundscapes', function() 
    if ( game.GetMap() == 'rp_bangclaw' ) then
        for _, obj in ipairs( ents.FindByClass( 'env_soundscape' ) ) do
            obj:Remove()
        end

        for _, obj in ipairs( ents.FindByClass( 'ambient_generic' ) ) do
            obj:Remove()
        end
    end
end )