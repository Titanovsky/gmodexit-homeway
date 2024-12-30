
if CLIENT then

	SWEP.PrintName			= "MK IV Grenade Launcher"
	SWEP.Author				= "Upset"
	SWEP.Slot				= 3
	SWEP.SlotPos			= 1
	SWEP.ViewModelFOV		= 35
	-- SWEP.UpAngle			= 5.25
	SWEP.SBobScale			= .9
	SWEP.WepIcon			= surface.GetTextureID("interface/weaponicons/grenadelauncher")
	
end

function SWEP:PrimaryAttack()	
	if !self:CanPrimaryAttack() or self:GetAttackDelay() > 0 then return end

	if self.Owner:IsNPC() then
		if self:GetNextPrimaryFire() <= CurTime() then
			self:SetNextPrimaryFire(CurTime() + self.Primary.Delay * 1.5)
			self:WeaponSound(self.Primary.Sound)
			self:TakeAmmo(1)
			self:SeriousFlash()
			if SERVER then
				local pos = self.Owner:GetShootPos()
				local ang = self.Owner:GetAimVector():Angle()
				pos = pos -ang:Up() *6 -ang:Right() *2
				local ent = ents.Create("ss2_grenade")
				ent:SetPos(pos)
				ent:SetAngles(ang)
				ent:SetEntityOwner(self.Owner)
				ent:SetExplodeDelay(2.5)
				ent:SetDamage(self.Primary.Damage, self.Primary.BlastDamage)
				ent:Spawn()
				ent:Activate()
				ent:SetModelScale(.75, 0)
				local phys = ent:GetPhysicsObject()
				if IsValid(phys) then
					phys:AddGameFlag(FVPHYSICS_NO_IMPACT_DMG)
					local vel = ang:Forward() * 800
					phys:SetVelocity(vel)
				end
				ent:EmitSound(self.Primary.Special1, 85, 100, 1, CHAN_ITEM)
			end
		end
		return
	end

	self:SendWeaponAnim(ACT_VM_PRIMARYATTACK_1)
	if !self.ChargeSound then
		self.ChargeSound = CreateSound(self.Owner, self.Primary.Special)
		self.ChargeSound:SetSoundLevel(85)
	end
	if self.ChargeSound and !self.ChargeSound:IsPlaying() then
		self.ChargeSound:Play()
	end
	self:SetAttackDelay(CurTime() + .55)
	self:SetIdleDelay(0)
	self:SetFidgetDelay(0)
end

function SWEP:SpecialThink()
	if game.SinglePlayer() and CLIENT then return end
	if self:GetAttackDelay() > 0 and (!self.Owner:KeyDown(IN_ATTACK) or self:GetAttackDelay() <= CurTime()) then
		local charge = (CurTime()+2.45 - self:GetAttackDelay())/2
		self:SetNextPrimaryFire(CurTime() + self.Primary.Delay * charge)
		self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
		self.Owner:SetAnimation(PLAYER_ATTACK1)
		self:WeaponSound(self.Primary.Sound)
		self:TakeAmmo(1)
		self:SeriousFlash()
		self:IdleStuff()
		if SERVER then
			local pos = self.Owner:GetShootPos()
			local ang = self.Owner:GetAimVector():Angle()
			local damage = math.Clamp(self.Primary.Damage * charge, self.Primary.Damage, self.Primary.Damage + 8)
			damage = math.Round(damage)
			pos = pos +ang:Forward() *3 -ang:Up() *6 +ang:Right() *4.5
			local ent = ents.Create("ss2_grenade")
			ent:SetPos(pos)
			ent:SetAngles(ang)
			ent:SetEntityOwner(self.Owner)
			ent:SetExplodeDelay(2.5)
			ent:SetDamage(damage, self.Primary.BlastDamage)
			ent:Spawn()
			ent:Activate()
			local phys = ent:GetPhysicsObject()
			if IsValid(phys) then
				phys:AddGameFlag(FVPHYSICS_NO_IMPACT_DMG)
				local vel = ang:Forward() * 800 * (CurTime()+.85 - self:GetAttackDelay())*3
				phys:SetVelocity(vel)
			end
			ent:EmitSound(self.Primary.Special1, 85, 100, 1, CHAN_ITEM)
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

function SWEP:SeriousFlash()
	if !IsFirstTimePredicted() or !IsValid(self.Owner) or self.Owner:WaterLevel() == 3 then return end
	local fx = EffectData()
	fx:SetEntity(self)
	fx:SetSurfaceProp(0)
	fx:SetOrigin(self.Owner:GetShootPos())
	fx:SetNormal(self.Owner:GetAimVector())
	fx:SetAttachment(1)
	for i = 0, 8 do
		util.Effect("ss2_mflashsmoke", fx)
	end
end

SWEP.HoldType			= "crossbow"
SWEP.Base				= "weapon_ss2_base"
SWEP.Category			= "Serious Sam 2"
SWEP.Spawnable			= true

SWEP.ViewModel			= Model("models/serioussam2/weapons/v_grenadelauncher.mdl")
SWEP.WorldModel			= Model("models/serioussam2/weapons/w_grenadelauncher.mdl")

SWEP.Primary.Sound			= Sound("serioussam2/weapons/grenadelauncher/grenadelauncher_fire04.wav")
SWEP.Primary.Special		= Sound("serioussam2/weapons/grenadelauncher/grenadelauncher_charge04.wav")
SWEP.Primary.Special1		= Sound("serioussam2/weapons/grenadelauncher/grenadelauncher_grenadecountdown04.wav")
SWEP.Primary.Damage			= 35
SWEP.Primary.BlastDamage	= 100
SWEP.Primary.Delay			= .35
SWEP.Primary.DefaultClip	= 10
SWEP.Primary.Ammo			= "Grenade"

SWEP.MuzzleScale			= 20
SWEP.SmokeType				= 2