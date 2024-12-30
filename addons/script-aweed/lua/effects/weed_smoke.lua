function EFFECT:Init(data)
	self.ent = data:GetEntity()
	self.Emitter = ParticleEmitter( self.ent:EyePos() ) 

	for k=0,2 do
		timer.Simple(k/10,function()
			local beat = self.Emitter:Add("effects/softglow_translucent", self.ent:EyePos() + self.ent:GetForward()*16 + self.ent:GetUp()*-16)
			if (beat) then
				beat:SetPos(self.ent:EyePos()  + self.ent:GetForward()*8 + self.ent:GetUp()*-6)
				beat:SetLifeTime(0)
				beat:SetDieTime(1)
				beat:SetStartAlpha(254)
				beat:SetEndAlpha(0)
				beat:SetStartSize(math.random(0.2,2))
				beat:SetEndSize(math.random(10,30))
				beat:SetCollide(false)
				beat:SetGravity(Vector(0,0,50))
				beat:SetRollDelta( math.random(-16,16) )
				beat:SetColor(255,255,255,math.random(4,30))
				beat:SetVelocity(self.ent:GetForward()*64)
			end
		end)
	end
	timer.Simple(3,function()
		self.Emitter:Finish()
	end)
end

function EFFECT:Think()
	if(IsValid(self.ent)) then
		return true
	end
	return false
end

function EFFECT:Render()
end