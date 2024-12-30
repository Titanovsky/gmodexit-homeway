Ambi.General.CreateModule( 'PhysEnvOpti' )

-- --------------------------------------------------------------------------------------------------------------------------------------------
Ambi.PhysEnvOpti.Config.enable = true
Ambi.PhysEnvOpti.Config.air_density = 0.1
Ambi.PhysEnvOpti.Config.gravity = Vector( 0, 0, -700 )
Ambi.PhysEnvOpti.Config.settings = {
    [ 'MaxAngularVelocity' ] = 300,
    [ 'MaxVelocity' ] = 400,
    [ 'MinFrictionMass' ] = 20,
    [ 'MaxFrictionMass' ] = 600,
    [ 'MaxCollisionChecksPerTimestep' ] = 1000,
    [ 'MaxCollisionsPerObjectPerTimestep' ] = 5,
    [ 'LookAheadTimeObjectsVsObject' ] = 0.5,
    [ 'LookAheadTimeObjectsVsWorld' ] = 1,
}