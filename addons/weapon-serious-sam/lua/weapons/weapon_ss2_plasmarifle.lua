
if CLIENT then

	SWEP.PrintName			= "XL 808 Plasma Rifle"
	SWEP.Author				= "Upset"
	SWEP.Slot				= 3
	SWEP.SlotPos			= 2
	SWEP.ViewModelFOV		= 63
	-- SWEP.UpAngle			= -7.5
	SWEP.SBobScale			= .8
	SWEP.WepIcon			= surface.GetTextureID("interface/weaponicons/plasmarifle")
	
end

game.AddDecal("ss2plasmadecal", "decals/dark")

function SWEP:PrimaryAttack()
	if self.Owner:IsNPC() and self:GetNextPrimaryFire() > CurTime() then return end

	if !self:CanPrimaryAttack() then return end
	self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
	self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
	self.Owner:SetAnimation(PLAYER_ATTACK1)
	self:WeaponSound(self.Primary.Sound)
	self:TakeAmmo(1)
	if SERVER then
		local pos = self.Owner:GetShootPos()
		local ang = self.Owner:GetAimVector():Angle()
		pos = pos +ang:Forward() *2 +ang:Right() *1 +ang:Up() *-4
		local ent = ents.Create("ss2_plasma")
		ent:SetAngles(ang)
		ent:SetPos(pos)
		ent:SetOwner(self.Owner)
		ent:SetDamage(self.Primary.Damage)
		ent:Spawn()
		ent:Activate()
		local phys = ent:GetPhysicsObject()
		if IsValid(phys) then
			phys:SetVelocity(ang:Up() *2 +ang:Forward() *1400 -ang:Right() *1)
		end
	end
	self:SeriousFlash()
	self:IdleStuff()
	self:HolsterDelay()
end

function SWEP:SeriousFlash()
	if !IsFirstTimePredicted() then return end
	local fx = EffectData()
	fx:SetEntity(self)
	fx:SetOrigin(self.Owner:GetShootPos())
	fx:SetNormal(self.Owner:GetAimVector())
	fx:SetAttachment(1)
	fx:SetScale(16)
	util.Effect("ss2_mflash_plasma", fx)
end

if SERVER then
	function SWEP:NPCShoot_Primary(ShootPos, ShootDir)
		local owner = self:GetOwner()
		if !IsValid(owner) then return end
		timer.Create("SS2PlasmaNPCAttack"..self.Owner:EntIndex(), self.Primary.Delay, 2, function()
			if !owner or !IsValid(owner) then return end
			self:PrimaryAttack()
		end)
	end
end

SWEP.HoldType			= "crossbow"
SWEP.Base				= "weapon_ss2_base"
SWEP.Category			= "Serious Sam 2"
SWEP.Spawnable			= true

SWEP.ViewModel			= Model("models/serioussam2/weapons/v_plasmarifle.mdl")
SWEP.WorldModel			= Model("models/serioussam2/weapons/w_plasmarifle.mdl")

SWEP.Primary.Sound			= Sound("serioussam2/weapons/plasmarifle/plasmarifle_fire03.wav")
SWEP.Primary.Damage			= 35
SWEP.Primary.Delay			= .15
SWEP.Primary.DefaultClip	= 50
SWEP.Primary.Ammo			= "ar2"