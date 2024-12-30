local C, GUI, Draw, UI = Ambi.Packages.Out( '@d' )
local W, H = ScrW(), ScrH()

local cvar_render = CreateClientConVar( 'ambi_territory_render', 0 )
local cvar_hud = CreateClientConVar( 'ambi_territory_hud', 1 )

local ang = Angle( 0, 0, 0 )
local origin = Vector( 0, 0, 0 )
hook.Add( 'PostDrawTranslucentRenderables', 'Ambi.Territory.ShowChunks', function()
    if ( cvar_render:GetBool() == false ) then return end
    
    for name, chunk in pairs( Ambi.Territory.Config.chunks ) do
        if chunk.map and ( chunk.map ~= game.GetMap() ) then continue end

        render.DrawWireframeBox( origin, ang, chunk.min, chunk.max, chunk.color, true )
    end
end )

local margin_bottom = Vector( 0, 0, 2 )
local margin_top = Vector( 0, 0, 2 )
hook.Add( 'HUDPaint', 'Ambi.Territory.ShowNames', function()
    if ( cvar_hud:GetBool() == false ) then return end
    if not LocalPlayer():IsAuth() then return end -- for homeway

    if not Ambi.Territory.Config.chunks then return end

    for name, chunk in SortedPairs( Ambi.Territory.Config.chunks ) do
        if chunk.map and ( chunk.map ~= game.GetMap() ) then continue end
        if not LocalPlayer():GetPos():WithinAABox( chunk.min - margin_bottom, chunk.max + margin_top ) then continue end

        local w = Draw.GetTextSizeX( UI.SafeFont( '24 Montserrat' ), chunk.header ) + 20
        Draw.Box( w, 25, W / 2 - w / 2, 8, C.HOMEWAY_BLACK, 6 )

        Draw.SimpleText( W / 2, 6, chunk.header, UI.SafeFont( '24 Montserrat' ), C.HOMEWAY_BLUE, 'top-center', 1, C.BLACK )

        return
    end
end )