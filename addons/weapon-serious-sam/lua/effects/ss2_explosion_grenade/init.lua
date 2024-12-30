function EFFECT:Init(data)
	local pos = data:GetOrigin()
	local norm = data:GetNormal()
	local lightcol = render.GetLightColor(pos) * 400
	lightcol[1] = math.Clamp(lightcol[1], 40, 255)
	local eye = math.Clamp(LocalPlayer():EyePos():Distance(pos)/10, 8, 26)
	local emitter = ParticleEmitter(pos)
	
		local flare = emitter:Add("effects/serioussam2/flares/flare_star01", pos-norm*4+VectorRand())
			flare:SetVelocity(Vector(0,0,0))
			flare:SetAirResistance(0)
			flare:SetGravity(Vector(0, 0, 0))
			flare:SetDieTime(.25)
			flare:SetStartAlpha(255)
			flare:SetEndAlpha(0)
			flare:SetStartSize(45*eye)
			flare:SetEndSize(0)
			flare:SetRoll(math.Rand(-90, 90))
			flare:SetRollDelta(math.Rand(-2, 2))
			flare:SetColor(255, 220, 150)
			
		for i = 0,25 do
			local particle = emitter:Add("particle/particle_smokegrenade", pos)
			particle:SetVelocity(VectorRand() * i * 30)
			particle:SetAirResistance(100)
			particle:SetGravity(Vector(0, 0, 50))
			particle:SetDieTime(math.Rand(.1, .15)*i)
			particle:SetStartAlpha(255)
			particle:SetEndAlpha(0)
			particle:SetStartSize(math.Rand(.6, 1)*eye)
			particle:SetEndSize(math.Rand(8, 10)*eye)
			particle:SetRoll(math.Rand(-90, 90))
			particle:SetRollDelta(math.Rand(-1, 1))
			particle:SetColor(50, 50, 50)
		end
		
		for i = 1,8 do
			local trail = emitter:Add("particle/particle_smokegrenade", pos)
			trail:SetVelocity(350 * i * Vector(0,0,1))
			trail:SetAirResistance(512)
			trail:SetGravity(Vector(0, 0, math.Rand(100, 150)))
			trail:SetDieTime(math.Rand(.8, 1.2))
			trail:SetStartAlpha(math.Rand(100, 255))
			trail:SetEndAlpha(0)
			trail:SetStartSize(math.Rand(.4, .6)*eye)
			trail:SetEndSize(math.Rand(1, 4)*eye)
			trail:SetRoll(math.Rand(-90, 90))
			trail:SetRollDelta(math.Rand(-1, 1))
			trail:SetColor(70, 70, 70)
		end
		
		for i = 1,5 do
			local dust = emitter:Add("effects/serioussam2/dust_11", pos + VectorRand() * i * 2)
			dust:SetVelocity(VectorRand() * i * norm * 120)
			dust:SetAirResistance(100)
			dust:SetGravity(Vector(0, 0, -600))
			dust:SetDieTime(math.Rand(.7, 1))
			dust:SetStartAlpha(math.Rand(140, 255))
			dust:SetEndAlpha(0)
			dust:SetStartSize(math.Rand(.8, 1)*eye)
			dust:SetEndSize(math.Rand(3, 5)*eye)
			dust:SetRoll(math.Rand(-90, 90))
			dust:SetRollDelta(math.Rand(-.5, .5))
			dust:SetColor(lightcol[1], lightcol[1], lightcol[1])
		end

	emitter:Finish()
end

function EFFECT:Think()
	return false
end

function EFFECT:Render()
end