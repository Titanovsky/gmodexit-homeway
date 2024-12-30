
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

ENT.Model = Model("models/serioussam2/projectiles/klodovik.mdl")
ENT.FlySound = Sound("serioussam2/weapons/common/flying16.wav")

function ENT:PhysInit()
	local size = 10
	local mins, maxs = Vector(-size, -size, -size), Vector(size, size, size)
	self:PhysicsInitBox(mins, maxs)
	self:SetCollisionGroup(COLLISION_GROUP_PROJECTILE)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_CUSTOM)
	self:DrawShadow(false)
	
	local phys = self:GetPhysicsObject()
	if IsValid(phys) then
		phys:AddGameFlag(FVPHYSICS_NO_IMPACT_DMG)
		phys:Wake()
		phys:SetMass(30)
		phys:EnableDrag(false)
		phys:EnableGravity(false)
		phys:SetBuoyancyRatio(1)
	end
	
	self:SetNewAngle(self:GetAngles())
	
	self.particleDelay = CurTime() +.12
end

function ENT:SetSpeed(speed)
	self.Speed = speed
end

function ENT:StartTouch(ent)
	if self:IsCreature(ent) then
		self:DoDirectDamage(ent, self.Damage, self.Owner)
		self:Explode(ent:GetPos())
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
	util.Effect("ss2_explosion_klodovik", explosion)
	
	local feathers = EffectData()
	feathers:SetOrigin(self:GetPos())
	util.Effect("ss2_feathers", feathers)
	
	self:EmitSound("serioussam2/explosions/explosion0"..math.random(1,7)..".wav", 400)
	local owner = self.Owner
	if IsValid(owner) then
		util.BlastDamage(self, owner, pos, 400, self.BlastDamage)
	end
	self:Remove()
end

local targets = {}

function ENT:FindTarget()
	table.Empty(targets)
	local ents = ents.FindInSphere(self:GetPos() + self:GetNewAngle():Forward() * 980, 768)
	for k,v in pairs(ents) do
		if IsValid(v) and v:IsNPC() and v:Disposition(self.Owner) != D_LI and v:GetClass() != "hornet" and v:WaterLevel() < 2 then
			local tr = util.TraceHull({
				start = self:GetPos(),
				endpos = v:GetPos(),
				filter = {self, self.Owner}
			})
			local target = tr.Entity
			if IsValid(target) and target:IsNPC() then
				table.insert(targets, {ent = target, pos = self:GetPos():Distance(target:GetPos())})
				//target:SetSchedule(SCHED_RUN_FROM_ENEMY)
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

function ENT:SpecialThink()
	if self.particleDelay and self.particleDelay <= CurTime() then
		self.particleDelay = nil
		local feathers = EffectData()
		feathers:SetOrigin(self:GetPos())
		util.Effect("ss2_feathers", feathers)
	end	
	
	if self.Target and IsValid(self.Target) and self.Target:Health() > 0 and self.Target:WaterLevel() < 2 and self:Visible(self.Target) then
		local targetangle = (self.Target:GetPos() - self:GetPos() + (self.Target:OBBMins() + self.Target:OBBMaxs()) *.5):Angle()
		self:SetAngles(targetangle)
		local phys = self:GetPhysicsObject()
		if IsValid(phys) then
			phys:SetVelocity(self:GetForward() * self.Speed)
		end
		self:SetHasTarget(true)
		self:SetNewAngle(targetangle)
	else
		self:FindTarget()
	end
end