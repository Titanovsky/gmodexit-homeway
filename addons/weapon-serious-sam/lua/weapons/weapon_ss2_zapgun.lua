
if CLIENT then

	SWEP.PrintName			= "Zap Gun"
	SWEP.Author				= "Upset"
	SWEP.Slot				= 1
	SWEP.SlotPos			= 0
	SWEP.ViewModelFOV		= 35
	-- SWEP.UpAngle			= 0
	SWEP.SBobScale			= .75
	SWEP.WepIcon			= surface.GetTextureID("interface/weaponicons/zapgun")
	
end

function SWEP:PrimaryAttack()
	if self.Owner:IsNPC() then
		if self:GetNextPrimaryFire() <= CurTime() then
			self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
			self:WeaponSound(self.Primary.Sound)
			if SERVER then
				local pos = self.Owner:GetShootPos()
				local ang = self.Owner:GetAimVector():Angle()
				pos = pos +ang:Right() *4
				local ent = ents.Create("ss2_plasmaball")
				ent:SetPos(pos)
				ent:SetAngles(ang)
				ent:SetOwner(self.Owner)
				ent:SetDamage(self.Primary.Damage)
				ent.Collision = 1
				ent.Speed = 800
				ent:Spawn()
				ent:Activate()
				local phys = ent:GetPhysicsObject()
				if IsValid(phys) then
					phys:SetVelocity(ang:Forward() * ent.Speed)
				end
			end
		end
		return
	end

	if self:GetAttackDelay() > 0 or self:GetHolster() then return end
	self:SendWeaponAnim(ACT_VM_PRIMARYATTACK_1)
	if !self.ChargeSound then
		self.ChargeSound = CreateSound(self.Owner, self.Primary.Special)
		self.ChargeSound:SetSoundLevel(85)
	end
	if self.ChargeSound and !self.ChargeSound:IsPlaying() then
		self.ChargeSound:Play()
	end
	self:SetAttackDelay(CurTime() + 1.15)
	self:SetIdleDelay(0)
end

function SWEP:SpecialThink()
	if game.SinglePlayer() and CLIENT then return end
	if self:GetAttackDelay() > 0 and (!self.Owner:KeyDown(IN_ATTACK) or self:GetAttackDelay() <= CurTime()) then
		local charge = (CurTime()+1.33 - self:GetAttackDelay())*4.26
		self:SetNextPrimaryFire(CurTime() + self.Primary.Delay + charge/18)
		self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
		self.Owner:GetViewModel():SetPlaybackRate(math.min(math.Round(1.1-charge/20, 2), 1))
		self.Owner:SetAnimation(PLAYER_ATTACK1)
		self:WeaponSound(self.Primary.Sound)
		self:IdleStuff()
		if SERVER then
			local tr = self.Owner:GetEyeTraceNoCursor()
			local target = tr.Entity
			local pos = self.Owner:GetShootPos()
			local ang = self.Owner:GetAimVector():Angle()
			local damage = math.Clamp(self.Primary.Damage * charge, self.Primary.Damage, 80)
			damage = math.Round(damage)
			pos = pos +ang:Forward() *2 -ang:Up() *2 +ang:Right() *2
			local ent = ents.Create("ss2_plasmaball")
			ent:SetPos(pos)
			ent:SetAngles(ang)
			ent:SetOwner(self.Owner)
			ent:SetDamage(damage)
			ent.Collision = math.Round(charge)
			ent.Speed = 800 * math.Round((1.905 - CurTime() + self:GetAttackDelay())/3, 2)
			ent.Target = IsValid(target) and target:IsNPC() and target
			ent:Spawn()
			ent:Activate()
			local phys = ent:GetPhysicsObject()
			if IsValid(phys) then
				phys:SetVelocity(ang:Forward() * ent.Speed)
			end
		end
		self:HolsterDelay()
		self:OnRemove()
	end
end

function SWEP:OnRemove()
	if self.ChargeSound then self.ChargeSound:Stop() end
	self:SpecialHolster()
end

function SWEP:SpecialHolster()
	self:SetAttackDelay(0)
end

SWEP.HoldType			= "pistol"
SWEP.Base				= "weapon_ss2_base"
SWEP.Category			= "Serious Sam 2"
SWEP.Spawnable			= true

SWEP.ViewModel			= Model("models/serioussam2/weapons/v_zapgun.mdl")
SWEP.WorldModel			= Model("models/serioussam2/weapons/w_zapgun.mdl")

SWEP.Primary.Sound			= Sound("serioussam2/weapons/zapgun/zapgun_fire13.wav")
SWEP.Primary.Special		= Sound("serioussam2/weapons/zapgun/zapgun_charge06.wav")
SWEP.Primary.Damage			= 14
SWEP.Primary.Delay			= .2