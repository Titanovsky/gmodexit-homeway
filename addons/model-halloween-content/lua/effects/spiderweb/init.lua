
function EFFECT:Init( data )
	local Pos = data:GetOrigin()
	local Color = data:GetStart()
	local emitter = ParticleEmitter( Pos )
	
	for i = 1,math.random(1,5) do

		local particle = emitter:Add( "particles/spiderweb", Pos + Vector( math.random(0,0),math.random(0,0),math.random(0,0) ) ) 
		 
		--if particle == nil then particle = emitter:Add( "particles/pumbkinface01", Pos + Vector(   math.random(0,0),math.random(0,0),math.random(0,0) ) ) end
		
		if (particle) then
			particle:SetVelocity(Vector(math.random(-45,45),math.random(-45,45),math.random(-45,45)))
			particle:SetLifeTime(2) 
			particle:SetDieTime(4) 
			particle:SetStartAlpha(255)
			particle:SetEndAlpha(0)
			particle:SetStartSize(1) 
			particle:SetEndSize(50)
			particle:SetAngles( Angle(math.Rand( 0, 360 ),math.Rand( 0, 360 ),math.Rand( 0, 360 )) )
			particle:SetAngleVelocity( Angle(0,0,0) ) 
			particle:SetRoll(math.Rand( 0, 360 ))
			particle:SetColor( 125,125,125 )
			--particle:SetColor(math.random(199,255),math.random(73,204),math.random(0,0),math.random(255,255))
			particle:SetGravity( Vector(0,-1,0) ) 
			particle:SetAirResistance(3)  
		end
	end

	emitter:Finish()
		
end

function EFFECT:Think()		
	return false
end

function EFFECT:Render()
end
