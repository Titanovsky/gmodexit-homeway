function EFFECT:GetMuzzleFlashPos( Position, Ent, Attachment, modelindex )

	modelindex = modelindex or 0
	
	if ( !IsValid( Ent ) ) then return Position end
	if ( !Ent:IsWeapon() ) then return Position end

	-- Shoot from the viewmodel
	if ( Ent:IsCarriedByLocalPlayer() && !LocalPlayer():ShouldDrawLocalPlayer() && !Ent:GetZoom() ) then
	
		local ViewModel = LocalPlayer():GetViewModel(modelindex)
		
		if ( ViewModel:IsValid() ) then
			
			local att = ViewModel:GetAttachment( Attachment )
			if ( att ) then
				Position = att.Pos
			end
			
		end
	
	-- Shoot from the world model
	else
	
		local att = Ent:GetAttachment( Attachment )
		if ( att ) then
			Position = att.Pos
		end
	
	end

	return Position

end

function EFFECT:Init(data)
	local Position = data:GetOrigin()
	local WeaponEnt = data:GetEntity()
	local Owner = IsValid(WeaponEnt) and WeaponEnt:GetOwner()
	local Attachment = data:GetAttachment()
	local ModelIndex = data:GetSurfaceProp()

	local smokepos = self:GetMuzzleFlashPos(Position, WeaponEnt, Attachment, ModelIndex)
	local vel = IsValid(Owner) and Owner:GetVelocity() or Vector(0, 0, 0)
	local emitter = ParticleEmitter(smokepos)

	local particle = emitter:Add("particle/particle_smokegrenade", smokepos)
		particle:SetVelocity(vel + 50 * data:GetNormal())
		particle:SetAirResistance(128)
		particle:SetGravity(Vector(0, 0, math.Rand(50, 80)))
		particle:SetDieTime(math.Rand(.4, .6))
		particle:SetStartAlpha(math.Rand(120, 150))
		particle:SetEndAlpha(0)
		particle:SetStartSize(math.Rand(2, 5))
		particle:SetEndSize(math.Rand(8, 10))
		particle:SetRoll(math.Rand(-90, 90))
		particle:SetRollDelta(math.Rand(-.25, .25))
		particle:SetColor(120, 120, 120)
		
	local particle1 = emitter:Add("particle/particle_smokegrenade", smokepos)
		particle1:SetVelocity(vel + 50 * data:GetNormal() + smokepos:Angle():Right() *50)
		particle1:SetAirResistance(180)
		particle1:SetGravity(Vector(0, 0, math.Rand(50, 80)))
		particle1:SetDieTime(math.Rand(.7, .9))
		particle1:SetStartAlpha(math.Rand(120, 150))
		particle1:SetEndAlpha(0)
		particle1:SetStartSize(math.Rand(2, 5))
		particle1:SetEndSize(math.Rand(15, 18))
		particle1:SetRoll(math.Rand(-90, 90))
		particle1:SetRollDelta(math.Rand(-.25, .25))
		particle1:SetColor(180, 180, 180)

	emitter:Finish()
	
	self:SetRenderBoundsWS(smokepos, Position)
end

function EFFECT:Think()
	return false
end

function EFFECT:Render()
end