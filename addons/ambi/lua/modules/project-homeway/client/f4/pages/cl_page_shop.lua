local C, GUI, Draw, UI = Ambi.Packages.Out( '@d' )

local W, H = ScrW(), ScrH()
local COLOR_PANEL = Color( 0, 0, 0, 200 ) 

-- ---------------------------------------------------------------------------------------------------------------------------------------
function Ambi.Homeway.ShowPageShop( vguiMain )
    local main = vguiMain

    main.back:SetVisible( true )
    main:Clear()
    
    local panel = GUI.DrawScrollPanel( main, main:GetWide(), main:GetTall(), 0, 0, function( self, w, h )
    end )

    local panel1 = GUI.DrawScrollPanel( main, main:GetWide() / 2, main:GetTall(), 0, 0, function( self, w, h )
        Draw.Box( w, h, 0, 0, COLOR_PANEL, 6 )
    end )

    local panel2 = GUI.DrawScrollPanel( main, main:GetWide() / 2 - 4, main:GetTall(), panel1:GetWide() + 2, 0, function( self, w, h )
        Draw.Box( w, h, 0, 0, COLOR_PANEL, 6 )
    end )

    local i = -1
    for class, item in SortedPairsByMemberValue( Ambi.DarkRP.GetShop(), 'category' ) do
        if not item then continue end
        if not Ambi.DarkRP.Config.f4menu_show_restrict_items_and_jobs then
            if item.allowed then
                local can

                for _, job in ipairs( item.allowed ) do
                    if isnumber( job ) and ( LocalPlayer():Team() == job ) then can = true break 
                    elseif isstring( job ) and ( LocalPlayer():GetJob() == job ) then can = true break 
                    end
                end

                if not can then continue end
            end
        end
        if ( item.category == 'Attachments' ) then continue end

        i = i + 1

        local price = item.GetPrice and item.GetPrice( LocalPlayer(), item ) or item.price

        local item_panel = GUI.DrawButton( panel1, panel1:GetWide(), 64, 0, 64 * i, nil, nil, nil, function()
            LocalPlayer():EmitSound( 'buttons/button15.wav', nil, 135, .1 )
            
            if timer.Exists( 'BlockF4MenuBuyItem' ) then return end
            timer.Create( 'BlockF4MenuBuyItem', 1, 1, function() end )

            LocalPlayer():ConCommand( 'say /'..Ambi.DarkRP.Config.shop_buy_command..' '..class )
        end, function( self, w, h ) 
            --Draw.Box( w, h, 0, 0, self.col ) -- debug

            Draw.SimpleText( 68, 4, item.name, UI.SafeFont( '28 Ambi' ), C.ABS_WHITE, 'top-left', 1, C.ABS_BLACK )
            Draw.SimpleText( 68, 4 + 28, price..Ambi.DarkRP.Config.money_currency_symbol, UI.SafeFont( '24 Nexa Script Light' ), LocalPlayer():GetMoney() >= price and C.AMBI_GREEN or C.AMBI_RED, 'top-left', 1, C.ABS_BLACK )
            Draw.Box( w, 2, 0, h - 2, C.AMBI_BLACK )
        end )
        item_panel.col = C.AMBI_WHITE
        item_panel:SetTooltip( item.description )

        GUI.OnCursor( item_panel, function()
            item_panel.col = ColorAlpha( C.ABS_WHITE, 50 )

            LocalPlayer():EmitSound( 'buttons/button15.wav', nil, 25, .1 ) 
        end, function() 
            item_panel.col = C.AMBI_WHITE
        end )
        
        GUI.DrawModel( item_panel, 64, 64, 0, 0, item.model )

        local line = GUI.DrawPanel( item_panel, item_panel:GetWide(), 8, 0, item_panel:GetTall() - 8, function( self, w, h ) 
            --Draw.Box( w, h, 0, 0, item.color )
        end )
    end

    local i = -1
    for class, item in SortedPairsByMemberValue( Ambi.DarkRP.GetShop(), 'category' ) do
        if not item then continue end
        if ( item.category ~= 'Attachments' ) then continue end

        i = i + 1

        local price = item.GetPrice and item.GetPrice( LocalPlayer(), item ) or item.price

        local item_panel = GUI.DrawButton( panel2, panel2:GetWide(), 64, 0, 64 * i, nil, nil, nil, function()
            LocalPlayer():EmitSound( 'buttons/button15.wav', nil, 135, .1 )
            
            if timer.Exists( 'BlockF4MenuBuyItem' ) then return end
            timer.Create( 'BlockF4MenuBuyItem', 1, 1, function() end )

            LocalPlayer():ConCommand( 'say /'..Ambi.DarkRP.Config.shop_buy_command..' '..class )
        end, function( self, w, h ) 
            --Draw.Box( w, h, 0, 0, self.col ) -- debug

            Draw.SimpleText( 68, 4, item.name, UI.SafeFont( '28 Ambi' ), C.ABS_WHITE, 'top-left', 1, C.ABS_BLACK )
            Draw.SimpleText( 68, 4 + 28, price..Ambi.DarkRP.Config.money_currency_symbol, UI.SafeFont( '24 Nexa Script Light' ), LocalPlayer():GetMoney() >= price and C.AMBI_GREEN or C.AMBI_RED, 'top-left', 1, C.ABS_BLACK )
            Draw.Box( w, 2, 0, h - 2, C.AMBI_BLACK )
        end )
        item_panel.col = C.AMBI_WHITE
        item_panel:SetTooltip( item.description )

        GUI.OnCursor( item_panel, function()
            item_panel.col = ColorAlpha( C.ABS_WHITE, 50 )

            LocalPlayer():EmitSound( 'buttons/button15.wav', nil, 25, .1 ) 
        end, function() 
            item_panel.col = C.AMBI_WHITE
        end )
        
        GUI.DrawModel( item_panel, 64, 64, 0, 0, item.model )

        local line = GUI.DrawPanel( item_panel, item_panel:GetWide(), 8, 0, item_panel:GetTall() - 8, function( self, w, h ) 
            --Draw.Box( w, h, 0, 0, item.color )
        end )
    end
end