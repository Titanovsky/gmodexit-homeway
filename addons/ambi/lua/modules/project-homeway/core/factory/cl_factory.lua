local C, GUI, Draw, UI, CL = Ambi.Packages.Out( '@d, ContentLoader' )

local W, H = ScrW(), ScrH()
local COLOR_PANEL = Color( 0, 0, 0, 220 ) 

function Ambi.Homeway.OpenFactoryMachineMenu( nID )
    local obj = Entity( nID )
    if not IsValid( obj ) or ( obj:GetClass() ~= 'factory_machine' ) then return end

    if not LocalPlayer():Alive() then return end

    local frame = GUI.DrawFrame( nil, W, H, 0, 0, '', true, false, false, function( self, w, h ) 
        if not LocalPlayer():Alive() then self:Remove() return end

        Draw.Box( w, h, 0, 0, COLOR_PANEL )
    end )
    frame.OnKeyCodePressed = function( self, nKey )
        self:Remove()
    end

    local main = GUI.DrawPanel( frame, frame:GetWide() * .28, frame:GetTall() * .64, 0, 0, function( self, w, h ) 
        Draw.Box( w, h, 0, 0, C.HOMEWAY_BLACK, 8 )

        Draw.SimpleText( w / 2, 1, 'Завод', UI.SafeFont( '46 Montserrat' ), C.AMBI, 'top-center' )
    end ) 
    main:Center()

    local panel_list = GUI.DrawScrollPanel( main, main:GetWide() - 20 * 2, main:GetTall() - 50 * 2, 20, 80, function( self, w, h ) 
        Draw.Box( w, h, 0, 0, C.HOMEWAY_BLUE_DARK, 8 )
    end )

    local tab = table.GetKeys( Ambi.Homeway.Config.factory_items )
    table.Shuffle( tab )

    for i, class in ipairs( tab ) do
        local item = Ambi.Homeway.Config.factory_items[ class ]
        local item_panel = GUI.DrawPanel( panel_list, panel_list:GetWide() - 8, 60, 4, ( i - 1 ) * ( 60 + 4 ) + 4, function( self, w, h ) 
            Draw.Box( w, h, 0, 0, COLOR_PANEL, 8 )

            Draw.SimpleText( 72, 4, item.header, UI.SafeFont( '26 Montserrat Medium' ), C.HOMEWAY_BLUE, 'top-left' )
            Draw.SimpleText( w - 8, 4, item.time..' сек', UI.SafeFont( '22 Montserrat Medium' ), C.HOMEWAY_BLUE, 'top-right' )
        end )

        GUI.DrawModel( item_panel, 64, 64, 4, 0, weapons.Get( class ).WorldModel )

        local select = GUI.DrawButton( item_panel, item_panel:GetWide(), item_panel:GetTall(), 0, 0, nil, nil, nil, function()
            if not LocalPlayer():Alive() then Ambi.Homeway.Notify( 'Вы мертвы', 4, NOTIFY_ERROR ) return end

            net.Start( 'ambi_homeway_factory_machine_make' )
                net.WriteUInt( nID, 12 )
                net.WriteString( class )
            net.SendToServer()

            frame:Remove()
        end, function( self, w, h ) 
            --Draw.Box( w, h, 0, 0, COLOR_PANEL, 6 )
        end )

        i = i + 1
    end
end