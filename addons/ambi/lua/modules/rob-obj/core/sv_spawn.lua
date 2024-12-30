Ambi.RobObj.template = Ambi.RobObj.template or { npcs = {}, objs = {} }

-- ---------------------\------------------------------------------------------------------------------------------------------------------------
function Ambi.RobObj.SpawnNPCs()
    for i = 1, #Ambi.RobObj.Config.security.places do
        if Ambi.RobObj.template.npcs[ i ] and IsValid( Ambi.RobObj.template.npcs[ i ] ) then Ambi.RobObj.template.npcs[ i ]:Remove() end

        local npc = ents.Create( 'npc_combine_s' )
        npc:SetPos( Ambi.RobObj.Config.security.places[ i ].pos )
        npc:SetAngles( Ambi.RobObj.Config.security.places[ i ].ang )
        npc:SetKeyValue( 'spawnflags', '8192' )
        --npc:AddRelationship( 'player D_HT 99' )
        npc:Spawn()
        npc:SetHealth( math.random( Ambi.RobObj.Config.security.min_hp, Ambi.RobObj.Config.security.max_hp ) )
        npc:Give( table.Random( Ambi.RobObj.Config.security.guns ) )
        npc:SetModel( table.Random( Ambi.RobObj.Config.security.models ) )
        npc.rob_obj_security = true

        Ambi.RobObj.template.npcs[ i ] = npc
    end
end

function Ambi.RobObj.SpawnObjects()
    for i = 1, #Ambi.RobObj.Config.object.places do
        if Ambi.RobObj.template.objs[ i ] and IsValid( Ambi.RobObj.template.objs[ i ] ) then Ambi.RobObj.template.objs[ i ]:Remove() end

        local obj = ents.Create( Ambi.RobObj.Config.object.class )
        obj:SetPos( Ambi.RobObj.Config.object.places[ i ].pos )
        obj:SetAngles( Ambi.RobObj.Config.object.places[ i ].ang )
        obj:Spawn()
        obj.rob_obj = true
        
        Ambi.RobObj.template.objs[ i ] = obj
    end
end

function Ambi.RobObj.GarbageCollector()
    for _, npc in ipairs( Ambi.RobObj.template.npcs ) do
        if IsValid( npc ) then npc:Remove() end
    end

    for _, obj in ipairs( Ambi.RobObj.template.objs ) do
        if IsValid( obj ) then obj:Remove() end
    end

    Ambi.RobObj.template = { npcs = {}, objs = {} }
end

-- ---------------------\------------------------------------------------------------------------------------------------------------------------
hook.Add( 'EntityTakeDamage', 'Ambi.RobObj.SecurityDamage', function( victim, dmginfo )
    local attacker = dmginfo:GetAttacker()
    if not IsValid( attacker ) or not attacker.rob_obj_security then return end

    if victim:IsNPC() and victim.rob_obj_security then dmginfo:SetDamage( 0 ) end -- if security npc attacked another security npc

    dmginfo:SetDamage( dmginfo:GetDamage() * Ambi.RobObj.Config.security.dmg )
end )
