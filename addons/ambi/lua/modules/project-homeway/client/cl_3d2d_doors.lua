local C, GUI, Draw, UI, CL = Ambi.Packages.Out( '@d, ContentLoader' )
local DISTANCE = 250

-- ---------------------------------------------------------------------------------------------------------------------------------------
local function GetOwners( eDoor )
    if eDoor.nw_IsBlocked then return Ambi.DarkRP.Config.doors_text_on_blocked end
    if string.IsValid( eDoor.nw_Category ) then return '' end
    if eDoor.nw_IsOwned then return '' end

    return Ambi.DarkRP.Config.doors_text_on_free..Ambi.DarkRP.Config.doors_cost_buy..Ambi.DarkRP.Config.money_currency_symbol
end

local function GetTitle( eDoor )
    if eDoor.nw_IsBlocked then return '' end
    if string.IsValid( eDoor.nw_Category ) then return eDoor.nw_Category end

    return eDoor.nw_Title or Ambi.DarkRP.Config.doors_text_title..eDoor:EntIndex()
end

-- ---------------------------------------------------------------------------------------------------------------------------------------
hook.Add( 'PostDrawTranslucentRenderables', 'Ambi.Homeway.DrawInfoDoors', function() 
    for _, door in ipairs( ents.FindInSphere( LocalPlayer():GetPos(), DISTANCE ) ) do
        if not Ambi.DarkRP.Config.doors_classes[ door:GetClass() ] then continue end

        local ang = door:GetAngles()
        local min, max = door:GetModelBounds()

        ang:RotateAroundAxis(ang:Right(), 90)
        ang:RotateAroundAxis(ang:Up(), -90)
        
        cam.Start3D2D( door:GetPos() + ang:Forward() * -47 + ( ang:Up() * 1.1 ) + ang:Right() * -54, ang, 0.13 ) // спереди
            draw.SimpleTextOutlined( GetTitle( door ), UI.SafeFont( '36 Montserrat' ), 190, 300, C.HOMEWAY_BLUE, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, C.ABS_BLACK )
            draw.SimpleTextOutlined( GetOwners( door ), UI.SafeFont( '24 Montserrat' ), 190, 334, C.HOMEWAY_WHITE, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, C.ABS_BLACK )
        cam.End3D2D()

        -- второй раз, чтобы было с другой стороны
        ang:RotateAroundAxis(ang:Right(), 180)

        cam.Start3D2D( door:GetPos() + ang:Forward() * -4 + ang:Up() * 1.18 + ang:Right() * -54, ang, 0.12 ) // сзади
            draw.SimpleTextOutlined( GetTitle( door ), UI.SafeFont( '36 Montserrat' ), 230, 320, C.HOMEWAY_BLUE, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, C.ABS_BLACK )
            draw.SimpleTextOutlined( GetOwners( door ), UI.SafeFont( '24 Montserrat' ), 230, 354, C.HOMEWAY_WHITE, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, C.ABS_BLACK )
        cam.End3D2D()
    end
end )