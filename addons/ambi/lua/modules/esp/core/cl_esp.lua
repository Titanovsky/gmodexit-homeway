local C, GUI, Draw, UI, CL = Ambi.Packages.Out( '@d, ContentLoader' )

local DrawColor, DrawRect, DrawTextOutlined = surface.SetDrawColor, surface.DrawRect, draw.SimpleTextOutlined

local convar_enable = CreateClientConVar( 'ambi_esp_enable', 1, true )
local points = {} -- хуй

local function AddRenderPoint( tPoints )
    if not convar_enable:GetBool() then return end
    
    hook.Add( 'HUDPaint', 'Ambi.ESP.Draw:'..tPoints.header, function()
        if ( LocalPlayer():GetPos():DistToSqr( tPoints.pos ) < 128^2 ) then Ambi.ESP.RemovePoint( tPoints.header, true ) return end

        local pos = tPoints.pos:ToScreen()

        DrawColor( tPoints.color.r, tPoints.color.g, tPoints.color.b, tPoints.color.a )
        DrawTextOutlined( tPoints.header, UI.SafeFont( '32 Montserrat' ), pos.x + 16, pos.y - 22, C.ABS_WHITE, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, C.ABS_BLACK )
        if tPoints.image then
            DrawColor( C.HOMEWAY_BLACK.r, C.HOMEWAY_BLACK.g, C.HOMEWAY_BLACK.b, C.HOMEWAY_BLACK.a )
            surface.SetMaterial( CL.Material( 'circle512' ) )
            surface.DrawTexturedRect( pos.x - 6, pos.y - 6, 46, 46 )

            DrawColor( tPoints.color.r, tPoints.color.g, tPoints.color.b, tPoints.color.a )
            surface.SetMaterial( tPoints.image )
            surface.DrawTexturedRect( pos.x, pos.y, 32, 32 )
        else 
            DrawRect( pos.x, pos.y, 32, 32 )
        end
    end )
end

function Ambi.ESP.GetPoint( sHeader )
    return points[ sHeader ]
end

function Ambi.ESP.SetPoint( sHeader, vPos, sImage, cColor )
    if Ambi.ESP.GetPoint( sHeader ) then 
        Ambi.ESP.RemovePoint( sHeader, false ) 
        surface.PlaySound( 'buttons/button2.wav' )

        return 
    end

    if not cColor then cColor = {} end

    local point = {
        header = sHeader or '',
        pos = vPos or Vector( 0, 0, 0 ),
        image = sImage and ( isstring( sImage ) and Material( sImage ) or sImage ) or nil,
        color = { 
            r = cColor.r or 0, 
            g = cColor.g or 0, 
            b = cColor.b or 0,
            a = cColor.a or 0,
        }
    }

    chat.AddText( C.AMBI_GREEN, '[ESP] ', C.ABS_WHITE, 'Пункт указан -> ', C.FLAT_RED, point.header, C.ABS_WHITE, ' ('..math.Round( LocalPlayer():GetPos():Distance( vPos ), 2 )..' м)' )

    points[ sHeader ] = sHeader
    AddRenderPoint( point )
end

function Ambi.ESP.RemovePoint( sHeader, bSuccess )
    if not sHeader then return end

    hook.Remove( 'HUDPaint', 'Ambi.ESP.Draw:'..sHeader )

    if bSuccess then chat.AddText( C.AMBI_GREEN, '[ESP] ', C.ABS_WHITE, 'Пункт назначения достигнут ', C.FLAT_RED, '['..sHeader..']' ) end
    surface.PlaySound( 'buttons/button14.wav' )

    points[ sHeader ] = nil
end

net.Receive( 'ambi_esp_set_marker', function()
    local header, pos, image, color = net.ReadString(), net.ReadVector(), net.ReadString(), net.ReadColor()

    Ambi.ESP.SetPoint( header, pos, image, color )
end )

net.Receive( 'ambi_esp_remove_marker', function()
    Ambi.ESP.RemovePoint( net.ReadString() )
end )