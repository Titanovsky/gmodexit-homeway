Ambi.Homeway.messages = Ambi.Homeway.messages or {}

local C, GUI, Draw, UI, CL = Ambi.Packages.Out( '@d, ContentLoader' )
local W, H = ScrW(), ScrH()

local w, h = ScrW(), ScrH()

local enable = CreateClientConVar( 'ambi_hw_chat', 0, true )

-- function Ambi.Homeway.OpenChat()
--     local cw, ch = chat.GetChatBoxSize()
--     local cx, cy = chat.GetChatBoxPos()

--     if LocalPlayer().menu then LocalPlayer().menu:Remove() end
--     if LocalPlayer().messages then LocalPlayer().messages:Remove() end

--     local menu = GUI.DrawFrame( nil, cw, ch + 64, 6, cy - 64 - 24, '', true, false, false, function( self, w, h )
--         draw.RoundedBox( 0, 0, 0, w, h, C.AMBI_PANEL )
--     end )

--     local box = GUI.DrawScrollPanel( menu, menu:GetWide() - 8, menu:GetTall() - 30 - 8, 4, 4, function( self, w, h ) 
--         draw.RoundedBox( 0, 0, 0, w, h, C.AMBI_PANEL )
--     end )

--     if Ambi.Homeway.messages and ( #Ambi.Homeway.messages > 0 ) then
--         for i, v in ipairs( Ambi.Homeway.messages ) do
--             local richtext = vgui.Create( 'RichText', box )
--             richtext:SetSize( box:GetWide() * 2, 22 )
--             richtext:SetPos( 0, 20 * ( i - 1 ) )
--             richtext:SetText( v )
--             function richtext:PerformLayout()
--                 self:SetFontInternal( UI.SafeFont( '22 Arimo' ) )
--                 self:SetFGColor( Color( 230, 230, 230 ) )
--             end

--             if ( i == #Ambi.Homeway.messages ) then 
--                 box:GetVBar():SetScroll( 999 )
--             end
--         end
--     end

--     local press = GUI.DrawTextEntry( menu, menu:GetWide(), 30, 0, menu:GetTall() - 30, UI.SafeFont( '26 Arimo' ), C.ABS_BLACK, '', nil, '', false )
--     press.OnKeyCodeTyped = function( self, nCode )
--         if ( nCode == KEY_BACKQUOTE ) then gui.HideGameUI() end
--         if ( nCode == KEY_ESCAPE ) then
--             Ambi.Homeway.CloseChat()
--             gui.HideGameUI()
--         elseif ( nCode == KEY_ENTER ) then
--             if ( string.Trim( self:GetText() ) ~= '' ) then LocalPlayer():ConCommand( 'say ' .. self:GetText() ) end
            
--             Ambi.Homeway.CloseChat()
--         end
--     end
--     press:RequestFocus()

--     LocalPlayer().menu = menu
-- end

-- function Ambi.Homeway.CloseChat()
--     if LocalPlayer().menu then
--         LocalPlayer().menu:Remove()
--         LocalPlayer().menu = nil
--     end
-- end

-- local function RefreshMessages( sText )
--     local chat = LocalPlayer().messages
--     if not chat then return end

--     local box = chat.box
--     if not box then return end

--     local last_child = box.last
--     local _, y = last_child:GetPos()

--     local richtext = vgui.Create( 'RichText', box )
--     richtext:SetSize( box:GetWide() * 2, 22 )
--     richtext:SetPos( 0, y + 20 )
--     richtext:SetText( sText )
--     function richtext:PerformLayout()
--         self:SetFontInternal( UI.SafeFont( '22 Arimo Outline' ) )
--         self:SetFGColor( Color( 255, 255, 0 ) )
--     end
--     box:AddItem( richtext )
--     box:ScrollToChild( richtext )

--     box.last = richtext
-- end

-- function Ambi.Homeway.ShowMessagesChat()
--     timer.Create( 'ChatRemoveShowMessages', 11, 1, function()
--         if LocalPlayer().messages then LocalPlayer().messages:Remove() end
--     end )

--     if LocalPlayer().messages then RefreshMessages( Ambi.Homeway.messages[ #Ambi.Homeway.messages ] ) return end

--     local cw, ch = chat.GetChatBoxSize()
--     local cx, cy = chat.GetChatBoxPos()

--     local menu = GUI.DrawPanel( nil, cw, ch + 64, 6, cy - 64 - 24, function( self, w, h )
--     end )
--     menu.OnRemove = function( self )
--         LocalPlayer().messages = nil
--     end

--     local box = GUI.DrawScrollPanel( menu, menu:GetWide() - 8, menu:GetTall() - 8, 4, 4, function( self, w, h ) 
--     end )

--     if Ambi.Homeway.messages and ( #Ambi.Homeway.messages > 0 ) then
--         for i, v in ipairs( Ambi.Homeway.messages ) do
--             local richtext = vgui.Create( 'RichText', box )
--             richtext:SetSize( box:GetWide() * 2, 22 )
--             richtext:SetPos( 0, 20 * ( i - 1 ) )
--             richtext:SetText( v )
--             function richtext:PerformLayout()
--                 self:SetFontInternal( UI.SafeFont( '22 Arimo' ) )
--                 self:SetFGColor( Color( 230, 230, 230 ) )
--             end

--             if ( i == #Ambi.Homeway.messages ) then 
--                 box.last = richtext
--                 box:ScrollToChild( richtext ) 
--             end
--         end
--     end

--     local scroller = box:GetVBar()
--     scroller:SetSize( 0, 0 )

--     menu.box = box
--     LocalPlayer().messages = menu
-- end

-- hook.Add( 'PlayerBindPress', 'Ambi.Homeway.ChatBoxOpen', function( ePly, sBind )
--     if enable:GetBool() and ( sBind == 'messagemode' ) or ( sBind == 'messagemode2' ) then Ambi.Homeway.OpenChat() return true end
-- end )

-- hook.Add( 'OnPlayerChat', 'Ambi.Homeway.AddMessageChat', function( ePly, sText, bTeamChat, bDead )
--     if not enable:GetBool() then return end

--     Ambi.Homeway.messages[ #Ambi.Homeway.messages + 1 ] = ePly:Name()..': '..sText
--     Ambi.Homeway.ShowMessagesChat()
-- end )