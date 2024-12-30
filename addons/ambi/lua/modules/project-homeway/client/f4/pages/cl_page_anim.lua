Ambi.Homeway.anims = {
    { cmd = "act agree", header = 'Согласен', act = ACT_GMOD_GESTURE_AGREE },
    { cmd = "act wave", header = 'Поприветствовать', act = ACT_GMOD_GESTURE_WAVE },
    { cmd = "act becon", header = 'Позвать к себе', act = ACT_GMOD_GESTURE_BECON },
    { cmd = "act salute", header = 'Воинское Приветствие', act = ACT_GMOD_TAUNT_SALUTE },
    { cmd = "act bow", header = 'Уважение', act = ACT_GMOD_GESTURE_BOW },
    { cmd = "act cheer", header = 'Радоваться', act = ACT_GMOD_TAUNT_CHEER },
    { cmd = "act dance", header = 'Потанцевал', act = ACT_GMOD_TAUNT_DANCE },
    { cmd = "act disagree", header = 'Не согласен', act = ACT_GMOD_GESTURE_DISAGREE },
    { cmd = "act forward", header = 'Вперёд', act = ACT_GMOD_GESTURE_POINT },
    { cmd = "act group", header = 'Сгрупироваться', act = ACT_GMOD_GESTURE_ITEM_PLACE },
    { cmd = "act halt", header = 'Стоять', act = ACT_GMOD_GESTURE_MELEE_SHOVE_1HAND },
    { cmd = "act laugh", header = 'Смеяться', act = ACT_GMOD_TAUNT_LAUGH },
    { cmd = "act muscle", header = 'Эротишный танец', act = ACT_GMOD_TAUNT_MUSCLE },
    { cmd = "act pers", header = 'Лев', act = ACT_GMOD_TAUNT_PERSISTENCE },
    { cmd = "act robot", header = 'Робот', act = ACT_GMOD_TAUNT_ROBOT },
    { cmd = "act zombie", header = 'Зомби', act = ACT_GMOD_GESTURE_TAUNT_ZOMBIE },
}

local C, GUI, Draw, UI = Ambi.Packages.Out( '@d' )

local W, H = ScrW(), ScrH()
local COLOR_PANEL = Color( 0, 0, 0, 200 ) 

-- ---------------------------------------------------------------------------------------------------------------------------------------
function Ambi.Homeway.ShowPageAnimation( vguiMain )
    local main = vguiMain

    main.back:SetVisible( true )
    main:Clear()
    
    local panel = GUI.DrawScrollPanel( main, main:GetWide() * .4, main:GetTall(), main:GetWide() / 2 - (main:GetWide() * .4 / 2), 0, function( self, w, h )
        --Draw.Box( w, h, 0, 0, C.HOMEWAY_BLACK, 8 )
    end )

    local panel_list = GUI.DrawScrollPanel( panel, panel:GetWide(), panel:GetTall(), 0, 0, function( self, w, h ) 
        Draw.Box( w, h, 0, 0, C.HOMEWAY_BLUE_DARK, 8 )
    end )

    for i, anim in ipairs( Ambi.Homeway.anims ) do
        local item_panel = GUI.DrawPanel( panel_list, panel_list:GetWide() - 8, 36, 4, ( i - 1 ) * ( 36 + 4 ) + 4, function( self, w, h ) 
            Draw.Box( w, h, 0, 0, COLOR_PANEL, 8 )

            Draw.SimpleText( w / 2, h / 2, anim.header, UI.SafeFont( '32 Montserrat Medium' ), C.HOMEWAY_BLUE, 'center' )
        end )

        local act = GUI.DrawButton( item_panel, item_panel:GetWide(), item_panel:GetTall(), 0, 0, nil, nil, nil, function()
            LocalPlayer():ConCommand( 'say "/anim '..anim.act..'"' )

            Ambi.Homeway.RemoveF4Menu()
        end, function( self, w, h ) 
        end )
    end
end