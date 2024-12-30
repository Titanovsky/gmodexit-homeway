
SWEP.PrintName			= 'Лазерный Резак'
SWEP.Author				= 'Homeway'
SWEP.Slot				= 3
SWEP.SlotPos			= 3
SWEP.ViewModelFOV		= 67

SWEP.HoldType			= "shotgun"
SWEP.Base				= "weapon_ss2_base"
SWEP.Category			= 'Homeway'
SWEP.Spawnable			= true

SWEP.ViewModel			= Model("models/serioussam2/weapons/v_beamgun.mdl")
SWEP.WorldModel			= Model("models/serioussam2/weapons/w_beamgun.mdl")

SWEP.Primary.SoundLoop		= Sound("serioussam2/weapons/beamgun/beamfire_loop.wav")
SWEP.Primary.SoundStart		= Sound("serioussam2/weapons/beamgun/beamfire_start.wav")
SWEP.Primary.SoundStop		= Sound("serioussam2/weapons/beamgun/beamfire_stop.wav")
SWEP.Primary.Damage			= 1 -- dunno actual dmg
SWEP.Primary.Delay			= .07 -- a bit faster than in SS2 but can't fix
SWEP.Primary.DefaultClip	= 100
SWEP.Primary.Ammo			= "ar2"

SWEP.BarrelAccelMax			= 1
SWEP.HitDist				= 200

SWEP.ImpactSounds = {
	--Sound("serioussam2/impacts/electric/impact_electric01.wav"),
	--Sound("serioussam2/impacts/electric/impact_electric03.wav")
}

function SWEP:SpecialDeploy()
	self:SetAttackDelay(0)
end

function SWEP:IsMaxSpin()
	return self:GetAttackDelay() >= self.BarrelAccelMax
end

function SWEP:PrimaryAttack()
	if !self:CanPrimaryAttack() then return end

	local tr = util.TraceLine({
		start = self.Owner:GetShootPos(),
		endpos = self.Owner:GetShootPos() + self.Owner:GetAimVector() * self.HitDist,
		filter = self.Owner
	})

	if not IsValid(tr.Entity) then return end
	if ( tr.Entity:GetClass() ~= 'rock' ) then return end

	if self:IsMaxSpin() then
		self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
		self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
		-- self.Owner:SetAnimation(PLAYER_ATTACK1)
		--self:TakeAmmo(self.AmmoToTake)
		
		if SERVER then self.Owner:LagCompensation(true) end

		if !IsValid(tr.Entity) then
			tr = util.TraceHull({
				start = self.Owner:GetShootPos(),
				endpos = self.Owner:GetShootPos() + self.Owner:GetAimVector() * self.HitDist,
				filter = self.Owner,
				-- mins = Vector(-4, -4, -4),
				-- maxs = Vector(4, 4, 4)
			})
		end
		
		if !self:GetAttack() then
			self:CreateBeam()
			--self:EmitSound(self.Primary.SoundStart, 100, 100, 1, CHAN_WEAPON)
			self:SetAttack(true)
		else
			--self:EmitSound(self.Primary.SoundLoop, 100, 100, 1, CHAN_WEAPON)
		end
		
		if tr.Hit and !tr.HitSky then
			if IsFirstTimePredicted() then
				-- local ef_hit = EffectData()
				-- ef_hit:SetOrigin(tr.HitPos)
				-- ef_hit:SetNormal(tr.HitNormal)
				-- util.Effect("ss2_lightning_hit", ef_hit)
				-- if tr.HitWorld then
				-- 	local sparks = EffectData()
				-- 	sparks:SetOrigin(tr.HitPos + tr.HitNormal * 2)
				-- 	sparks:SetNormal(tr.HitNormal)
				-- 	sparks:SetMagnitude(2)
				-- 	sparks:SetScale(1)
				-- 	sparks:SetRadius(2)
				-- 	sparks:SetColor( 4 )
				-- 	util.Effect("Sparks", sparks)
				-- end
				-- if IsValid(tr.Entity) then
				-- 	local tesla = EffectData()
				-- 	tesla:SetMagnitude(1)
				-- 	tesla:SetEntity(tr.Entity)
				-- 	util.Effect("TeslaHitboxes", tesla)
				-- end
			end
			if SERVER then
				--sound.Play(self.ImpactSounds[math.random(1,2)], tr.HitPos, 80, math.random(90,120))
				local dmginfo = DamageInfo()
				local attacker = self.Owner
				if !IsValid(attacker) then attacker = self end

				if IsValid( tr.Entity ) and ( tr.Entity:GetClass() ~= 'rock' ) then return end

				dmginfo:SetAttacker(attacker)
				dmginfo:SetInflictor(self)
				dmginfo:SetDamageType(bit.bor(DMG_SHOCK, DMG_AIRBOAT))
				dmginfo:SetDamage(self.Primary.Damage)
				dmginfo:SetDamageForce(self.Owner:GetUp() *2000 +self.Owner:GetForward() *20000)
				dmginfo:SetDamagePosition(tr.HitPos)
				tr.Entity:TakeDamageInfo(dmginfo)
			end
		else
			if IsFirstTimePredicted() then
				local ef_hit = EffectData()
				ef_hit:SetOrigin(tr.HitPos)
				util.Effect("ss2_lightning_nohit", ef_hit)
			end		
		end
		if SERVER then
			self.Owner:LagCompensation(false)
		end
	end
end

function SWEP:CreateBeam()
	if CLIENT then return end
	
	if self.entBeam and IsValid(self.entBeam) then return end
	
	self.entBeam = ents.Create("ss2_beam")
	local entBeam = self.entBeam
	if IsValid(entBeam) then
		entBeam:SetPos(self.Owner:GetShootPos())
		entBeam:SetAngles(self:GetAngles())
		entBeam:SetOwner(self.Owner)
		entBeam:SetParent(self)
		entBeam:SetWepEntity(self)
		entBeam:SetHitDist(self.HitDist)
		entBeam:Spawn()
	end
end

function SWEP:DestroyBeam()
	if self.entBeam and IsValid(self.entBeam) then
		self.entBeam:Remove()
	end
end

function SWEP:SpecialThink()
	if game.SinglePlayer() and CLIENT then return end

	
	if self:IsMaxSpin() and (!self.Owner:KeyDown(IN_ATTACK)) then
		--self:EmitSound(self.Primary.SoundStop, 100, 100, 1, CHAN_WEAPON)
		self:SetIdleDelay(CurTime() +.05)
		self:SetAttack(false)
		self:DestroyBeam()
	end
	
	local attdelay = self:GetAttackDelay()
	if self.Owner:KeyDown(IN_ATTACK) then
		self:SetAttackDelay(math.min(attdelay+.06, self.BarrelAccelMax))
	else
		self:SetAttackDelay(math.max(attdelay-.02, 0))
	end
end

function SWEP:ResetBones()
	local owner = self.Owner
	if CLIENT then
		if IsValid(self) and IsValid(owner) and owner and owner:IsPlayer() then
			local vm = owner:GetViewModel()
			if IsValid(vm) then
				vm:ManipulateBoneAngles(1, Angle(0, 0, 0))
			end
		end
	end
end

function SWEP:SpecialHolster()
	self:OnRemove()
end

function SWEP:OnRemove()
	self:SetAttack(false)
	--self:StopSound(self.Primary.SoundLoop)
	self:ResetBones()
end

if CLIENT then

	local spin = 0
	local spinSpeed = 300
	
	function SWEP:BoneSpin(bone, iswmodel)
		local FT = FrameTime()
		local speed = spinSpeed
		if self:IsMaxSpin() then
			speed = speed * 2.5
		end
		if iswmodel then
			if !self.WmodelSpin then self.WmodelSpin = 0 end
			self.WmodelSpin = Lerp(FT, self.WmodelSpin, self.WmodelSpin + self:GetAttackDelay() * speed)
			self.WmodelSpin = self.WmodelSpin %360
			return self.WmodelSpin
		else
			spin = Lerp(FT, spin, spin + self:GetAttackDelay() * speed)
			spin = spin %180
			return spin
		end
	end

	function SWEP:ViewModelDrawn(vm)
		local bone = vm:LookupBone("Barrels")
		if !bone then return end
		local spin = self:BoneSpin(bone)
		vm:ManipulateBoneAngles(bone, Angle(-spin,0,0))
	end

	function SWEP:DrawWorldModel()
		self:DrawModel()
		local owner = self:GetOwner()
		if !IsValid(owner) or owner:IsNPC() then return end
		local bone = self:LookupBone("Barrels")
		if !bone then return end
		local spin = self:BoneSpin(bone, true)
		self:ManipulateBoneAngles(bone, Angle(-spin,0,0))
	end

end