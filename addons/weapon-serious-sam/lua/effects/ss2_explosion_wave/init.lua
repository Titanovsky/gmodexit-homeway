EFFECT.mat = Material("effects/serioussam2/wavering")

function EFFECT:Init(data)
	self.pos = data:GetOrigin() + Vector(0,0,4)
	self.eye = math.Clamp(LocalPlayer():EyePos():Distance(self.pos)/14, 1, 18)

	self.Time = .45
	self.Size = 64
	self.Scale = data:GetScale()
end

function EFFECT:Think()
	self.Time = self.Time - FrameTime()
	self.Size = self.Size + FrameTime() * 60 * self.eye * self.Scale
	self.alpha = 800 * self.Time
	self.alpha = math.Clamp(self.alpha, 0, 255)
	
	return self.Time > 0
end

function EFFECT:Render()
	render.SetMaterial(self.mat)
	render.DrawQuadEasy(self.pos, self:GetAngles():Up(), self.Size, self.Size, Color(255, 255, 150, self.alpha))
end