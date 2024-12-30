Ambi.Date.time_enviroments = Ambi.Date.time_enviroments or {}

Ambi.Date.light_environment = Ambi.Date.light_environment or nil
Ambi.Date.env_skypaint = Ambi.Date.env_skypaint or nil

-- ----------------------------------------------------------------------------------------------------------------------------
function Ambi.Date.AddTimeEnvironment( sTime, tTime )
    Ambi.Date.time_enviroments[ string.lower( sTime ) ] = tTime

    hook.Call( '[Ambi.Date.AddedTimeEnvironment]', nil, sTime, tTime )
end

function Ambi.Date.SetTimeEnvironment( sTime )
    sTime = string.lower( sTime )

    local env = Ambi.Date.time_enviroments[ sTime ]
    if not env then return end
    if ( hook.Call( '[Ambi.Date.CanSetTimeEnvironment]', nil, sTime, env ) == false ) then return end

    if env.pattern and Ambi.Date.light_environment then Ambi.Date.light_environment:Fire( 'setpattern', env.pattern ) end

    if Ambi.Date.env_skypaint then
        for k, v in pairs( env ) do
            if ( k == 'pattern' ) then continue end

            Ambi.Date.env_skypaint:SetKeyValue( k, v )
        end
    end

    hook.Call( '[Ambi.Date.SetTimeEnvironment]', nil, sTime, env )
end

function Ambi.Date.FindSkyPaint()
    for _, ent in pairs( ents.FindByClass( 'env_skypaint' ) ) do
        Ambi.Date.env_skypaint = ent
    end

    if Ambi.Date.env_skypaint then print( '[Date] env_skypaint has been detected: '..tostring( Ambi.Date.env_skypaint ) ) end
end

function Ambi.Date.FindLightEnvironment()
    for _, ent in pairs( ents.FindByClass( 'light_environment' ) ) do
        Ambi.Date.light_environment = ent
    end

    if Ambi.Date.light_environment then print( '[Date] light_environment has been detected: '..tostring( Ambi.Date.light_environment ) ) end
end

-- ----------------------------------------------------------------------------------------------------------------------------
Ambi.Date.AddTimeEnvironment( 'Day', {
    pattern = 'l', 
    topcolor = '0.27 0.55 0.98', 
    bottomcolor = '0.67 0.75 0.97',
    duskcolor = '0.47 0.68 0.98',
    duskscale = '1.00',
    fadebias = '1.00',
    sunsize = '0.00',
    suncolor = '0.00 0.00 0.00',
    drawstars = '0',
    startexture = 'skybox/starfield',
    starslayers = '0',
    starscale = '0.00 0.00 0.00',
    starfade = '0.00 0.00 0.00',
    starspeed = '0.00 0.00 0.00',
} )

Ambi.Date.AddTimeEnvironment( 'SunDown', {
    pattern = 'f', 
    topcolor = '0.69 0.53 0.45', 
    bottomcolor = '0.26 0.13 0.05',
    duskcolor = '0.63 0.27 0.04',
    duskscale = '1.24',
    fadebias = '1.00',
    sunsize = '2.00',
    suncolor = '1.00 0.56 0.00',
    drawstars = '0',
    startexture = 'skybox/starfield',
    starslayers = '2',
    starscale = '0.90',
    starfade = '1.50',
    starspeed = '0.01'
} )

Ambi.Date.AddTimeEnvironment( 'Night', {
    pattern = 'a', 
    topcolor = '0.00 0.00 0.00', 
    bottomcolor = '0.01 0.01 0.01',
    duskcolor = '0.00 0.00 0.00',
    duskscale = '1.00',
    fadebias = '0.32',
    sunsize = '0.00',
    suncolor = '0.00 0.00 0.00',
    drawstars = '1',
    startexture = 'skybox/starfield',
    starslayers = '2',
    starscale = '0.90',
    starfade = '1.50',
    starspeed = '0.01'
} )

Ambi.Date.AddTimeEnvironment( 'Night Christmas', {
    pattern = 'b',
    topcolor = '0.00 0.00 0.00', 
    bottomcolor = '0.00 0.00 0.02',
    duskcolor = '0.00 0.00 0.02',
    duskscale = '1.00',
    duskintensity = '1.00',
    fadebias = '1.00',
    sunsize = '0.00',
    drawstars = '1',
    startexture = 'skybox/starfield',
    starslayers = '2',
    starscale = '1.45',
    starfade = '1.45',
    starspeed = '0.01'
} )

Ambi.Date.AddTimeEnvironment( 'Halloween', {
    pattern = 'a',
    topcolor = '0.35 0.00 0.00', 
    bottomcolor = '0.02 0.00 0.02',
    duskcolor = '0.25 0.00 0.30',
    duskscale = '1.00',
    duskintensity = '1.00',
    fadebias = '1.00',
    sunsize = '0.00',
    drawstars = '1',
    startexture = 'skybox/starfield',
    starslayers = '2',
    starscale = '1.45',
    starfade = '1.45',
    starspeed = '0.01'
} )

-- ----------------------------------------------------------------------------------------------------------------------------
hook.Add( 'InitPostEntity', 'Ambi.Date.FindTimeEnvironmentsEntities', function()
    timer.Simple( 1, function()
        Ambi.Date.FindLightEnvironment()
        Ambi.Date.FindSkyPaint()
    end )
end )