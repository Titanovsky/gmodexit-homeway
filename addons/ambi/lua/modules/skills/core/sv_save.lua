local JSON = Ambi.Packages.Out( 'json' )

-- --------------------------------------------------------------------------------------------------------------------------------------------
file.CreateDir( 'skills' )

-- --------------------------------------------------------------------------------------------------------------------------------------------
function Ambi.Skills.Save( ePly )
    if not ePly then return false end

    local skills = ePly.skills 
    if not skills then return false end

    if ( hook.Call( '[Ambi.Skills.CanSave]', nil, ePly, skills ) == false ) then return false end
    
    JSON.SerializeFile( skills, 'ambi/skills/'..ePly:NiceSteamID() )

    hook.Call( '[Ambi.Skills.Saved]', ePly, skills )

    return true
end

function Ambi.Skills.Load( ePly )
    if not ePly then return false end

    local skills = ePly.skills 
    if not skills then return false end

    skills = JSON.DeserializeFile( 'ambi/skills/'..ePly:NiceSteamID() )

    if ( hook.Call( '[Ambi.Skills.CanLoad]', nil, ePly, skills ) == false ) then return false end

    hook.Call( '[Ambi.Skills.Loaded]', nil, ePly, skills )

    return skills
end