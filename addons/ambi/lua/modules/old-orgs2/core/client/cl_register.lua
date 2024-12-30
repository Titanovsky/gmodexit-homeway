local C, GUI, Draw, UI, CL = Ambi.Packages.Out( '@d, ContentLoader' )

local w = ScrW()
local h = ScrH()

function AmbOrgs2.openRegisterMenu()
    local frame = vgui.Create( 'DFrame' )
    frame:SetSize( 600, 200 )
    frame:Center()
    frame:MakePopup()
    frame:SetTitle( '' )
    frame:ShowCloseButton( true )

    frame.Paint = function( self, w, h )
        draw.RoundedBox( 0, 0, 0, w, h, C.AMBI_PURPLE )
        draw.RoundedBox( 0, 4, 4, w-8, h-8, C.AMBI_BLACK ) 

        draw.SimpleText('• Дайте название и цвет организации.', UI.SafeFont( '22 Ambi' ), 16, 8, C.AMBI_WHITE, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
    end

    local name = vgui.Create( 'DTextEntry', frame )
    name:SetSize( 280, 48 )
    name:SetPos( 16, 48 )
    name:SetFont( UI.SafeFont( '22 Ambi' ) )

    local mixer = vgui.Create( "DColorMixer", frame )
    mixer:SetSize( 128, 128 )
    mixer:SetPos( frame:GetWide() - mixer:GetWide() - 48, 32 )
    mixer:SetPalette( false )
    mixer:SetAlphaBar( false )
    mixer:SetWangs( false )

    local send = vgui.Create( 'DButton', frame )
    send:SetSize( 120, 40 )
    send:SetPos( frame:GetWide()/2 - send:GetWide()/2, frame:GetTall() - send:GetTall() - 16)
    send:SetFont( UI.SafeFont( '22 Ambi' ) )
    send:SetTextColor( AMB_COLOR_WHITE )
    send:SetText( 'Создать' )
    send.DoClick = function()
        frame:Remove()
        if #name:GetValue() == 0 then return end
        local col = Color( mixer:GetColor().r, mixer:GetColor().g, mixer:GetColor().b )
        AmbOrgs2.register( name:GetValue(), col )
    end
    send.Paint = function( self, w, h )
        draw.RoundedBox( 0, 0, 0, w, h, C.AMBI_PURPLE )
        draw.RoundedBox( 0, 2, 2, w-4, h-4, C.AMBI_BLACK ) 
    end
end

function AmbOrgs2.register( name, color )
    --color = AmbLib.convertColorToVec( color )
    net.Start( 'amb_register_org' )
        net.WriteString( name )
        net.WriteColor( color )
    net.SendToServer()
end
