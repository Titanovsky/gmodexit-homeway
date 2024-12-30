local current_map = game.GetMap()
local delay_check_props_on_chunks = 1

-- Концепция PropsInTable нужна, чтобы не все ентити искать, а только те, которые представляют внимание

Ambi.Territory.table_props = Ambi.Territory.table_props or {}

hook.Add( 'PlayerSpawnedProp', 'Ambi.Territory.AddPropsInTable', function( ePly, _, eProp )
    local chunk_type = Ambi.Territory.GetChunkType( eProp )

    if eProp.prop then
        Ambi.Territory.table_props[ eProp:EntIndex() ] = eProp.prop
    else
        Ambi.Territory.table_props[ eProp:EntIndex() ] = eProp
    end
end )

hook.Add( 'EntityRemoved', 'Ambi.Territory.RemovePropsInTable', function( eObj )
    if not Ambi.Territory.Config.removed_classes[ eObj:GetClass() ] then return end

    local ID = eObj:EntIndex()
    if not Ambi.Territory.table_props[ ID ] then return end

    Ambi.Territory.table_props[ ID ] = nil
end )

------------------------------------------------------------------------------------------------------------------

local delay = 0
hook.Add( 'Think', 'Ambi.Territory.CheckPropsOnChunks', function()
    if ( delay > CurTime() ) then return end

    delay = CurTime() + delay_check_props_on_chunks
    
    for _, prop in ipairs( ents.GetAll() ) do
        if not Ambi.Territory.Config.removed_classes[ prop:GetClass() ] then continue end
        if not IsValid( prop ) then continue end

        local chunk_type = Ambi.Territory.GetChunkType( prop )
        if chunk_type and ( chunk_type == 'safe' ) or ( chunk_type == 'noprop' ) then 
            local owner = prop:CPPIGetOwner()
            if IsValid( owner ) and owner:IsPlayer() and not owner:IsSuperAdmin() then
                owner:Notify( 'Нельзя сотворить здесь!', 4, NOTIFY_ERROR )
        

                prop:Remove()

                return
            end 
        end
    end
end )

hook.Add( 'EntityTakeDamage', 'Ambi.Territory.SafeZones', function( eObj, dmgInfo )
    if not IsValid( eObj ) or not eObj:IsPlayer() then return end

    if ( Ambi.Territory.GetChunkType( eObj ) == 'safe' ) then dmgInfo:SetDamage( 0 ) return false end
end )

hook.Add( 'CanTool', 'Ambi.Territory.SafeZonesBlockTools', function( ePly, _, sTool )
    if ( AMB.Territory.GetChunkType( ePly ) == 'safe' ) and not ePly:IsSuperAdmin() then return false end
end )