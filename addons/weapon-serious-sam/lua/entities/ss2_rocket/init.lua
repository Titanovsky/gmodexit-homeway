
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

ENT.Model = Model("models/serioussam2/projectiles/rocket.mdl")
ENT.FlySound = Sound("serioussam2/weapons/common/flying01.wav")

function ENT:PhysInit()
	self:SetCollisionGroup(COLLISION_GROUP_PROJECTILE)
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_CUSTOM)
	
	local phys = self:GetPhysicsObject()
	if IsValid(phys) then
		phys:AddGameFlag(FVPHYSICS_NO_IMPACT_DMG)
		phys:Wake()
		phys:SetMass(10)
		phys:EnableDrag(false)
		phys:EnableGravity(false)
		phys:SetBuoyancyRatio(0)
	end
end

function ENT:Explode(exppos, norm)
	local pos = self:DoTrace(self:GetPos(), exppos)
	
	local explosion = EffectData()
	explosion:SetOrigin(pos)
	explosion:SetNormal(norm)
	explosion:SetScale(1)
	util.Effect("ss2_explosion_rocket", explosion)
	util.Effect("ss2_explosion_wave", explosion)
	
	self:EmitSound("serioussam2/explosions/explosion0"..math.random(1,7)..".wav", 400)
	local owner = self:GetOwner()
	if IsValid(owner) then
		util.BlastDamage(self, owner, pos, 256, self.BlastDamage)
	end
	self:Remove()
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
		util.Decal("Scorch", start, endpos)
	end
	
	local pos = ent:Health() > 0 and ent:GetPos() or hitpos
	self:DoDirectDamage(ent, self.Damage, self:GetOwner())
	self:Explode(pos, hitnorm)
end

function ENT:Think()
end