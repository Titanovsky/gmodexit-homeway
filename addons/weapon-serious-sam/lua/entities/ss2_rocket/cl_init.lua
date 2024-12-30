include('shared.lua')

local mat_smoke = "particle/particle_smokegrenade"
local mat_bubble = "effects/bubble"

function ENT:Initialize()
	self.emitter = ParticleEmitter(self:GetPos())
end

function ENT:Draw()
	self:DrawModel()
	
	if !cvars.Bool("ss2_cl_particles") or !self.emitter then return end
	
	local pos = self:GetPos() - self:GetForward()*32
	local vel = self:GetVelocity()
	
	local trail = self.emitter:Add("effects/serioussam2/trail_02", pos)
	if trail then
		trail:SetVelocity(Vector(0, 0, 0))
		trail:SetAirResistance(0)
		trail:SetGravity(Vector(0, 0, 0))
		trail:SetDieTime(.7)
		trail:SetStartAlpha(20)
		trail:SetEndAlpha(0)
		trail:SetStartSize(10)
		trail:SetEndSize(1)
		trail:SetRoll(0)
		trail:SetRollDelta(0)
		trail:SetColor(255, 255, 255)
	end
	
	local mat = mat_smoke
	if self:WaterLevel() == 3 then
		mat = mat_bubble
	end

	local particle = self.emitter:Add(mat, pos)
	if particle then
		particle:SetVelocity(Vector(0, 0, 0))
		particle:SetAirResistance(0)
		particle:SetGravity(Vector(0, 0, 100))
		particle:SetDieTime(math.Rand(.2, .6))
		particle:SetStartAlpha(math.Rand(100,120))
		particle:SetEndAlpha(0)
		particle:SetStartSize(4)
		particle:SetEndSize(math.Rand(10, 20))
		particle:SetRoll(math.Rand(-90, 90))
		particle:SetRollDelta(math.Rand(-.25, .25))
		particle:SetColor(240, 240, 240)
	end
end

function ENT:OnRemove()
	if self.emitter and self.emitter:IsValid() then
		self.emitter:Finish()
	end
end