include("ss2_ai_translations.lua")

if SERVER then

	SWEP.Weight				= 1
	SWEP.AutoSwitchTo		= false
	SWEP.AutoSwitchFrom		= false
	CreateConVar("ss2_sv_ammomultiplier", 2, FCVAR_ARCHIVE, "Multiplier for additional ammo on weapon pickup\n Any positive number, 0 - disabled")
	CreateConVar("ss2_sv_loadout", 0, {FCVAR_NOTIFY, FCVAR_ARCHIVE}, "Players spawn with SS2 weapons")
	CreateConVar("ss2_sv_cannonball_gib", 1, FVAR_NONE, "Allow cannonball to gib")
	CreateConVar("ss2_sv_restrictcannon", 0, FVAR_NONE, "Restrict Cannon if it's too OP for you")

	local weps = {
		"weapon_ss2_zapgun",
		"weapon_ss2_colt",
		"weapon_ss2_circularsaw"
	}

	hook.Add("PlayerLoadout", "SS2Loadout", function(ply)
		if cvars.Bool("ss2_sv_loadout") then
			for _, wep in pairs(weps) do
				ply:Give(wep)
			end
			return true
		end
	end)
	
	concommand.Add("ss2_giveloadout", function(ply)
		if !ply:IsAdmin() or !ply:IsSuperAdmin() then return end
		ply:StripWeapons()
		for _, wep in pairs(weps) do
			ply:Give(wep)
		end
	end)

else

	SWEP.DrawCrosshair		= false
	SWEP.ViewModelFlip		= false
	SWEP.ViewModelFlip1		= true
	SWEP.ViewModelFOV		= 60
	SWEP.BobScale			= 0
	SWEP.SwayScale			= .1
	-- SWEP.UpAngle			= 0
	SWEP.SBobScale			= 1
	
	CreateClientConVar("ss2_cl_particles", 1)
	
	local path = "interface/weaponicons/"
	local col = Color(255, 150, 150, 255)
	killicon.Add("weapon_ss2_autoshotgun", path.."autoshotgun", col)
	killicon.Add("weapon_ss2_doubleshotgun", path.."doubleshotgun", col)
	killicon.Add("weapon_ss2_beamgun", path.."beamgun", col)
	killicon.Add("ss2_cannonball", path.."cannon", col)
	killicon.Add("weapon_ss2_circularsaw", path.."circularsaw", col)
	killicon.Add("weapon_ss2_colt", path.."colt", col)
	killicon.Add("ss2_grenade", path.."grenadelauncher", col)
	killicon.Add("ss2_klodovik", path.."klodovik", col)
	killicon.Add("weapon_ss2_minigun", path.."minigun", col)
	killicon.Add("weapon_ss2_plasmarifle", path.."plasmarifle", col)
	killicon.Add("ss2_rocket", path.."rocketlauncher", col)
	killicon.Add("weapon_ss2_seriousbomb", path.."seriousbomb", col)
	killicon.Add("weapon_ss2_sniper", path.."sniper", col)
	killicon.Add("weapon_ss2_uzi", path.."uzi", col)
	killicon.Add("weapon_ss2_zapgun", path.."zapgun", col)
	
end

local cvar_sv_unlimitedammo = CreateConVar("ss2_sv_unlimitedammo", 0, {FCVAR_NOTIFY, FCVAR_REPLICATED}, "Unlimited ammo for everyone", 0, 1)

SWEP.Author					= "Upset"
SWEP.Category				= "Serious Sam 2"
SWEP.Spawnable				= false
SWEP.AdminOnly				= false

SWEP.HoldType				= "ar2"

SWEP.Primary.Damage			= 10
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0
SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "none"
SWEP.Secondary.Ammo			= "none"

SWEP.AmmoToTake				= 1
SWEP.EnableDrySound			= true
SWEP.DrySound				= Sound("serioussam2/weapons/common/dryfire01.wav")

SWEP.MuzzleScale			= 14
SWEP.EnableSmoke			= true
SWEP.SmokeType				= 1

SWEP.DeploySpeed			= 1
SWEP.HolsterTime			= .2

SWEP.EnableLuaIdle			= false
SWEP.HideWhenEmpty			= false

SWEP.Akimbo					= false
SWEP.AkimboOffset = {
	Right = -.5,
	Forward	= 1.8,
	Up = 3,
}

local SSAM2_STATE_DEPLOY = 0
local SSAM2_STATE_HOLSTER = 1
local SSAM2_STATE_IDLE = 2

function SWEP:SetupDataTables()
	self:NetworkVar("Int", 0, "State")
	self:NetworkVar("Bool", 0, "Holster")
	self:NetworkVar("Bool", 1, "Attack")
	self:NetworkVar("Bool", 2, "StartHolster")
	self:NetworkVar("Float", 0, "HolsterTime")
	
	// anims
	self:NetworkVar("Float", 1, "IdleDelay")
	self:NetworkVar("Float", 2, "FidgetDelay")
	
	self:NetworkVar("Float", 3, "AttackDelay")
	
	// sniper vars
	self:NetworkVar("Bool", 3, "Zoom")
	self:NetworkVar("Float", 4, "ZoomTime")
	self:NetworkVar("Float", 5, "ZoomStart")
	
	// akimbo vars
	self:NetworkVar("Int", 1, "Shot")
	self:NetworkVar("Int", 2, "Ammo1")
	self:NetworkVar("Int", 3, "Ammo2")
	self:NetworkVar("Float", 6, "NextAkimboFireA")
	self:NetworkVar("Float", 7, "NextAkimboFireB")
	self:NetworkVar("Float", 8, "AkimboIdleDelayA")
	self:NetworkVar("Float", 9, "AkimboIdleDelayB")
	
	self:NetworkVar("Float", 10, "EffectTime")

	self:SpecialDataTables()
end

function SWEP:SpecialDataTables()
end

function SWEP:Initialize()
	if self.Akimbo and CLIENT then
		self.LeftModel = ClientsideModel(self.WorldModel, RENDERGROUP_BOTH)
		self.LeftModel:SetNoDraw(true)
	end
	self:SetHoldType(self.HoldType)
	self:SetDeploySpeed(self.DeploySpeed)
	if CLIENT then hook.Add("CalcViewModelView", self, self.ViewModelAngles) end
	self:SpecialInit()
end

function SWEP:SpecialInit()
end

function SWEP:OnRestore()
	self.DisableHolster = nil
end

function SWEP:Equip(ply)
	if !IsValid(ply) or !ply:IsPlayer() then return end
	local cvar = "ss2_sv_ammomultiplier"
	if cvars.Bool(cvar) then
		local multiplier = math.Clamp(cvars.Number(cvar, 1), 0, 9999)
		ply:GiveAmmo(self.Primary.DefaultClip * multiplier, self.Primary.Ammo)
	end
end

function SWEP:Deploy()
	self:SetState(SSAM2_STATE_DEPLOY)
	self:SendWeaponAnim(ACT_VM_DRAW)
	self:IdleStuff()
	self:SpecialDeploy()
	self:SetHolster(nil)
	
	if self.Akimbo then
		local owner = self:GetOwner()
		if owner and IsValid(owner) and owner:IsPlayer() and owner:Alive() and IsValid(self) then
			local vm = owner:GetViewModel(1)
			vm:SetWeaponModel(self.ViewModel, self)
			self:SendSecondWeaponAnim(ACT_VM_DRAW)
		end
	end

	return true
end

function SWEP:SpecialDeploy()
end

function SWEP:PrimaryAttack()
	if !self:CanPrimaryAttack() then return end
	
	if self.Owner:IsNPC() then
		if self:GetNextPrimaryFire() <= CurTime() then
			self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
			self:WeaponSound()
			self:SeriousFlash()
			self:TakeAmmo(self.AmmoToTake)
			self:ShootBullet(self.Primary.Damage, self.Primary.NumShots, self.Primary.Cone)
		end
		return
	end
	
	self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
	if self.Akimbo then
		if self:GetShot() == 0 then
			self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
			self:SeriousFlash()
			self:IdleStuff(1)
			self:SetShot(1)
		else
			self:SendSecondWeaponAnim(ACT_VM_PRIMARYATTACK)
			self:SeriousFlash(1)
			self:IdleStuff(2)
			self:SetShot(0)
		end
	else
		self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
		self:SeriousFlash()
		self:IdleStuff()
	end	
	self.Owner:SetAnimation(PLAYER_ATTACK1)
	self:WeaponSound()
	self:ShootBullet(self.Primary.Damage, self.Primary.NumShots, self.Primary.Cone)
	self:TakeAmmo(self.AmmoToTake)
	self:HolsterDelay()
end

function SWEP:SecondaryAttack()
	-- do handgrenades here
end

function SWEP:WeaponSound(snd, lvl, chan)
	snd = snd or self.Primary.Sound or self.FireSounds[math.random(1, #self.FireSounds)]
	lvl = lvl or 100
	if game.SinglePlayer() then
		chan = chan or CHAN_AUTO
	else
		chan = chan or CHAN_WEAPON
	end
	self:EmitSound(snd, lvl, 100, 1, chan)
end

function SWEP:HolsterDelay(time)
	if self.Primary.Delay < .1 then return end
	time = time or self:GetNextPrimaryFire() -.1
	self.DisableHolster = time
end

function SWEP:OnRemove()
	if self.Akimbo then
		local owner = self:GetOwner()

		if owner and owner:IsValid() and owner:IsPlayer() then
			local vm = owner:GetViewModel(1)
			if IsValid(vm) then
				vm:SetWeaponModel(self.ViewModel, nil)
			end
		end
	end
end

function SWEP:OnDrop()
	self:OnRemove()
end

function SWEP:ResetBones()
end

function SWEP:Holster(wep)
	self:ResetBones()

	if self == wep then
		return
	end
	
	if self:GetState() == SSAM2_STATE_HOLSTER or !IsValid(wep) then
		self:SetState(SSAM2_STATE_HOLSTER)
		self:OnRemove()
		return true
	end
	
	if self:GetHolster() then return false end
	
	if self.DisableHolster and self.DisableHolster > CurTime() then
		if IsValid(wep) then
			self.NewWeapon = wep:GetClass()
			self:SetStartHolster(true)
			timer.Simple(.1, function()
				if IsValid(self) and IsValid(self.Owner) and self.Owner:Alive() then
					if SERVER then self.Owner:SelectWeapon(self.NewWeapon) end
				end
			end)
		end
		return false
	end

	if IsValid(wep) then
		self:SetIdleDelay(0)
		self:SetFidgetDelay(0)
		if self.Akimbo then
			self:SetAkimboIdleDelayA(0)
			self:SetAkimboIdleDelayB(0)
		end
		self:SetStartHolster(false)
		self:SetHolster(true)
		self:SpecialHolster()
		self:SendWeaponAnim(ACT_VM_HOLSTER)
		if self.Akimbo then self:SendSecondWeaponAnim(ACT_VM_HOLSTER) end
		self.NewWeapon = wep:GetClass()
		self:SetHolsterTime(CurTime() + self.HolsterTime)
	end

	return false
end

function SWEP:SpecialHolster()
end

function SWEP:Think()
	self:SpecialThink()
	
	if game.SinglePlayer() and CLIENT then return end
	
	local holsterTime = self:GetHolsterTime()
	if holsterTime > 0 and holsterTime <= CurTime() then
		if IsValid(self) and IsValid(self.Owner) and self.Owner:Alive() then
			self:SetState(SSAM2_STATE_HOLSTER)
			if SERVER then self.Owner:SelectWeapon(self.NewWeapon) end
		end
		self:SetHolsterTime(0)
	end
	
	if !self.EnableLuaIdle then
		local fidget = self:GetFidgetDelay()
		if self.Akimbo then
			local idleA = self:GetAkimboIdleDelayA()
			local idleB = self:GetAkimboIdleDelayB()
			if idleA > 0 and CurTime() > idleA then
				self:SetAkimboIdleDelayA(0)
				self:FidgetAnim()
				self:SendWeaponAnim(ACT_VM_IDLE)
			end
			if idleB > 0 and CurTime() > idleB then
				self:SetAkimboIdleDelayB(0)
				self:FidgetAnim()
				self:SendSecondWeaponAnim(ACT_VM_IDLE)
			end
		else
			local idle = self:GetIdleDelay()
			if idle > 0 and CurTime() > idle then
				self:SetIdleDelay(0)
				self:FidgetAnim()
				self:SendWeaponAnim(ACT_VM_IDLE)
				self:SetState(SSAM2_STATE_IDLE)
			end
		end
		if fidget > 0 and CurTime() > fidget then
			self:SetFidgetDelay(0)
			if self:LookupSequence("idle2") != -1 then
				if self.Owner:GetVelocity():Length() <= 10 then
					self:SendWeaponAnim(ACT_VM_FIDGET)
					if self.Akimbo then self:SendSecondWeaponAnim(ACT_VM_FIDGET) end
					self:IdleStuff()
				else
					self:FidgetAnim()
				end
			end
		end
	end
	
	if !game.SinglePlayer() and self:GetHolster() then
		self:ResetBones()
	end
end

function SWEP:SpecialThink()
end

function SWEP:ShootBullet(dmg, numbul, cone)
	local bullet = {}
	bullet.Num 		= numbul
	bullet.Src 		= self.Owner:GetShootPos()
	bullet.Dir 		= self.Owner:GetAimVector()
	bullet.Spread 	= Vector(cone, cone, 0)
	bullet.Tracer	= 1
	bullet.Force	= 4
	bullet.Damage	= dmg
	self.Owner:FireBullets(bullet)
end

function SWEP:GetAmmo()
	return self.Owner:GetAmmoCount(self:GetPrimaryAmmoType())
end

function SWEP:GetGrenadesAmmo()
	return self.Owner:GetAmmoCount(self:GetSecondaryAmmoType())
end

function SWEP:CanPrimaryAttack()
	if !IsValid(self.Owner) or self:GetHolster() or self:GetStartHolster() then return false end

	if IsValid(self.Owner) and !self.Owner:IsNPC() then
		if self:GetAmmo() < self.AmmoToTake then
			self:SetNextPrimaryFire(CurTime() + .2)
			if self.EnableDrySound then
				self:EmitSound(self.DrySound, 75, 100, 1, CHAN_AUTO)
			end
			return false
		end
	end
	return true
end

function SWEP:IsCreature(ent)
	return ent:IsPlayer() or ent:IsNPC() or ent:IsNextBot()
end

function SWEP:SeriousFlash(modelindex)
	modelindex = modelindex or 0
	if !IsFirstTimePredicted() or !IsValid(self.Owner) or self.Owner:WaterLevel() == 3 then return end
	local fx = EffectData()
	fx:SetEntity(self)
	fx:SetSurfaceProp(modelindex)
	fx:SetOrigin(self.Owner:GetShootPos())
	fx:SetNormal(self.Owner:GetAimVector())
	fx:SetAttachment(1)
	fx:SetScale(self.MuzzleScale)
	util.Effect("ss2_mflash", fx)
	if self.EnableSmoke then
		if self.SmokeType == 1 then
			util.Effect("ss2_mflashsmoke", fx)
		else
			util.Effect("ss2_mflashsmoke_big", fx)
		end
	end
	if !game.SinglePlayer() and CLIENT or game.SinglePlayer() then
		self.Owner:MuzzleFlash()
	end
end

function SWEP:Reload()
end

function SWEP:TakeAmmo(num)
	num = num or 1
	if !cvar_sv_unlimitedammo:GetBool() and !self.Owner:IsNPC() then
		if self:GetAmmo() > 0 then
			self.Owner:RemoveAmmo(num, self:GetPrimaryAmmoType())
		end
	end
end

function SWEP:TakeGrenade(num)
	num = num or 1
	if !cvar_sv_unlimitedammo:GetBool() then
		if self:GetGrenadesAmmo() > 0 then
			self.Owner:RemoveAmmo(num, self:GetSecondaryAmmoType())
		end
	end	
end

function SWEP:IdleStuff(wep)
	if self.EnableLuaIdle or self.Owner:IsNPC() then return end
	self:SetFidgetDelay(0)
	if self.Akimbo then		
		if wep == 1 then
			self:SetAkimboIdleDelayA(CurTime() +self:SequenceDuration())
		elseif wep == 2 then
			local vm = self.Owner:GetViewModel(1)
			self:SetAkimboIdleDelayB(CurTime() +vm:SequenceDuration())
		else
			self:SetAkimboIdleDelayA(CurTime() +self:SequenceDuration())
			self:SetAkimboIdleDelayB(CurTime() +self:SequenceDuration())
		end
	else
		self:SetIdleDelay(CurTime() +self:SequenceDuration())
	end
end

function SWEP:FidgetAnim()
	self:SetFidgetDelay(CurTime() +self:SequenceDuration() +math.Rand(4,8))
end

function SWEP:SendSecondWeaponAnim(anim)
	local owner = self:GetOwner()
		
	if (owner && owner:IsValid() && owner:IsPlayer()) then
	
		local vm = owner:GetViewModel(1)
	
		local idealSequence = self:SelectWeightedSequence(anim)
		local nextSequence = self:FindTransitionSequence(self:GetSequence(), idealSequence)
		
		vm:RemoveEffects(EF_NODRAW)

		if (nextSequence > 0) then
			vm:SendViewModelMatchingSequence(nextSequence)
		else
			vm:SendViewModelMatchingSequence(idealSequence)
		end

		return vm:SequenceDuration(vm:GetSequence())
	end
end

if SERVER then return end

function SWEP:GetTracerOrigin()
	if self.Akimbo then
		local ply = self:GetOwner()
		if IsValid(ply) then
			local vm = ply:GetViewModel(1)
			if IsValid(vm) then
				local att = vm:GetAttachment(1)
				if att and self:GetShot() == 0 then
					return att.Pos
				end
			end
		end
	end
end

function SWEP:ViewModelAngles(wep, vm, oldpos, oldang, pos, ang)
	if wep != self then return end
	if self.UpAngle then oldang:RotateAroundAxis(oldang:Right(), self.UpAngle) end
	if self.HideWhenEmpty and self:GetAmmo() <= 0 and self:GetAttackDelay() <= CurTime() then
		return oldpos - ang:Up() * 20, oldang
	end
	return nil, oldang
end

local ground = 0

function SWEP:CalcViewModelView(vm, oldpos, oldang, pos, ang)
	if !IsValid(vm) or !IsValid(self.Owner) then return end
	local reg = debug.getregistry()
	local GetVelocity = reg.Entity.GetVelocity
	local ownerVelocity = GetVelocity(self.Owner)
	local Length = reg.Vector.Length2D
	local vel = Length(ownerVelocity)
	local velb = math.Clamp(vel/256, 0, .4)
	local move = math.sin(CurTime() * 10.5)
	local moveright = move *velb
	local moveup = move *moveright /2

	local bobscale = self.SBobScale
	
	if self.Owner:GetMoveType() != MOVETYPE_NOCLIP then
		local modelindex = vm:ViewModelIndex()
		if modelindex == 0 then
			pos = pos + moveright *bobscale * oldang:Right()
		else
			pos = pos - moveright *bobscale * oldang:Right()
		end	
		pos = pos + moveup *bobscale * oldang:Up()
		
		local upvel = math.Clamp(ownerVelocity[3]/128, -.375, 0)
		if game.SinglePlayer() or IsFirstTimePredicted() then
			local FT = FrameTime()
			if upvel < 0 then
				ground = Lerp(FT*60, ground, upvel)
			else			
				if ground < 0 then
					ground = math.min(Lerp(FT*6, ground, .01), 0)
				end
			end
		end
		pos = pos - Vector(0,0,ground)
	end
	
	if self.EnableLuaIdle then
		pos = pos + math.sin(CurTime() * 1.3) * oldang:Up() /26
	end
	
	if self:GetZoom() then
		pos = pos + ang:Up() * 20
	end

	return pos, oldang
end

function SWEP:DrawWeaponSelection(x, y, wide, tall, alpha)
	surface.SetDrawColor(255, 255, 255, alpha)
	surface.SetTexture(self.WepIcon)
	
	wide = wide/1.5
	tall = tall/2
	x = x+wide/4
	y = y+tall/2

	surface.DrawTexturedRect(x, y, wide, tall)
end

function SWEP:DrawHUD()
	self:Crosshair()
end

function SWEP:HealthDetect(tr)
	local colr, colg, colb = 255, 255, 255
	-- NPC health won't update in singleplayer if ai_disabled is 1
	if tr.Hit and self:IsCreature(tr.Entity) and tr.Entity:Health() > 0 then
		local maxhealth, health = tr.Entity:GetMaxHealth(), tr.Entity:Health()
		if health <= maxhealth / 4 then
			colr, colg, colb = 255, 0, 0
		elseif health <= maxhealth / 2 then
			colr, colg, colb = 255, 255, 0
		else
			colr, colg, colb = 0, 255, 0
		end
	end
	return colr, colg, colb
end

local crosshair = surface.GetTextureID("interface/crosshairs/xbox_cross")
local cvar_cl_crosshair = CreateClientConVar("ss2_cl_crosshair", 1)

function SWEP:Crosshair()
	if !cvar_cl_crosshair:GetBool() then return end
	local x, y
	local tr = self.Owner:GetEyeTraceNoCursor()
	
	if (self.Owner == LocalPlayer() && self.Owner:ShouldDrawLocalPlayer()) then
		local coords = tr.HitPos:ToScreen()
		x, y = coords.x, coords.y
	else
		x, y = ScrW() / 2, ScrH() / 2
	end

	local dist = math.Round(-self.Owner:GetPos():Distance(tr.HitPos) /64)
	dist = math.Clamp(dist+64, 32, 64)
	
	local colr, colg, colb = self:HealthDetect(tr)
	
	surface.SetTexture(crosshair)
	surface.SetDrawColor(colr, colg, colb, 255)
	surface.DrawTexturedRect(x - dist /2, y - dist /2, dist, dist)
end

function SWEP:DrawWorldModel()
	if self.Akimbo and !self.Owner:IsNPC() then
		local lhand, LHandAT
		
		if !IsValid(self.Owner) then
			self:DrawModel()
			return
		end
		
		if !LHandAT then
			LHandAT = self.Owner:LookupAttachment("anim_attachment_lh")
		end

		lhand = self.Owner:GetAttachment(LHandAT)
		
		if !lhand then
			self:DrawModel()
			return
		end

		loffset = lhand.Ang:Right() * self.AkimboOffset.Right + lhand.Ang:Forward() * self.AkimboOffset.Forward + lhand.Ang:Up() * self.AkimboOffset.Up
		lhand.Ang:RotateAroundAxis(lhand.Ang:Up(), 175)
		
		self.LeftModel:SetRenderOrigin(lhand.Pos + loffset)
		self.LeftModel:SetRenderAngles(lhand.Ang)	
		self.LeftModel:DrawModel()
	end	
	self:DrawModel()
end