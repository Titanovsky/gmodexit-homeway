

/*---------------------------------------------------------
   Initializes the effect. The data is a table of data 
   which was passed from the server.
---------------------------------------------------------*/
function EFFECT:Init( data )
	
	local Pos = data:GetOrigin()
	local Norm = data:GetNormal()
	
	local LightColor = render.GetLightColor( Pos ) * 255
		LightColor.r = math.Clamp( LightColor.r, 70, 255 )
		
	local emitter = ParticleEmitter( Pos )
	
		local particle = emitter:Add( "effects/blood_core", Pos )
			particle:SetVelocity( Norm )
			particle:SetDieTime( math.Rand( 1.0, 2.0 ) )
			particle:SetStartAlpha( 255 )
			particle:SetStartSize( math.Rand( 16, 32 ) )
			particle:SetEndSize( math.Rand( 32, 64 ) )
			particle:SetRoll( math.Rand( 0, 360 ) )
			particle:SetColor( LightColor.r*0.5, 0, 0 )
				
	emitter:Finish()

	util.Decal( "Blood", Pos + Norm*10, Pos - Norm*10 )
	
	if ( math.random( 0, 5 ) == 0 ) then
		// This sound makes my stomach go funny
		local dist = 1-self:GetPos():Distance(LocalPlayer():GetPos())/1024
		if dist < 0 then
			dist = 0
		end
		EmitSound("physics/flesh/flesh_bloody_impact_hard1.wav",self:GetPos(),self:EntIndex(),CHAN_AUTO,dist)
	end
		
	// If we hit the ceiling drip blood randomly for a while
	if ( Norm.z < -0.5 ) then
	
		self.DieTime 		= CurTime() + 10
		self.Pos 			= Pos
		self.NextDrip 		= 0;
		self.LastDelay		= 0;
	
	end
	
end


/*---------------------------------------------------------
   THINK
   Returning false makes the entity die
---------------------------------------------------------*/
function EFFECT:Think( )

	if (!self.DieTime) then return false end
	if (self.DieTime < CurTime()) then return false end

	if (self.NextDrip > CurTime()) then return true end
	
	self.LastDelay = self.LastDelay + math.Rand( 0.1, 0.2 )
	self.NextDrip = CurTime() + self.LastDelay
	
	local LightColor = render.GetLightColor( self.Pos ) * 255
		LightColor.r = math.Clamp( LightColor.r, 70, 255 )
	
	local emitter = ParticleEmitter( self.Pos )
	
		local RandVel = VectorRand() * 16
		RandVel.z = 0
		
		local particle = emitter:Add( "effects/blooddrop", self.Pos + RandVel )
		if (particle) then
		
			particle:SetVelocity( Vector( 0, 0, math.Rand( -300, -150 ) ) )
			particle:SetDieTime( 1 )
			particle:SetStartAlpha( 255 )
			particle:SetEndAlpha( 255 )
			particle:SetStartSize( 2 )
			particle:SetEndSize( 0 )
			particle:SetColor( LightColor.r*0.5, 0, 0 )
			
		end
				
	emitter:Finish()

	
	return true
	
end


/*---------------------------------------------------------
   Draw the effect
---------------------------------------------------------*/
function EFFECT:Render()

	// Do nothing - this effect is only used to spawn the particles in Init
	
end



