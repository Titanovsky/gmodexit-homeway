local Add = Ambi.Daily.AddPattern

local jobs = {
    'j_mafia1',
    'j_gang1',
    'j_police1',
    'j_bodyguard',
    'j_sheriff',
    'j_mayor',
    'j_fbi1',
    'j_gundealer',
}

Add( 'setjob', {
    Description = function( tDaily )
        local job = tDaily.features.job_name

        return 'Вступить на работу '..job
    end,

    Reward = function( ePly, tDaily )
        ePly:ChatSend( '~B~ • ~W~ За выполнение дейлика вы получаете: 1000$'  )
        ePly:AddMoney( 1000 )
    end,

    Make = function( tDaily, nID )
        local job_class = table.Random( jobs )
        local job = Ambi.DarkRP.GetJob( job_class )
        if not job then return end

        tDaily.features.job = job_class
        tDaily.features.job_name = job.name

        Ambi.Daily.HookAdd( tDaily, '[Ambi.DarkRP.SetJob]', 'Ambi.Homeway.DailySetJob', function( ePly, sClass )
            if ( sClass ~= job_class ) then return end

            Ambi.Daily.AddCount( ePly, nID, 1 )
        end )
    end
} )