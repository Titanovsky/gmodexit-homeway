local NW, Draw, C = Ambi.NW
local C, GUI, Draw, UI = Ambi.Packages.Out( '@d' ) -- todo refactor

local W, H = ScrW(), ScrH()
local icons = {}

hook.Add( 'HUDPaint', 'Ambi.Inv.ShowItems', function()
    -- local entities = ents.FindInSphere( LocalPlayer():GetPos(), 420 )

    -- for _, item in ipairs( entities ) do
    --     if IsValid( item ) and ( item:GetClass() == 'inv_item' ) then
    --         surface.SetAlphaMultiplier( 1.0 )

    --         local class = NW.GetString( item, 'Class' )
    --         --if not Ambi.SimpleInventory.GetClass( class ) then continue end

    --         local pos = Vector( item:GetPos() ):ToScreen()

    --         surface.SetAlphaMultiplier( ( 420 - item:GetPos():Distance( LocalPlayer():GetPos() ) ) / 420 * 1.2 )

    --         Draw.Box( 76 - 4, 82 - 4, pos.x - 35 + 2, pos.y - 35 + 2, C.AMBI_PANEL, 8, 'all' )
    --         Draw.Text( pos.x, pos.y + 35, 'x'..NW.GetInt( item, 'Count' ), UI.SafeFont( '24 Arial' ), C.ABS_WHITE, 'center', 1, C.ABS_BLACK )

    --         local ent = LocalPlayer():GetEyeTrace().Entity
    --         if IsValid( ent ) and ( ent == item ) then 
    --             --local name = Ambi.SimpleInventory.GetClass( class ).name

    --             --Draw.Text( W / 2, H - 4, name..' x'..NW.GetInt( item, 'Count' ), UI.SafeFont( '24 Arial' ), C.ABS_WHITE, 'bottom-center', 1, C.ABS_BLACK )
    --         end

    --         -- if Ambi.SimpleInventory.GetClass( class ).icon then
    --         --     if icons[ class ] and not icons[ class ]:IsError() then
    --         --         -- Draw.Material( 64, 64, pos.x - 28, pos.y - 38, icons[ class ] )
    --         --     else
    --         --         -- Ambi.SimpleInventory.DownloadIcon( class )
    --         --         -- icons[ class ] = Material( '../data/ambi/cache/simpleinventory/icons/'..Ambi.SimpleInventory.Config.directory_icons..'/'..class..'.png' )
    --         --     end
    --         -- end

    --         surface.SetAlphaMultiplier( 1.0 )
    --     end
    -- end
end )