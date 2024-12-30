Ambi.MyPets.pets = Ambi.MyPets.pets or {}

-- ----------------------------------------------------------------------------------------------------------------------------------------------------------
function Ambi.MyPets.Spawn( sClass, sName, sClassEntity, sDescription, eOwner, vPos, fManipulate, fSpawn, fRemove )
    if not sClass then return end

    sName, sDescription = sName or 'Unknow', sDescription or ''
    vPos = vPos or Vector( 0, 0, 0 )
    sClassEntity = sClassEntity or 'mypets_obj_pet'

    if not IsValid( eOwner ) then return end
    if not sClassEntity then return end

    if Ambi.MyPets.pets[ sClass ] then  
       Ambi.MyPets.Remove( sClass )
    end

    local pet = ents.Create( sClassEntity )
    pet:Spawn()

    if not pet then return end

    pet.class = sClass
    pet.nw_NamePet = sName
    pet.nw_OwnerPet = eOwner

    eOwner.pet = pet

    Ambi.MyPets.pets[ sClass ] = {
        name = sName,
        description = sDescription,
        owner = eOwner,
        pet = pet,
        pos = vPos,
        Spawn = fSpawn,
        Remove = fRemove,
        Manipulation = fManipulation
    }

    if fSpawn then fSpawn( pet, eOwner ) end

    hook.Call( '[Ambi.MyPets.Spawned]', nil, pet, sClass, eOwner, sName, sClassEntity, sDescription, vPos, fManipulate, fSpawn, fRemove )

    return pet
end

function Ambi.MyPets.Remove( sClass )
    if not sClass then return end

    local info = Ambi.MyPets.pets[ sClass ] 
    if not info then return end

    if info.Remove then info.Remove( info.pet, sClass ) end

    if IsValid( info.pet ) then info.pet:Remove() end
    if IsValid( info.owner ) then info.owner.pet = nil end

    Ambi.MyPets.pets[ sClass ] = nil

    hook.Call( '[Ambi.MyPets.Removed]', nil, sClass, info )
end

function Ambi.MyPets.Get( sClass )
    return Ambi.MyPets.pets[ sClass or '' ]
end

-- ----------------------------------------------------------------------------------------------------------------------------------------------------------
local ENTITY = FindMetaTable( 'Entity' )

function ENTITY:SpawnPet( sClass, sName, sClassEntity, sDescription, vPos, fManipulate, fSpawn, fRemove )
    sClass = sClass..' '..self:EntIndex()

    return Ambi.MyPets.Spawn( sClass, sName, sClassEntity, sDescription, self, vPos, fManipulate, fSpawn, fRemove )
end

function ENTITY:RemovePet( sClass )
    return Ambi.MyPets.Remove( sClass )
end

function ENTITY:GetPet()
    return self.pet
end

function ENTITY:GetPetTable()
    return self.pet and Ambi.MyPets.Get( self.pet.class ) or nil
end

-- ----------------------------------------------------------------------------------------------------------------------------------------------------------
hook.Add( 'PlayerDisconnected', 'Ambi.MyPets.RemovePet', function( ePly ) 
    local pet = ePly.pet
    if pet then Ambi.MyPets.Remove( pet.class ) end
end )

hook.Add( 'EntityRemoved', 'Ambi.MyPets.RemoveInfo', function( eObj ) 
    local class = eObj.class
    --if class then Ambi.MyPets.Remove( class ) end
end )