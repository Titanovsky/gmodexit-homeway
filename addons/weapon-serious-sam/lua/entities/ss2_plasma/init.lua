
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
	self:SetModel("models/serioussam2/projectiles/plasmaray.mdl")
	self:SetColor(Color(160,255,255,255))
	local size = 4
	local mins, maxs = Vector(-size, -size, -size), Vector(size, size, size)
	self:PhysicsInitBox(mins, maxs)
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
	
	self.sound = CreateSound(self, "serioussam2/weapons/common/flying02.wav")
	self.sound:Play()
end

function ENT:SetDamage(dmg)
	self.Damage = dmg
end

function ENT:PhysicsCollide(data, physobj)
	if self.didHit then return end
	self.didHit = true
	self:OnHit(data.HitEntity, data.HitPos, data.HitNormal)
end

function ENT:OnHit(ent, hitpos, hitnorm)
	local start = hitpos + hitnorm
	local endpos = hitpos - hitnorm
	if ent:GetClass() == "worldspawn" then
		util.Decal("ss2plasmadecal", start, endpos)
	end

	local effectdata = EffectData()
	effectdata:SetOrigin(endpos)
	effectdata:SetNormal(hitnorm)
	util.Effect("ss2_plasmahit", effectdata)
	self:EmitSound("serioussam2/explosions/explosionsmall0"..math.random(2,4)..".wav", 80)
	
	ent:TakeDamage(self.Damage, self:GetOwner())
	self:Remove()
end

function ENT:OnRemove()
	if self.sound then self.sound:Stop() end
end