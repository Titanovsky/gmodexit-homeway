function Ambi.FogOpti.SetFarZ( nSize )
    local size = tostring( nSize or 0 )

    Ambi.FogOpti.fog:SetKeyValue( 'farz', size )
end

function Ambi.FogOpti.SetColor( cColor )
    local color = Format( '%i %i %i', cColor.r, cColor.g, cColor.b )
    
    Ambi.FogOpti.fog:SetKeyValue( 'fogcolor', color )
end

function Ambi.FogOpti.SetColor2( cColor )
    local color = Format( '%i %i %i', cColor.r, cColor.g, cColor.b )
    
    Ambi.FogOpti.fog:SetKeyValue( 'fogcolor2', color )
end

function Ambi.FogOpti.SetStart( nSize )
    local size = tostring( nSize or 0 )

    Ambi.FogOpti.fog:SetKeyValue( 'fogstart', size )
end

function Ambi.FogOpti.SetEnd( nSize )
    local size = tostring( nSize or 0 )

    Ambi.FogOpti.fog:SetKeyValue( 'fogend', size )
end

function Ambi.FogOpti.SetMaxDensity( nSize )
    local size = tostring( nSize or 0 )

    Ambi.FogOpti.fog:SetKeyValue( 'fogmaxdensity', size )
end

function Ambi.FogOpti.Enable( bEnable )
    local enable = bEnable and '1' or '0'

    Ambi.FogOpti.fog:SetKeyValue( 'fogenable', enable )
end

function Ambi.FogOpti.Blend( bEnable )
    local enable = bEnable and '1' or '0'

    Ambi.FogOpti.fog:SetKeyValue( 'fogblend', enable )
end

function Ambi.FogOpti.Create( fCallback )
    Ambi.FogOpti.fog = ents.FindByClass( 'env_fog_controller' )[ 1 ] or ents.Create( 'env_fog_controller' )

    if fCallback then fCallback() end

    Ambi.FogOpti.fog:Spawn()

    print( '• Fog created: '..tostring( Ambi.FogOpti.fog ) )
end

-- --------------------------------------------------------------------------------------------------------------------------------------------
hook.Add( 'Initialize', 'Ambi.FogOpti.CreateOrFind', function() 
    if not Ambi.FogOpti.Config.default.create then return end

    Ambi.FogOpti.Create( function()
        Ambi.FogOpti.Enable( Ambi.FogOpti.Config.default.fogenable )
        Ambi.FogOpti.SetStart( Ambi.FogOpti.Config.default.fogstart )
        Ambi.FogOpti.SetEnd( Ambi.FogOpti.Config.default.fogend )
        Ambi.FogOpti.SetFarZ( Ambi.FogOpti.Config.default.farz )
        Ambi.FogOpti.SetMaxDensity( Ambi.FogOpti.Config.default.fogmaxdensity )
        Ambi.FogOpti.Blend( Ambi.FogOpti.Config.default.fogblend )
        Ambi.FogOpti.SetColor( Ambi.FogOpti.Config.default.fogcolor )
        Ambi.FogOpti.SetColor2( Ambi.FogOpti.Config.default.fogcolor2 )
    end ) 
end )