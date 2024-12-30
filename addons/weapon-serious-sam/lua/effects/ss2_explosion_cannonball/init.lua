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
			flare:SetStartSize(50*eye)
			flare:SetEndSize(0)
			flare:SetRoll(math.Rand(-90, 90))
			flare:SetRollDelta(math.Rand(-2, 2))
			flare:SetColor(255, 255, 255)			
		
		for i = 0,5 do
		local fire = emitter:Add("effects/serioussam2/fire/fire_cloud_01", pos)
			fire:SetVelocity(VectorRand() * i * 20)
			fire:SetAirResistance(100)
			fire:SetGravity(Vector(0, 0, 50))
			fire:SetDieTime(math.Rand(.4, .6))
			fire:SetStartAlpha(255)
			fire:SetEndAlpha(0)
			fire:SetStartSize(math.Rand(.6, .8)*eye)
			fire:SetEndSize(math.Rand(10, 14)*eye)
			fire:SetRoll(math.Rand(-90, 90))
			fire:SetRollDelta(math.Rand(-1, 1))
			fire:SetColor(255, 150, 0)
		end

		for i = 0,32 do
			local particle = emitter:Add("particle/particle_smokegrenade", pos)
			particle:SetVelocity(VectorRand() * 600)
			particle:SetAirResistance(100)
			particle:SetGravity(Vector(0, 0, 50))
			particle:SetDieTime(math.Rand(2, 4))
			particle:SetStartAlpha(255)
			particle:SetEndAlpha(0)
			particle:SetStartSize(math.Rand(.8, 1.4)*eye)
			particle:SetEndSize(math.Rand(7, 10)*eye)
			particle:SetRoll(math.Rand(-90, 90))
			particle:SetRollDelta(math.Rand(-1, 1))
			particle:SetColor(80, 80, 80)
		end
		
		for i = 1,30 do
			local sparks = emitter:Add("effects/serioussam2/flares/flare_star03", pos)
			sparks:SetVelocity(VectorRand() * 350 + norm)
			sparks:SetAirResistance(0)
			sparks:SetGravity(Vector(0, 0, -500))
			sparks:SetDieTime(math.Rand(.8, 1.2))
			sparks:SetStartAlpha(255)
			sparks:SetEndAlpha(50)
			sparks:SetStartSize(math.Rand(.1, .2)*eye)
			sparks:SetEndSize(math.Rand(.6, .8)*eye)
			sparks:SetRoll(math.Rand(-90, 90))
			sparks:SetRollDelta(math.Rand(-.4, .4))
		end
		
		for i = 1,8 do
			local dust = emitter:Add("effects/serioussam2/dust_11", pos + VectorRand() * i * 2)
			dust:SetVelocity(VectorRand() * i * Vector(0,0,1) * 120)
			dust:SetAirResistance(100)
			dust:SetGravity(Vector(0, 0, -600))
			dust:SetDieTime(math.Rand(.7, 1))
			dust:SetStartAlpha(math.Rand(140, 255))
			dust:SetEndAlpha(0)
			dust:SetStartSize(math.Rand(1, 1.2)*eye)
			dust:SetEndSize(math.Rand(6, 8)*eye)
			dust:SetRoll(math.Rand(-90, 90))
			dust:SetRollDelta(math.Rand(-.5, .5))
			dust:SetColor(lightcol[1], lightcol[1], lightcol[1])
		end
		
		for i = 1,10 do
			local trail = emitter:Add("particle/particle_smokegrenade", pos)
			trail:SetVelocity(350 * i * Vector(0,0,1))
			trail:SetAirResistance(512)
			trail:SetGravity(Vector(0, 0, math.Rand(100, 150)))
			trail:SetDieTime(math.Rand(1.5, 2))
			trail:SetStartAlpha(math.Rand(150, 255))
			trail:SetEndAlpha(0)
			trail:SetStartSize(math.Rand(1, 1.4)*eye)
			trail:SetEndSize(math.Rand(5, 8)*eye)
			trail:SetRoll(math.Rand(-90, 90))
			trail:SetRollDelta(math.Rand(-1, 1))
			trail:SetColor(70, 70, 70)
		end

	emitter:Finish()
end

function EFFECT:Think()
	return false
end

function EFFECT:Render()
end