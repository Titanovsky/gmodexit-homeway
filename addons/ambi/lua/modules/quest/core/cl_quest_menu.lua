local C, GUI, Draw, UI = Ambi.Packages.Out( '@d' )

local w = ScrW()
local h = ScrH()

local COLOR_PANEL = Color( 0, 0, 0, 240 )
local COLOR_QUEST = Color( 20, 0, 100, 100 )

Ambi.Quest.finished_quests = Ambi.Quest.finished_quests or {}

function Ambi.Quest.OpenMenu()
    local quests = Ambi.Quest.quests

    local frame = GUI.DrawFrame( nil, 340, 290, 0, 0, nil, true, true, true, function( self, w, h ) 
        draw.RoundedBox( 0, 0, 0, w, h, COLOR_PANEL )
    end )
    frame:Center()

    local i = 0
    for class, quest in SortedPairsByMemberValue( quests, 'order' ) do
        local name = quest.name
        local name_size = Ambi.UI.Draw.GetTextSizeX( UI.SafeFont( '20 Ambi' ), quest.name )

        local panel = GUI.DrawPanel( frame, name_size + 10, 32, 4, 4 + ( 32 + 4 ) * i, function( self, w, h ) 
            draw.RoundedBox( 0, 0, 0, w, h, COLOR_QUEST )
            draw.SimpleText( name, UI.SafeFont( '20 Ambi' ), 4, h / 2, C.ABS_WHITE, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
        end )

        local ready = Ambi.Quest.finished_quests[ class ]
        local name, color, font = ready and 'Пройден' or 'Взять', ready and C.AMBI or C.AMBI_GREEN, UI.SafeFont( '16 Ambi' )
        local text_size_x = Ambi.UI.Draw.GetTextSizeX( font, name )
        local take = GUI.DrawButton( frame, text_size_x + 6, 32, 4 + panel:GetWide() + 4, 4 + ( 32 + 4 ) * i, nil, nil, nil, function()
            if LocalPlayer():GetQuest() then surface.PlaySound( 'buttons/button8.wav' ) return end
            if not LocalPlayer():Alive() then surface.PlaySound( 'buttons/button8.wav' ) return end
            if ready then surface.PlaySound( 'buttons/button8.wav' ) return end

            net.Start( 'ambi_quest_start_quest' )
                net.WriteString( class )
            net.SendToServer()

            frame:Remove()
        end, function( self, w, h ) 
            draw.RoundedBox( 4, 0, 0, w, h, color )
            draw.SimpleTextOutlined( name, font, w / 2, h / 2, C.ABS_WHITE, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, C.ABS_BLACK )
        end )

        i = i + 1
    end
end

net.Receive( 'ambi_quest_receive_finished', function() 
    table.Merge( Ambi.Quest.finished_quests, net.ReadTable() or {} )
end )