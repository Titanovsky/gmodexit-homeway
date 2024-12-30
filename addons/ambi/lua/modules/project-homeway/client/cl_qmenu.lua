local C, GUI, Draw, UI = Ambi.Packages.Out( '@d' )
local DrawTextOutline, DrawBox = draw.SimpleTextOutlined, draw.RoundedBox
local W, H = ScrW(), ScrH()

local COLOR_PANEL = Color( 0, 0, 0, 200 )

local PANEL = {}

function PANEL:Init()
    self.PanelList = vgui.Create( "DPanelList", self )
    self.PanelList:SetPadding( 4 )
    self.PanelList:SetSpacing( 2 )
    self.PanelList:EnableVerticalScrollbar( true )
    self:ToBuildPanels()
end

function PANEL:ToBuildPanels()
    self.PanelList:Clear()
    local categories = {}

    for _, tab in ipairs( Ambi.Homeway.Config.props )  do
        if not categories[ tab.category ] then categories[ tab.category ] = {} end

        categories[ tab.category ][ #categories[ tab.category ] + 1 ] = tab.model
    end

    for name, tab in SortedPairs( categories ) do
        local Category = vgui.Create("DCollapsibleCategory", self)
        self.PanelList:AddItem( Category )
        Category:SetExpanded( false )
        Category:SetLabel( '' )
        Category:SetCookieName("EntitySpawn." .. name)
        Category.Paint = function( self, w, h )
            Draw.Box( w, h, 0, 0, COLOR_PANEL, 8 )
            Draw.SimpleText( w / 2, 0, name, UI.SafeFont( '24 Montserrat Medium' ), C.WHITE, 'top-center', 1, C.BLACK )
        end

        local Content = vgui.Create( "DPanelList" )
        Category:SetContents( Content )
        Content:EnableHorizontal( true )
        Content:SetDrawBackground( false )
        Content:SetSpacing(2)
        Content:SetPadding(2)
        Content:SetAutoSize(true)
        local num = 1

        for k, v in ipairs( tab ) do
            local Icon = vgui.Create("SpawnIcon", self)
            local Model = v

            Icon:SetModel( Model )

            Icon.DoClick = function()
                RunConsoleCommand("gm_spawn", Model)
            end

            Icon.DoRightClick = function()
                SetClipboardText( Model )
            end

            local lable = vgui.Create( "DLabel", Icon )
            lable:SetFont( "DebugFixedSmall" )
            lable:SetTextColor( color_black )
            lable:SetText( Model )
            lable:SetContentAlignment( 5 )
            lable:SetWide( self:GetWide() )
            lable:AlignBottom( -42 )
            Content:AddItem( Icon )
            num = num + 1
        end
    end

    self.PanelList:InvalidateLayout()
end

function PANEL:PerformLayout()
    self.PanelList:StretchToParent( 0, 0, 0, 0 )
end

local CreationSheet = vgui.RegisterTable( PANEL, "Panel" )

local function CreateContentPanel()
    return vgui.CreateFromTable(CreationSheet) 
end
 
spawnmenu.AddCreationTab( 'Пропы', CreateContentPanel, "icon16/star.png", -99 )