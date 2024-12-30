
if CLIENT then

	SWEP.PrintName			= "XM-214-A Minigun"
	SWEP.Author				= "Upset"
	SWEP.Slot				= 2
	SWEP.SlotPos			= 3
	SWEP.ViewModelFOV		= 54
	-- SWEP.UpAngle			= 4.5
	SWEP.WepIcon			= surface.GetTextureID("interface/weaponicons/minigun")
	
end

function SWEP:SpecialDeploy()
	self:SetAttackDelay(2)
end

function SWEP:PrimarySoundStart()
	if !self.LoopSound then
		self.LoopSound = CreateSound(self.Owner, self.Primary.Special1)
	end
	if self.LoopSound and !self.LoopSound:IsPlaying() then
		self.LoopSound:Play()
	end
end

function SWEP:PrimaryAttack()
	if !self:CanPrimaryAttack() then return end
	
	if self.Owner:IsNPC() then
		if self:GetNextPrimaryFire() <= CurTime() then
			self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
			self:WeaponSound(self.Primary.Sound)
			self:SeriousFlash()
			self:ShootBullet(self.Primary.Damage, self.Primary.NumShots, self.Primary.Cone)
		end
		return
	end
	
	if !self:GetAttack() then
		self:EmitSound(self.Primary.Special3, 75, 100, 1, CHAN_ITEM)
		self:EmitSound(self.Primary.Special)
		self:SetAttack(true)
	end	

	if self:GetAttackDelay() >= self.BarrelAccelTime then
		self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
		self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
		self.Owner:SetAnimation(PLAYER_ATTACK1)
		self:PrimarySoundStart()
		self:WeaponSound(self.Primary.Sound)
		self:ShootBullet(self.Primary.Damage, self.Primary.NumShots, self.Primary.Cone)
		self:SeriousFlash()
		self:TakeAmmo(self.AmmoToTake)
	end
end

if SERVER then
	function SWEP:NPCShoot_Primary(ShootPos, ShootDir)
		local owner = self:GetOwner()
		if !IsValid(owner) then return end
		timer.Create("SS2MinigunNPCAttack"..self.Owner:EntIndex(), self.Primary.Delay, 5, function()
			if !owner or !IsValid(owner) then return end
			self:PrimaryAttack()
			self:EmitSound(self.Primary.Special2, 75, 100, 1, CHAN_ITEM)
		end)
	end
end

function SWEP:SpecialThink()
	if game.SinglePlayer() and CLIENT then return end
	if self.Owner:KeyReleased(IN_ATTACK) or self:GetAmmo() <= 0 then
		if self:GetAttack() then
			self:EmitSound(self.Primary.Special, 75, 100, 1, CHAN_AUTO)
			self:EmitSound(self.Primary.Special2, 75, 100, 1, CHAN_ITEM)
			self:SetIdleDelay(CurTime() +.05)
		end
		if self.LoopSound then self.LoopSound:Stop() end
		self:SetAttack(nil)
	end	
	
	local attdelay = self:GetAttackDelay()
	if self.Owner:KeyDown(IN_ATTACK) and self:GetAmmo() > 0 then
		self:SetAttackDelay(math.Clamp(attdelay^1.025, 2, self.BarrelAccelTime))
	else
		self:SetAttackDelay(math.Clamp(attdelay^.992, 2, self.BarrelAccelTime))
	end
end

function SWEP:ResetBones()
	local owner = self.Owner
	if CLIENT then
		if IsValid(self) and IsValid(owner) and owner and owner:IsPlayer() then
			local vm = owner:GetViewModel()
			if IsValid(vm) then
				vm:ManipulateBoneAngles(3, Angle(0, 0, 0))
			end
		end
	end
end

function SWEP:SpecialHolster()
	self:OnRemove()
end

function SWEP:OnRemove()
	if self.LoopSound then self.LoopSound:Stop() end
	self:SetAttack(nil)
	self:ResetBones()
end

if CLIENT then

	local lastpos = 0
	local speed = 4

	function SWEP:ViewModelDrawn(vm)
		local bone = vm:LookupBone("Barrels")
		if !bone then return end
		local attack = lastpos+self:GetAttackDelay()-2
		lastpos = Lerp(FrameTime()*40, lastpos, attack)
		local rotate = (attack*speed) %360
		vm:ManipulateBoneAngles(bone, Angle(0,rotate,0))
	end

	function SWEP:DrawWorldModel()
		self:DrawModel()
		if !IsValid(self:GetOwner()) or self:GetOwner():IsNPC() then return end
		local bone = self:LookupBone("Barrels")
		if !bone then return end
		local lastpos_w = self:GetVar("lastpos_w"..self:EntIndex(), 0)
		local attack = lastpos_w + self:GetAttackDelay() - 2
		self:SetVar("lastpos_w"..self:EntIndex(), Lerp(FrameTime()*40, lastpos_w, attack))
		local rotate = (attack*speed) %360
		self:ManipulateBoneAngles(bone, Angle(-rotate,0,0))
	end

end

SWEP.HoldType			= "shotgun"
SWEP.Base				= "weapon_ss2_base"
SWEP.Category			= "Serious Sam 2"
SWEP.Spawnable			= true

SWEP.ViewModel			= Model("models/serioussam2/weapons/v_minigun.mdl")
SWEP.WorldModel			= Model("models/serioussam2/weapons/w_minigun.mdl")

SWEP.Primary.Sound			= Sound("serioussam2/weapons/minigun/minigun_fireloop04.wav")
SWEP.Primary.Special		= Sound("serioussam2/weapons/minigun/minigun_click04.wav")
SWEP.Primary.Special1		= Sound("serioussam2/weapons/minigun/minigun_spin.wav")
SWEP.Primary.Special2		= Sound("serioussam2/weapons/minigun/minigun_spindown.wav")
SWEP.Primary.Special3		= Sound("serioussam2/weapons/minigun/minigun_spinup.wav")
SWEP.Primary.Cone			= .04
SWEP.Primary.Delay			= .07
SWEP.Primary.DefaultClip	= 100
SWEP.Primary.Ammo			= "smg1"

SWEP.BarrelAccelTime		= 5		// must be higher than 2, integers only

SWEP.MuzzleScale			= 24