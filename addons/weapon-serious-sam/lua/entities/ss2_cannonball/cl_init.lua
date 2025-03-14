include('shared.lua')

function ENT:Initialize()
	self.emitter = ParticleEmitter(self:GetPos())
end

function ENT:Think()
	if self:WaterLevel() >= 2 then
		self.extinguished = true
	end
end

function ENT:Draw()
	self:DrawModel()
	
	if !cvars.Bool("ss2_cl_particles") or self.extinguished or !self.emitter then return end
	
	local pos = self:GetPos()
	local vel = self:GetVelocity()
	
	local flame = self.emitter:Add("effects/serioussam2/fire/fire_cloud_01", pos)
	if flame then
		flame:SetVelocity(VectorRand()*4 - vel + Vector(0,0,400))
		flame:SetAirResistance(400)
		flame:SetGravity(Vector(0, 0, 50))
		flame:SetDieTime(math.Rand(.1, .2))
		flame:SetStartAlpha(math.Rand(200, 255))
		flame:SetEndAlpha(0)
		flame:SetStartSize(30)
		flame:SetEndSize(math.Rand(70, 80))
		flame:SetRoll(math.Rand(-90, 90))
		flame:SetRollDelta(math.Rand(-.25, .25))
		flame:SetColor(255,150,0)
	end

	local particle = self.emitter:Add("particle/particle_smokegrenade", pos)
	if particle then
		particle:SetVelocity(VectorRand()*4 - vel + Vector(0,0,500))
		particle:SetAirResistance(200)
		particle:SetGravity(Vector(0, 0, 800))
		particle:SetDieTime(math.Rand(.4, .6))
		particle:SetStartAlpha(math.Rand(100,120))
		particle:SetEndAlpha(0)
		particle:SetStartSize(10)
		particle:SetEndSize(math.Rand(120, 180))
		particle:SetRoll(math.Rand(-90, 90))
		particle:SetRollDelta(math.Rand(-.25, .25))
		particle:SetColor(50, 50, 50)
	end
end

function ENT:OnRemove()
	if self.emitter and self.emitter:IsValid() then
		self.emitter:Finish()
	end
end