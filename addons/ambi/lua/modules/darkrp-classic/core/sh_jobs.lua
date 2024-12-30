local Gen = Ambi.Packages.Out( 'General' )
local cache_commands = {}

local function GetDefaultValues( tJob )
    tJob.name = tJob.name or 'Unknow'
    tJob.description = tJob.description or ''
    tJob.category = tJob.category or 'Other'
    tJob.max = tJob.max or 0
    tJob.salary = tJob.salary or 0
    tJob.color = tJob.color or Color( 255, 255, 255 )
    tJob.model = tJob.model or { 'models/player/Group03/Female_01.mdl' }
    tJob.weapons = tJob.weapons or { 'keys' }

    return tJob
end

function Ambi.DarkRPClassic.JobCreate( tJob )
    local table_job = GetDefaultValues( tJob )

    print( tJob.command )

    return DarkRP.createJob( table_job.name, table_job )
end

function Ambi.DarkRPClassic.JobSimpleCreate( sName, sCommand, sCategory, sDescription, nMax, nSalary, bVote, bLicense, bDemote, cColor, tModels, tWeapons, tOther  )
    if not sCommand or cache_commands[sCommand] then Gen.Error( 'DarkRPClassic', 'sCommand is nill or already have' ) return end

    local tab = {
        name = sName,
        command = sCommand,
        category = sCategory,
        description = sDescription,
        max = nMax,
        salary = nSalary,
        vote = bVote,
        hasLicense = bLicense,
        candemote = bDemote,
        color = cColor,
        model = tModels,
        weapons = tWeapons,
    }

    if tOther then
        for key, value in pairs( tOther ) do
            tab[ key ] = value
        end
    end

    return Ambi.DarkRPClassic.JobCreate( tab )
end