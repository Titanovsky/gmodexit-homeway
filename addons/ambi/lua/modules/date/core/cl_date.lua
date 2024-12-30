Ambi.Date.time          = Ambi.Date.time or {}
Ambi.Date.time.minutes  = Ambi.Date.time.minutes or 0
Ambi.Date.time.hours    = Ambi.Date.time.hours or 0
Ambi.Date.time.days     = Ambi.Date.time.days or 1

net.Receive( 'ambi_date_replication_time', function() 
    Ambi.Date.time = net.ReadTable()

    local delay = net.ReadFloat()
    Ambi.Date.Go( delay )
end )