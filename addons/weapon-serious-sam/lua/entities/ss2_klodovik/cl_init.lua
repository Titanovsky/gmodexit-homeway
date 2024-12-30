include('shared.lua')

function ENT:Initialize()
	self:SetRenderAngles(self:GetAngles())
	self.movetime = 0
	self.emitter = ParticleEmitter(self:GetPos())
end

local bones = {
	["Wing_R_1"] = 40,
	["Wing_L_1"] = 40,
	["Wing_R_2"] = 20,
	["Wing_L_2"] = 20
}

function ENT:Draw()
	if self:GetHasTarget() then
		local newang = self:GetNewAngle()
		newang = LerpAngle(FrameTime()*8, self:GetAngles(), newang)
		self:SetRenderAngles(newang)
	end
	self:DrawModel()

	local move = math.sin(CurTime()*35)
	self:ManipulateBonePosition(self:LookupBone("origin"), Vector(0,0,math.sin(CurTime()*30)))
	self.movetime = self.movetime + FrameTime() * 3
	self.movetime = math.min(self.movetime, 1)
	self:ManipulateBoneAngles(self:LookupBone("Body"), Angle(-5,20,26)*self.movetime)
	self:ManipulateBoneAngles(self:LookupBone("Head"), Angle(5,-20,18)*self.movetime)
	self:ManipulateBonePosition(self:LookupBone("Head"), Vector(1,1,-1)*self.movetime)
	for bone, scale in pairs(bones) do
		self:ManipulateBoneAngles(self:LookupBone(bone), Angle(0,0,move*scale))
	end
	
	
	if !cvars.Bool("ss2_cl_particles") or !self.emitter then return end
	
	local ang = self:GetRenderAngles()
	local pos = self:GetPos() - ang:Forward() * 1 - ang:Up() * 6
	local vel = self:GetVelocity()

	local particle = self.emitter:Add("particle/particle_smokegrenade", pos)
	if particle then
		particle:SetVelocity(VectorRand()*40)
		particle:SetAirResistance(0)
		particle:SetGravity(Vector(0, 0, 200))
		particle:SetDieTime(math.Rand(.2, .8))
		particle:SetStartAlpha(math.Rand(100, 120))
		particle:SetEndAlpha(0)
		particle:SetStartSize(2)
		particle:SetEndSize(math.Rand(8, 16))
		particle:SetRoll(math.Rand(-90, 90))
		particle:SetRollDelta(math.Rand(-.25, .25))
		particle:SetColor(200, 200, 200)
	end
end

function ENT:OnRemove()
	if self.emitter and self.emitter:IsValid() then
		self.emitter:Finish()
	end
end