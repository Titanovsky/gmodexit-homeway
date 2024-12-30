function Ambi.PhysEnvOpti.Setup()
    print( '[PhysEnvOpti] Set custom physenv settings\n' )

    physenv.SetPerformanceSettings( Ambi.PhysEnvOpti.Config.settings )
    physenv.SetAirDensity( Ambi.PhysEnvOpti.Config.air_density )
    physenv.SetGravity( Ambi.PhysEnvOpti.Config.gravity )
end
concommand.Add( 'ambi_physenvopti_refresh', Ambi.PhysEnvOpti.SetPhysEnvrionmentSettings )

hook.Add( 'PostGamemodeLoaded', 'Ambi.PhysEnvOpti.Setup', function()
    if not Ambi.PhysEnvOpti.Config.enable then return end

    timer.Simple( 1, Ambi.PhysEnvOpti.Setup )
end )