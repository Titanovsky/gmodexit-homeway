if not Ambi.ChatCommands.AddCommand then return end

local Add = Ambi.ChatCommands.AddCommand

Add( 'roll', 'Homeway DarkRP', 'Случайное число от 0 до 100', 0.1, function( ePly, tArgs ) 
    local text = ''

    for i, v in ipairs( tArgs ) do
        if ( i == 1 ) then continue end

        text = text..' '..v
    end
    
    if ePly.gimp then return end

    local roll = math.random( 0, 100 )

    for _, ply in ipairs( ents.FindInSphere( ePly:GetPos(), Ambi.DarkRP.Config.chat_max_length ) ) do
        if ply:IsPlayer() then ply:ChatSend( '~HOMEWAY_BLUE~ • ~W~ '..ePly:Name()..' кинул ролл на ~HOMEWAY_BLUE~ '..roll ) end
    end
    
    return true
end )