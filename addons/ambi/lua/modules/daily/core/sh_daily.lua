Ambi.Daily.patterns = Ambi.Daily.patterns or {}
Ambi.Daily.dailies = Ambi.Daily.dailies or {}

-- ------------------------------------------------------------------------------------------------------------
function Ambi.Daily.AddPattern( sClass, tDaily )
    Ambi.Daily.patterns[ sClass ] = tDaily

    print( '[Daily] added pattern: '..sClass )
end

function Ambi.Daily.GetPattern( sClass )
    return Ambi.Daily.patterns[ sClass or '' ]
end

-- ------------------------------------------------------------------------------------------------------------
function Ambi.Daily.Get( nSlot )
    if not nSlot then return end

    return Ambi.Daily.dailies[ nSlot ]
end

-- ------------------------------------------------------------------------------------------------------------
function Ambi.Daily.HookAdd( tDaily, sEvent, sHook, fCallback )
    local id = tDaily.id

    sHook = sHook..'_'..id

    hook.Add( sEvent, sHook, fCallback )

    tDaily.hooks[ sEvent ] = sHook
end