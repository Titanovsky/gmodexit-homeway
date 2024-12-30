AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
	self:SetModel(self.Model)
	self:PhysInit()
	
	self.sound = CreateSound(self, self.FlySound)
	self.sound:Play()
end

function ENT:PhysInit()
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
end

function ENT:SetEntityOwner(ply)
	self:SetOwner(ply)
	self:SetVar("owner", ply)
end

function ENT:SetExplodeDelay(delay)
	self.ExplosionTime = CurTime() + delay
end

function ENT:SetDamage(dmg, bdmg)
	self.Damage = dmg
	if bdmg then
		self.BlastDamage = bdmg
	end
end

function ENT:OnRemove()
	if self.sound then self.sound:Stop() end
end

function ENT:EnableOwnerCollision()
	self:SetOwner(nil)
	self.Owner = self:GetVar("owner", game.GetWorld())
end

function ENT:PhysicsCollide(data, phys)
	self:EnableOwnerCollision()
	self:PhysCollide(data, phys)
end

function ENT:PhysCollide(data, phys)
end

function ENT:DoDirectDamage(ent, dmg, owner)
	if ent:IsWorld() or ent:IsPlayer() or ent == owner or !IsValid(owner) then return end
	local dmginfo = DamageInfo()
	dmginfo:SetInflictor(self)
	dmginfo:SetAttacker(owner)
	dmginfo:SetDamage(dmg)
	dmginfo:SetDamageType(DMG_BLAST)
	ent:TakeDamageInfo(dmginfo)
end

function ENT:Think()
	if self.ExplosionTime and self.ExplosionTime <= CurTime() then
		self.ExplosionTime = nil
		self:Explode()
	end
	self:SpecialThink()
end

function ENT:SpecialThink()
end

function ENT:DoTrace(pos1, pos2)
	local tr = util.TraceHull({
		start = pos1,
		endpos = pos2,
		filter = self
	})
	
	return tr.HitPos, tr.HitNormal
end