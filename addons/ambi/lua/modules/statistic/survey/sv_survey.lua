local CFG = Ambi.Statistic.Config

local db = Ambi.SQL.CreateTable( CFG.survey_db, 'SteamID TEXT, Name TEXT, SurveyID NUMBER, AnswerID NUMBER, Date NUMBER' )

local function SelectDB( sKey, ePly )
    return Ambi.SQL.Select( db, sKey, 'SteamID', ePly:SteamID() )
end 

function Ambi.Statistic.Survey.CanAnswer( ePly, nID )
    return not tobool( sql.Query( 'SELECT * FROM '..CFG.survey_db..' WHERE SurveyID = '..sql.SQLStr( nID )..' AND SteamID = '..sql.SQLStr( ePly:SteamID() ) ) )
end

function Ambi.Statistic.Survey.CallQuestion( ePly, nID )
    if not Ambi.Statistic.Survey.CanAnswer( ePly, nID ) then return end

    ePly.survey_ready = true
    ePly:SendLua( 'Ambi.Statistic.Survey.CallQuestion('..nID..')' )
end

function Ambi.Statistic.Survey.GiveAnswer( ePly, nID, nAnswerID )
    if not Ambi.Statistic.Survey.CanAnswer( ePly, nID ) then return end

    local Action = Ambi.Statistic.Survey.Get( nID ).answers[ nAnswerID ].Action
    if Action then Action( ePly, nID, nAnswerID ) end

    local ID = ePly:SteamID()
    local Name = ePly:Nick()
    local Date = os.time()

    Ambi.SQL.Insert( db, 'SteamID, Name, SurveyID, AnswerID, Date', '%s, %s, %i, %i, %i', ID, Name, nID, nAnswerID, Date )

    hook.Call( '[Ambi.Statistic.Survey.GaveAnswer]', nil, ePly, nID, nAnswerID, Ambi.Statistic.Survey.Get( nID ) )
end

function Ambi.Statistic.Survey.GetFreeQuestions( ePly )
    local tab = {}

    for id, v in ipairs( Ambi.Statistic.Survey.table ) do
        if not Ambi.Statistic.Survey.CanAnswer( ePly, id ) then continue end

        tab[ #tab + 1 ] = id
    end

    if ( #tab == 0 ) then return end

    return tab
end

local net_ready_answer = net.AddString( 'amb_statistic_survey_ready_answer' )
net.Receive( net_ready_answer, function( nLen, ePly ) 
    if ( ePly.survey_ready == false ) then ePly:Kick( 'Подозрение в Читерстве: #A0101' ) return end

    ePly.survey_ready = false

    local id_question = net.ReadUInt( 8 )
    if not id_question or not Ambi.Statistic.Survey.Get( id_question ) then return end
    if not Ambi.Statistic.Survey.CanAnswer( ePly, id_question ) then return end

    local id_answer = net.ReadUInt( 4 )
    if not id_answer or not Ambi.Statistic.Survey.Get( id_question ).answers[ id_answer ] then return end

    Ambi.Statistic.Survey.GiveAnswer( ePly, id_question, id_answer )
end )