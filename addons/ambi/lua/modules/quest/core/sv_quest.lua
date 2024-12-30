local Gen, C = Ambi.General, Ambi.General.Global.Colors
local ENTITY = FindMetaTable( 'Entity' )
local PLAYER = FindMetaTable( 'Player' )

-- ----------------------------------------------------------------------------------------------------------------------------
function ENTITY:AddQuestInfo( sClass, nStep, nCount )
    if not sClass or not nStep then Gen.Error( 'Quest', 'Unspecified sClass or nStep' ) return end

    self.nw_Quest = sClass
    self.nw_QuestStep = nStep
    self.nw_QuestCount = nCount or 1

    Gen.OnDebug( function() 
        MsgC( C.ABS_RED, '[DEBUG] ', C.ABS_WHITE, 'E:AddQuestInfo '..self:Name()..' ['..self:EntIndex()..']'..' [ Q:'..sClass..' S:'..nStep..' C:'..nCount..' ]\n' )
    end )
end

-- ----------------------------------------------------------------------------------------------------------------------------
function PLAYER:StartQuest( sClass, bForce )
    local quest = Ambi.Quest.Get( sClass )
    if not quest then return end
    if not quest.steps[ 1 ] then return end

    if not bForce then
        if self:GetFinishedQuest( sClass ) then return end

        if quest.from then  
            local finished = 0
            for _, class in ipairs( quest.from ) do
                if self:GetFinishedQuest( class ) then finished = finished + 1 break end
            end
            if ( finished < #quest.from ) then self:ChatPrint( 'Вам нужно пройти предыдущие квесты!' ) return end
        end

        if quest.Check and ( quest.Check( self ) == false ) then return end
    end

    self.nw_Quest = sClass
    self.nw_QuestStep = 1
    self.nw_QuestCount = 0

    Gen.OnDebug( function() 
        MsgC( C.ABS_RED, '[DEBUG] ', C.ABS_WHITE, 'P:StartQuest '..self:Name()..' ['..self:EntIndex()..']'..' [ Q:'..sClass..' FORCE:'..tostring( bForce )..' ]\n' )
    end )

    self:ChatSend( C.AMBI_GREEN, '[Quest]', C.ABS_WHITE, ' Вы начали проходить: ', C.AMBI_GREEN, quest.name )

    self:SaveQuestProgress()

    quest:OnStart( self )

    self:SetQuestStep( 1, sClass, true )
end

function PLAYER:EndQuest( sClass, nStatus )
    local quest = Ambi.Quest.Get( sClass )
    if not quest then return end

    if ( self:GetQuestClass() ~= sClass ) then return end

    nStatus = nStatus or 0

    if quest.give_reward_end and ( nStatus == 0 ) then quest:GiveReward( self ) end

    self:SaveQuestProgress( true )

    self.nw_Quest = false
    self.nw_QuestStep = false
    self.nw_QuestCount = false

    Gen.OnDebug( function() 
        MsgC( C.ABS_RED, '[DEBUG] ', C.ABS_WHITE, 'P:EndQuest '..self:Name()..' ['..self:EntIndex()..']'..' [ Q:'..sClass..' STATUS:'..tostring( nStatus )..' ]\n' )
    end )

    quest:OnEnd( self )

    self:ChatSend( C.AMBI_GREEN, '[Quest]', C.ABS_WHITE, ' Вы закончили проходить: ', C.AMBI_GREEN, quest.name )

    self:SendFinishedQuests()
end

function PLAYER:AddQuestCount( nCount, sQuest, nStep )
    local quest = self:GetQuest()
    if not quest then return end
    if sQuest and ( self:GetQuestClass() ~= sQuest ) then return end
    if nStep and ( self:GetQuestStep() < nStep ) then return end

    self.nw_QuestCount = self.nw_QuestCount + ( nCount or 1 )
    if ( self.nw_QuestCount < 0 ) then self.nw_QuestCount = 0 end

    Gen.OnDebug( function() 
        MsgC( C.ABS_RED, '[DEBUG] ', C.ABS_WHITE, 'P:AddQuestCount '..self:Name()..' ['..self:EntIndex()..']'..' [ Q:'..quest.class..' S:'..self.nw_QuestStep..' C:'..nCount..' ]\n' )
    end )

    self:SaveQuestProgress()

    if ( self:GetQuestCount() >= self:GetQuestStepInfo().count ) then
        self:SetQuestStep()
    end
end

function PLAYER:SetQuestStep( nStep, sQuest )
    local quest = self:GetQuest()
    if not quest then return end
    if sQuest and ( self:GetQuestClass() ~= sQuest ) then return end

    nStep = nStep or ( self.nw_QuestStep + 1 )

    self.nw_QuestCount = 0
    self.nw_QuestStep = nStep

    Gen.OnDebug( function() 
        MsgC( C.ABS_RED, '[DEBUG] ', C.ABS_WHITE, 'P:SetQuestStep '..self:Name()..' ['..self:EntIndex()..']'..' [ Q:'..quest.class..' S:'..nStep..' C:'..self.nw_QuestCount..' ]\n' )
    end )

    self:SaveQuestProgress()

    if ( nStep > #self:GetQuest().steps ) then
        return self:EndQuest( self:GetQuestClass() )
    end

    self:GetQuestStepInfo().OnStart( self, self:GetQuestStepInfo() )
    if ( self:GetQuestStepInfo().Check( self ) == true ) then self:SetQuestStep( nStep + 1, sQuest ) end
end

-- ----------------------------------------------------------------------------------------------------------------------------
net.AddString( 'ambi_quest_start_quest' )
net.Receive( 'ambi_quest_start_quest', function( _, ePly ) 
    if ePly:GetQuest() then return end

    local class = net.ReadString()
    if not Ambi.Quest.Get( class ) then return end
    if ePly:GetFinishedQuest( class ) then return end

    ePly:StartQuest( class )
end )