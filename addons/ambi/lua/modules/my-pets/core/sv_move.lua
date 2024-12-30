-- • DON'T CHANGE THIS FILE, WHEN GAME (SERVER) IS ACTIVE!!!

local pets = {}

-- ----------------------------------------------------------------------------------------------------------------------------------------------------------
function Ambi.MyPets.GetMovingPets()
    return pets
end

-- ----------------------------------------------------------------------------------------------------------------------------------------------------------
hook.Add( '[Ambi.MyPets.Spawned]', 'Ambi.MyPets.FillPetInMoveCore', function( ePet, sClass, eOwner, _, _, _, vPos, fManipulate ) 
    pets[ #pets + 1 ] = { pet = ePet, owner = eOwner, pos = vPos, class = sClass, Manipulate = fManipulate }
end )

hook.Add( '[Ambi.MyPets.Removed]', 'Ambi.MyPets.DeleteFromPetsInMoveCore', function( sClass ) 
    local len = #pets

    for i, tab in ipairs( pets ) do
        if ( tab.class == sClass ) then 
            table.remove( pets, i )
        end
    end
end )

hook.Add( 'Think', 'Ambi.MyPets.Move', function()
    if not Ambi.MyPets.Config.move_enable then return end

    for i, info in ipairs( pets ) do
        local pet, owner = info.pet, info.owner
        if not IsValid( pet ) or not IsValid( owner ) then table.remove( pets, i ) break end

        local pos, ang = owner:LocalToWorld( info.pos ),  owner:EyeAngles()
        if info.Manipulate then
            local _pos, _ang = info.Manipulate( pet, owner, pos, ang )
            if _pos then pos = _pos end
            if _ang then ang = _ang end
        end

        pet:SetPos( pos )
        pet:SetAngles( ang )
    end
end )