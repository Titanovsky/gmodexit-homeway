local CATEGORY = '[MyPets]'

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------
local MODEL = 'models/Combine_Helicopter/helicopter_bomb01.mdl'
local SIZE = 0.4
local OFFSET = Vector( 16, 10, 76 )

local command = 'pet'
local function Action( eCaller, ePly)
    local tag = 'ulx_animal_'..ePly:SteamID()
    if Ambi.MyPets.IsValid( tag ) then 
        Ambi.MyPets.Remove( tag ) 
        ulx.fancyLogAdmin( eCaller, '#A удалил питомца у игрока #T', ePly )

        return
    end

    ePly:AddItem( sItem, nCount )

    Ambi.MyPets.Create( tag, 'Писунчик', 'mypets_obj_pet', 'Description', ePly, OFFSET, function( ePet ) 
        ePet:SetModel( MODEL )
        ePet:SetModelScale( SIZE ) 
    end )

	ulx.fancyLogAdmin( eCaller, '#A выдал питомца игроку #T', ePly )
end
local method = ulx.command( CATEGORY, 'ulx '..command, Action, '!'..command )
method:addParam{ type=ULib.cmds.PlayerArg }
method:defaultAccess( ULib.ACCESS_SUPERADMIN )
method:help( 'Выдать/Удалить Тестового питомца игроку' )