local C, GUI, Draw, UI, CL = Ambi.Packages.Out( '@d, ContentLoader' )

local COLOR_MENU = Color( 59, 59, 59, 250 )
local COLOR_TEXT = Color( 255, 255, 255 )
local w = ScrW()
local h = ScrH()

function AmbOrgs2.toInvite( name, leader, id )
    local inv = vgui.Create( "DFrame" )
    inv:SetTitle( '' )
    inv:SetSize( w/1.5, h/1.8 )
    inv:Center()
    inv:MakePopup()
    inv:ShowCloseButton( true )
    inv.Paint = function( self, w, h )
        draw.RoundedBox( 0, 0, 0, w, h, COLOR_MENU )
        draw.SimpleText("Приглашение", UI.SafeFont( '54 Ambi' ), inv:GetWide()/2-8, 65, COLOR_TEXT, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        draw.SimpleText("Вы были приглашены лидером: "..leader, UI.SafeFont( '22 Ambi' ), inv:GetWide()/2-8, 115, COLOR_TEXT, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        draw.SimpleText("В организацию "..name, UI.SafeFont( '22 Ambi' ), inv:GetWide()/2-8, 145, team.GetColor( index ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        draw.SimpleText("Вы готовы вступить?", UI.SafeFont( '22 Ambi' ), inv:GetWide()/2-8, 255, COLOR_TEXT, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end

    local btn_ok = vgui.Create( "DButton", inv )
    btn_ok:SetText( "Согласен" )
    btn_ok:SetTextColor( COLOR_TEXT )
    btn_ok:SetFont(UI.SafeFont( '32 Ambi' ))
    btn_ok:SetSize( 240, 50 )
    btn_ok:SetPos( inv:GetWide()/2-btn_ok:GetWide()-40, inv:GetTall()-btn_ok:GetTall()-15 )
    btn_ok.Paint = function( self, w, h )
        draw.RoundedBox( 0, 0, 0, w, h, C.AMBI_GREEN )
    end
    btn_ok.DoClick = function( self )
        inv:Remove()
        net.Start('amb_invite_org')
            net.WriteUInt( id, 14 )
        net.SendToServer()
    end

    local btn_cancel = vgui.Create( "DButton", inv )
    btn_cancel:SetFont(UI.SafeFont( '32 Ambi' ))
    btn_cancel:SetText( "Отказываюсь" )
    btn_cancel:SetTextColor( COLOR_TEXT )
    btn_cancel:SetPos( inv:GetWide()-btn_ok:GetWide()*1.7, inv:GetTall()-btn_ok:GetTall()-15 )
    btn_cancel:SetSize( 240, 50 )
    btn_cancel.Paint = function( self, w, h )
        draw.RoundedBox( 0, 0, 0, w, h, C.AMBI_RED )
    end
    btn_cancel.DoClick = function( self )
        inv:Remove()
    end

    timer.Simple( 9, function() if ValidPanel( inv ) then inv:Remove() end end )
end

-- Данное творение принадлежит проекту [ Ambition ]