hook.Add( '[Ambi.DarkRP.CanSetJob]', 'Ambi.Homeway.BlockJobTime', function( ePly, sClass, bForce, tJob ) 
    if bForce then return end

    local time = tJob.time
    if not time then return end

    if ( ePly:GetTime() < time * 60 ) then ePly:Notify( 'Наиграйте '..tJob.time..' минут на профессию '..tJob.name, 5, NOTIFY_ERROR ) return false end
end )