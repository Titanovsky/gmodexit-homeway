local A = Ambi.General

function Ambi.Statistic.Survey.Add( nID, sName, sQuestion, tAnswers )
    if not nID or not isnumber( nID ) then A.Error( 'Statistic.Survey', 'nID is not selected or it type is not number' ) return false end
    if not tAnswers or not istable( tAnswers ) then A.Error( 'Statistic.Survey', 'tAnswers is not selected or it type is not table' ) return false end

    local CFG = Ambi.Statistic.Config

    if not sName or ( sName == '' ) then 
    
        A.Warning( 'Statistic.Survey', 'sName is not selected! Selected default name' ) 
        sName = CFG.survey_default_name
        
    end
    if not sQuestion or ( sQuestion == '' ) then 
        A.Warning( 'Statistic.Survey', 'sQuestion is not selected! Selected default question' ) 
        sQuestion = CFG.survey_default_question
    end
    if Ambi.Statistic.Survey.table[ nID ] then A.Warning( 'Statistic.Survey', 'Survey with ID '..nID..' rewrite' ) end

    Ambi.Statistic.Survey.table[ nID ] = {
        name = sName,
        question = sQuestion,
        answers = tAnswers
    }

    return true
end

function Ambi.Statistic.Survey.Get( nID )
    if not nID or not isnumber( nID ) then A.Error( 'Statistic.Survey', 'nID is not selected or it type is not number' ) return false end

    return Ambi.Statistic.Survey.table[ nID ]
end