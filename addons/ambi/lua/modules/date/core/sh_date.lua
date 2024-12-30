Ambi.Date.time          = Ambi.Date.time or {}
Ambi.Date.time.minutes  = Ambi.Date.time.minutes or 0
Ambi.Date.time.hours    = Ambi.Date.time.hours or 0
Ambi.Date.time.days     = Ambi.Date.time.days or 1

local MINUTE = 60
local DAY = 24

-- ---------------------------------------------------------------------------------------------------------------------------------------
function Ambi.Date.Go( nDelay )
    timer.Create( 'Date', nDelay or Ambi.Date.Config.time_delay, 1, function()
        if not Ambi.Date.Config.time_go then Ambi.Date.Go() return end

        Ambi.Date.time.minutes = Ambi.Date.time.minutes + Ambi.Date.Config.time_minute 

        if ( Ambi.Date.time.minutes >= MINUTE ) then 
            local remains = 0
            if ( Ambi.Date.time.minutes > MINUTE ) then
                remains = math.floor( ( MINUTE - Ambi.Date.time.minutes ) * -1 / MINUTE )
            end

            Ambi.Date.time.minutes = 0
            Ambi.Date.time.hours = Ambi.Date.time.hours + 1 + remains

            hook.Call( '[Ambi.Date.AddedHours]', nil, Ambi.Date.time.minutes, Ambi.Date.time.hours, Ambi.Date.time.days )

            if ( Ambi.Date.time.hours >= DAY ) then 
                local remains = 0
                if ( Ambi.Date.time.hours > MINUTE ) then
                    remains = math.floor( ( DAY - Ambi.Date.time.hours ) * -1 / DAY ) 
                end
        
                Ambi.Date.time.hours = 0
                Ambi.Date.time.days = Ambi.Date.time.days + 1 + remains

                hook.Call( '[Ambi.Date.AddedDays]', nil, Ambi.Date.time.minutes, Ambi.Date.time.hours, Ambi.Date.time.days )
            end
        end

        Ambi.Date.Go()

        hook.Call( '[Ambi.Date.Go]', nil, Ambi.Date.time.minutes, Ambi.Date.time.hours, Ambi.Date.time.days )
    end )
end

-- ---------------------------------------------------------------------------------------------------------------------------------------
function Ambi.Date.GetMinutes()
    return Ambi.Date.time.minutes
end

function Ambi.Date.GetHours()
    return Ambi.Date.time.hours
end

function Ambi.Date.GetDays()
    return Ambi.Date.time.days
end

function Ambi.Date.GetMinutesNiceFormat()
    return Ambi.Date.time.minutes > 9 and Ambi.Date.time.minutes or '0'..Ambi.Date.time.minutes
end

function Ambi.Date.GetHoursNiceFormat()
    return Ambi.Date.time.hours > 9 and Ambi.Date.time.hours or '0'..Ambi.Date.time.hours
end

function Ambi.Date.GetTimeNiceFormat()
    return Ambi.Date.GetHoursNiceFormat()..':'..Ambi.Date.GetMinutesNiceFormat()
end