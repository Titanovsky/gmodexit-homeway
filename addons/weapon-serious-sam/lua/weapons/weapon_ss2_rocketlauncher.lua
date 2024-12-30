
if CLIENT then

	SWEP.PrintName			= "XPML30 Rocket Launcher"
	SWEP.Author				= "Upset"
	SWEP.Slot				= 3
	SWEP.SlotPos			= 0
	SWEP.ViewModelFOV		= 46
	-- SWEP.UpAngle			= 2.2
	SWEP.WepIcon			= surface.GetTextureID("interface/weaponicons/rocketlauncher")
	
end

function SWEP:PrimaryAttack()
	if self.Owner:IsNPC() and self:GetNextPrimaryFire() > CurTime() then return end

	if !self:CanPrimaryAttack() then return end
	self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
	self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
	self.Owner:SetAnimation(PLAYER_ATTACK1)
	self:WeaponSound(self.Primary.Sound)
	self:WeaponSound(self.Primary.Special, 100, CHAN_AUTO)
	self:TakeAmmo(1)
	self:SeriousFlash()
	self:IdleStuff()	
	if SERVER then
		local pos = self.Owner:GetShootPos()
		local ang = self.Owner:GetAimVector():Angle()
		pos = pos +ang:Right() *4 +ang:Up() *-5
		local ent = ents.Create("ss2_rocket")
		ent:SetAngles(ang)
		ent:SetPos(pos)
		ent:SetOwner(self.Owner)
		ent:SetDamage(self.Primary.Damage, self.Primary.BlastDamage)
		ent:Spawn()
		ent:Activate()
		local phys = ent:GetPhysicsObject()
		if IsValid(phys) then
			phys:SetVelocity(ang:Forward() *1100)
		end
	end
	self:HolsterDelay()
end

SWEP.HoldType			= "crossbow"
SWEP.Base				= "weapon_ss2_base"
SWEP.Category			= "Serious Sam 2"
SWEP.Spawnable			= true

SWEP.ViewModel			= Model("models/serioussam2/weapons/v_rocketlauncher.mdl")
SWEP.WorldModel			= Model("models/serioussam2/weapons/w_rocketlauncher.mdl")

SWEP.Primary.Sound			= Sound("serioussam2/weapons/rocketlauncher/rocketlauncher_fire03.wav")
SWEP.Primary.Special		= Sound("serioussam2/weapons/rocketlauncher/rocketlauncher_initialfire02.wav")
SWEP.Primary.Damage			= 50
SWEP.Primary.BlastDamage	= 80
SWEP.Primary.Delay			= .6
SWEP.Primary.DefaultClip	= 8
SWEP.Primary.Ammo			= "RPG_Round"

SWEP.MuzzleScale			= 64
SWEP.SmokeType				= 2