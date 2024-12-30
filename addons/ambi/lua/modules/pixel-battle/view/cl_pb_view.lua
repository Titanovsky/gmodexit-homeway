local C, GUI, Draw, UI = Ambi.Packages.Out( '@d' )
local W, H = ScrW(), ScrH()

local COLOR_PANEL = Color( 0, 0, 0, 240 )

-- --------------------------------------------------------------------------------------------------------------------------------------------
function Ambi.PixelBattle.ShowView()
    local dragging = false
    local drag_x, drag_y = 0, 0
    local zoom = 1

    local rt_name = "MyRenderTarget12"
    local rt = GetRenderTargetEx(rt_name, 1000, 1000, 0, 2, 0, 2, -1 )
    local rt_material = CreateMaterial("MyRTMaterial12", "UnlitGeneric", {
        ["$basetexture"] = rt_name,
        ["$translucent"] = 0,
        ["$ignorez"] = 1,
        ["$vertexcolor"] = 1,
        ["$vertexalpha"] = 1,
        ["$nolod"] = 1,
        ["$additive"] = 0,
        ["$nofiltering"] = 1
    })

    local function DrawToRT()
        render.PushRenderTarget(rt)
        cam.Start2D()

        surface.SetDrawColor(255, 255, 255, 255)
        surface.DrawRect(0, 0, 1000, 1000)
    
        cam.End2D()
        render.PopRenderTarget()
    end

    local function DrawCanvas(self, w, h)
        surface.SetDrawColor(255, 255, 255, 255)
        surface.SetMaterial(rt_material)
        surface.DrawTexturedRect(0, 0, w, h)
    end

    local function SetupMove( vguiPanel )
        function vguiPanel:OnMousePressed( nMouseCode )
            if ( nMouseCode ~= MOUSE_MIDDLE ) then return end
    
            dragging = true
            drag_x, drag_y = input.GetCursorPos() -- чтобы изначально панель не была где-то сбоку
        end
        
        function vguiPanel:OnMouseReleased( nMouseCode )
            if ( nMouseCode ~= MOUSE_MIDDLE ) then return end
    
            dragging = false
        end
    end

    local function SetupAutoScale( vguiPanel )
        vguiPanel.pw, vguiPanel.ph = vguiPanel:GetWide(), vguiPanel:GetTall()
        vguiPanel.px, vguiPanel.py = vguiPanel:GetX(), vguiPanel:GetY()

        function vguiPanel:PerformLayout( nW, nH )
            local canvas = vguiPanel:GetParent()

            local procent_w = canvas:GetWide() / canvas.pw
            local procent_h = canvas:GetTall() / canvas.ph

            local wide = math.floor( procent_w * vguiPanel.pw )
            local tall = math.floor( procent_h * vguiPanel.ph )
            vguiPanel:SetSize( wide, tall )

            local x = math.floor( procent_w * vguiPanel.px )
            local y = math.floor( procent_h * vguiPanel.py )
            vguiPanel:SetPos( x, y )
        end
    end

    local function SetupWheelScale( vguiPanel )
        function vguiPanel:OnMouseWheeled( nDelta )
            local canvas = vguiPanel.canvas
            local speed = 100

            local wide, tall = canvas:GetWide(), canvas:GetTall()
            if ( zoom >= 5 ) and ( nDelta == 1 ) then return end
            if ( zoom <= 0.2 ) and ( nDelta == -1 ) then return end

            zoom = math.Round( zoom + 0.1 * nDelta, 1 )

            canvas:SetSize( wide + nDelta * speed, tall + nDelta * speed )

            --DrawToRT()
        end
    end

    local frame = GUI.DrawFrame( nil, W * .95, H * .95, 0, 0, '', true, true, true, function( self, w, h ) 
        Draw.Box( w, h, 0, 0, C.BLACK )

        Draw.SimpleText( 4, 4, 'x'..zoom, UI.SafeFont( '32 Ambi' ), C.WHITE, 'top-left', 1, C.ABS_BLACK )
    end )
    frame:Center()

    local window = GUI.DrawPanel( frame, frame:GetWide() * .9, frame:GetTall() * .9, 0, 0, function( self, w, h ) 
        Draw.Box( w, h, 0, 0, C.AMBI_GRAY )

        --Draw.SimpleText( w - 2, 6 + 36, '123', UI.SafeFont( '32 Slimamif Medium' ), C.WHITE, 'top-left', 1, C.ABS_BLACK )
    end ) 
    window:Center()
    SetupMove( window )
    SetupWheelScale( window )

    local canvas = GUI.DrawPanel( window, 500, 500, 0, 0, function( self, w, h ) 
        Draw.Box( w, h, 0, 0, C.WHITE )

        DrawCanvas( self, w, h )
    end ) 
    canvas:Center()
    canvas.pw, canvas.ph = canvas:GetWide(), canvas:GetTall()
    canvas.Think = function()
        if dragging then
            local x, y = input.GetCursorPos()
            if ( x == drag_x ) and ( y == drag_y ) then return end

            local delta_x, delta_y = x - drag_x, y - drag_y
            drag_x, drag_y = x, y

            local pos_x, pos_y = canvas:GetPos()
            canvas:SetPos( pos_x + delta_x, pos_y + delta_y )
        end

        if canvas.is_pressed_mouse then
            local x, y = canvas:LocalCursorPos()
            x = x / zoom
            y = y / zoom

            x = math.floor(x / 4) * 4
            y = math.floor(y / 4) * 4

            render.PushRenderTarget(rt)
                cam.Start2D()
                    surface.SetDrawColor(C.RED)
                    surface.DrawRect(x, y, 4, 4)
                cam.End2D()
            render.PopRenderTarget()
        end
    end
    canvas.is_pressed_mouse = false
    canvas.Reset = function()
        zoom = 1

        canvas:SetSize( canvas.pw, canvas.ph )
        canvas:Center()

        for _, panel in ipairs( canvas:GetChildren() ) do
            panel:InvalidateLayout()
        end
    end
    canvas.canvas = canvas
    window.canvas = canvas
    SetupWheelScale( canvas )

    canvas.OnMousePressed = function( self, nMouseCode )
        if nMouseCode == MOUSE_MIDDLE then 
            dragging = true
            drag_x, drag_y = input.GetCursorPos() -- чтобы изначально панель не была где-то сбоку

            return 
        end

        self.is_pressed_mouse = true
    end
    
    canvas.OnMouseReleased = function( self, nMouseCode )
        if ( nMouseCode == MOUSE_MIDDLE ) then dragging = false return end

        self.is_pressed_mouse = false
    end

    DrawToRT()

    frame.OnKeyCodePressed = function( self, nKeyCode )
        if ( nKeyCode == KEY_E ) then canvas:Reset() end
        if ( nKeyCode == KEY_SPACE ) then frame:Remove() end
    end
end