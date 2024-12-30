
if CLIENT then

	SWEP.PrintName			= "Klodovik"
	SWEP.Author				= "Upset"
	SWEP.Slot				= 4
	SWEP.SlotPos			= 1
	SWEP.ViewModelFOV		= 63
	-- SWEP.UpAngle			= 10
	SWEP.SBobScale			= .7
	SWEP.WepIcon			= surface.GetTextureID("interface/weaponicons/klodovik")
	
end

function SWEP:SpecialInit()
	self:SetSolid(SOLID_NONE)
	if CLIENT then
		self.OriginPos = self:GetPos()
		self.Rotate = 0
		self.RotateTime = RealTime()
		self:SetModelScale(1.5, 0)
	end
end

function SWEP:OnDrop()
	if CLIENT then
		self.OriginPos = self:GetPos()
	end
end

function SWEP:DrawWorldModel()
	self:DrawModel()
	if IsValid(self:GetOwner()) then return end
	self:SetRenderOrigin(self.OriginPos + Vector(0,0,math.sin(RealTime() * 3) *6))
	self.Rotate = (RealTime() - self.RotateTime)*140 %360
	self:SetRenderAngles(Angle(0,-self.Rotate,0))
end

function SWEP:PrimaryAttack()
	if self.Owner:IsNPC() and self:GetNextPrimaryFire() > CurTime() then return end

	if !self:CanPrimaryAttack() then return end	
	self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
	self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
	self.Owner:SetAnimation(PLAYER_ATTACK1)
	self:WeaponSound()
	self:TakeAmmo(1)
	if SERVER then
		local target = IsValid(self.Owner) and !self.Owner:IsNPC() and self.Owner:GetEyeTraceNoCursor().Entity
		local pos = self.Owner:GetShootPos()
		local ang = self.Owner:GetAimVector():Angle()
		pos = pos +ang:Forward() *-20 +ang:Right() *1 -ang:Up() *2
		local ent = ents.Create("ss2_klodovik")
		ent:SetAngles(ang)
		ent:SetPos(pos)
		ent:SetEntityOwner(self.Owner)
		ent:SetExplodeDelay(6)
		ent:SetDamage(self.Primary.Damage, self.Primary.BlastDamage)
		ent:SetSpeed(self.ProjectileSpeed)
		ent.Target = IsValid(target) and target:IsNPC() and target
		ent:Spawn()
		ent:Activate()
		local phys = ent:GetPhysicsObject()
		if IsValid(phys) then
			phys:SetVelocity(ang:Forward() *ent.Speed)
		end
	end
	self:HolsterDelay()
	self:IdleStuff()
end

SWEP.HoldType			= "slam"
SWEP.Base				= "weapon_ss2_base"
SWEP.Category			= "Serious Sam 2"
SWEP.Spawnable			= true

SWEP.ViewModel			= Model("models/serioussam2/weapons/v_klodovik.mdl")
SWEP.WorldModel			= Model("models/serioussam2/weapons/w_klodovik.mdl")

SWEP.FireSounds = {
	Sound("serioussam2/weapons/clawdovic/clawdovic_fire01.wav"),
	Sound("serioussam2/weapons/clawdovic/clawdovic_fire02.wav")
}

SWEP.Primary.Damage			= 600
SWEP.Primary.BlastDamage	= 100
SWEP.Primary.Delay			= 1
SWEP.Primary.DefaultClip	= 1
SWEP.Primary.Ammo			= "klodovik"

SWEP.ProjectileSpeed		= 512

SWEP.EnableDrySound			= false
SWEP.HideWhenEmpty			= true