local PLAYER = FindMetaTable( 'Player' )

function PLAYER:StartAnim( nAct, bDontKill )
    net.Start( 'ambi_hw_anim_send_all' )
        net.WriteEntity( self )
        net.WriteUInt( nAct or 0, 16 )
        net.WriteBool( bDontKill )
    net.Broadcast()
end

net.AddString( 'ambi_hw_anim_send_all' )