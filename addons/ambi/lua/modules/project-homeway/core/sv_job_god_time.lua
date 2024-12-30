net.AddString( 'ambi_homeway_job_god_start' )
net.AddString( 'ambi_homeway_job_god_remove' )

hook.Add( '[Ambi.DarkRP.SetJob]', 'Ambi.Homeway.JobGod', function( ePly, sClass, bForce, sOldClass, tJob ) 
    if timer.Exists( 'Ambi.Homeway.GodJobTime:'..ePly:SteamID() ) then
        ePly.nw_JobGod = false

        net.Start( 'ambi_homeway_job_god_remove' )
        net.Send( ePly )
    end
    if not tJob.god_time then return end

    ePly.nw_JobGod = true
    ePly:Notify( 'У вас бессмертие', 8 )

    net.Start( 'ambi_homeway_job_god_start' )
        net.WriteUInt( tJob.god_time, 15 )
    net.Send( ePly )

    timer.Create( 'Ambi.Homeway.GodJobTime:'..ePly:SteamID(), tJob.god_time, 1, function() 
        ePly.nw_JobGod = false

        net.Start( 'ambi_homeway_job_god_remove' )
        net.Send( ePly )

        ePly:Notify( 'Ваше бессмертие исчезло', 8 )
    end )
end )

hook.Add( 'PlayerDisconnected', 'Ambi.Homeway.JobGod', function( ePly ) 
    if timer.Exists( 'Ambi.Homeway.GodJobTime:'..ePly:SteamID() ) then timer.Remove( 'Ambi.Homeway.GodJobTime:'..ePly:SteamID() ) end
end )

hook.Add( 'PlayerShouldTakeDamage', 'Ambi.Homeway.JobGod', function( ePly, eAttacker ) 
    if ePly.nw_JobGod or eAttacker.nw_JobGod then return false end
end )