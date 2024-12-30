local START_POS = Vector( 0, 0, 32 )

function Ambi.Metz.StoveInitialize( eObj )
    local self = eObj

    self:SetHealth( Ambi.Metz.Config.stove_health )
    self:SetMaxHealth( Ambi.Metz.Config.stove_health_max )

    --self.nw_distance = Ambi.Metz.Config.draw_distance

	self.nw_stoveConsumption = Ambi.Metz.Config.stove_consumption
	self.nw_stoveHeat = Ambi.Metz.Config.stove_heat

    self.nw_gasStorage = Ambi.Metz.Config.stove_gas_storage
    self.nw_gasStorageMax = Ambi.Metz.Config.stove_gas_storage_max

    for i = 1, 4 do
        self[ 'nw_firePlace'..i ] = false
    end

	self:SetPos( self:GetPos() + START_POS )

	if Ambi.Metz.Config.stove_can_gravity_gun then
		self:GetPhysicsObject():SetMass( 105 )
	end
end

function Ambi.Metz.StoveTakeDamage( eObj, dmgInfo )
    if not Ambi.Metz.Config.stove_can_take_damage then return end

    local self = eObj

    self:SetHealth( self:Health() - dmgInfo:GetDamage() )

    if ( self:Health() <= 0 ) then 
        if Ambi.Metz.Config.stove_explode_after_destruction then Ambi.Metz.StoveExplode( self ) end

        self:Remove()
    end
end

function Ambi.Metz.StoveExplode( eObj )
    local self = eObj
    local size = Ambi.Metz.Config.stove_explosion_damage
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

local STRUCTURES = {
    [ 'metz_phosphor_pot' ] = function( eObj ) return ( eObj:GetSulfur() > 0 and eObj:GetMacid() > 0 ) end,
    [ 'metz_final_pot' ] = function( eObj ) return ( eObj:GetRedPhosphor() > 0 and eObj:GetCrystalIodine() > 0 ) end,
}

local function CheckStructure( sClass, eObj )
    local Action = STRUCTURES[ sClass ]
    if not Action then return end

    return Action( eObj )
end

local function ActionCheckFire( eObj, nNum, tTraceFire, nGasStorage, nGasStorageMax )
    local self = eObj
    local ent = tTraceFire.Entity

    if not IsValid( ent ) then self[ 'nw_firePlace'..nNum ] = false return end
    if ent.GetStatus and ent:GetStatus() then self[ 'nw_firePlace'..nNum ] = false return end

    local class = ent:GetClass()
    local gas_storage = nGasStorage
    local gas_storage_max = nGasStorageMax

    if CheckStructure( class, ent ) then
        self.nw_gasStorage = math.Clamp( gas_storage - Ambi.Metz.Config.stove_consumption, 0, gas_storage_max )
        
        ent.nw_time = math.Clamp( ent:GetTime() - 1, 0, ent:GetMaxTime() )
        if ( ent.nw_time == 0 ) then
            ent:SetStatus( true )
            ent:EmitSound( 'ambient/fire/ignite.wav' )
            self[ 'nw_firePlace'..nNum ] = false
        end

        local soundChance = math.random( 1, 2 )
        if ( soundChance == 2 ) then
            ent:EmitSound( 'ambient/levels/canals/toxic_slime_gurgle' .. math.random( 2, 8 ) .. '.wav' )
        end

        self[ 'nw_firePlace'..nNum ] = true
    end
end

function Ambi.Metz.StoveThink( eObj )
    local self = eObj
    local pos = self:GetPos()
    local up, forward, right = self:GetUp(), self:GetForward(), self:GetRight()

    local traceF1 = {}
    traceF1.start = pos + ( up * 20 ) + ( forward * 2.8 ) + ( right * 11.5 )
    traceF1.endpos = pos + ( up * 24 ) + ( forward * 2.8 ) + ( right * 11.5 )
    traceF1.filter = self

    local traceF2 = {}
    traceF2.start = pos + ( up * 20 ) + ( forward * 2.8 ) + ( right * -11.2 )
    traceF2.endpos = pos + ( up * 24 ) + ( forward * 2.8 ) + ( right * -11.2 )
    traceF2.filter = self

    local traceF3 = {}
    traceF3.start = pos + ( up * 20 ) + ( forward * -9.8 ) + ( right * -11.2 )
    traceF3.endpos = pos + ( up * 24 ) + ( forward * -9.8 ) + ( right * -11.2 )
    traceF3.filter = self

    local traceF4 = {}
    traceF4.start = pos + ( up * 20 ) + ( forward * -9.8 ) + ( right * 11.5 )
    traceF4.endpos = pos + ( up * 24 ) + ( forward * -9.8 ) + ( right * 11.5 )
    traceF4.filter = self
    
    local traceFire1 = util.TraceLine( traceF1 )
    local traceFire2 = util.TraceLine( traceF2 )
    local traceFire3 = util.TraceLine( traceF3 )
    local traceFire4 = util.TraceLine( traceF4 )

    local gas_storage = self.nw_gasStorage
    local gas_storage_max = self.nw_gasStorageMax
    
    if ( ( not self.next_heat or CurTime() >= self.next_heat ) and ( gas_storage > 0 ) ) then
        ActionCheckFire( self, 1, traceFire1, gas_storage, gas_storage_max )
        ActionCheckFire( self, 2, traceFire2, gas_storage, gas_storage_max )
        ActionCheckFire( self, 3, traceFire3, gas_storage, gas_storage_max )
        ActionCheckFire( self, 4, traceFire4, gas_storage, gas_storage_max )

        self.next_heat = CurTime() + 1
    end
end