net.Receive( 'ambi_hw_anim_send_all', function()
    local ply = net.ReadEntity()
    if ( ply == NULL ) then return end

    local act = net.ReadUInt( 16 )

    local dont_kill_anim = net.ReadBool()

    ply:AnimRestartGesture( GESTURE_SLOT_CUSTOM, act, not dont_kill_anim )
end )