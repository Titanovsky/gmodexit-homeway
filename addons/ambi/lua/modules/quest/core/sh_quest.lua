local Gen = Ambi.General
local ENTITY = FindMetaTable( 'Entity' )

Ambi.Quest.quests = Ambi.Quest.quests or {}

-- ----------------------------------------------------------------------------------------------------------------------------
local MetaQuest = {
    class = 'quest_class',
    name = 'Unknow',
    description = '',
    reward_description = '',
    GiveReward = function( ePly ) end,
    order = 100,

    from = {},
    chain = 'Базовые',
    give_reward_end = true,

    OnStart = function( ePly ) end,
    OnEnd = function( ePly ) end,
    Check = function( ePly ) return true end,
}

MetaQuest.SetFrom = function( self, tTable )
    self.from = tTable or {}

    return self
end

MetaQuest.SetOrder = function( self, nOrder )
    self.order = nOrder or 100

    return self
end

MetaQuest.AddStep = function( self, nID, sDescription, sType, nCount, fStart, fRetry, fCheck )
    if not nID or ( nID == 0 ) then Gen.Error( 'Quest.AddStep', 'ID is not valid' ) return end
    if ( nID ~= 1 ) and not self.steps[ nID - 1 ] then Gen.Error( 'Quest.AddStep', 'Steps should be in order' ) return end

    self.steps[ nID ] = {
        description = sDescription or '',
        type = sType or 'none',
        count = nCount or 1,
        OnStart = fStart or function() end,
        OnRetry = fRetry or function() end,
        Check = fCheck or function() return false end,
    }

    print( '[Quest] Added Step '..nID..' for '..self.name..' ('..self.class..')'  )

    return self.steps[ nID ]
end

function Ambi.Quest.Create( sClass, sName, sDescription )
    if not sClass then return end

    local quest = {}
    quest.steps = {}
    quest.class = sClass
    quest.name = sName
    quest.description = sDescription

    quest = setmetatable( quest, { __index = MetaQuest } )
    
    Ambi.Quest.quests[ sClass ] = quest

    print( '[Quest] Created: '..sName..' ('..sClass..')'  )

    return quest 
end

function Ambi.Quest.Get( sClass )
    return Ambi.Quest.quests[ sClass ]
end

-- ----------------------------------------------------------------------------------------------------------------------------
function ENTITY:GetQuest()
    local quest = self.nw_Quest
    if not quest then return end

    return Ambi.Quest.quests[ quest ]
end

function ENTITY:GetQuestClass()
    return self.nw_Quest
end

function ENTITY:GetQuestStep()
    return self.nw_QuestStep
end

function ENTITY:GetQuestStepInfo()
    return self:GetQuest().steps[ self.nw_QuestStep ]
end

function ENTITY:GetQuestCount()
    return self.nw_QuestCount
end

function ENTITY:CheckQuest( sQuest, nStep )
    local quest, step = self:GetQuestClass(), self:GetQuestStep()
    
    return quest and ( quest == sQuest ) and ( step == nStep )
end