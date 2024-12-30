
if CLIENT then

	SWEP.PrintName			= "P-Lah Chainsaw"
	SWEP.Author				= "Upset"
	SWEP.Slot				= 0
	SWEP.SlotPos			= 1
	SWEP.ViewModelFOV		= 56
	-- SWEP.UpAngle			= -6
	SWEP.SBobScale			= .4
	SWEP.WepIcon			= surface.GetTextureID("interface/weaponicons/circularsaw")
	
end

function SWEP:SpecialDeploy()
	self:SetAttackDelay(2)
	self:EmitSound(self.EngineStartSound, 75, 100, .5)
end

function SWEP:SpecialHolster()
	self:EmitSound(self.EngineStopSound, 75, 100, .5)
	if self.idle then self.idle:Stop() end
end

function SWEP:PrimarySound(num)
	if CLIENT and !IsFirstTimePredicted() then return end
	if !self.CutSound then
		self.CutSound = CreateSound(self.Owner, self.Primary.Sound)
		self.CutSound:SetSoundLevel(90)
	end
	if self.CutSound and !self.CutSound:IsPlaying() then
		self.CutSound:Play()
	end
end

function SWEP:PrimaryAttack()
	if self:GetHolster() then return end
	if !self:GetAttack() then
		self:EmitSound("Weapon_SS2_CircularSaw.CutStart")
		self:SetAttack(true)
	end

	if self:GetAttackDelay() >= self.BladeAccelTime then
		self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
		self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
		self.Owner:SetAnimation(PLAYER_ATTACK1)
		self:StopSound("Weapon_SS2_CircularSaw.CutStart")
		self:PrimarySound()
		
		if SERVER then self.Owner:LagCompensation(true) end
		local tr = util.TraceLine({
			start = self.Owner:GetShootPos(),
			endpos = self.Owner:GetShootPos() + self.Owner:GetAimVector() * self.HitDist,
			filter = self.Owner
		})

		if !IsValid(tr.Entity) then
			tr = util.TraceHull({
			start = self.Owner:GetShootPos(),
			endpos = self.Owner:GetShootPos() + self.Owner:GetAimVector() * self.HitDist,
			filter = self.Owner,
			mins = Vector(-5, -5, -5),
			maxs = Vector(5, 5, 5)
			})
		end
		
		if tr.Hit then
			self:ImpactEffect(tr)
			self:ScreenShake(tr.HitPos, .75)
			local hitsnd = self.HitSounds[math.random(1, 3)]
			if self:IsCreature(tr.Entity) then
				hitsnd = self.HitSounds[math.random(4, 7)]
			end
			if SERVER then
				sound.Play(hitsnd, tr.HitPos, 80, 100)
				local dmginfo = DamageInfo()
				local attacker = self.Owner
				if (!IsValid(attacker)) then attacker = self end
				dmginfo:SetAttacker(attacker)
				dmginfo:SetInflictor(self)
				dmginfo:SetDamage(self.Primary.Damage)
				dmginfo:SetDamageForce(self.Owner:GetUp() *1000 +self.Owner:GetForward() *8000 +self.Owner:GetRight() *-1000)
				tr.Entity:TakeDamageInfo(dmginfo)
			end
		else
			self:ScreenShake(self:GetPos(), .25)
		end
		if SERVER then self.Owner:LagCompensation(false) end
	end
end

function SWEP:SpecialThink()
	if game.SinglePlayer() and CLIENT then return end
	if self.Owner:KeyReleased(IN_ATTACK) then
		if self:GetAttack() then
			self:EmitSound("Weapon_SS2_CircularSaw.CutEnd")
			self:SetIdleDelay(CurTime() +.05)
		end
		if self.CutSound then self.CutSound:Stop() end
		self:SetAttack(nil)
	end	
	
	local attdelay = self:GetAttackDelay()
	if self.Owner:KeyDown(IN_ATTACK) then
		self:SetAttackDelay(math.Clamp(attdelay^1.025, 2, self.BladeAccelTime))
	else
		self:SetAttackDelay(math.Clamp(attdelay^.99, 2, self.BladeAccelTime))
	end
	
	if !self.idle then
		self.idle = CreateSound(self, self.EngineSound)
	end
	if self.idle and !self.idle:IsPlaying() and !self:GetHolster() then
		self.idle:Play()
	end
end

function SWEP:ResetBones()
	local owner = self.Owner
	if CLIENT then
		if IsValid(self) and IsValid(owner) and owner and owner:IsPlayer() then
			local vm = owner:GetViewModel()
			if IsValid(vm) then
				vm:ManipulateBoneAngles(4, Angle(0, 0, 0))
			end
		end
	end
end

function SWEP:OnRemove()
	if self.CutSound then self.CutSound:Stop() end
	if self.idle then self.idle:Stop() end
	self:SetAttack(nil)
	self:ResetBones()
end

if CLIENT then

	local lastpos = 0
	local speed = 10
	
	function SWEP:ViewModelDrawn(vm)
		local bone = vm:LookupBone("Blades")
		if !bone then return end		
		local attack = lastpos+self:GetAttackDelay()-2
		lastpos = Lerp(FrameTime()*40, lastpos, attack)
		local rotate = (attack*speed) %360
		vm:ManipulateBoneAngles(bone, Angle(0,rotate,0))
	end

	function SWEP:DrawWorldModel()
		self:DrawModel()
		if !IsValid(self:GetOwner()) then return end
		local bone = self:LookupBone("Saw")
		if !bone then return end
		local lastpos_w = self:GetVar("lastpos_w"..self:EntIndex(), 0)
		local attack = lastpos_w + self:GetAttackDelay() - 2
		self:SetVar("lastpos_w"..self:EntIndex(), Lerp(FrameTime()*40, lastpos_w, attack))
		local rotate = (attack*speed) %360
		self:ManipulateBoneAngles(bone, Angle(0,0,-rotate))
	end

end

function SWEP:ScreenShake(pos, freq)
	if game.SinglePlayer() and SERVER or CLIENT and IsFirstTimePredicted() then util.ScreenShake(pos, freq, 500, 1, 80) end
end

function SWEP:ImpactEffect(tr)
	if !IsFirstTimePredicted() then return end
	local e = EffectData()
	e:SetOrigin(tr.HitPos)
	e:SetStart(tr.StartPos)
	e:SetSurfaceProp(tr.SurfaceProps)
	e:SetDamageType(DMG_SLASH)
	e:SetHitBox(tr.HitBox)
	if CLIENT then
		e:SetEntity(tr.Entity)
	else
		e:SetEntIndex(tr.Entity:EntIndex())
	end
	util.Effect("Impact", e)
end

SWEP.HoldType			= "shotgun"
SWEP.Base				= "weapon_ss2_base"
SWEP.Category			= "Serious Sam 2"
SWEP.Spawnable			= true

SWEP.ViewModel			= Model("models/serioussam2/weapons/v_circularsaw.mdl")
SWEP.WorldModel			= Model("models/serioussam2/weapons/w_circularsaw.mdl")

SWEP.Primary.Sound			= Sound("serioussam2/weapons/circularsaw/saw_cutloop01.wav")
SWEP.Primary.Damage			= 25
SWEP.Primary.Delay			= .07

SWEP.EngineSound			= Sound("serioussam2/weapons/circularsaw/saw_engine.wav")
SWEP.EngineStartSound		= Sound("serioussam2/weapons/circularsaw/saw_start.wav")
SWEP.EngineStopSound		= Sound("serioussam2/weapons/circularsaw/saw_stop.wav")

SWEP.BladeAccelTime			= 6		// must be higher than 2, integers only

SWEP.HitDist				= 75
SWEP.HitSounds = {
	Sound("serioussam2/weapons/circularsaw/hit/saw_01.wav"),
	Sound("serioussam2/weapons/circularsaw/hit/saw_02.wav"),
	Sound("serioussam2/weapons/circularsaw/hit/saw_03.wav"),
	Sound("serioussam2/weapons/circularsaw/hit/saw_flesh01.wav"),
	Sound("serioussam2/weapons/circularsaw/hit/saw_flesh02.wav"),
	Sound("serioussam2/weapons/circularsaw/hit/saw_flesh03.wav"),
	Sound("serioussam2/weapons/circularsaw/hit/saw_flesh04.wav")
}