function EFFECT:Init(data)
	local pos = data:GetOrigin()

	local emitter = ParticleEmitter(pos)

		for i = 0,35 do
			local particle = emitter:Add("effects/serioussam2/feather", pos)
			particle:SetVelocity(VectorRand() * i * 8)
			particle:SetAirResistance(100)
			particle:SetGravity(Vector(0, 0, -80))
			particle:SetDieTime(math.Rand(.1, .2)*i)
			particle:SetStartAlpha(255)
			particle:SetEndAlpha(0)
			particle:SetStartSize(math.Rand(2, 4))
			particle:SetEndSize(math.Rand(.3, .4))
			particle:SetRoll(math.Rand(-90, 90))
			particle:SetRollDelta(math.Rand(-8, 8))
			particle:SetColor(60, 200, 0)
		end

	emitter:Finish()
end

function EFFECT:Think()
	return false
end

function EFFECT:Render()
end