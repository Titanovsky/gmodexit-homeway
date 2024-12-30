local mat1 = "effects/serioussam2/lightning_01"
local mat2 = "effects/serioussam2/lightning_03"
	
function EFFECT:Init(data)
	self.Pos = data:GetOrigin()
	self.Normal = data:GetNormal()
	self.Count = 0
	self.NextAppear = CurTime()
	local eye = (LocalPlayer():EyePos() - self.Pos):Length() / 7
	self.EyeDist = math.Clamp(eye + 24, 1, 128)

	self.emitter = ParticleEmitter(self.Pos, true)	
	
	local emitter = ParticleEmitter(self.Pos)
	for i = 0,4 do
		local smoke = emitter:Add("particle/particle_smokegrenade", self.Pos + self.Normal * 2 + VectorRand() * 3)
		smoke:SetVelocity(self.Normal * 20 + VectorRand() * 30)
		smoke:SetGravity(Vector(0, 0, 50))
		smoke:SetDieTime(math.Rand(.4, .6))
		smoke:SetStartAlpha(255)
		smoke:SetEndAlpha(0)
		smoke:SetStartSize(math.Rand(.01, .02)*self.EyeDist)
		smoke:SetEndSize(math.Rand(.25, .35)*self.EyeDist)
		smoke:SetRoll(math.Rand(-90, 90))
		smoke:SetRollDelta(math.Rand(-4, 4))
		smoke:SetColor(100, 100, 100)
	end
	emitter:Finish()	
end

function EFFECT:Think()
	if self.emitter and self.emitter:IsValid() and self.NextAppear <= CurTime() then
		local mat = math.random(0,1) == 0 and mat1 or mat2
		
		local flare = self.emitter:Add(mat, self.Pos+self.Normal*8 + VectorRand())
		flare:SetAngles(self.Normal:Angle() + Angle(0,0,math.random(-180, 180)))
		flare:SetDieTime(.1)
		flare:SetStartAlpha(255)
		flare:SetEndAlpha(100)
		if math.random(0,1) == 0 then
			flare:SetStartSize(self.EyeDist + math.Rand(-10, 10))
			flare:SetEndSize(15)
		else
			flare:SetStartSize(15)
			flare:SetEndSize(self.EyeDist + math.Rand(-10, 10))
		end
		flare:SetColor(160, 180, 255)
		
		self.NextAppear = CurTime() + .05
		self.Count = self.Count + 1
	end
	if self.Count > 5 then 
		if self.emitter and self.emitter:IsValid() then self.emitter:Finish() end
		return false
	else
		return true
	end
end

function EFFECT:Render()
end