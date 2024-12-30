function EFFECT:Init(data)
	local pos = data:GetOrigin()
	local norm = data:GetNormal()
	local eye = math.Clamp(LocalPlayer():EyePos():Distance(pos)/10, 8, 26)
	local emitter = ParticleEmitter(pos)
	
		local flare = emitter:Add("effects/serioussam2/flares/flare", pos-norm*4+VectorRand())
			flare:SetVelocity(Vector(0,0,0))
			flare:SetAirResistance(0)
			flare:SetGravity(Vector(0, 0, 0))
			flare:SetDieTime(.1)
			flare:SetStartAlpha(255)
			flare:SetEndAlpha(0)
			flare:SetStartSize(5*eye)
			flare:SetEndSize(0)
			flare:SetRoll(math.Rand(-90, 90))
			flare:SetRollDelta(math.Rand(-.25, .25))
			
		for i = 1,25 do
			local particle = emitter:Add("effects/serioussam2/flares/flare_plasma", pos)
				particle:SetVelocity(VectorRand()*eye * i *.6)
				particle:SetAirResistance(0)
				particle:SetGravity(Vector(0, 0, -200))
				particle:SetDieTime(math.Rand(.15,.4))
				particle:SetStartAlpha(255)
				particle:SetEndAlpha(0)
				particle:SetStartSize(math.Rand(.2, .3)*eye)
				particle:SetEndSize(math.Rand(.3, .4)*eye)
				particle:SetRoll(math.Rand(-90, 90))
				particle:SetRollDelta(math.Rand(-.25, .25))
				particle:SetColor(0, 150, 255)
		end

	emitter:Finish()
end

function EFFECT:Think()
	return false
end

function EFFECT:Render()
end