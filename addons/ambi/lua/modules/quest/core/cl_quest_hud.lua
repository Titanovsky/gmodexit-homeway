local C, GUI, Draw, UI = Ambi.Packages.Out( '@d' )
local w = ScrW()
local h = ScrH()

local COLOR_PANEL = Color( 0, 0, 0, 240 )

local cvar_enable = CreateClientConVar( 'ambi_quest_hud_enable', '1', true )

hook.Add( 'HUDPaint', 'Ambi.Quest.HUD', function()
    if not cvar_enable:GetBool() then return end

    local quest = LocalPlayer():GetQuest()
    if not quest then return end

    draw.RoundedBox( 4, 12, 12, 390, 40, COLOR_PANEL )
    draw.RoundedBoxEx( 4, 12, 12, 390, 12, C.HOMEWAY_BLUE, true, true )

    local step = LocalPlayer():GetQuestStep()

    local desc, player_quest_count = LocalPlayer():GetQuestStepInfo().description, LocalPlayer():GetQuestCount()
    draw.SimpleTextOutlined( desc, UI.SafeFont( '30 Montserrat Medium' ), 18, 24, C.ABS_WHITE, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, C.ABS_BLACK )

    local count = LocalPlayer():GetQuestStepInfo().count
    if ( count > 1 ) then 
        draw.SimpleTextOutlined( player_quest_count..'/'..count, UI.SafeFont( '20 Montserrat' ), 288, 24, C.ABS_WHITE, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP, 1, C.ABS_BLACK ) 
    end
end )