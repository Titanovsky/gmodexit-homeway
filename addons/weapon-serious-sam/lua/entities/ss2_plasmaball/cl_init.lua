include('shared.lua')

local mat = Material("sprites/glow04_noz")

function ENT:Initialize()
	self:SetRenderBounds(self:OBBMins(), self:OBBMaxs(), -self:GetForward()*128)
	self.emitter = ParticleEmitter(self:GetPos())
end

function ENT:Draw()
	self:DrawModel()
	
	local pos = self:GetPos()
	local eyevec = EyeVector()
	render.SetMaterial(mat)
	render.DrawQuadEasy(pos - eyevec, -eyevec, self:GetSize()/2, self:GetSize()/2, Color(255,200,0,255), math.sin(CurTime()) * 180)
	
	if !cvars.Bool("ss2_cl_particles") or !self.emitter then return end
	
	local pos = self:GetPos()
	local vel = self:GetVelocity()

	local particle = self.emitter:Add("effects/serioussam2/flares/flare_star01", pos)
	if particle then
		particle:SetVelocity(VectorRand()*10)
		particle:SetAirResistance(0)
		particle:SetGravity(Vector(0, 0, 0))
		particle:SetDieTime(math.Rand(.2, .7))
		particle:SetStartAlpha(math.Rand(100, 120))
		particle:SetEndAlpha(0)
		particle:SetStartSize(math.Rand(.2, .5) * self:GetSize())
		particle:SetEndSize(0)
		particle:SetRoll(math.Rand(-90, 90))
		particle:SetRollDelta(math.Rand(-.25, .25))
		particle:SetColor(255, 255, 100)
	end
end

function ENT:OnRemove()
	if self.emitter and self.emitter:IsValid() then
		self.emitter:Finish()
	end
end