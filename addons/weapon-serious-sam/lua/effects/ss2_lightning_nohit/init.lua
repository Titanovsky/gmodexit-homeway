function EFFECT:Init(data)
	local pos = data:GetOrigin()
	local eye = (LocalPlayer():EyePos() - pos):Length() / 12
	eye = math.Clamp(eye + 16, 16, 256)
	
	local emitter = ParticleEmitter(pos)
	
	for i = 1,3 do
		local flare = emitter:Add("effects/serioussam2/lightning_15", pos)
		flare:SetDieTime(.065)
		flare:SetStartAlpha(255)
		flare:SetEndAlpha(255)
		flare:SetStartSize(math.Rand(1, 2) * eye)
		flare:SetEndSize(math.Rand(.7, .9) * eye)
		flare:SetRoll(math.Rand(-1, 1))
		flare:SetRollDelta(math.Rand(-.25, .25))
		flare:SetColor(210, 230, 255)
	end
	
	emitter:Finish()
end

function EFFECT:Think()
	return false
end

function EFFECT:Render()
end