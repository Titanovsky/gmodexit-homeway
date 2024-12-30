AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

ENT.Model = Model("models/serioussam2/projectiles/grenade.mdl")
ENT.FlySound = Sound("serioussam2/weapons/common/flying01.wav")

function ENT:PhysInit()
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	
	hook.Add("EntityTakeDamage", self, self.ReducePlayerDamage)
end

function ENT:PhysCollide(data,phys)
	local impulse = -data.Speed * data.HitNormal * 20
	if data.HitNormal[3] != -1 then
		phys:ApplyForceCenter(impulse)
	end
end

function ENT:Explode(exppos)
	local pos = self:GetPos()
	local norm
	exppos = exppos or pos
	
	pos, norm = self:DoTrace(pos, exppos)
	
	local explosion = EffectData()
	explosion:SetOrigin(pos)
	explosion:SetNormal(norm)
	explosion:SetMagnitude(3)
	explosion:SetScale(3)
	explosion:SetRadius(3)
	util.Effect("Sparks", explosion)
	util.Effect("ss2_explosion_grenade", explosion)

	local trace = util.TraceLine({start = self:GetPos() + Vector(0,10,0), endpos = self:GetPos() - Vector(0,0,32), filter=self})
	util.Decal("Scorch", trace.HitPos + trace.HitNormal, trace.HitPos - trace.HitNormal)
	
	self:EmitSound("serioussam2/explosions/explosion0"..math.random(1,7)..".wav", 400, 100, 1, CHAN_ITEM)
	local owner = self.Owner
	if IsValid(owner) then
		util.BlastDamage(self, owner, pos, 256, self.BlastDamage)
	end
	self:Remove()
end

function ENT:StartTouch(ent)
	if self:IsCreature(ent) or ent:Health() > 0 then
 		self:DoDirectDamage(ent, self.Damage, self.Owner)
		self:Explode(ent:GetPos())
	end
end

function ENT:ReducePlayerDamage(ent, dmginfo)
	local inflictor = dmginfo:GetInflictor()
	if inflictor != self or game.SinglePlayer() then return end
	if IsValid(ent) and IsValid(inflictor) and ent:IsPlayer() then
		dmginfo:ScaleDamage(.5)
	end
end