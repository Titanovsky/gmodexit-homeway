local C, GUI, Draw, UI, CL = Ambi.Packages.Out( '@d, ContentLoader' )
local W, H = ScrW(), ScrH()
local COLS = 4

local COLOR_PANEL = Color( 0, 0, 0, 230)

-- --------------------------------------------------------------------------------------------------------------------------------------------
function Ambi.Inv.Show( vguiFrame )
    local frame = vguiFrame

    local panel = GUI.DrawScrollPanel( frame, frame:GetWide(), frame:GetTall() - 30, 0, 30, function( self, w, h ) 
    end )

    local grid = GUI.DrawGrid( panel, panel:GetWide() / COLS, 132, 0, 0, COLS )

    local items = LocalPlayer():GetInventory().items
    for slot, tab in ipairs( items ) do
        local item = tab.item
        local class
        local icon
        local name = ''

        if item then
            class = Ambi.Inv.items[ item.class ]
            name = class.name
            icon = class.icon
        end
        
        local panel = GUI.DrawPanel( nil, grid:GetColWide() - 4, grid:GetRowHeight() - 4, 0, 0, function( self, w, h ) 
            Draw.Box( w, h, 0, 0, COLOR_PANEL ) -- debug

            -- Draw.Text( 1, 0, slot, UI.SafeFont( '16 Eirik Raude' ), C.ABS_WHITE, 'top-left' )

            if item then
                Draw.Text( w - 4, -2, 'x'..tostring( item.count ), UI.SafeFont( '24 Eirik Raude' ), C.ABS_WHITE, 'top-right' )

                if icon and string.StartsWith( icon, 'http' ) then
                    Draw.Material( 128, 128, w / 2 - 128 / 2, 0, CL.Material( 'inv_'..item.class ) )
                end

                Draw.Text( 4, -2, class.name, UI.SafeFont( '24 Montserrat' ), C.ABS_WHITE, 'top-left' )
            end
        end )
        grid:AddItem( panel )

        if item then 
            local desc = item.description or ''
            panel:SetTooltip( name..' x'..item.count..'\n'..desc ) 

            if icon and string.StartsWith( icon, 'model' ) then
                local mdl = GUI.DrawModel( panel, 128, 128, 0, 0, icon )
                mdl:Center()
            end
        end

        if not item then continue end

        if class.Drop then
            local drop = GUI.DrawButton( panel, 60, 32, 0, panel:GetTall() - 32, nil, nil, nil, function( self )
                local menu = vgui.Create( 'DMenu', self )
                menu.Paint = function( self, w, h ) Draw.Box( w, h, 0, 0, COLOR_PANEL ) end

                local drop_x = menu:AddOption( 'Выкинуть X', function() 
                    local _frame = GUI.DrawFrame( nil, 240, 240, W / 2 - 240 / 2, H / 2 - 240 / 2, '', true, true, true, function( self, w, h )
                        Draw.Box( w, h, 0, 0, COLOR_PANEL )
                        Draw.Text( w / 2, 4, 'x'..item.count, UI.SafeFont( '24 Eirik Raude' ), C.ABS_WHITE, 'top-center' )
                    end )

                    local count = GUI.DrawTextEntry( _frame, _frame:GetWide() - 8, 30, 4, _frame:GetTall() / 2 - 15, UI.SafeFont( '28 Eirik Raude' ), C.AMBI_BLACK, nil, nil, 'Введите сюда нужное количество', false, true )

                    local drop = GUI.DrawButton( _frame, 70, 25, _frame:GetWide() / 2 - 70 / 2, _frame:GetTall() - 25 - 4, nil, nil, nil, function( self )
                        local count = tonumber( count:GetValue() )

                        if not count then return end
                        if ( count <= 0 ) then return end
                        if ( count > item.count ) then return end

                        net.Start( 'ambi_inv_drop_item' )
                            net.WriteUInt( slot, 10 )
                            net.WriteUInt( count, 16 )
                        net.SendToServer()

                        self:Remove()
                        _frame:Remove()
                        frame:Clear()

                        timer.Simple( 0.1, function() Ambi.Inv.Show( vguiFrame ) end )
                    end, function( self, w, h )
                        Draw.Box( w, h, 0, 0, COLOR_PANEL )
                        Draw.Text( w / 2, h / 2, 'Выкинуть', UI.SafeFont( '16 Eirik Raude' ), C.ABS_WHITE, 'center' )
                    end )
                end )
                drop_x:SetFont( UI.SafeFont( '24 Eirik Raude' ) )
                drop_x:SetTextColor( C.ABS_WHITE )

                if ( item.count > 2 ) then
                    local drop_one = menu:AddOption( 'Выкинуть 1', function() 
                        net.Start( 'ambi_inv_drop_item' )
                            net.WriteUInt( slot, 10 )
                            net.WriteUInt( 1, 16 )
                        net.SendToServer()

                        self:Remove()
                        frame:Clear()

                        timer.Simple( 0.1, function() Ambi.Inv.Show( vguiFrame ) end )
                    end )
                    drop_one:SetFont( UI.SafeFont( '20 Eirik Raude' ) )
                    drop_one:SetTextColor( C.ABS_WHITE )
                end

                local half = math.floor( item.count / 2 )
                if ( half > 0 ) then
                    local drop_half = menu:AddOption( 'Выкинуть '..half, function()
                        net.Start( 'ambi_inv_drop_item' )
                            net.WriteUInt( slot, 10 )
                            net.WriteUInt( half, 16 )
                        net.SendToServer()

                        self:Remove()
                        frame:Clear()

                        timer.Simple( 0.1, function() Ambi.Inv.Show( vguiFrame ) end )
                    end )
                    drop_half:SetFont( UI.SafeFont( '20 Eirik Raude' ) )
                    drop_half:SetTextColor( C.ABS_WHITE )
                end

                local drop_all = menu:AddOption( 'Выкинуть '..item.count, function() 
                    net.Start( 'ambi_inv_drop_item' )
                        net.WriteUInt( slot, 10 )
                        net.WriteUInt( item.count, 16 )
                    net.SendToServer()

                    self:Remove()
                    frame:Clear()

                    timer.Simple( 0.1, function() Ambi.Inv.Show( vguiFrame ) end )
                end )
                drop_all:SetFont( UI.SafeFont( '20 Eirik Raude' ) )
                drop_all:SetTextColor( C.ABS_WHITE )

                menu:SetPos( 0, 0 )
                menu:Open()
            end, function( self, w, h )
                -- Draw.Box( w, h, 0, 0, C.AMBI_RED ) -- debug

                Draw.Text( w / 2, h / 2, 'Drop', UI.SafeFont( '28 Ambi' ), C.AMBI_RED, 'center' )
            end )
        end

        if class.Use then
            local use = GUI.DrawButton( panel, 40, 32, 60, panel:GetTall() - 32, nil, nil, nil, function( self )
                net.Start( 'ambi_inv_use_item' )
                    net.WriteUInt( slot, 10 )
                net.SendToServer()

                timer.Simple( 0.1, function()
                    frame:Clear()
                    Ambi.Inv.Show( vguiFrame )
                end )
            end, function( self, w, h )
                -- Draw.Box( w, h, 0, 0, C.AMBI_GREEN ) -- debug

                Draw.Text( w / 2, h / 2, 'Use', UI.SafeFont( '24 Ambi' ), C.AMBI_GREEN, 'center' )
            end )
        end
    end
end