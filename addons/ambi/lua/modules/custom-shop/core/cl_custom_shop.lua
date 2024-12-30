function Ambi.CustomShop.Dress( sClass, eOwner )
    if not IsValid( eOwner ) then return end

    local clothes = Ambi.CustomShop.clothes[ sClass ]
    if not clothes then return end

    if Ambi.CustomShop.entities[ sClass..' '..eOwner:EntIndex() ] then
        local ent = Ambi.CustomShop.entities[ sClass..' '..eOwner:EntIndex() ].ent
        if IsValid( ent ) and not ( ent == NULL ) then ent:Remove() end
    end

    local obj = {}
    table.Merge( obj, clothes )

    obj.owner = eOwner

    obj.ent = ents.CreateClientside( 'customshop_clothes' )
    obj.ent:SetModel( obj.model )
    if obj.size then obj.ent:SetModelScale( obj.size ) end
    obj.ent:Spawn()
    obj.ent:SetPos( eOwner:GetPos() )

    if obj.Manipulate then obj.Manipulate = clothes.Manipulate end
    if obj.Spawn then obj.Spawn = clothes.Spawn end
    if obj.Remove then obj.Remove = clothes.Remove end

    if obj.Spawn then obj.Spawn( obj ) end

    Ambi.CustomShop.entities[ sClass..' '..eOwner:EntIndex() ] = obj
end

function Ambi.CustomShop.UnDress( sClass, eOwner )
    if not eOwner then return end

    sClass = sClass..' '..eOwner:EntIndex()

    local obj = Ambi.CustomShop.entities[ sClass ]
    if not obj then return end

    if obj.Remove then obj.Remove( obj ) end
    if IsValid( obj.ent ) then obj.ent:Remove() end

    Ambi.CustomShop.entities[ sClass ] = nil
end

net.Receive( 'ambi_customshop_dress_entities', function() 
    local class = net.ReadString()
    local owner = net.ReadEntity()

    Ambi.CustomShop.Dress( class, owner )
end )

net.Receive( 'ambi_customshop_undress_entities', function() 
    Ambi.CustomShop.UnDress( net.ReadString(), net.ReadEntity() )
end )

-- --------------------------------------------------------------------------------------------------------------------------------------------------------
local POS_DEFAULT, ANG_DEFAULT = Vector( 0, 0, 0 ), Angle( 0, 0, 0 )

hook.Add( 'Think', 'Ambi.CustomShop.ShowClothes', function() 
    for class, obj in pairs( Ambi.CustomShop.entities ) do
        local owner = obj.owner
        if not IsValid( owner ) or ( owner == NULL ) then Ambi.CustomShop.UnDress( class ) continue end

        local ent = obj.ent
        if not IsValid( ent ) then Ambi.CustomShop.UnDress( class ) continue end

        ent.RenderOverride = function( self )
            if ( owner == LocalPlayer() ) and ( GetViewEntity() == LocalPlayer() ) or ( owner:IsPlayer() and not owner:Alive() ) then return end
            if ( GetViewEntity() == LocalPlayer() and not LocalPlayer():CheckDistance( ent, 1600 ) ) then return end
            
            self:DrawModel()
        end

        local bone = obj.bone
        if bone then
            local bone_id = owner:LookupBone( bone )
            if not bone_id then continue end

            local pos, ang = owner:GetBonePosition( bone_id )
            if obj.Manipulate then 
                local new_pos, new_ang = obj.Manipulate( obj, pos, ang ) 
                if new_pos then pos = new_pos end
                if new_ang then ang = new_ang end
            end

            ent:SetPos( pos )
            ent:SetAngles( ang )
        else
            local pos, ang = POS_DEFAULT, ANG_DEFAULT
            if obj.Manipulate then 
                local new_pos, new_ang = obj.Manipulate( obj, pos, ang ) 
                if new_pos then pos = new_pos end
                if new_ang then ang = new_ang end
            end

            ent:SetPos( pos )
            ent:SetAngles( ang )
        end
    end
end )

hook.Add( 'CreateClientsideRagdoll', 'Ambi.CustomShop.ChangeClothesFromOwnerToRagdoll', function( eOwner, eRagdoll ) 
    for class, obj in pairs( Ambi.CustomShop.entities ) do
        if eOwner:IsPlayer() and ( obj.owner == eOwner and IsValid( eRagdoll ) ) then Ambi.CustomShop.Dress( string.Explode( ' ', class )[ 1 ], eRagdoll ) end
    end
end )

hook.Add( 'EntityRemoved', 'Ambi.CustomShop.SendEntities', function( eObj ) 
    for class, obj in pairs( Ambi.CustomShop.entities ) do
        if ( obj.owner == eObj ) then Ambi.CustomShop.UnDress( string.Explode( ' ', class )[ 1 ], eObj ) end
    end
end )