local C = Ambi.Packages.Out( 'colors' )

-- ----------------------------------------------------------------------------------------------------------------------------
local function AddPostTime( nTime, ePly, fCallback )
    timer.Simple( nTime, function()
        if IsValid( ePly ) then fCallback() end
    end )
end

local function NPCQuestGiverTalk( ePly, nTime, sText )
    AddPostTime( nTime, ePly, function() 
        ePly:ChatSend( '~AMBI~ [Маркус] ~W~ '..sText ) 
        ePly:PlaySound( 'buttons/button1.wav' )
    end )
end

-- ----------------------------------------------------------------------------------------------------------------------------
local quest = Ambi.Quest.Create( 'q_guide1', 'Первые шаги на Homeway' )

quest:AddStep( 1, 'Знакомься с Homeway', 'chat', 1, function( ePly ) 
    ePly:PlaySound( 'ambi/homeway/quest1/3.ogg' )
    NPCQuestGiverTalk( ePly, 0, 'Окей, дружище, ты попал на ~HOMEWAY_BLUE~ Homeway ~W~ , самый лучший Role Play сервер в Garry\'s Mod. Где тонна интересных и увлекательных механик.' )

    AddPostTime( 10, ePly, function() 
        ePly:AddQuestCount( 1 )
    end )
end, function( ePly, tStep ) 
    tStep.OnStart( ePly ) 
end )

quest:AddStep( 2, 'Нажми F4', 'chat', 1, function( ePly ) 
    ePly:Notify( 'Задача для квеста справа сверху', 6 )
    ePly:ChatSend( '~AMBI_BLUE~ [Подсказка] ~W~ Введите ~AMBI_BLUE~ /discord' ) 
    ePly:ChatSend( '~AMBI_BLUE~ [Подсказка] ~W~ Чтобы узнать все команды, введите ~AMBI_BLUE~ /cmd'  ) 
    ePly:PlaySound( 'ambi/homeway/quest1/4.ogg' )

    NPCQuestGiverTalk( ePly, 0, 'Пора тебе самому в этом убедиться, открой F4.' )

end, function( ePly, tStep ) 
    tStep.OnStart( ePly ) 
end )

quest:AddStep( 3, 'Поговорить с Дэйвом', 'chat', 1, function( ePly ) 
    ePly:PlaySound( 'ambi/homeway/quest1/5.ogg' )

    NPCQuestGiverTalk( ePly, 0, 'Видишь, уже пипец как необычно, а теперь открой Навигацию и иди в Торговый Центр, и поговори с Дэйвом.' )
end, function( ePly, tStep ) 
    tStep.OnStart( ePly ) 
end )

quest:AddStep( 4, 'Введите /kit money', 'chat', 1, function( ePly ) 
    ePly:PlaySound( 'ambi/homeway/quest1/6.ogg' )

    NPCQuestGiverTalk( ePly, 0, 'Кхм.. Раньше у Дэйва был большой арсенал оружия, но и этого тоже хватит. Если не хочешь тратить деньги, то введи /kit money и получи сундук.' )
end, function( ePly, tStep ) 
    tStep.OnStart( ePly ) 
end )

quest:AddStep( 5, 'Зайти в инвентарь и открыть сундук', 'chat', 1, function( ePly ) 
    ePly:PlaySound( 'ambi/homeway/quest1/7.ogg' )

    NPCQuestGiverTalk( ePly, 0, 'Сундуки - это афигенные штуки, через которые ты случайно выбиваешь самые разные приколдесы, от денег и оружия до крафтовых профессии и премиумов. Зайди в инвентарь и открой сундук.' )
end, function( ePly, tStep ) 
    tStep.OnStart( ePly ) 
end )

quest:AddStep( 6, 'Сыграть в казино "4 Дракона"', 'chat', 1, function( ePly ) 
    ePly:PlaySound( 'ambi/homeway/quest1/8.ogg' )

    NPCQuestGiverTalk( ePly, 0, 'Мда.. Не везёт тебе, друг мой, тогда попробуй сыграть в казино "4 дракона", оно рядом с тобой.' )
end, function( ePly, tStep ) 
    tStep.OnStart( ePly ) 
end )

quest:AddStep( 7, 'Сделать оружие на заводе', 'chat', 1, function( ePly ) 
    ePly:RunCommand( 'stopsound' )
    ePly:AddMoney( 1500 )
    
    ePly:SetPos( Vector( 812, -1832, 127 ) )
    ePly:SetAngles( Angle( 10, 160, 0 ) )
    ePly:Notify( 'Сделай оружие на заводе', 6 )
    
    NPCQuestGiverTalk( ePly, 0, 'Сделай оружие на заводе.' )
end )

-- -- --------------------------------------------------------------------------------------------------------------
local REWARD_MONEY = 4000 -- Наградные Деньги

quest.GiveReward = function( self, ePly )
    ePly:Notify( REWARD_MONEY..'$', 20, 2 )
    ePly:AddMoney( REWARD_MONEY )

    ePly:ScreenFade( SCREENFADE.IN, Color( 255, 255, 255, 200), .75, 0 )
    ePly:PlaySound( 'ambi/other/complete_rank_up.mp3' )

    Ambi.Homeway.NotifyAll( ePly:Name()..' прошёл первый квест', 15 )
end 

-- -- -- ----------------------------------------------------------------------------------------------------------------------------
local class = quest.class

if CLIENT then 
    local obj
    net.Receive( 'ambi_homeway_quest1_render', function() 
        hook.Add( 'Think', 'Ambi.Homeway.RenderMarkus', function() 
            if obj then Ambi.UI.Render.Outline.Add( obj, C.AMBI, 1 ) return end

            for _, ent in ipairs( ents.GetAll() ) do
                if ( ent:GetClass() == 'npc_questgiver' ) then obj = ent break end
            end
        end )

        timer.Simple( 60 * 5, function() 
            hook.Remove( 'Think', 'Ambi.Homeway.RenderMarkus' )
        end )
    end )

    return 
end

net.AddString( 'ambi_homeway_quest1_render' )
net.AddString( 'ambi_homeway_quest1_accept', function( _, ePly ) 
    if ePly:GetFinishedQuest( 'q_guide1' ) then ePly:Kick( 'Подозрение в читерстве [Quest1]' ) return end

    ePly:StartQuest( 'q_guide1' )
end )

hook.Add( '[Ambi.Homeway.Auth]', 'Ambi.Homeway.ForFocusMarkusQuest1', function( ePly, bIsFirst ) 
    if not bIsFirst then return end
    
    net.Start( 'ambi_homeway_quest1_render' )
    net.Send( ePly )
end )

hook.Add( 'ShowSpare2', 'Ambi.Homeway.Quest1', function ( ePly ) 
    if ePly:CheckQuest( 'q_guide1', 2 ) then ePly:AddQuestCount( 1 ) return end
end )

hook.Add( 'PlayerUse', 'Ambi.Homeway.Quest1', function( ePly, eObj )
    if not IsValid( eObj ) then return end

    if ePly:CheckQuest( 'q_guide1', 3 ) and ( eObj:GetClass() == 'npc_gun_dealer' ) then ePly:AddQuestCount( 1 ) return end
end )

hook.Add( '[Ambi.ChatCommands.Executed]', 'Ambi.Homeway.Quest1', function( ePly, tCommand, sText ) 
    if ( sText == '/kit money' ) and ePly:CheckQuest( 'q_guide1', 4 ) then ePly:AddQuestCount( 1 ) return end
end )

hook.Add( '[Ambi.Homeway.OpenChest]', 'Ambi.Homeway.Quest1', function( ePly ) 
    if ePly:CheckQuest( 'q_guide1', 5 ) then ePly:AddQuestCount( 1 ) end
end )

hook.Add( '[Ambi.Homeway.CasinoFourDragon]', 'Ambi.Homeway.Quest1', function( ePly ) 
    if ePly:CheckQuest( 'q_guide1', 6 ) then ePly:AddQuestCount( 1 ) end
end )

hook.Add( '[Ambi.Homeway.FactoryPutWarehouse]', 'Ambi.Homeway.Quest1', function( ePly ) 
    if ePly:CheckQuest( 'q_guide1', 7 ) then ePly:AddQuestCount( 1 ) end
end ) --