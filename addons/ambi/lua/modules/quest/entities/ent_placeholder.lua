local C, Ents = Ambi.General.Global.Colors, Ambi.RegEntity

local ENT = {}

ENT.Class       = 'quest_placeholder'
ENT.Type	    = 'anim'

ENT.PrintName	= 'Placeholder'
ENT.Author		= 'Ambi'
ENT.Category	= 'Quest'
ENT.Spawnable   = true

ENT.Stats = {
    type = 'Entity',
    model = 'models/hunter/plates/plate3x5.mdl',
    module = 'guide',
    date = '16.03.2021 21:36:39'
}

Ents.Register( ENT.Class, 'ents', ENT )

if CLIENT then
    ENT.RenderGroup = RENDERGROUP_BOTH

    function ENT:DrawTranslucent()
        Ents.Draw( self, false )
    end

    return Ents.Register( ENT.Class, 'ents', ENT )
end 

function ENT:Initialize()
    Ents.Initialize( self, self.Stats.model )
    Ents.Physics( self, MOVETYPE_NONE, SOLID_VPHYSICS, COLLISION_GROUP_WEAPON, false, false, false )
    self:SetTrigger( true )
end

function ENT:Touch( ePly )
    if not IsValid( ePly ) or not ePly:IsPlayer() then return end
    if not Ambi.Quest.GetPlayerQuest( ePly ) then return end

    local self_quest_id, self_quest_step, self_quest_count = Ambi.Quest.GetEntityQuestID( self ), Ambi.Quest.GetEntityQuestStep( self ), Ambi.Quest.GetEntityQuestCount( self )
    if not self_quest_id or ( self_quest_id <= 0 ) then return end
    if ( self_quest_id ~= Ambi.Quest.GetPlayerQuestID( ePly ) ) then return end
    if ( self_quest_step ~= Ambi.Quest.GetPlayerQuestStep( ePly ) ) then return end

    Ambi.Quest.AddCount( ePly, self_quest_count, self_quest_id, self_quest_step )
end

Ents.Register( ENT.Class, 'ents', ENT )