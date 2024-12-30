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
		particle:SetVelocity(vel + 45 * data:GetNormal())
		particle:SetAirResistance(128)
		particle:SetGravity(Vector(0, 0, math.Rand(50, 100)))
		particle:SetDieTime(math.Rand(.5, .6))
		particle:SetStartAlpha(math.Rand(120, 150))
		particle:SetEndAlpha(0)
		particle:SetStartSize(math.Rand(1, 3))
		particle:SetEndSize(math.Rand(10, 15))
		particle:SetRoll(math.Rand(-90, 90))
		particle:SetRollDelta(math.Rand(-1, 1))
		particle:SetColor(180, 180, 180)

	emitter:Finish()
	
	self:SetRenderBoundsWS(smokepos, Position)
end

function EFFECT:Think()
	return false
end

function EFFECT:Render()
end