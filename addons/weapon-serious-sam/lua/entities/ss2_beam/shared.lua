if SERVER then AddCSLuaFile("shared.lua") end

ENT.Type			= "anim"
ENT.PrintName		= "SS2 Beam"
ENT.Author			= "Upset"

function ENT:SetupDataTables()
	self:NetworkVar("Entity", 0, "WepEntity")
	self:NetworkVar("Int", 1, "HitDist")
end

if SERVER then

	function ENT:Initialize()
		self:DrawShadow(false)
	end

end

if SERVER then return end

ENT.RenderGroup = RENDERGROUP_TRANSLUCENT

function ENT:DoTrace()
	local owner = self:GetOwner()
	local hitdist = self:GetHitDist()
	local tr = util.TraceLine({
		start = owner:GetShootPos(),
		endpos = owner:GetShootPos() + owner:GetAimVector() * hitdist,
		filter = owner
	})
	if !IsValid(tr.Entity) then
		tr = util.TraceHull({
			start = owner:GetShootPos(),
			endpos = owner:GetShootPos() + owner:GetAimVector() * hitdist,
			filter = owner
		})
	end
	return tr
end

function ENT:GetBeamPos(Position, Ent, Attachment, modelindex)

	modelindex = modelindex or 0
	
	if !IsValid(Ent) then return Position end
	if !Ent:IsWeapon() then return Position end
	
	local ply = LocalPlayer()
	local specply = ply:GetObserverTarget()

	-- Shoot from the viewmodel
	if Ent:IsCarriedByLocalPlayer() and !ply:ShouldDrawLocalPlayer() then
	
		local ViewModel = ply:GetViewModel(modelindex)
		
		if IsValid(ViewModel) then
			
			local att = ViewModel:GetAttachment(Attachment)
			if att then
				Position = att.Pos
			end
			
		end
	
	-- Shoot from the world model
	else
	
		if modelindex == 1 and IsValid(Ent.LeftModel) then
			Ent = Ent.LeftModel
		end
		local att = Ent:GetAttachment(Attachment)
		if att then
			Position = att.Pos
		end
	
	end

	return Position

end

-- function ENT:GetBeamPos(Position, Ent, Attachment)
	-- if !IsValid(Ent) then return Position end
	-- if !Ent:IsWeapon() then return Position end
	
	-- local ply = LocalPlayer()
	-- local specply = ply:GetObserverTarget()

	-- if (!Ent:IsCarriedByLocalPlayer() or ply:ShouldDrawLocalPlayer()) and !(ply:GetObserverMode() == OBS_MODE_IN_EYE and IsValid(specply) and Ent:GetOwner() == specply) then

		-- local att = Ent:GetAttachment(Attachment)
		-- if att then
			-- return att.Pos
		-- end
	
	-- end
-- end

function ENT:Initialize()
	local tr = self:DoTrace()
	self:SetRenderBoundsWS(self:GetPos(), tr.HitPos)
end

local matBeam = Material("effects/serioussam2/lightning_flare")
local matLightning = Material("effects/serioussam2/lightning_08")

function ENT:Draw()
end

function ENT:DrawTranslucent()
	local owner = self:GetOwner()
	if !IsValid(owner) then return end
	
	local tr = self.trace
	if !tr then return end
	
	local startPos = self:GetBeamPos(tr.StartPos, self:GetWepEntity(), 1)
	if !startPos then return end
	local endPos = tr.HitPos	
	
	local dist = startPos:DistToSqr(endPos)
	dist = dist * .001
	
	local texWidth = -dist * .012 + 32
	texWidth = math.max(texWidth, 18)
	local texScroll = CurTime() * (texWidth - 13)
	local color = Color(255, 255, 255, 200)
		
	render.SetMaterial(matBeam)	
	render.DrawBeam(startPos, endPos, 13, .15, 1, color)
	render.SetMaterial(matLightning)
	render.DrawBeam(startPos, endPos, texWidth, texScroll, texScroll + 1, color)
	render.DrawBeam(startPos, endPos, texWidth, texScroll, texScroll - 1, color)
end

function ENT:Think()
	local owner = self:GetOwner()
	if !IsValid(owner) then return end	
	self.trace = self:DoTrace()
	self:SetRenderBoundsWS(self:GetPos(), self.trace.HitPos)
end