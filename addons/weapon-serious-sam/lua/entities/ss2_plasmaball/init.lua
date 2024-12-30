
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
	self:SetModel("models/serioussam2/projectiles/plasmabeam.mdl")
	self:PhysicsInitSphere(self.Collision)
	self:SetCollisionGroup(COLLISION_GROUP_PROJECTILE)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_CUSTOM)
	self:DrawShadow(false)
	
	local phys = self:GetPhysicsObject()
	if IsValid(phys) then
		phys:SetMaterial("default_silent")
		phys:AddGameFlag(FVPHYSICS_NO_IMPACT_DMG)
		phys:SetMass(1)
		phys:EnableDrag(false)
		phys:EnableGravity(false)
		phys:SetBuoyancyRatio(0)
	end
	
	self.sound = CreateSound(self, "serioussam2/weapons/common/flying05.wav")
	self.sound:Play()
	
	SafeRemoveEntityDelayed(self, 5)
end

function ENT:SetDamage(dmg)
	self.Damage = dmg
	self:SetSize(dmg)
end

function ENT:PhysicsCollide(data, physobj)
	if self.didHit then return end
	self.didHit = true
	self:OnHit(data.HitEntity, data.HitPos, data.HitNormal)
end

function ENT:OnHit(ent, hitpos, hitnorm)
	local start = hitpos + hitnorm
	self.endpos = hitpos - hitnorm
	if ent:GetClass() == "worldspawn" then
		util.Decal("fadingscorch", start, self.endpos)
	end
	
	ent:TakeDamage(self.Damage, self:GetOwner())
	self:Remove()
end

function ENT:OnRemove()
	if self.sound then self.sound:Stop() end
	local effectdata = EffectData()
	effectdata:SetOrigin(self.endpos or self:GetPos())
	util.Effect("ss2_explosion_plasmabeam", effectdata)
	self:EmitSound("serioussam2/explosions/explosionsmall0"..math.random(2,4)..".wav", 80)
end

local targets = {}

function ENT:FindTarget()
	table.Empty(targets)
	local ents = ents.FindInSphere(self:GetPos() + self:GetForward() * 1200, 600)
	for k,v in pairs(ents) do
		if IsValid(v) and v:IsNPC() and v:Disposition(self.Owner) != D_LI and v:GetClass() != "hornet" then
			local tr = util.TraceHull({
				start = self:GetPos(),
				endpos = v:GetPos(),
				filter = {self, self.Owner}
			})
			local target = tr.Entity
			if IsValid(target) and target:IsNPC() then
				table.insert(targets, {ent = target, pos = self:GetPos():Distance(target:GetPos())})
			end
		end
	end
	if targets then
		table.SortByMember(targets, "pos", true)
		if targets[1] then
			self.Target = targets[1].ent
		end
	end
end

function ENT:Think()	
	if self.Target and IsValid(self.Target) and self.Target:Health() > 0 then
		local targetangle = (self.Target:GetPos() - self:GetPos() + (self.Target:OBBMins() + self.Target:OBBMaxs()) *.65):Angle()
		self:SetAngles(targetangle)
		local phys = self:GetPhysicsObject()
		if IsValid(phys) then
			phys:SetVelocity(self:GetForward() * self.Speed)
		end
	else
		self:FindTarget()
	end
end