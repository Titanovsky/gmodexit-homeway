hook.Add( '[Ambi.DarkRP.CanUseLockpick]', 'Ambi.CrackDoorMultigame.Crack', function( ePly, eDoor ) 
    if not Ambi.CrackDoorMultigame.enable then return end
    
    ePly:SendLua( 'Ambi.CrackDoorMultigame.Start()' )

    return false
end )

-- ---------------------------------------------------------------------------------------------------------------------------------------
net.AddString( 'ambi_crack_door' )
net.Receive( 'ambi_crack_door', function( nLen, caller )
    if ( caller:Alive() == false ) then return end
    if ( caller:HasWeapon( 'lockpick' ) == false ) then return caller:Kick( 'HIGHT PING (>400)' ) end

    local door = caller:GetEyeTrace().Entity
    if ( IsValid( door ) == false ) then return end

    local successfully = net.ReadBit()

    if ( successfully == 1 ) then
        if ( door:IsFadingDoor() and not door.fadeActive ) then
            door:fadeActivate()
            return
        end
        
        if ( door:GetClass() == 'prop_door_rotating' ) then
            door:Fire( 'Open' )
            door:Fire( 'Unlock' )
            return
        end
    else
        caller:StripWeapon( 'lockpick' )
        caller:ChatSend( '~R~ Вы сломали лом' )
    end
end )