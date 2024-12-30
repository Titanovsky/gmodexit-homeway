hook.Add( 'OnEntityCreated', 'Ambi.RenderDistanceOpti.DisableObjects', function( eObj )
    if not Ambi.RenderDistanceOpti.Config.setup_rules_on_created then return end
    if not Ambi.RenderDistanceOpti.Config.enable_for_player and eObj:IsPlayer() then return end

    Ambi.RenderDistanceOpti.Setup( eObj )
end )