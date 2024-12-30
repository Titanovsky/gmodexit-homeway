function Ambi.Metz.GasCylinderInitialize( eObj )
    local self = eObj

    self.nw_amount = Ambi.Metz.Config.gas_amount
    self:SetHealth( Ambi.Metz.Config.gas_health )
    self:SetMaxHealth( Ambi.Metz.Config.gas_health )

	self:GetPhysicsObject():SetMass( 105 )
end

function Ambi.Metz.GasCylinderExplode( eObj )
    local self = eObj
    local size = Ambi.Metz.Config.gas_explosion_damage
    local pos = self:GetPos()

	local explosion = ents.Create( 'env_explosion' )
	explosion:SetPos( pos )
	explosion:SetKeyValue( 'iMagnitude', size )
	explosion:Spawn()
	explosion:Activate()
	explosion:Fire( 'Explode', 0, 0 )

	local shake = ents.Create( 'env_shake' )
	shake:SetPos( pos ) 
	shake:SetKeyValue( 'amplitude', ( size * 2 ) )
	shake:SetKeyValue( 'radius', size )
	shake:SetKeyValue( 'duration', '1.5' )
	shake:SetKeyValue( 'frequency', '255' )
	shake:SetKeyValue( 'spawnflags', '4' )
	shake:Spawn()
	shake:Activate()
	shake:Fire( 'StartShake', '', 0 )
end

function Ambi.Metz.GasCylinderTakeDamage( eObj, dmgInfo )
    if not Ambi.Metz.Config.gas_can_take_damage then return end

    local self = eObj

    self:SetHealth( self:Health() - dmgInfo:GetDamage() )

    if ( self:Health() <= 0 ) then 
        if Ambi.Metz.Config.gas_explode_after_destruction then Ambi.Metz.GasCylinderExplode( self ) end

        self:Remove()
    end
end

function Ambi.Metz.GasCylinderStartTouch( eObj, eStove )
    local self = eObj

    if IsValid( eStove ) and ( eStove:GetClass() == 'metz_stove' ) then
        local max = eStove.nw_gasStorageMax -- 200
        local storage = eStove.nw_gasStorage -- 199
        local amount = self.nw_amount -- 2
        if ( storage >= max ) then return end

        local new_storage = amount + storage -- 2 + 199 = 201
        local remains = new_storage - max -- 201 - 200 = 1

        if ( remains > 0 ) then
            eStove.nw_gasStorage = max
            eObj.nw_amount = remains
        else
            eStove.nw_gasStorage = new_storage
            eObj:Remove()
        end
    end
end