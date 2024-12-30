Ambi.CustomShop.clothes = Ambi.CustomShop.clothes or {}
Ambi.CustomShop.entities = Ambi.CustomShop.entities or {}

local PLAYER = FindMetaTable( 'Player' )

-- --------------------------------------------------------------------------------------------------------------------------------------------------------
function Ambi.CustomShop.CreateClothes( sClass, sName, sDescription, sModel, nSize, sBone, vManipulate, fSpawn, fRemove )
    if not sClass then return end

    sName = sName or 'Unknow'
    sDescription = sDescription or ''

    Ambi.CustomShop.clothes[ sClass ] = {
        name = sName,
        description = sDescription,
        model = sModel,
        size = nSize,
        bone = sBone,
        Manipulate = vManipulate,
        Spawn = fSpawn,
        Remove = fRemove,
    }

    hook.Call( '[Ambi.CustomShop.Created]', nil, sClass, sName, sDescription, sModel, nSize, nBone, fManipulate, fSpawn, fRemove )
end

function Ambi.CustomShop.RemoveClothes( sClass )
    if not sClass then return end

    local cloth = Ambi.CustomShop.clothes[ sClass ]
    if not cloth then return end

    Ambi.CustomShop.clothes[ sClass ] = nil

    hook.Call( '[Ambi.CustomShop.Removed]', nil, sClass, cloth )
end

function Ambi.CustomShop.GetClothes( sClass )
    return Ambi.CustomShop.clothes[ sClass ]
end

function Ambi.CustomShop.GetClothesAll()
    return Ambi.CustomShop.clothes
end

function Ambi.CustomShop.GetEntity( eObj, sClass )
    return Ambi.CustomShop.entities[ sClass..' '..eObj:EntIndex() ]
end

function Ambi.CustomShop.GetEntities()
    return Ambi.CustomShop.entities
end
