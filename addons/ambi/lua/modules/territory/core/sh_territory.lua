function Ambi.Territory.AddChunk( sChunk, sHeader, sType, sMap, vMin, vMax, cColor )
    Ambi.Territory.Config.chunks[ sChunk or '' ] = {
        map = sMap,
        header = sHeader or '',
        type = sType or '',
        min = vMin or Vector( 0, 0, 0 ),
        max = vMax or Vector( 0, 0, 0 ),
        color = cColor or Color( 0, 0, 0 )
    }
end

function Ambi.Territory.GetChunk( sName )
    return Ambi.Territory.Config.chunks[ sName ]
end

function Ambi.Territory.GetChunkName( eObj )
    local chunks = Ambi.Territory.Config.chunks

    for name, chunk in SortedPairs( chunks ) do
        if eObj:GetPos():WithinAABox( chunk.min + Vector( 0, 0, -2 ), chunk.max + Vector( 0, 0, 2 ) ) then return name end
    end
end

function Ambi.Territory.GetChunkType( eObj )
    local chunks = AMB.Territory.Config.chunks

    for name, chunk in SortedPairs( chunks ) do
        if eObj:GetPos():WithinAABox( chunk.min + Vector( 0, 0, -2 ), chunk.max + Vector( 0, 0, 2 ) ) then return chunk.type end
    end
end

-- Для Basewars ---------------------------------------------------------------------

--[[
function AMB.Territory.GetChunkCapter( eObj )
    local chunks = AMB.Territory.Config.chunks

    for name, chunk in SortedPairs( chunks ) do
        if eObj:GetPos():WithinAABox( chunk.mins + Vector( 0, 0, -2 ), chunk.maxs + Vector( 0, 0, 2 ) ) then return chunk.capter end
    end
end

function AMB.Territory.GetChunksCapter()
    local chunks = AMB.Territory.Config.chunks
    local ret = {}

    for name, chunk in SortedPairs( chunks ) do
        if ( chunk.type == 'capture' ) then 
            local count = #ret + 1
            ret[ count ] = chunk 
            ret.name = name
        end
    end

    return ret
end

function AMB.Territory.GetChunkOwner( eObj )
    local chunks = AMB.Territory.Config.chunks

    for name, chunk in SortedPairs( chunks ) do
        if eObj:GetPos():WithinAABox( chunk.mins + Vector( 0, 0, -2 ), chunk.maxs + Vector( 0, 0, 2 ) ) then return chunk.owner end
    end

    return false
end
]]--