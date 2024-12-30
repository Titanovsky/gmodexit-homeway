Ambi.Inv.items = Ambi.Inv.items or {}

local Gen, CL = Ambi.Packages.Out( 'general, ContentLoader' )

local DEFAULT_NAME = ''
local DEFAULT_DESCRIPTION = ''
local DEFAULT_CATEGORY = 'Other'
local DEFAULT_DROP = function() return true end

local structure_activity = {
    cut = {
        name = 'Срезать',
        description = 'Срезать кожу',
        Action = function() end,
    },

    eat = { 
        name = 'Съесть',
        description = 'Выполнить действие: скушать что-то',
        Action = function() end,
    }
}

-- ----------------------------------------------------------------------------------------------------------------------------
if CLIENT then
    CL.CreateDir( 'inv' )
end

-- ----------------------------------------------------------------------------------------------------------------------------
function Ambi.Inv.AddItem( sClass, sName, nStack, sCategory, sDescription, sIcon, fUse, fDrop, tActivity )
    if not sClass or not isstring( sClass ) then Gen.Error( 'Inv', 'sClass is not valid or has not string type' ) return end

    sName = sName or DEFAULT_NAME
    sCategory = sCategory or DEFAULT_CATEGORY
    sDescription = sDescription or DEFAULT_DESCRIPTION
    nStack = nStack or Ambi.Inv.Config.stack
    tActivity = tActivity
    fUse = fUse
    fDrop = fDrop or DEFAULT_DROP

    Ambi.Inv.items[ sClass ] = {
        name = sName,
        category = sCategory,
        description = sDescription,
        icon = sIcon,
        stack = nStack,
        activity = tActivity,
        Use = fUse,
        Drop = fDrop, -- can drop
    }

    if CLIENT and sIcon and string.StartsWith( sIcon, 'http' ) then
        CL.DownloadMaterial( 'inv_'..sClass, 'inv/'..sClass..'.png', sIcon )
    end

    Ambi.Inv.Log( 'Добавлен класс предметов: ('..sClass..') ['..sName..', '..nStack..', '..sCategory..']' )

    hook.Call( '[Ambi.Inv.AddedItem]', nil, sClass, Ambi.Inv.items[ sClass ] )
end

function Ambi.Inv.RemoveItem( sClass )
    if not sClass then return end --todo error

    Ambi.Inv.items[ sClass ] = nil

    Ambi.Inv.Log( 'Удалён класс предметов: '..sName..' ('..sClass..')' )

    hook.Call( '[Ambi.Inv.RemovedItem]', nil, sClass )
end

function Ambi.Inv.GetItem( sClass )
    return Ambi.Inv.items[ sClass or '' ]
end