local AddItem = Ambi.Inv.AddItem

local function SpawnPet( ePly, sClass, sHeader, vPos, fSpawn )
    local pet = ePly:GetPet()
    if pet then 
        ePly:ChatSend( '~AMBI~ • ~W~ Питомец ~B~ '..Ambi.MyPets.Get( pet.class ).name..' ~W~ обращён в яйцо призыва!' ) 
        ePly:RemovePet( pet.class ) 
    else
        ePly:SpawnPet( sClass, sHeader, 'mypets_obj_pet', nil, vPos, nil, fSpawn )
        ePly:ChatSend( '~AMBI~ • ~W~ Питомец ~B~ '..Ambi.MyPets.Get( ePly:GetPet().class ).name..' ~W~ выпущен!' )

        hook.Call( '[Ambi.MysticRP.CallPet]', nil, ePly, sClass, ePly:GetPet() )
    end

    return false
end

local CATEGORY = 'Питомцы'
local SPEC_STACK = 1

AddItem( 'pet_pasta', 'Pet: Макаронка', SPEC_STACK, CATEGORY, 'Можно надеть', 'https://i.imgur.com/HG6QgQO.png', function( ePly )
    return SpawnPet( ePly, 'pasta', 'Макаронка', Vector( 15, -15, 80 ), function( eObj ) 
        eObj:SetMaterial( 'ambi/amp/amp_pasta1' )
            eObj:SetModelScale( 0.5 )
    end )
end )

AddItem( 'pet_cactus', 'Pet: Кактус', SPEC_STACK, CATEGORY, 'Можно надеть', 'https://i.imgur.com/7SD3tHx.png', function( ePly )
    return SpawnPet( ePly, 'pasta', 'Кактус', Vector( 25, -15, 80 ), function( eObj ) 
        eObj:SetModel( 'models/cactus/cactus.mdl' )
            eObj:SetModelScale( 0.2 )
    end )
end )

-- AddItem( 'pet_ufo', 'Pet: НЛО', SPEC_STACK, CATEGORY, 'Можно надеть', 'https://www.freepnglogos.com/uploads/ufo-png/ufo-ufovisitors-ufos-1.png', function( ePly )
--     return SpawnPet( ePly, 'ufo', 'НЛО', Vector( 15, -15, 80 ), function( eObj ) 
--         eObj:SetModel( 'models/props_invasion/invasion_ufo.mdl' )
--         eObj:SetModelScale( 0.04 )
--     end )
-- end )

-- AddItem( 'pet_sword', 'Pet: НЛО', SPEC_STACK, CATEGORY, 'Можно надеть', 'https://freepngimg.com/thumb/sword/20747-4-transparent-sword-clip-art.png', function( ePly )
--     return SpawnPet( ePly, 'ufo', 'НЛО', Vector( 15, -15, 80 ), function( eObj ) 
--         eObj:SetModel( 'models/zerochain/props_halloween/sword.mdl' )
--         eObj:SetModelScale( 0.4 )
--     end )
-- end )