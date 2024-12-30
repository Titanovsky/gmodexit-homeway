local C, GUI, Draw, UI, CL = Ambi.Packages.Out( '@d, ContentLoader' )

local w = ScrW()
local h = ScrH()

local COLOR_PANEL = Color( 0, 0, 0, 150 )

function AmbOrgs2.openMenuCreateOrg()
    local frame = vgui.Create( 'DFrame' )
    frame:SetSize( w/3, h/3 )
    frame:Center()
    frame:MakePopup()
    frame:SetTitle( '' )
    frame:ShowCloseButton( true )

    frame.Paint = function( self, w, h )
        draw.RoundedBox( 0, 0, 0, w, h, C.AMBI_PURPLE )
        draw.RoundedBox( 0, 4, 4, w-8, h-8, C.AMBI_BLACK ) 

        draw.SimpleText('Создание организаций - '..AmbOrgs2.cost_for_org..'$', UI.SafeFont( '26 Ambi' ), w/2, 24, C.AMBI_WHITE, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP )
    end

    local create = vgui.Create( 'DButton', frame )
    create:SetSize( 260, 52 )
    create:SetPos( frame:GetWide()/2 - create:GetWide()/2, frame:GetWide()/2 - create:GetWide()/2 )
    create:SetFont( UI.SafeFont( '22 Ambi' ) )
    create:SetTextColor( C.ABS_WHITE )
    create:SetText( 'Купить организацию' )
    create.Paint = function( self, w, h )
        draw.RoundedBox( 0, 2, 2, w-4, h-4, COLOR_PANEL ) 
    end
    create.DoClick = function()
        if LocalPlayer():GetMoney() < AmbOrgs2.cost_for_org then surface.PlaySound( 'ambi/ui/error3.wav' ) return end

        frame:Remove()
        
        AmbOrgs2.openRegisterMenu()
    end
end

function AmbOrgs2.openMenuLeaveOrg()

    local frame = vgui.Create( 'DFrame' )
    frame:SetSize( w/3, h/3 )
    frame:Center()
    frame:MakePopup()
    frame:SetTitle( '' )
    frame:ShowCloseButton( true )
    frame.Paint = function( self, w, h )

        draw.RoundedBox( 0, 0, 0, w, h, C.AMBI_PURPLE )
        draw.RoundedBox( 0, 4, 4, w-8, h-8, C.AMBI_BLACK ) 

    end

    local leave = vgui.Create( 'DButton', frame )
    leave:SetSize( 200, 52 )
    leave:SetPos( frame:GetWide()/2 - leave:GetWide()/2, frame:GetWide()/2 - leave:GetWide()/2 )
    leave:SetFont( UI.SafeFont( '22 Ambi' ) )
    leave:SetTextColor( C.ABS_WHITE )
    leave:SetText( 'Покинуть организацию' )
    leave.Paint = function( self, w, h )
        draw.RoundedBox( 0, 0, 0, w, h, C.AMBI_PURPLE )
        draw.RoundedBox( 0, 2, 2, w-4, h-4, C.AMBI_BLACK ) 
    end
    leave.DoClick = function()
        frame:Remove()
        
        net.Start( 'amb_leave_org' )
            net.WriteEntity( LocalPlayer() )
        net.SendToServer()
    end
end