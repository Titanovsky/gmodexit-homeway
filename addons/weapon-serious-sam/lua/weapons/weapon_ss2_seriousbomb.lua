
if CLIENT then

	SWEP.PrintName			= "Serious Bomb"
	SWEP.Author				= "Upset"
	SWEP.Slot				= 5
	SWEP.SlotPos			= 1
	SWEP.ViewModelFOV		= 54
	SWEP.WepIcon			= surface.GetTextureID("interface/weaponicons/seriousbomb")
	
end

local firemat = Material("models/serioussam2/weapons/seriousbomb/fire")

function SWEP:SpecialDeploy()
	firemat:SetVector("$color2", Vector(0, 0, 0))
end

function SWEP:PrimaryAttack()
	if !self:CanPrimaryAttack() then return end
	self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
	self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
	self:TakeAmmo(self.AmmoToTake)	
	self:SetAttackDelay(CurTime() +2)
	self:HolsterDelay()
	self:IdleStuff()
end

function SWEP:SpecialThink()
	local attdelay = self:GetAttackDelay()
	local CT = CurTime()
	if attdelay > 0 then
		if attdelay < CT+1.8 then
			if !self.Fuse then
				self.Fuse = CreateSound(self, self.Primary.Special1)
			end
			if self.Fuse and !self.Fuse:IsPlaying() then
				self.Fuse:Play()
			end
		end
		if attdelay < CT+.9 then
			if !self.DetonateStart then
				self.DetonateStart = CreateSound(self.Owner, self.Primary.Special)
			end
			if self.DetonateStart and !self.DetonateStart:IsPlaying() then
				self.DetonateStart:Play()
			end
		end
		if attdelay <= CT then
			if self.DetonateStart then self.DetonateStart:Stop() end
			if self.Fuse then self.Fuse:Stop() end
			if game.SinglePlayer() and CLIENT then return end
			self:SetAttackDelay(0)
			self:WeaponSound(self.Primary.Sound, 0)
			
			self.Owner:ScreenFade(SCREENFADE.IN, Color(255, 255, 255, 255), 1, .25)
			if SERVER then
				local ents = ents.FindInSphere(self.Owner:GetPos(), self.Primary.Radius)
				
				for k,v in pairs(ents) do
					if IsValid(v) and (self:IsCreature(v) or v:Health() > 0) and v != self:GetOwner() then
						if v:IsPlayer() and !v:Alive() then return end
						local tr = util.TraceHull({
							start = self.Owner:GetShootPos(),
							endpos = v:GetPos(),
							filter = function(ent) if ent == v then return true end end
						})
						if IsValid(tr.Entity) then
							local dist = tr.StartPos:Distance(tr.HitPos)
							local points = self.Primary.Damage * (1 - math.sqrt(dist/self.Primary.Radius))
							points = math.max(math.Round(points), 0)

							local dmginfo = DamageInfo()
							dmginfo:SetDamage(points)
							dmginfo:SetDamageType(bit.bor(DMG_BLAST, DMG_AIRBOAT))
							dmginfo:SetDamageForce((tr.HitPos - tr.StartPos) * 1000)
							dmginfo:SetAttacker(self:GetOwner())
							dmginfo:SetInflictor(self)
							tr.Entity:TakeDamageInfo(dmginfo)
							
							if tr.Entity:IsPlayer() then
								local screencol = math.min(points, 255)
								tr.Entity:ScreenFade(SCREENFADE.IN, Color(255, 255, 255, screencol), 1, .25)
							end
						end
					end
				end
			end
		end
	end
end

function SWEP:ResetBones()
	local owner = self.Owner
	if CLIENT then
		if IsValid(self) and IsValid(owner) and owner and owner:IsPlayer() then
			local vm = owner:GetViewModel()
			if IsValid(vm) then
				for i = 9, 33 do
					vm:ManipulateBoneScale(i, Vector(1,1,1))
				end
			end
		end
	end
end

function SWEP:OnRemove()
	if self.DetonateStart then self.DetonateStart:Stop() end
	if self.Fuse then self.Fuse:Stop() end
	self:SetAttackDelay(0)
	self:ResetBones()
end

local time = 0

function SWEP:ViewModelDrawn(vm)
	local attdelay = self:GetAttackDelay()
	if attdelay > 0 then
		local FT = FrameTime()
		time = time + FT
		if time > .35 then
			time = time + FT*22
			for i = 1, 25 do
				local scale = math.sqrt(math.max(1-time/i, 0))
				local bone = vm:LookupBone("Rope_"..i)
				if !bone then return end
				vm:ManipulateBoneScale(bone, Vector(scale,scale,scale))
			end
			
			local att = vm:GetAttachment(1)
			local pos, ang = att.Pos, att.Ang
			
			if FT > 0 and time < 25 then
				local effectdata = EffectData()
				effectdata:SetOrigin(pos)
				effectdata:SetMagnitude(1)
				effectdata:SetScale(.1)
				effectdata:SetRadius(.1)
				util.Effect("Sparks", effectdata)
			end
		end		
		if time > 3.8 then
			firemat:SetVector("$color2", Vector(0, 0, 0))
		elseif time > .05 then
			firemat:SetVector("$color2", Vector(1, 1, 1))
		end
	else
		time = 0
		for i = 9, 33 do
			vm:ManipulateBoneScale(i, Vector(1,1,1))
		end
	end	
end

SWEP.HoldType			= "slam"
SWEP.Base				= "weapon_ss2_base"
SWEP.Category			= "Serious Sam 2"
SWEP.AdminOnly			= true
SWEP.Spawnable			= true

SWEP.ViewModel			= Model("models/serioussam2/weapons/v_seriousbomb.mdl")
SWEP.WorldModel			= Model("models/serioussam2/weapons/w_seriousbomb.mdl")

SWEP.Primary.Sound			= Sound("serioussam2/weapons/seriousnuke/seriousnuke_detonate04.wav")
SWEP.Primary.Special		= Sound("serioussam2/weapons/seriousnuke/seriousnuke_detonatestart02.wav")
SWEP.Primary.Special1		= Sound("serioussam2/weapons/seriousnuke/seriousnuke_fuse.wav")
SWEP.Primary.Damage			= 1000
SWEP.Primary.Radius			= 8400
SWEP.Primary.Delay			= 2.1
SWEP.Primary.DefaultClip	= 1
SWEP.Primary.Ammo			= "seriousbomb"

SWEP.HolsterTime			= .4

SWEP.EnableDrySound			= false
SWEP.HideWhenEmpty			= true