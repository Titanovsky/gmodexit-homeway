
if CLIENT then

	SWEP.PrintName			= "SBC Cannon"
	SWEP.Author				= "Upset"
	SWEP.Slot				= 5
	SWEP.SlotPos			= 0
	SWEP.ViewModelFOV		= 50
	-- SWEP.UpAngle			= 5.5
	SWEP.SBobScale			= .9
	SWEP.WepIcon			= surface.GetTextureID("interface/weaponicons/cannon")
	
end

function SWEP:PrimaryAttack()
	if !self:CanPrimaryAttack() or self:GetAttackDelay() > 0 then return end
	
	if cvars.Bool("ss2_sv_restrictcannon") then
		self:SetNextPrimaryFire(CurTime() + 2)
		if !self.Owner:IsNPC() then self.Owner:PrintMessage(HUD_PRINTCENTER, "Cannon is restricted!") end
		return
	end
	
	if self.Owner:IsNPC() then
		if self:GetNextPrimaryFire() <= CurTime() then
			self:SetNextPrimaryFire(CurTime() + self.Primary.Delay * 4)
			self:WeaponSound(self.Primary.Sound)
			self:SeriousFlash()
			self:TakeAmmo(1)
			if SERVER then
				local pos = self.Owner:GetShootPos()
				local ang = self.Owner:GetAimVector():Angle()
				pos = pos +ang:Right() *2
				local ent = ents.Create("ss2_cannonball")
				ent:SetPos(pos)
				ent:SetAngles(ang)
				ent:SetEntityOwner(self.Owner)
				ent:SetExplodeDelay(4)
				ent:SetDamage(self.Primary.Damage / 4)
				ent:Spawn()
				ent:Activate()
				local phys = ent:GetPhysicsObject()
				if IsValid(phys) then
					phys:AddGameFlag(FVPHYSICS_NO_IMPACT_DMG)
					local vel = ang:Forward() * 1000
					phys:SetVelocity(vel)
					phys:SetMass(10000)
				end
			end
		end
		return
	end
	
	self:SendWeaponAnim(ACT_VM_PRIMARYATTACK_1)
	if !self.ChargeSound then
		self.ChargeSound = CreateSound(self.Owner, self.Primary.Special)
		self.ChargeSound:SetSoundLevel(90)
	end
	if self.ChargeSound and !self.ChargeSound:IsPlaying() then
		self.ChargeSound:Play()
	end
	self:SetAttackDelay(CurTime() + 1.25)
end

function SWEP:SpecialThink()
	if game.SinglePlayer() and CLIENT then return end
	if self:GetAttackDelay() > 0 and (!self.Owner:KeyDown(IN_ATTACK) or self:GetAttackDelay() <= CurTime()) then
		local charge = (CurTime()+3.1 - self:GetAttackDelay())/2
		self:SetNextPrimaryFire(CurTime() + self.Primary.Delay * charge)
		self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
		self.Owner:SetAnimation(PLAYER_ATTACK1)
		self:WeaponSound(self.Primary.Sound)
		self:TakeAmmo(1)
		self:SeriousFlash()
		self:IdleStuff()
		if SERVER then
			local pos = self.Owner:GetShootPos()
			local ang = self.Owner:GetAimVector():Angle()
			local damage = math.Clamp(self.Primary.Damage * charge, self.Primary.Damage, 750)
			damage = math.Round(damage)
			pos = pos -ang:Up() *4 +ang:Right() *4
			local ent = ents.Create("ss2_cannonball")
			ent:SetPos(pos)
			ent:SetAngles(ang)
			ent:SetEntityOwner(self.Owner)
			ent:SetExplodeDelay(4)
			ent:SetDamage(damage)
			ent:Spawn()
			ent:Activate()
			local phys = ent:GetPhysicsObject()
			if IsValid(phys) then
				phys:AddGameFlag(FVPHYSICS_NO_IMPACT_DMG)
				local vel = ang:Forward() * 1000 * (CurTime()+1.75 - self:GetAttackDelay())*2
				phys:SetVelocity(vel)
				phys:SetMass(10000)
			end
		end
		self:HolsterDelay()
		self:OnRemove()
		self:SetEffectTime(CurTime()+.5)
	end
end

function SWEP:OnRemove()
	if self.ChargeSound then self.ChargeSound:Stop() end
	self:SpecialHolster()
end

function SWEP:SpecialHolster()
	self:SetAttackDelay(0)
end

local fxframetime = 0

function SWEP:ViewModelDrawn(vm)
	if !cvars.Bool("ss2_cl_particles") then return end
	local fxtime = self:GetEffectTime()
	if fxtime > CurTime() then
		fxframetime = fxframetime + FrameTime()
		if fxframetime > .25 then
			for i = 2, 3 do
				local fx = EffectData()
				fx:SetEntity(self)
				fx:SetOrigin(self:GetPos())
				fx:SetAttachment(i)
				util.Effect("ss2_tubeflame", fx)
			end
		end
	else
		fxframetime = 0
	end
end

SWEP.HoldType			= "crossbow"
SWEP.Base				= "weapon_ss2_base"
SWEP.Category			= "Serious Sam 2"
SWEP.Spawnable			= true

SWEP.ViewModel			= Model("models/serioussam2/weapons/v_cannon.mdl")
SWEP.WorldModel			= Model("models/serioussam2/weapons/w_cannon.mdl")

SWEP.Primary.Sound			= Sound("serioussam2/weapons/cannon/cannon_fire03.wav")
SWEP.Primary.Special		= Sound("serioussam2/weapons/cannon/cannon_charge06.wav")
SWEP.Primary.Damage			= 500
SWEP.Primary.Delay			= .5
SWEP.Primary.DefaultClip	= 5
SWEP.Primary.Ammo			= "cannonball"

SWEP.MuzzleScale			= 60
SWEP.SmokeType				= 2