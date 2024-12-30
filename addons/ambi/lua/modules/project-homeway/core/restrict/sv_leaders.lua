hook.Add( '[Ambi.DarkRP.CanDemoteJob]', 'Ambi.Homeway.DemotePlayerFromLeader', function( eCaller, ePly, sReason )
    if IsValid( eCaller ) and ( eCaller:GetTime() <= 60 * 20 ) then eCaller:Notify( 'Наиграйте 10 минут', 5, NOTIFY_ERROR ) return false end

    local job = eCaller:GetJob()
    local ply_job = ePly:GetJob()
    local category = eCaller:GetJobTable().category
    local ply_category = ePly:GetJobTable().category

    if ( ( job == 'j_fbi_leader' ) or ( job == 'j_mafia_leader' ) or ( job == 'j_sheriff' ) ) and ( category == ply_category ) then
        eCaller:Notify( 'Вы выгнали '..ePly:Name()..' из фракции', 10, 2 )

        ePly:DemoteJob( true, eCaller )
        ePly:Notify( 'Вас уволил лидер '..eCaller:Name(), 15 )
        ePly:BlockJob( ply_job, 60 * 5 )

        for _, ply in ipairs( player.GetAll() ) do
            ply:ChatSend( '~FLAT_RED~ • ~W~ '..eCaller:GetJobTable().name..' выгнал ~FLAT_RED~ '..ePly:Name()..' ~W~ из '..category ) 
        end

        return false
    end
end )