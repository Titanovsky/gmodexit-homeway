local C, GUI, Draw, UI = Ambi.Packages.Out( '@d' )
local W, H = ScrW(), ScrH()

local LICENSE = Material( 'icon16/page.png' )
local WANTED = Material( 'icon16/exclamation.png' )
local DISTANCE = 450 * 450
local org_colors = {}

local convar_enable = CreateClientConVar( 'ambi_hw_enable_3d2d_hud_players', 1, true )

local function ShowColorOrg( nID )
    if not nID then return C.WHITE end
    
    if org_colors[ nID ] then return org_colors[ nID ] end

    local col = string.Explode(',', AmbOrgs2.Orgs[ nID ].Color )

    org_colors[ nID ] = Color( col[1], col[2], col[3] )

    return org_colors[ nID ]
end

-- ---------------------------------------------------------------------------------------------------------------------------------------
hook.Add( 'PostDrawTranslucentRenderables', 'Ambi.Homeway.Players3D2DHUD', function()
    if not convar_enable:GetBool() then return end
    if not LocalPlayer():IsAuth() then return end
    
    for i, ply in ipairs( player.GetAll() ) do
        if ( ply == LocalPlayer() ) then continue end
        if not ply:Alive() then continue end
        if ( LocalPlayer():GetPos():DistToSqr( ply:GetPos() ) > DISTANCE ) then continue end
        if ply.nw_Spectating then continue end
        if ply.nw_Nocliping then continue end

        local _,max = ply:GetRotatedAABB( ply:OBBMins(), ply:OBBMaxs() )
        local rot = ( ply:GetPos() - EyePos() ):Angle().yaw - 90
        local head_bone = ply:LookupBone( 'ValveBiped.Bip01_Head1' ) or 1
        local head = ( ply:GetBonePosition( head_bone ) and ply:GetBonePosition( head_bone ) + Vector( 0, 0, 14 ) or nil ) or ply:LocalToWorld( ply:OBBCenter() ) + Vector( 0, 0, 24 )
        
        cam.Start3D2D( head, Angle( 0, rot, 90 ), 0.08 )
            Draw.SimpleText( 4, 10, ply:Name(), UI.SafeFont( '32 Montserrat' ), C.ABS_WHITE, 'center', 1, C.ABS_BLACK )
            Draw.SimpleText( 4, 35, ply:JobName(), UI.SafeFont( '24 Montserrat' ), ply:TeamColor(), 'center', 1, C.ABS_BLACK )

            if ply.nw_JobGod then Draw.SimpleText( 4, -65, 'Бессмертен', UI.SafeFont( '40 Montserrat' ), C.RED, 'center', 1, C.ABS_BLACK ) end
            if ply:HasLicenseGun() then Draw.Material( 16, 16, 0, -24, LICENSE ) end
            if ply:IsWanted() then Draw.SimpleText( 4, 55, 'В Розыске', UI.SafeFont( '28 Montserrat' ), C.FLAT_RED, 'center', 1, C.ABS_BLACK ) end
            if ply:IsArrested() then Draw.SimpleText( 4, 55, 'Арестован', UI.SafeFont( '28 Montserrat' ), C.FLAT_RED, 'center', 1, C.ABS_BLACK ) end

            if ply:HasOrg() then Draw.SimpleText( 4, -20, AmbOrgs2.Orgs[ ply:GetOrgID() or 0 ].Name, UI.SafeFont( '40 Montserrat' ), ShowColorOrg( ply:GetOrgID() ), 'center', 1, C.ABS_BLACK ) end
        cam.End3D2D()
    end
end ) 

hook.Add( 'PostDrawTranslucentRenderables', 'Ambi.Homeway.ShowNoclipAdmins', function()
    if not convar_enable:GetBool() then return end
    if not LocalPlayer():IsStaff() then return end
    
    for i, ply in ipairs( player.GetAll() ) do
        if not ply:Alive() then continue end
        if ( ply:GetMoveType() ~= MOVETYPE_NOCLIP ) then continue end

        Ambi.UI.Render.Outline.Add( ply, C.HOMEWAY_BLUE, 1 )

        if ( ply == LocalPlayer() ) then continue end
        
        local _,max = ply:GetRotatedAABB( ply:OBBMins(), ply:OBBMaxs() )
        local rot = ( ply:GetPos() - EyePos() ):Angle().yaw - 90
        local head_bone = ply:LookupBone( 'ValveBiped.Bip01_Head1' ) or 1
        local head = ( ply:GetBonePosition( head_bone ) and ply:GetBonePosition( head_bone ) + Vector( 0, 0, 14 ) or nil ) or ply:LocalToWorld( ply:OBBCenter() ) + Vector( 0, 0, 24 )

        cam.Start3D2D( head, Angle( 0, rot, 90 ), 0.08 )
            Draw.SimpleText( 4, 10, ply:Name(), UI.SafeFont( '32 Montserrat' ), C.ABS_WHITE, 'center', 1, C.ABS_BLACK )
            --Draw.SimpleText( 4, 40, ply:SteamID(), UI.SafeFont( '36 Montserrat' ), C.ABS_WHITE, 'center', 1, C.ABS_BLACK )
        cam.End3D2D()
    end
end ) 