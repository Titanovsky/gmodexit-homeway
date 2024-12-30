local C, GUI, Draw, UI, CL = Ambi.Packages.Out( '@d, ContentLoader' )
local W, H = ScrW(), ScrH()

function Ambi.Homeway.ShowCasino( nObj )
    local buyer = Entity( nObj )
    if not IsValid( buyer ) then return end

    local frame = GUI.DrawFrame( nil, 400, 400, 0, 0, '', true, true, true, function( self, w, h ) 
        Draw.Box( w, h, 0, 0, C.AMBI_BLACK )

        Draw.SimpleText( 4, 4, self.text, UI.SafeFont( '28 Ambi' ), self.color, 'top-left', 1, C.ABS_BLACK )
    end )
    frame:Center()
    frame.text = ''
    frame.color = Color( 0, 0, 0 )

    local is_red

    local red = GUI.DrawButton( frame, frame:GetWide() / 2, 200, 0, 40, nil, nil, nil, function( self )
        is_red = true

        frame.text = 'Красный'
        frame.color = Color( 233,81, 76)
    end, function( self, w, h ) 
        Draw.Box( w, h, 0, 0, C.ABS_BLACK )
        Draw.Box( w - 4, h - 4, 2, 2, C.AMBI_RED )
    end )

    local blue = GUI.DrawButton( frame, frame:GetWide() / 2, 200, frame:GetWide() - ( frame:GetWide() / 2 ), 40, nil, nil, nil, function( self )
        is_red = false

        frame.text = 'Синий'
        frame.color = Color( 76,167, 241)
    end, function( self, w, h ) 
        Draw.Box( w, h, 0, 0, C.ABS_BLACK )
        Draw.Box( w - 4, h - 4, 2, 2, C.AMBI_BLUE )
    end )

    local te_money = GUI.DrawTextEntry( frame, frame:GetWide() / 1.4, 28, frame:GetWide() / 2 - ( frame:GetWide() / 1.4 ) / 2, frame:GetTall() - 40 - 28 - 12, UI.SafeFont( '26 Ambi' ), nil, 500, nil, nil, false, true )

    local use = GUI.DrawButton( frame, frame:GetWide() / 2, 40, frame:GetWide() / 2 - frame:GetWide() / 4, frame:GetTall() - 40 - 4, nil, nil, nil, function( self )
        local money = tonumber( te_money:GetValue() )
        if ( money <= 0 ) or ( money > 25000 ) then surface.PlaySound( 'Error4' ) return end
        if ( LocalPlayer():GetMoney() < money ) then surface.PlaySound( 'Error4' ) return end
        if ( is_red == nil ) then surface.PlaySound( 'Error4' ) return end

        net.Start( 'ambi_homeway_use_casino' )
            net.WriteBool( is_red )
            net.WriteUInt( money, 15 )
            net.WriteEntity( buyer )
        net.SendToServer()

        timer.Create( 'Casino:'..buyer:EntIndex(), 3, 1, function() end )

        frame:Remove()
    end, function( self, w, h )
        Draw.Box( w, h, 0, 0, Color( 0, 0, 0, 100 ) )

        Draw.SimpleText( w / 2, h / 2, 'Играть', UI.SafeFont( '32 Ambi' ), C.ABS_WHITE, 'center', 1, C.ABS_BLACK )
    end )
end