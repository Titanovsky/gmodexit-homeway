function EFFECT:Init(data)
	local pos = data:GetOrigin()
	local norm = data:GetNormal()
	local eye = math.Clamp(LocalPlayer():EyePos():Distance(pos)/10, 8, 26)
	local emitter = ParticleEmitter(pos)
	
		local flare = emitter:Add("effects/serioussam2/flares/flare_star01", pos-norm*4+VectorRand())
			flare:SetVelocity(Vector(0,0,0))
			flare:SetAirResistance(0)
			flare:SetGravity(Vector(0, 0, 0))
			flare:SetDieTime(.25)
			flare:SetStartAlpha(255)
			flare:SetEndAlpha(0)
			flare:SetStartSize(40*eye)
			flare:SetEndSize(0)
			flare:SetRoll(math.Rand(-90, 90))
			flare:SetRollDelta(math.Rand(-2, 2))
			flare:SetColor(255, 220, 150)
			
		for i = 0,30 do
			local particle = emitter:Add("particle/particle_smokegrenade", pos)
			particle:SetVelocity(VectorRand() * math.Rand(200, 600))
			particle:SetAirResistance(100)
			particle:SetGravity(Vector(0, 0, 50))
			particle:SetDieTime(math.Rand(1, 2))
			particle:SetStartAlpha(255)
			particle:SetEndAlpha(0)
			particle:SetStartSize(math.Rand(.6, 1)*eye)
			particle:SetEndSize(math.Rand(8, 10)*eye)
			particle:SetRoll(math.Rand(-90, 90))
			particle:SetRollDelta(math.Rand(-2, 2))
			particle:SetColor(120, 120, 120)
		end

	emitter:Finish()
end

function EFFECT:Think()
	return false
end

function EFFECT:Render()
end