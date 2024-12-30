local Gen, C = Ambi.General, Ambi.General.Global.Colors
local Files, Folders, JSON = Ambi.Files, Ambi.Files.Folders, Ambi.Files.JSON
local PLAYER = FindMetaTable( 'Player' )

-- ----------------------------------------------------------------------------------------------------------------------------
Folders.Create( 'quest', true )

-- ----------------------------------------------------------------------------------------------------------------------------
function PLAYER:SaveQuestProgress( bFinished )
    if not self:GetQuest() then return end

    local class, step, count = self:GetQuestClass(), self:GetQuestStep(), self:GetQuestCount()

    local path = 'ambi/quest/'..self:SteamID64()..'.json'
    if not file.Exists( path, 'DATA' ) then file.Write( path, '[]' ) end

    local tab = JSON.Out( file.Read( path, 'DATA' ) )
    if not tab then tab = {} end

    if not tab.progress then tab.progress = {} end
    if not tab.finished then tab.finished = {} end

    if bFinished then
        tab.progress[ class ] = nil

        tab.finished[ class ] = true
        self.finished_quests[ class ] = true

        self:SendFinishedQuests()
    else
        tab.progress[ class ] = { step = step, count = count, time = os.time() }
    end

    if not tab.progress then tab.progress = {} end
    if not tab.finished then tab.finished = {} end

    local str = JSON.In( tab )
    file.Write( path, str )
end

function PLAYER:RemoveQuestProgress()
    if not self:GetQuest() then return end

    local class = self:GetQuestClass()

    local path = 'ambi/quest/'..self:SteamID64()..'.json'
    if not file.Exists( path, 'DATA' ) then file.Write( path, '[]' ) end

    local tab = JSON.Out( file.Read( path, 'DATA' ) )
    if not tab then return end

    if not tab.progress then tab.progress = {} end
    if not tab.finished then tab.finished = {} end

    tab.progress[ class ] = nil

    if not tab.progress then tab.progress = {} end
    if not tab.finished then tab.finished = {} end

    local str = JSON.In( tab )
    file.Write( path, str )

    self.nw_Quest = false -- Обычный P:EndQuest() нельзя
    self.nw_QuestStep = false
    self.nw_QuestCount = false
end

function PLAYER:ClearFinishedQuest( sClass )
    if not sClass then return end

    local path = 'ambi/quest/'..self:SteamID64()..'.json'
    if not file.Exists( path, 'DATA' ) then file.Write( path, '[]' ) end

    local tab = JSON.Out( file.Read( path, 'DATA' ) )
    if not tab then return end

    if not tab.progress then tab.progress = {} end
    if not tab.finished then tab.finished = {} end

    tab.finished[ sClass ] = nil
    
    if not tab.progress then tab.progress = {} end
    if not tab.finished then tab.finished = {} end

    local str = JSON.In( tab )
    file.Write( path, str )

    self.finished_quests[ sClass ] = nil
    self:SendFinishedQuests()
end

function PLAYER:SendFinishedQuests()
    net.Start( 'ambi_quest_receive_finished' )
        net.WriteTable( self.finished_quests )
    net.Send( self )
end

function PLAYER:GetFinishedQuest( sClass )
    if not self.finished_quests then return false end

    return self.finished_quests[ sClass ]
end

-- ----------------------------------------------------------------------------------------------------------------------------
net.AddString( 'ambi_quest_receive_finished' )

-- ----------------------------------------------------------------------------------------------------------------------------
hook.Add( 'PlayerInitialSpawn', 'Ambi.Quest.SetProgressAndFinishedQuests', function( ePly ) 
    timer.Simple( 1, function() -- workaround
        if not IsValid( ePly ) then return end

        ePly.finished_quests = {}

        local path = 'ambi/quest/'..ePly:SteamID64()..'.json'
        if not file.Exists( path, 'DATA' ) then return end

        local tab = JSON.Out( file.Read( path, 'DATA' ) )
        if not tab then return end

        if tab.finished then
            ePly.finished_quests = tab.finished
            ePly:SendFinishedQuests()
        end

        if tab.progress then  
            for class, progress in pairs( tab.progress ) do
                local quest = Ambi.Quest.Get( class )
                if not quest then continue end

                ePly.nw_Quest = class
                ePly.nw_QuestStep = progress.step
                ePly.nw_QuestCount = progress.count

                local step = ePly:GetQuestStepInfo()
                if not step then 
                    ePly:EndQuest( class, 1 )
                    ePly:ChatSend( C.AMBI_GREEN, '[Quest]', C.ABS_WHITE, 'Ваш квест поломан! Обратитесь к администратору' )

                    return 
                end

                ePly:ChatSend( C.AMBI_GREEN, '[Quest]', C.ABS_WHITE, ' Вы продолжаете квест ', C.AMBI_GREEN, quest.name )

                if step.OnRetry then
                    step.OnRetry( ePly, step )
                end
            end
        end
    end )
end )