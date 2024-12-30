local flare1 = Material("effects/serioussam2/flares/flare_fire_01")
local flare2 = Material("effects/serioussam2/flares/flare_fire_02")

function EFFECT:GetMuzzleFlashPos( Position, Ent, Attachment, modelindex )

	modelindex = modelindex or 0
	
	if ( !IsValid( Ent ) ) then return Position end
	if ( !Ent:IsWeapon() ) then return Position end

	-- Shoot from the viewmodel
	if ( Ent:IsCarriedByLocalPlayer() && !LocalPlayer():ShouldDrawLocalPlayer() && !Ent:GetZoom() ) then
	
		local ViewModel = LocalPlayer():GetViewModel(modelindex)
		
		if ( ViewModel:IsValid() ) then
			
			local att = ViewModel:GetAttachment( Attachment )
			if ( att ) then
				Position = att.Pos
			end
			
		end
	
	-- Shoot from the world model
	else
	
		local att = Ent:GetAttachment( Attachment )
		if ( att ) then
			Position = att.Pos
		end
	
	end

	return Position

end

function EFFECT:Init(data)
	self.Position = data:GetOrigin()
	self.WeaponEnt = data:GetEntity()
	self.Attachment = data:GetAttachment()
	self.ModelIndex = data:GetSurfaceProp()
	if math.random(1, 2) == 1 then
		self.mat = flare1
	else
		self.mat = flare2
	end
	
	self.DieTime = math.Rand(.01, .02)
	self.Size = data:GetScale()
	self.Rotate = math.Rand(-180,180)
end

function EFFECT:Think()
	self.DieTime = self.DieTime - FrameTime()
	self.Size = self.Size + self.DieTime*40
	return self.DieTime > 0
end

function EFFECT:Render()
	local Muzzle = self:GetMuzzleFlashPos(self.Position, self.WeaponEnt, self.Attachment, self.ModelIndex)
	if !self.WeaponEnt or !IsValid(self.WeaponEnt) or !Muzzle then return end
	render.SetMaterial(self.mat)
	render.DrawQuadEasy(Muzzle, -EyeVector(), self.Size, self.Size, Color(255, 255, 255, 255), self.Rotate)
	self:SetRenderBoundsWS(Muzzle, self.Position)
end