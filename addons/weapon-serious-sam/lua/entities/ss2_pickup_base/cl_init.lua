include('shared.lua')

function ENT:Initialize()
	self.OriginPos = self:GetPos()
	self.Rotate = 0
	self.RotateTime = RealTime()
end

function ENT:Draw()
	self:SetRenderOrigin(self.OriginPos + Vector(0,0,math.sin(RealTime() * 3) *6))
	self:SetupBones()
	self:DrawModel()
	self.Rotate = (RealTime() - self.RotateTime)*140 %360
	self:SetAngles(Angle(0,-self.Rotate,0))
end