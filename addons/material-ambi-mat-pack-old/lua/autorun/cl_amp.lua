-- ####### Ambi ######################################################################################
-- Workshop >> https://steamcommunity.com/sharedfiles/filedetails/?id=3007369763
-- Discord >> https://discord.com/invite/g8RmTmDGcG
-- VK >> https://vk.com/ambi_team
-- Steam >> https://steamcommunity.com/groups/ambiteam
-- ###################################################################################################

local FileFind, StringExplode, ipairs, ListAdd = file.Find, string.Explode, ipairs, list.Add
local Add = function( sPathMaterial ) ListAdd( 'OverrideMaterials', 'ambi/amp/'..sPathMaterial ) end

-- ---------------------------------------------------------------------------------
local materials, _ = FileFind( 'materials/ambi/amp/*', 'GAME' )
if not materials then return end

for _, name in ipairs( materials ) do
    if not string.StartsWith( name, 'amp' ) then continue end -- for don't make a conflict with the new AMP

    local tag = StringExplode( '.', name )[ 1 ]

    Add( tag )
end