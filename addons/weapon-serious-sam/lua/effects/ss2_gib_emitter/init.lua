
function EFFECT:Init(data)	
	local Pos = data:GetOrigin()
	local Normal = data:GetNormal()
	local Ent = data:GetEntity()
	
	for i = 0, 12 do
		local BloodPos = Pos + VectorRand()*i*4
		local LightColor = render.GetLightColor( BloodPos ) * 255
		LightColor[1] = math.Clamp( LightColor[1], 70, 255 )
		local emitter = ParticleEmitter( BloodPos )
			local particle = emitter:Add( "effects/blood_core", BloodPos )
			particle:SetVelocity( Normal )
			particle:SetDieTime( math.Rand( 1, 2 ) )
			particle:SetStartAlpha( 255 )
			particle:SetStartSize( math.Rand( 16, 32 ) )
			particle:SetEndSize( math.Rand( 64, 128 ) )
			particle:SetRoll( math.Rand( 0, 360 ) )
			particle:SetColor( LightColor[1], 0, 0 )
		emitter:Finish()
		util.Decal( "Blood", Pos + Normal*10, Pos - Normal*10 )
	end
	
	for i = 0, 14 do
		local effectdata = EffectData()
		effectdata:SetOrigin(Pos + i * Vector(0,0,4))
		effectdata:SetNormal(Normal)
		effectdata:SetEntity(Ent)
		util.Effect("ss2_gib_bodypart", effectdata)
	end
end

function EFFECT:Think()
	return false
end

function EFFECT:Render()
end