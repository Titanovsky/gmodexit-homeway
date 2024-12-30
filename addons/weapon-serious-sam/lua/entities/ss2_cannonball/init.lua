AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

ENT.Model = Model("models/serioussam2/projectiles/cannonball.mdl")
ENT.FlySound = Sound("serioussam2/weapons/common/flying06.wav")

function ENT:PhysInit()
	self:PhysicsInitSphere(32)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
end

function ENT:PhysCollide(data, phys)
	if data.HitNormal[3] < 0 and data.HitEntity:GetClass() == "worldspawn" then
		self.EnableFriction = true
	end
	if IsValid(data.HitEntity) and !(data.HitEntity:IsNPC() or data.HitEntity:IsPlayer()) then
		local entphys = data.HitEntity:GetPhysicsObject()
		if IsValid(entphys) then
			entphys:ApplyForceOffset(phys:GetVelocity() * entphys:GetMass(), data.HitPos)
		end
	end
end

function ENT:PhysicsUpdate(phys)
	local tr = util.TraceHull({
		start = self:GetPos(),
		endpos = self:GetPos(),
		filter = self,
		mins = self:OBBMins()*1.05,
		maxs = self:OBBMaxs()*1.05
	})

	if self.EnableFriction and tr.HitWorld then
		local vel = phys:GetVelocity()
		local length = vel:Length2D()
		local friction = -vel:GetNormalized()*length/64
		phys:AddVelocity(friction)
	end
end

function ENT:Explode(exppos)
	local pos = self:GetPos()
	local norm
	exppos = exppos or pos
	
	pos, norm = self:DoTrace(pos, exppos)

	local effectdata = EffectData()
	effectdata:SetOrigin(pos)
	effectdata:SetScale(3)
	util.Effect("ss2_explosion_wave", effectdata)
	
	local explosion = EffectData()
	explosion:SetOrigin(pos)
	explosion:SetNormal(norm)
	explosion:SetMagnitude(3)
	explosion:SetScale(3)
	explosion:SetRadius(3)
	util.Effect("Sparks", explosion)
	util.Effect("ss2_explosion_cannonball", explosion)
	
	self:EmitSound("serioussam2/explosions/explosionhuge01.wav", 500)
	local owner = self.Owner
	if IsValid(owner) then
		util.BlastDamage(self, owner, pos, 350, self.Damage)
	end
	self:Remove()
end

local gibableNPCs = {
	["npc_fastzombie"] = true,
	["npc_fastzombie_torso"] = true,
	["npc_poisonzombie"] = true,
	["npc_zombie"] = true,
	["npc_zombie_torso"] = true,
	["npc_zombine"] = true,
	["npc_citizen"] = true,
	["npc_magnusson"] = true,
	["npc_kleiner"] = true,
	["npc_eli"] = true,
	["npc_breen"] = true,
	["npc_combine_s"] = true,
	["npc_metropolice"] = true,
	["npc_stalker"] = true
}

local hlsNPCs = {
	["monster_alien_grunt"] = true,
	["monster_alien_slave"] = true,
	["monster_human_assassin"] = true,
	["monster_bullchicken"] = true,
	["monster_alien_controller"] = true,
	["monster_human_grunt"] = true,
	["monster_headcrab"] = true,
	["monster_houndeye"] = true,
	["monster_scientist"] = true,
	["monster_barney"] = true,
	["monster_zombie"] = true
}

function ENT:StartTouch(ent)
	if IsValid(ent) then
		local entclass = ent:GetClass()
		if self:GetClass() == entclass then
			self:Explode()
		elseif ent:Health() > 0 then
			if ent:GetMaxHealth() >= 500 or self:GetVelocity():Length() < 180 or ent:IsPlayer() or ent == self.Owner then
				self:Explode(ent:GetPos())
			else
				local dmginfo = DamageInfo()
				dmginfo:SetAttacker(self.Owner)
				dmginfo:SetInflictor(self)
				dmginfo:SetDamage(self.Damage)
				if cvars.Bool("ss2_sv_cannonball_gib") then
					local gibSound = "serioussam2/explosions/Splat0"..math.random(1,3)..".wav", 85, math.random(90, 110)
					if gibableNPCs[entclass] then
						dmginfo:SetDamageType(DMG_REMOVENORAGDOLL)
						local effectdata = EffectData()
						effectdata:SetOrigin(ent:GetPos())
						effectdata:SetNormal(dmginfo:GetDamageForce())
						effectdata:SetEntity(self)
						util.Effect("ss2_gib_emitter", effectdata)
						ent:EmitSound(gibSound)
					elseif hlsNPCs[entclass] then
						dmginfo:SetDamageType(DMG_ALWAYSGIB)
						ent:EmitSound(gibSound)
					end
				end
				ent:TakeDamageInfo(dmginfo)
			end
		end
	end
end