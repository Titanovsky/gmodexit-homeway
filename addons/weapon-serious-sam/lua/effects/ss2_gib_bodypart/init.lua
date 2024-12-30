
function EFFECT:Init(data)
	local gibs = data:GetEntity().gibs
	
	self.LifeTime = CurTime() + 10
	self.emitter = ParticleEmitter(self:GetPos())
	
	if !gibs then return end 
	self:SetModel( gibs[math.random(1, #gibs)] )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMaterial( "models/flesh" )

	self:SetCollisionGroup( COLLISION_GROUP_DEBRIS )
	self:SetCollisionBounds( Vector( -128 -128, -128 ), Vector( 128, 128, 128 ) )

	local phys = self:GetPhysicsObject()
	if phys and phys:IsValid() then
		phys:SetMaterial("bloodyflesh")
		phys:Wake()
		phys:SetAngles( Angle( math.Rand(0,360), math.Rand(0,360), math.Rand(0,360) ) )
		phys:SetVelocity( data:GetNormal() * math.Rand( 100, 300 ) + VectorRand() * math.Rand( 100, 200 ) )
	end
end

function EFFECT:Think()
	return self.LifeTime > CurTime()
end

function EFFECT:Render()
	self:DrawModel()
	if !cvars.Bool("ss2_cl_particles") then return end
	local FT = FrameTime()
	if FT < .02 and self:GetVelocity():Length() > 100 then
		local BloodPos = self:GetPos() + VectorRand()*4
		local LightColor = render.GetLightColor( BloodPos ) * 255
		LightColor[1] = math.Clamp( LightColor[1], 70, 255 )

		local particle = self.emitter:Add( "effects/blood_core", BloodPos )
		particle:SetDieTime( math.Rand( .5, 1 ) )
		particle:SetStartAlpha( math.Rand(200, 255) )
		particle:SetStartSize( math.Rand( 8, 16 ) )
		particle:SetEndSize( math.Rand( 32, 64 ) )
		particle:SetRoll( math.Rand( 0, 360 ) )
		particle:SetColor( LightColor[1], 0, 0 )
	end
end

function EFFECT:PhysicsCollide(data, physobj)
	local start = data.HitPos + data.HitNormal
	local endpos = data.HitPos - data.HitNormal

	if data.Speed > 64 and data.DeltaTime > .2 then
		util.Decal("Blood", start, endpos)
	end
end