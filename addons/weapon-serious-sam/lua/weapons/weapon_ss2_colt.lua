
if CLIENT then

	SWEP.PrintName			= "Colt Anaconda"
	SWEP.Author				= "Upset"
	SWEP.Slot				= 1
	SWEP.SlotPos			= 1
	SWEP.ViewModelFOV		= 45
	-- SWEP.UpAngle			= 2.5
	SWEP.SBobScale			= .7
	SWEP.WepIcon 			= surface.GetTextureID("interface/weaponicons/colt")
	
end

function SWEP:SpecialInit()
	self:SetAmmo1(self.Primary.ClipSize)
	self:SetAmmo2(self.Primary.ClipSize)
end

function SWEP:PrimaryAttack()
	if self.Owner:IsNPC() then
		if self:GetNextPrimaryFire() <= CurTime() then
			self:SetNextPrimaryFire(CurTime() + self.Primary.Delay / 2)
			self:WeaponSound(self.Primary.Sound)
			self:SeriousFlash()
			self:ShootBullet(self.Primary.Damage, self.Primary.NumShots, self.Primary.Cone, 4)
		end
		return
	end

	if self:GetHolster() then return end
	if self.Akimbo then
		if self:GetShot() == 0 then
			self:SetShot(1)
			if self:GetNextAkimboFireA() >= CurTime() or self:GetAmmo1() <= 0 then return end
			self:SetNextAkimboFireA(CurTime() + self.Primary.Delay)
			self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
			self:ShootBullet(self.Primary.Damage, self.Primary.NumShots, self.Primary.Cone, 4)
			self:SeriousFlash()
			self:IdleStuff(1)
			self:Attack()
			self:SetAmmo1(self:GetAmmo1() - 1)
		else
			self:SetShot(0)
			if self:GetNextAkimboFireB() >= CurTime() or self:GetAmmo2() <= 0 then return end
			self:SetNextAkimboFireB(CurTime() + self.Primary.Delay)
			self:SendSecondWeaponAnim(ACT_VM_PRIMARYATTACK)
			self:ShootBullet(self.Primary.Damage, self.Primary.NumShots, self.Primary.Cone, -4)
			self:SeriousFlash(1)
			self:IdleStuff(2)
			self:Attack()
			self:SetAmmo2(self:GetAmmo2() - 1)
		end
	end
	self:SetNextPrimaryFire(CurTime() + self.Primary.Delay/2)
end

function SWEP:ShootBullet(dmg, numbul, cone, right)
	local pos = self.Owner:GetShootPos()
	local ang = self.Owner:GetAngles()
	local bullet = {}
	bullet.Num 		= numbul
	bullet.Src 		= pos + ang:Right() *right
	bullet.Dir 		= self.Owner:GetAimVector()
	bullet.Spread 	= Vector(cone, cone, 0)
	bullet.Tracer	= 1
	bullet.Force	= 4
	bullet.Damage	= dmg
	self.Owner:FireBullets(bullet)
end

function SWEP:Attack()
	self.Owner:SetAnimation(PLAYER_ATTACK1)
	self:WeaponSound(self.Primary.Sound)
end

function SWEP:AkimboReload(wep)
	if wep == 1 then
		self:SetNextAkimboFireA(CurTime() + 1)
		self:SendWeaponAnim(ACT_VM_RELOAD)
		self:SetAmmo1(self.Primary.ClipSize)
		self:IdleStuff(1)
	else
		self:SetNextAkimboFireB(CurTime() + 1)
		self:SendSecondWeaponAnim(ACT_VM_RELOAD)
		self:SetAmmo2(self.Primary.ClipSize)
		self:IdleStuff(2)
	end
	self:WeaponSound(self.ReloadSound, 75, CHAN_AUTO)
	self:HolsterDelay(CurTime() + .6)
end

function SWEP:SpecialThink()
	if game.SinglePlayer() and CLIENT then return end
	if self:GetAmmo1() <= 0 and self:GetNextAkimboFireA() <= CurTime() then
		self:AkimboReload(1)
	end
	if self:GetAmmo2() <= 0 and self:GetNextAkimboFireB() <= CurTime() then
		self:AkimboReload(2)
	end
end

SWEP.HoldType			= "duel"
SWEP.Base				= "weapon_ss2_base"
SWEP.Category			= "Serious Sam 2"
SWEP.Spawnable			= true

SWEP.ViewModel			= Model("models/serioussam2/weapons/v_colt.mdl")
SWEP.WorldModel			= Model("models/serioussam2/weapons/w_colt.mdl")

SWEP.FireSounds = {
	Sound("serioussam2/weapons/colt/colt_fire05.wav"),
	Sound("serioussam2/weapons/colt/colt_fire06.wav")
}

SWEP.Primary.Cone			= .01
SWEP.Primary.ClipSize		= 6
SWEP.Primary.Delay			= .45
SWEP.Primary.DefaultClip	= 6
SWEP.Primary.Damage			= 60

SWEP.ReloadSound			= Sound("serioussam2/weapons/colt/colt_reload03.wav")

SWEP.Akimbo					= true
SWEP.AkimboOffset = {
	Right = -.5,
	Forward	= 5.4,
	Up = 2.8,
}

SWEP.SmokeType				= 2