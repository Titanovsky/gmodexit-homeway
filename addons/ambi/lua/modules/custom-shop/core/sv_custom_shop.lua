local ENTITY = FindMetaTable( 'Entity' )

-- --------------------------------------------------------------------------------------------------------------------------------------------------------
net.AddString( 'ambi_customshop_dress_entities' )
net.AddString( 'ambi_customshop_undress_entities' )

-- --------------------------------------------------------------------------------------------------------------------------------------------------------
function ENTITY:Dress( sClass )
    if not sClass then return end

    local obj = Ambi.CustomShop.entities[ sClass..' '..self:EntIndex() ]
    --if obj then self:UnDress( sClass ) end

    local clothes = Ambi.CustomShop.clothes[ sClass ]
    if not clothes then return end

    local obj = {}
    table.Merge( obj, clothes )
    obj.owner = self

    Ambi.CustomShop.entities[ sClass..' '..self:EntIndex() ] = obj

    for i, v in pairs( obj ) do
        if isfunction( v ) then Ambi.CustomShop.entities[ sClass..' '..self:EntIndex() ][ i ] = nil end
    end

    net.Start( 'ambi_customshop_dress_entities' )
        net.WriteString( sClass )
        net.WriteEntity( self )
    net.Broadcast()

    hook.Call( '[Ambi.CustomShop.PlayerDress]', nil, sClass, obj )
end

function ENTITY:UnDress( sClass )
    local personal_class = sClass..' '..self:EntIndex()
    if not Ambi.CustomShop.entities[ personal_class ] then return end

    Ambi.CustomShop.entities[ personal_class ] = nil

    net.Start( 'ambi_customshop_undress_entities' )
        net.WriteString( sClass )
        net.WriteEntity( self )
    net.Broadcast()

    hook.Call( '[Ambi.CustomShop.PlayerUnDress]', nil, sClass, obj )
end

-- --------------------------------------------------------------------------------------------------------------------------------------------------------
hook.Add( 'PlayerInitialSpawn', 'Ambi.CustomShop.SendEntities', function( ePly ) 
    timer.Simple( 1, function()
        if not IsValid( ePly ) then return end
        
        for class, obj in pairs( Ambi.CustomShop.entities ) do
            net.Start( 'ambi_customshop_dress_entities' )
                net.WriteString( string.Explode( ' ', class )[ 1 ] )
                net.WriteEntity( obj.owner )
            net.Send( ePly )
        end
    end )
end )

hook.Add( 'EntityRemoved', 'Ambi.CustomShop.SendEntities', function( eObj ) 
    for class, obj in pairs( Ambi.CustomShop.entities ) do
        if ( obj.owner == eObj ) then eObj:UnDress( string.Explode( ' ', class )[ 1 ] ) end
    end
end )

hook.Add( 'PlayerDisconnected', 'Ambi.CustomShop.SendEntities', function( ePly ) 
    for class, obj in pairs( Ambi.CustomShop.entities ) do
        if ( obj.owner == ePly ) then ePly:UnDress( string.Explode( ' ', class )[ 1 ] ) end
    end
end )

hook.Add( 'CreateEntityRagdoll', 'Ambi.CustomShop.SetClothFromEntityToRagdoll', function( eOwner, eRagdoll ) 
    if not eOwner:IsPlayer() then return end

    for class, obj in pairs( Ambi.CustomShop.entities ) do
        if ( obj.owner == eOwner and IsValid( eRagdoll ) ) then eRagdoll:Dress( string.Explode( ' ', class )[ 1 ] ) end
    end
end )