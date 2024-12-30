local C, GUI, Draw, UI, CL = Ambi.Packages.Out( '@d, ContentLoader' )
local W, H = ScrW(), ScrH()

local COLOR_PANEL = Color( 0, 0, 0, 220 ) 

function Ambi.Homeway.OpenWarehouse( nEntIndexWarehouse )
    local obj = Entity( nEntIndexWarehouse )
    if not IsValid( obj ) or ( obj:GetClass() ~= 'warehouse' ) then return end

    local wh = Ambi.Homeway.GetWarehouse( obj:GetWarehouse() )

    local frame = GUI.DrawFrame( nil, W, H, 0, 0, '', true, false, false, function( self, w, h ) 
        if not LocalPlayer():Alive() then self:Remove() return end
        if obj:IsClosed() then self:Remove() end

        Draw.Blur( self, 2 )

        Draw.Box( w, h, 0, 0, COLOR_PANEL )
    end )
    frame.OnKeyCodePressed = function( self, nKey )
        self:Remove()
    end

    local close = GUI.DrawButton( frame, frame:GetWide(), frame:GetTall(), 0, 0, nil, nil, nil, function()
        frame:Remove()
    end, function( self, w, h ) 
    end )

    local main = GUI.DrawPanel( frame, frame:GetWide() * .4, frame:GetTall() * .6, 0, 0, function( self, w, h ) 
        Draw.Box( w, h, 0, 0, C.HOMEWAY_BLACK, 8 )

        Draw.SimpleText( w / 2, 6, 'Склад', UI.SafeFont( '64 Montserrat SemiBold' ), C.HOMEWAY_BLUE, 'top-center' )

        if self.draw_anti_discont then
            Draw.SimpleText( w / 2, 46, 'Есть оружейники цены увеличены на 30%', UI.SafeFont( '22 Montserrat' ), C.FLAT_RED, 'top-center' )
        end
    end ) 
    main:Center()

    local panel_list = GUI.DrawScrollPanel( main, main:GetWide() - 20 * 2, main:GetTall() - 50 * 2, 20, 80, function( self, w, h ) 
        Draw.Box( w, h, 0, 0, C.HOMEWAY_BLUE_DARK, 8 )
    end )

    for i, wep in ipairs( wh.items ) do
        local count = obj:GetWeaponCount( i )
        local text_count = ( count > 0 ) and '  x'..count or ''
        local text = i..'. '..wep.header..text_count
        local wx = Draw.GetTextSizeX( UI.SafeFont( '28 Montserrat Medium' ), text ) + 22

        local take = GUI.DrawButton( panel_list, wx, 40, 0, ( i - 1 ) * 40, nil, nil, nil, function()
            if not wh.jobs[ LocalPlayer():GetJob() ] then frame:Remove() return end 
            if LocalPlayer():HasWeapon( wep.class ) then Ambi.Homeway.Notify( 'У вас есть это оружие', 4, NOTIFY_ERROR ) return end

            count = obj:GetWeaponCount( i )
            if ( count <= 0 ) then return end

            surface.PlaySound( 'ambi/ui/click_tower_unite.wav' )

            net.Start( 'ambi_homeway_warehouse_take_wep' )
                net.WriteUInt( i, 6 )
            net.SendToServer()
        end, function( self, w, h ) 
            count = obj:GetWeaponCount( i )
            text_count = ( count > 0 ) and '  x'..count or ''
            text = i..'. '..wep.header..text_count

            Draw.SimpleText( 12, 0, text, UI.SafeFont( '28 Montserrat Medium' ), ( count > 0 ) and self.color or C.AMBI_GRAY, 'top-left', 1, C.ABS_BLACK )
        end )
        take.color = C.HOMEWAY_WHITE

        GUI.OnCursor( take, function()
            surface.PlaySound( 'ambi/ui/hover7.wav' )

            take.color = C.AMBI
        end, function()
            take.color = C.HOMEWAY_WHITE
        end )

        if wh.leaders[ LocalPlayer():GetJob() ] and wep.cost then
            local buy = GUI.DrawButton( panel_list, 100, 26, wx, ( i - 1 ) * 40 + 4, nil, nil, nil, function()
                if not wh.leaders[ LocalPlayer():GetJob() ] then frame:Remove() return end 

                local count = obj:GetWeaponCount( i )
                if wep.max and ( count >= wep.max ) then Ambi.Homeway.Notify( 'Достиг максимум', 4, NOTIFY_ERROR ) return end

                if ( LocalPlayer():GetMoney() < wep.cost ) then Ambi.Homeway.Notify( 'Нет денег', 4, NOTIFY_ERROR ) return end

                surface.PlaySound( 'ambi/ui/click_tower_unite.wav' )

                net.Start( 'ambi_homeway_warehouse_buy_wep' )
                    net.WriteUInt( i, 6 )
                net.SendToServer()
            end, function( self, w, h )
                Draw.Box( w, h, 0, 0, self.color, 6 )

                Draw.SimpleText( w / 2, h / 2, wep.cost..'$', UI.SafeFont( '22 Montserrat' ), C.FLAT_GREEN, 'center' )
            end )
            buy.color = COLOR_PANEL

            GUI.OnCursor( buy, function()
                surface.PlaySound( 'ambi/ui/hover7.wav' )

                buy.color = ColorAlpha( COLOR_PANEL, 100 )
            end, function()
                buy.color = COLOR_PANEL
            end ) 
        end
    end
end