Ambi.Homeway.groups_door = Ambi.Homeway.groups_door or {}

function Ambi.Homeway.AddGroupDoor( eDoor, sGroup )
    if eDoor and isnumber( eDoor ) then eDoor = Entity( eDoor ) end

    if not Ambi.Homeway.groups_door[ sGroup ] then Ambi.Homeway.groups_door[ sGroup ] = {} end

    Ambi.Homeway.groups_door[ sGroup ][ eDoor ] = true
end