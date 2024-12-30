local C, GUI, Draw, UI = Ambi.Packages.Out( '@d' )

local w = ScrW()
local h = ScrH()

-- ---------------------------------------------------------------------------------------------------------------------------------------
local function Success()
    if not Ambi.CrackDoorMultigame.enable then return end

    local entity = LocalPlayer():GetEyeTrace().Entity
    if not IsValid( entity ) then return end
    if not LocalPlayer():CheckDistance( entity, 94 ) then return end
    if not entity:CanBeUsedByLockpick() then return end

    net.Start( 'ambi_crack_door' )
        net.WriteBit( true )
    net.SendToServer()
end

local function Fail()
    if not Ambi.CrackDoorMultigame.enable then return end

    local entity = LocalPlayer():GetEyeTrace().Entity
    if not IsValid( entity ) then return end
    if not LocalPlayer():CheckDistance( entity, 94 ) then return end
    if not entity:CanBeUsedByLockpick() then return end

    net.Start( 'ambi_crack_door' )
        net.WriteBit( false )
    net.SendToServer()
end

local function RandColor( nElements )
    local access_colors = {
        C.AMBI_RED,
        C.AMBI_GREEN,
        C.AMBI_PURPLE,
        C.AMBI_BLUE,
        C.AMBI,
    }

    if ( nElements > #access_colors ) then nElements = #access_colors end

    local tab = {}

    local i = 0
    for k, v in RandomPairs( access_colors ) do
        i = i + 1
        tab[i] = v
    end

    local return_tab = {}

    for i = 1, nElements do
        return_tab[i] = tab[i]
    end

    return return_tab
end

-- ---------------------------------------------------------------------------------------------------------------------------------------
function Ambi.CrackDoorMultigame.Start()
    if not Ambi.CrackDoorMultigame.enable then return end
    local colors = RandColor( 4 )

    local frame = vgui.Create( 'DFrame' )
    frame:SetSize( w/2, h/2 )
    frame:Center()
    frame:MakePopup()
    frame:SetTitle( '' )
    frame:ShowCloseButton( false )
    frame.Paint = function( self, w, h )
        draw.RoundedBox( 0, 0, 0, w, h, C.AMBI_BLACK )
        draw.RoundedBox( 0, 0, 0, w, h/28, C.AMBI )

        if ( timer.Exists( 'AmbTime[CrackingDoor]' ) ) then
            draw.SimpleText( 'Запомните порядок цветов!  [ '..math.Round( timer.TimeLeft( 'AmbTime[CrackingDoor]' ) )..' ]', UI.SafeFont( '32 Ambi' ), w/2, h/10, C.AMBI, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP )
        end
    end
    frame.OnKeyCodePressed = function( self, nKey )
        self:Remove()
    end

    local grid = vgui.Create( 'DGrid',  frame)
    grid:SetPos( frame:GetWide()/4, frame:GetTall()/2 )
    grid:SetColWide( 84 )
    grid:SetRowHeight( 84 )
    grid:SetCols( #colors )

    for i = 1, #colors do
        local panel = vgui.Create( 'DPanel' )
        panel:SetSize( grid:GetColWide()-4, grid:GetRowHeight() )
        panel.Paint = function( self, w, h )
            draw.RoundedBox( 0, 0, 0, w, h, colors[i] )
            draw.SimpleTextOutlined( i, UI.SafeFont( '18 Ambi' ), w/2, h/4, C.ABS_WHITE, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, C.ABS_BLACK )
        end

        grid:AddItem( panel )
    end

    timer.Create( 'AmbTime[CrackingDoor]', 6, 1, function() 
        frame:Remove() 
        Ambi.CrackDoorMultigame.Processing( colors ) 
    end )
end

function Ambi.CrackDoorMultigame.Processing( tColors )
    local ply_choise = {}

    local frame = vgui.Create( 'DFrame' )
    frame:SetSize( w/2, h/2 )
    frame:Center()
    frame:MakePopup()
    frame:SetTitle( '' )
    frame:ShowCloseButton( false )
    frame.Paint = function( self, w, h )
        draw.RoundedBox( 0, 0, 0, w, h, C.AMBI_BLACK )
        draw.RoundedBox( 0, 0, 0, w, h/28, C.AMBI )

        if ( timer.Exists( 'AmbTime[MiniGame1]' ) ) then
            draw.SimpleText( 'Выберите по порядку! У Вас  '..math.Round( timer.TimeLeft( 'AmbTime[MiniGame1]' ) ), UI.SafeFont( '32 Ambi' ), w/2, h/10, C.AMBI, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP )
        end
    end
    frame.Think = function( self )
        if ( LocalPlayer():Alive() == false ) then return frame:Remove() end

        if ( #ply_choise > 0 ) and ( ply_choise[1] ~= 1 ) then
            timer.Destroy( 'AmbTime[MiniGame1]' )
            frame:Remove()
            
            Fail()
        elseif ( #ply_choise > 1 ) and ( ply_choise[2] ~= 2 ) then
            timer.Destroy( 'AmbTime[MiniGame1]' )
            frame:Remove()

            Fail()
        elseif ( #ply_choise > 2 ) and ( ply_choise[3] ~= 3 ) then
            timer.Destroy( 'AmbTime[MiniGame1]' )
            frame:Remove()
            
            Fail()
        elseif ( #ply_choise > 3 ) and ( ply_choise[4] ~= 4 ) then
            timer.Destroy( 'AmbTime[MiniGame1]' )
            frame:Remove()
            
            Fail()
        end

        if ( ply_choise[1] == 1 ) and ( ply_choise[2] == 2 ) and ( ply_choise[3] == 3 ) and ( ply_choise[4] == 4 ) then 
            timer.Destroy( 'AmbTime[MiniGame1]' )
            frame:Remove()

            return Success()
        end
    end

    timer.Create( 'AmbTime[MiniGame1]', 3.85, 1, function() 
        frame:Remove()
        Fail()
    end )

    for id, color in pairs( tColors ) do
        local btn = vgui.Create( 'DButton', frame )
        btn:SetSize( 64, 64 )
        btn:SetPos( frame:GetWide()/2 + math.random( -132, 132 ), frame:GetTall()/2 + math.random( -132, 132 ) )
        btn:SetText( '' )
        btn.Paint = function( self, w, h )
            draw.RoundedBox( 0, 0, 0, w, h, color )
        end
        btn.DoClick = function( self )
            ply_choise[ #ply_choise + 1 ] = id
            self:Remove()
        end
    end
end