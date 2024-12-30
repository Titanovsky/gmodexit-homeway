local PLAYER = FindMetaTable( 'Player' )

function PLAYER:SetJobLife( nCount )
    self.nw_JobLife = nCount or 0 
end

function PLAYER:AddJobLife( nCount )
    self:SetJobLife( ( nCount or 1 ) + self:GetJobLife() )
end

hook.Add( 'PlayerDeath', 'Ambi.Homeway.JobLife', function( ePly ) 
    local job_life = ePly:GetJobTable().life
    if not job_life then return end

    ePly:AddJobLife( -1 )

    if ( ePly:GetJobLife() <= 0 ) then
        ePly:BlockJob( ePly:GetJob(), 60 * 10 )
        ePly:SetJob( Ambi.DarkRP.Config.jobs_class )
    end
end )

hook.Add( '[Ambi.DarkRP.SetJob]', 'Ambi.Homeway.JobLife', function( ePly, sClass, _, sOldClass, tJob ) 
    local old_job = Ambi.DarkRP.GetJob( sOldClass )
    if old_job and old_job.life and ( ePly:GetJobLife() < old_job.life ) then
        ePly:BlockJob( sOldClass, 60 * 10 )
        ePly:Notify( 'Вы получили блок на '..old_job.name, 8, NOTIFY_ERROR )
    end

    local job_life = tJob.life
    if job_life then  
        ePly:SetJobLife( job_life )
    end 
end )

hook.Add( 'PlayerDisconnected', 'Ambi.Homeway.JobLife', function( ePly ) 
    local job = ePly:GetJobTable()
    if job and job.life and ( ePly:GetJobLife() < job.life ) then
        ePly:BlockJob( ePly:GetJob(), 60 * 10 )
    end
end )