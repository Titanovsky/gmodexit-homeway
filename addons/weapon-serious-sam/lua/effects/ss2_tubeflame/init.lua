local mat_flame = "effects/serioussam2/fire/fire_cloud_01"
local mat_smoke = "particle/particle_smokegrenade"
local mat_bubble = "effects/bubble"

function EFFECT:Init(data)
	local Position = data:GetOrigin()
	local WeaponEnt = data:GetEntity()
	local Attachment = data:GetAttachment()
	local flamepos = self:GetTracerShootPos(Position, WeaponEnt, Attachment)
	
	local mat = mat_flame
	local col1, col2, col3 = 255, 150, 0
	local inwater = WeaponEnt:GetOwner():WaterLevel() == 3
	if inwater then
		mat = mat_bubble
		col1, col2, col3 = 200, 200, 255
	end
	
	local emitter = ParticleEmitter(flamepos)
	
		local flame = emitter:Add(mat, flamepos)
		flame:SetVelocity(VectorRand()*4+Vector(0,0,100))
		flame:SetAirResistance(400)
		flame:SetGravity(Vector(0, 0, 50))
		flame:SetDieTime(.2)
		flame:SetStartAlpha(255)
		flame:SetEndAlpha(0)
		flame:SetStartSize(math.random(1,3))
		flame:SetEndSize(5)
		flame:SetRoll(math.Rand(-90, 90))
		flame:SetRollDelta(math.Rand(-.25, .25))
		flame:SetColor(col1, col2, col3)

		if !inwater then
			local particle = emitter:Add(mat_smoke, flamepos)
			particle:SetVelocity(VectorRand()*4 + Vector(0,0,100))
			particle:SetAirResistance(500)
			particle:SetGravity(Vector(0, 0, 200))
			particle:SetDieTime(math.Rand(.7, .9))
			particle:SetStartAlpha(math.Rand(150,220))
			particle:SetEndAlpha(0)
			particle:SetStartSize(1)
			particle:SetEndSize(math.Rand(10, 12))
			particle:SetRoll(math.Rand(-90, 90))
			particle:SetRollDelta(math.Rand(-.25, .25))
			particle:SetColor(50, 50, 50)
		end

	emitter:Finish()
end

function EFFECT:Think()
	return false
end

function EFFECT:Render()
end