EFFECT.mat = Material("effects/serioussam2/flares/flare_blueplasma")

function EFFECT:Init(data)
	self.Position = data:GetOrigin()
	self.WeaponEnt = data:GetEntity()
	self.Attachment = data:GetAttachment()
	
	self.DieTime = math.Rand(.01, .02)
	self.Size = data:GetScale()
	self.Rotate = math.Rand(-45,45)
end

function EFFECT:Think()
	self.DieTime = self.DieTime - FrameTime()
	self.Size = self.Size + self.DieTime*40
	return self.DieTime > 0
end

function EFFECT:Render()
	local Muzzle = self:GetTracerShootPos(self.Position, self.WeaponEnt, self.Attachment)
	if !self.WeaponEnt or !IsValid(self.WeaponEnt) or !Muzzle then return end
	render.SetMaterial(self.mat)
	render.DrawQuadEasy(Muzzle, -EyeVector(), self.Size, self.Size, Color(255, 255, 255, 255), self.Rotate)
	self:SetRenderBoundsWS(Muzzle, self.Position)
end