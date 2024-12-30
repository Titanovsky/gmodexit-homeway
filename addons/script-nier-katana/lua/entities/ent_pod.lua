AddCSLuaFile()

ENT.Type 			= "anim"
ENT.Base 			= "base_gmodentity"
ENT.PrintName		= "Pod 042"
ENT.Author			= "Xaxidoro"
ENT.Information		= ""
ENT.Category		= "Mad Cows Weapons"

ENT.Spawnable		= false
ENT.AdminSpawnable	= false

ENT.HurtTime		= CurTime()
ENT.MoveTime 		= CurTime()
ENT.SoundTime		= CurTime()

function ENT:Draw()
	
	self.Entity:DrawModel()
	
end

function ENT:Think()

	if not self.Entity:GetOwner():IsValid() and SERVER then
		self.Entity:Remove()
		return
	end

	if self.SoundTime < CurTime() and IsFirstTimePredicted() then
		if math.random( 0, 10 ) < 4 then
			--self.Entity:EmitSound( "ambient/machines/combine_terminal_idle" .. math.random( 1, 4 ) .. ".wav", 75, 100, 1, CHAN_AUTO )
		elseif self:GetOwner():Health() < 40 then
			local hurtSound = math.random( 0, 1.8 )
			if hurtSound >= 1 then
				self.Entity:EmitSound( "weapons/pod042/attack-2.wav", 75, 100, 1, CHAN_AUTO )
			elseif hurtSound >= 0 then
				self.Entity:EmitSound( "weapons/pod042/attack-1.wav", 75, 100, 1, CHAN_AUTO )
			end
		end
		self.SoundTime = CurTime() + math.random( 5, 10 )
	end
	
	if self.HurtTime > CurTime() then 
		local sparks = ents.Create( "env_spark" )
			sparks:SetPos( self.Entity:GetPos() )
			sparks:SetKeyValue( "MaxDelay", "0" )
			sparks:SetKeyValue( "Magnitude", "2" )
			sparks:SetKeyValue( "TrailLength", "3" )
			sparks:SetKeyValue( "spawnflags", "0" )
			sparks:Spawn()
			sparks:Fire( "SparkOnce", "", 0 )
		return 
	end
	
	if self.Entity:GetPos():Distance( self:GetOwner():GetPos() ) > 50 then
		if( self.Entity:GetPhysicsObject():IsValid() ) then
			self.Entity:GetPhysicsObject():ApplyForceCenter( ( ( self:GetOwner():GetPos() + self.Owner:GetUp() * 80 + self.Owner:GetRight() * -50 ) - self.Entity:GetPos() ) * 15 )
		end
	elseif self.MoveTime < CurTime() then
		if( self.Entity:GetPhysicsObject():IsValid() ) then
			self.Entity:GetPhysicsObject():ApplyForceCenter( Vector( math.Rand( -40, 40 ), math.Rand( -40, 40 ), math.Rand( -40, 40 ) ) )
		end
		self.MoveTime = CurTime() + 1
	end
	
	local trace = util.TraceLine( {
		start = self:GetOwner():GetShootPos(),
		endpos = self:GetOwner():GetShootPos() + self.Owner:GetAimVector() * 10000,
		filter = self:GetOwner()
	} )
	trace.mask = MASK_SHOT
	if( trace.Hit ) then
		local lookAng = ( trace.HitPos - self.Entity:GetPos() ):Angle()
		lookAng:RotateAroundAxis( lookAng:Up(), -90 )
		self.Entity:SetAngles( lookAng )
		
	end
end

if SERVER then

	function ENT:Initialize()

		self.Entity:SetModel("models/player/pod042.mdl")
		self.Entity:PhysicsInit(SOLID_VPHYSICS)
		self.Entity:SetMoveType(MOVETYPE_VPHYSICS)
		self.Entity:SetSolid(SOLID_VPHYSICS)
		self.Entity:DrawShadow(false)
		self.Entity:SetGravity(0)
		
		self.Entity:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE)
		
		local phys = self.Entity:GetPhysicsObject()
		
		if (phys:IsValid()) then
			phys:EnableGravity( false )
			phys:Wake()
		end
		
		local introSound = math.random( 0, 2.8 )
		if introSound >= 2 then
			self.Entity:EmitSound( "weapons/pod042/intro-1.wav", 75, 100, 1, CHAN_AUTO )
		elseif introSound >= 1 then
			self.Entity:EmitSound( "weapons/pod042/intro-2.wav", 75, 100, 1, CHAN_AUTO )
		elseif introSound >= 0 then
			self.Entity:EmitSound( "weapons/pod042/intro-3.wav", 75, 100, 1, CHAN_AUTO )
		end
		self.SoundTime = CurTime() + math.random( 5, 10 )
		
	end

	function ENT:OnTakeDamage( damage )
		self.HurtTime = CurTime() + 3
		local hurtSound = math.random( 0, 2.8 )
		if hurtSound >= 2 then
			self.Entity:EmitSound( "weapons/pod042/hurt-2.wav", 75, 100, 1, CHAN_AUTO )
		elseif hurtSound >= 1 then
			self.Entity:EmitSound( "weapons/pod042/hurt-3.wav", 75, 100, 1, CHAN_AUTO )
		elseif hurtSound >= 0 then
			self.Entity:EmitSound( "weapons/pod042/hurt-1.wav", 75, 100, 1, CHAN_AUTO )
		end
		self.SoundTime = CurTime() + 5
	end
	
end