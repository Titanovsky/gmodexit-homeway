if SERVER then
	AddCSLuaFile()
end

SWEP.Category	= "CrossFire"
SWEP.Author		= "SWEP by UnkN\nModel by ClearSkyC"
SWEP.Base 		= "weapon_base"
SWEP.UseHands	= true
SWEP.HoldType 	= "pistol"
SWEP.Spawnable 	= false

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip 	= -1
SWEP.Secondary.Automatic 	= true
SWEP.Secondary.Ammo 		= "none"

SWEP.MeleeRange 	= 50
SWEP.MeleeDamage 	= 54

SWEP.DeployDuration	= 0.5
SWEP.MeleeDuration	= 1
SWEP.MuzzleAttach	= 1
SWEP.MuzzleScale	= 1

SWEP.MeleeSequence	= 9
SWEP.ReloadSequence = 7
SWEP.DeploySequence = 4

local swing,hitsnd,mins,maxs,punch,add = {"weapons/knife/knife_slash1.wav","weapons/knife/knife_slash2.wav"},{"weapons/knife/knife_hit1.wav","weapons/knife/knife_hit2.wav","weapons/knife/knife_hit3.wav","weapons/knife/knife_hit4.wav"},Vector(-10,-10,-10),Vector(10,10,10),Angle(0, 3, 0)
function SWEP:Initialize()
	self:SetHoldType( self.HoldType )
	self.NextReload = 0
	self.ChargeShoot = 0
end
local function GetRandDamage(dmg,mul)
	local adddmg = dmg * mul
	return dmg+math.random(-adddmg,0)
end
function SWEP:AttackTrace()
	local o = self.Owner
	o:LagCompensation(true)
	local sp,av = o:GetShootPos(),o:GetAimVector()
	local ran = sp + av * self.MeleeRange
	local tr = util.TraceHull({filter=o,start=sp,mask=MASK_SHOT_HULL,endpos=ran,mins=mins,maxs=maxs})
	if tr.Hit then
		o:ViewPunch(punch)
		local ent = tr.Entity
		if IsValid(ent) then
			local dmg = DamageInfo()
			dmg:SetDamage(GetRandDamage(self.MeleeDamage,0.1))
			dmg:SetAttacker(o)
			dmg:SetInflictor(self)
			dmg:SetDamageForce(av*10)
			dmg:SetDamagePosition(tr.HitPos)
			dmg:SetDamageType(DMG_SLASH)
			ent:DispatchTraceAttack(dmg, sp, ran)
			if (ent:IsPlayer() or ent:IsNPC() or ent.Type == "nextbot" or ent:GetClass() == "prop_ragdoll") then
				self:EmitSound(hitsnd[math.random(1,4)])
			else
				self:EmitSound("weapons/knife/knife_hitwall1.wav")
			end
		elseif tr.HitWorld then
			self:EmitSound("weapons/knife/knife_hitwall1.wav")
		end
		util.Decal("ManhackCut", sp, ran)
	else
		self:EmitSound(self.MeleeSound or swing[math.random(1,2)])
	end
	o:LagCompensation(false)
end
DMG_THROUGHTWALL = bit.bor(DMG_AIRBOAT,DMG_ENERGYBEAM)
function SWEP:BulletPenetrate(attacker, tr, dmginfo, aimvect)
	if CLIENT then return end
	local mat = tr.MatType
	if mat == MAT_SAND then return false end
	local dir = tr.Normal * 16
	if mat == MAT_GLASS or mat == MAT_PLASTIC or mat == MAT_WOOD or mat == MAT_FLESH or mat == MAT_ALIENFLESH then
		dir = tr.Normal * 32
	end
	local trace = {start=tr.HitPos + dir,endpos=tr.HitPos,mask=MASK_SHOT}
	trace = util.TraceLine(trace) 
	if trace.StartSolid or trace.Fraction >= 1 or tr.Fraction <= 0 then return false end
	local fDamageMulti = 0.5
	if (mat == MAT_CONCRETE) then
		fDamageMulti = 0.3
	elseif (mat == MAT_WOOD or mat == MAT_PLASTIC or mat == MAT_GLASS) then
		fDamageMulti = 0.8
	end
	local bullet = {Num=1,Src=trace.HitPos,Dir=tr.Normal,Spread=vector_origin,Tracer=1,TracerName="effect_penetration_trace",Force=5,Damage=(dmginfo:GetDamage()*fDamageMulti),HullSize=2}
	if bullet.Damage > 1 then
		bullet.Callback	= function(a,b,c)
			c:SetDamageType(DMG_THROUGHTWALL)
			self:BulletPenetrate(a,b,c)
		end
	end
	timer.Simple(0.05, function()
		if not IsFirstTimePredicted() then return end
		if attacker then
			attacker.FireBullets(attacker, bullet, true)
		end
	end)
	return true
end
local CurTime,single=CurTime,game.SinglePlayer()
function SWEP:FireAnimationEvent( pos, ang, event )
	if event == 21 then
		local fx = EffectData()
		fx:SetEntity(self.Owner:GetViewModel())
		fx:SetAttachment(self.MuzzleAttach)
		fx:SetScale(self.MuzzleScale)
		util.Effect("CS_MuzzleFlash",fx)
		return true
	end
end
function SWEP:Muzzle()
	local o = self.Owner
	if o:ShouldDrawLocalPlayer() then
		local fx = EffectData()
		fx:SetEntity(self)
		fx:SetOrigin(o:GetShootPos())
		fx:SetNormal(o:GetAimVector())
		fx:SetAttachment(1)
		fx:SetScale(self.MuzzleScale)
		util.Effect("CS_MuzzleFlash",fx)
	end
	if self.ShellEffect then
		local vm = o:GetViewModel()
		if not IsValid(vm) then return end
		local att = vm:LookupAttachment("shell")
		if not att or att < 0 then
			self.ShellEffect = nil
			return
		end
		local angpos = vm:GetAttachment(att)
		if angpos and angpos.Pos then
			local fx = EffectData()
			fx:SetEntity(vm)
			fx:SetOrigin(angpos.Pos)
			fx:SetAttachment(att)
			fx:SetAngles(angpos.Ang)
			util.Effect("RifleShellEject",fx)
		end
	end
end
local max,min,ceil = math.max,math.min,math.ceil
function SWEP:PrimaryAttack()
	if not self:CanPrimaryAttack() then return end
	if single then
		self:CallOnClient( "Muzzle" )
	end
	self:EmitSound(self.Primary.Sound)
	local o,ct = self.Owner,CurTime()
	local sp,av=o:GetShootPos(),o:GetAimVector()
	self:TakePrimaryAmmo(1)
	local bullet = {Num=self.Primary.NumShots,Src=sp,Dir=av,Tracer=1,TracerName="Tracer",Force=5,Damage=GetRandDamage(self.Primary.Damage,0.25)}
	local mult = 1
	if not o:IsOnGround() then
		mult = 3
	else
		local vel = o:GetVelocity():Length2DSqr()
		if vel > 0 then
			mult = mult * math.Clamp(vel*0.000025,1,5)
		end
		if o:Crouching() then
			mult = mult * 0.5
		end
	end
	local put = self.Primary.Cone * min(self.ChargeShoot*0.05,1) * mult
	bullet.Spread = Vector( put, put, put )
	bullet.Callback	= function(a,b,c)
		self:BulletPenetrate(a,b,c)
	end
	o:FireBullets(bullet,SERVER)
	if CLIENT then
		self:Muzzle()
	end
	self:SendWeaponAnim( ACT_VM_PRIMARYATTACK )
	o:SetAnimation( PLAYER_ATTACK1 )
	self:SetNextPrimaryFire(ct+self.Primary.Delay)
	self:SetNextSecondaryFire(ct+self.Primary.Delay)
	self.ChargeShoot = self.ChargeShoot + 5
end
function SWEP:SendWeaponSequence(seq,o)
	o = o or self.Owner
	local vm = o:GetViewModel()
	if IsValid(vm) then
		vm:SendViewModelMatchingSequence(seq)
	end
end
function SWEP:Deploy()
	self:SetWeaponHoldType( self.HoldType )
	if self.ENUMSetup == nil then
		self.ENUMSetup = true
		pcall(self.SetupENUM,self)
	end
	self:SendWeaponSequence(self.DeploySequence)
	local ct = CurTime() + self.DeployDuration
	self:SetNextPrimaryFire(ct)
	self:SetNextSecondaryFire(ct)
	if self.CustomDeploy then
		return true,self:CustomDeploy(ct)
	end
	return true
end
function SWEP:Holster()
	if self.NextReload > CurTime() then return false end
	return true
end
function SWEP:SecondaryAttack()
	self:SendWeaponSequence(self.MeleeSequence)
	local ct = CurTime()+self.MeleeDuration
	self:SetNextSecondaryFire(ct-0.3)
	self:SetNextPrimaryFire(ct)
	self.NextReload = ct-0.3
	self.Owner:DoAnimationEvent(ACT_GMOD_GESTURE_MELEE_SHOVE_2HAND)
	self.NextHit = CurTime() + self.MeleeAttack
	self.ChargeShoot = max(self.ChargeShoot - ceil((self.MeleeDuration-0.4) * 100),0)
end
function SWEP:SetupENUM()
	local vm = self.Owner:GetViewModel()
	if IsValid(vm) then
		self.ReloadSpeed = select(2,vm:LookupSequence("reload"))
	else
		self.ReloadSpeed = 0
	end
end
function SWEP:Think()
	if self.ENUMSetup == nil then
		self.ENUMSetup = true
		pcall(self.SetupENUM,self)
	end
	local ct = CurTime()
	if self.NextHit and self.NextHit <= ct then
		self:AttackTrace()
		self.NextHit = nil
	end
	if self.ChargeShoot ~= 0 and self:GetNextPrimaryFire() + self.Primary.Delay < ct then
		self.ChargeShoot = self.ChargeShoot - 1
	end
end
function SWEP:Reload()
	if CurTime() < self.NextReload then return end
	if self:DefaultReload( ACT_VM_RELOAD ) then
		self:SendWeaponSequence(self.ReloadSequence)
		self.ChargeShoot = max(self.ChargeShoot - ceil(self.ReloadSpeed * 100),0)
		self.Owner:SetAnimation( PLAYER_RELOAD )	
	end
end