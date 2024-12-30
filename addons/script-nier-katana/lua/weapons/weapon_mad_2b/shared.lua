if (SERVER) then

	AddCSLuaFile( "shared.lua" )
	SWEP.Weight				= 5
	SWEP.AutoSwitchTo			= false
	SWEP.AutoSwitchFrom		= false

end

sound.Add({
	['name'] = "TFA_L4D2_OREN.Equip",
	['channel'] = CHAN_STATIC,
	['sound'] = { "weapons/l4d2_oren_katana/knife_deploy.wav" },
	['pitch'] = {95,105}
})

sound.Add({
	['name'] = "TFA_L4D2_OREN.Holster",
	['channel'] = CHAN_STATIC,
	['sound'] = { "weapons/l4d2_oren_katana/katana_holster.wav" },
	['pitch'] = {95,105}
})

sound.Add({
	['name'] = "TFA_L4D2_OREN.Swing",
	['channel'] = CHAN_STATIC,
	['sound'] = { "weapons/l4d2_oren_katana/katana_swing_miss1.wav", "weapons/l4d2_oren_katana/katana_swing_miss2.wav", "weapons/l4d2_oren_katana/katana_swing_miss3.wav", "weapons/l4d2_oren_katana/katana_swing_miss4.wav"},
	['pitch'] = {95,105}
})
sound.Add({
	['name'] = "TFA_L4D2_OREN.HitFlesh",
	['channel'] = CHAN_STATIC,
	['sound'] = { "weapons/l4d2_oren_katana/melee_katana_01.wav", "weapons/l4d2_oren_katana/melee_katana_04.wav" },
	['pitch'] = {95,105}
})
sound.Add({
	['name'] = "TFA_L4D2_OREN.HitFleshHard",
	['channel'] = CHAN_STATIC,
	['sound'] = { "weapons/l4d2_oren_katana/melee_katana_02.wav", "weapons/l4d2_oren_katana/melee_katana_03.wav" },
	['pitch'] = {95,105}
})
sound.Add({
	['name'] = "TFA_L4D2_OREN.HitWorld",
	['channel'] = CHAN_STATIC,
	['sound'] = { "weapons/l4d2_oren_katana/katana_impact_world1.wav", "weapons/l4d2_oren_katana/katana_impact_world2.wav" },
	['pitch'] = {95,105}
})

SWEP.HoldType = "melee2"

if ( CLIENT ) then
	SWEP.PrintName			= "VIRTUOUS CONTRACT"
	SWEP.Author				= "Xaxidoro"
	SWEP.DrawAmmo 			= false
	SWEP.DrawCrosshair 		= false
	SWEP.ViewModelFOV			= 80
	SWEP.ViewModelFlip		= false
	SWEP.CSMuzzleFlashes		= false
	
	SWEP.Slot				= 1
	SWEP.SlotPos			= 1

	killicon.Add("weapon_mad_2b", "HUD/killicons/default", Color( 255, 80, 0, 255 ) )
end


SWEP.Base 						= "weapon_mad_base"

SWEP.Category					= "Nier"

SWEP.UseHands 					= true

SWEP.Spawnable					= true
SWEP.AdminSpawnable				= true

SWEP.ViewModel 					= "models/weapons/c_2b_sword.mdl"
SWEP.WorldModel 				= "models/weapons/w_2b_sword.mdl"

SWEP.Weight						= 5
SWEP.AutoSwitchTo				= false
SWEP.AutoSwitchFrom				= false
SWEP.HoldType = "melee2"

SWEP.Primary.Delay 				= 0.5
SWEP.Primary.Cone				= 0.1
SWEP.Primary.ClipSize			= -1
SWEP.Primary.Damage				= 34
SWEP.Primary.DefaultClip		= -1
SWEP.Primary.Automatic			= true
SWEP.Primary.Ammo				= "none"
SWEP.Primary.Combo				= 0

SWEP.Secondary.ClipSize			= -1
SWEP.Secondary.DefaultClip		= -1
SWEP.Secondary.Damage			= 0	
SWEP.Secondary.Automatic		= true
SWEP.Secondary.Ammo				= "none"
SWEP.Secondary.Combo			= 0

SWEP.Pistol						= true
SWEP.Rifle						= false
SWEP.Shotgun					= false
SWEP.Sniper						= false

SWEP.RunArmOffset 				= Vector(0,2,-2)
SWEP.RunArmAngle 				= Vector(-10,0,5)

SWEP.HoldingPos 				= Vector(0,0,-1)
SWEP.HoldingAng 				= Vector(0,-90,0)

SWEP.MeleeRange					= 110
SWEP.SwingTimeAlt				= 0.45
SWEP.SwingTime 					= 0.2

SWEP.Idling 					= 0
SWEP.Parrying 					= false
SWEP.ParryTime 					= CurTime()
SWEP.SlashTime 					= CurTime()
SWEP.ShootTime					= CurTime()
SWEP.AirDashTime				= CurTime()
SWEP.SprintTime					= CurTime()
SWEP.ComboReset					= CurTime()

SWEP.DroneActive 				= false
SWEP.Drone 						= nil

SWEP.Offset = { --Procedural world model animation, defaulted for CS:S purposes.
	Pos = {
		Up = 1,
		Right = -1,
		Forward = 2
	},
	Ang = {
		Up = 0,
		Right = 0,
		Forward = 0
	},
	Scale = 0.8
}

function SWEP:IdleAnimationDelay( seconds, index )
	timer.Remove( "IdleAnimation" )
	self.Idling = index
	timer.Create( "IdleAnimation", seconds, 1, function()
		if not self:IsValid() or self.Idling == 0 then return end
		if self.Idling == index then
			self.Weapon:SendWeaponAnim(ACT_VM_IDLE)
		end
	end )
end

/*---------------------------------------------------------
   Name: SWEP:Reload()
   Desc: Parry
---------------------------------------------------------*/
function SWEP:Reload()

	if self.Owner:KeyDown(IN_USE) and self.SlashTime < CurTime() then
		if self.Weapon:GetNetworkedBool("Holsted") or self.Weapon:GetDTBool(0) then return end
		
		self.SlashTime = CurTime() + 3
		self.ParryTime = CurTime() + 5
		self.Parrying = true
		
		self.Weapon:SendWeaponAnim(ACT_VM_RECOIL3)
		self.Weapon:EmitSound("TFA_L4D2_OREN.Holster", 50, 100)
		
		self.Weapon:SetNextPrimaryFire(CurTime() + 2.7)
		self.Weapon:SetNextSecondaryFire(CurTime() + 2.7)
		
		if SERVER then
			timer.Simple( 2.5, function() 
				if not self:IsValid() or self.Idling == 0 then return end
				self.Parrying = false 
				self.Owner:SetAnimation(PLAYER_ATTACK1)
				self.Weapon:SendWeaponAnim(ACT_VM_HITLEFT)
				self.Owner:GetViewModel():SetPlaybackRate(3)
				self.Weapon:EmitSound("TFA_L4D2_OREN.HitFlesh")
				self:Bomb()
			end )
		end
		
		self:IdleAnimationDelay( 3, 3 )
		return
	end
	
end

function SWEP:OnRemove() 
	self:Holster()
	return true
end
function SWEP:OnDrop()
	self:Holster()
	return true
end
function SWEP:Holster()
	self.Idling = 0
	self.Parrying = false
	self.ParryTime = CurTime()
	self.SprintTime = CurTime()
	timer.Remove( "IdleAnimation" )
	
	if self.Drone then
		if self.Drone:IsValid() then
			self.Drone:Remove()
			self.Drone = nil
			self.DroneActive = false
		end
	end
	if self.Owner:IsValid() then
		self.Owner:SetRunSpeed( 500 )
	end
	
	return true
end

/*---------------------------------------------------------
   Name: SWEP:Deploy()
---------------------------------------------------------*/
function SWEP:Deploy()
	
	self.Parrying = false
	self.Weapon:SendWeaponAnim(ACT_VM_DRAW)
	self.Weapon:SetNextPrimaryFire(CurTime() + 1)

	self:IdleAnimationDelay( 0.9, -1 )
	
	if SERVER and not self.DroneActive then
		self.Drone = ents.Create("ent_pod")
		self.Drone:SetOwner( self.Owner )
		self.Drone:SetAngles(self.Owner:EyeAngles())
		local pos = self.Owner:GetShootPos()
			pos = pos + self.Owner:GetForward() * -10
			pos = pos + self.Owner:GetRight() * -25
			pos = pos + self.Owner:GetUp() * 25
		self.Drone:SetPos(pos)
		self.Drone:SetPhysicsAttacker(self.Owner)
		self.Drone:Spawn()
		self.Drone:Activate()
		self.DroneActive = true
	end

	return true
	
end

/*---------------------------------------------------------
   Name: SWEP:Think()
   Desc: Called every frame.
---------------------------------------------------------*/
function SWEP:Think()

	if self.ComboReset < CurTime() then
		self.Primary.Combo = 0
		self.Secondary.Combo = 0
	end

	if self.Owner:KeyPressed( IN_SPEED ) then
		self.SprintTime = CurTime()
		self.Owner:EmitSound( "weapons/physcannon/energy_sing_flyby2.wav" )
	end
	if self.Owner:KeyDown( IN_SPEED ) then
		if CurTime() - self.SprintTime > 3 then
			self.Owner:SetRunSpeed( 900 )
		elseif CurTime() - self.SprintTime < 0.6 then
			self.Owner:SetRunSpeed( 1300 )
			self.ParryTime = CurTime() + 1
			self.Parrying = true
		else
			self.Owner:SetRunSpeed( 500 )
		end
	else
		self.Owner:SetRunSpeed( 500 )
		self.SprintTime = CurTime()
	end
	
	if not self.Owner:IsOnGround() then
		if self.Owner:KeyPressed( IN_JUMP ) and self.AirDashTime < CurTime() and IsFirstTimePredicted() then
			self.AirDashTime = CurTime() + 0.5
			self.Owner:EmitSound( "weapons/physcannon/energy_sing_flyby2.wav" )
			if self.Owner:KeyDown( IN_FORWARD ) then
				self.Owner:SetVelocity( self.Owner:GetAimVector() * 300 + self.Owner:GetUp() * 100 )
			elseif self.Owner:KeyDown( IN_BACK ) then
				self.Owner:SetVelocity( self.Owner:GetAimVector() * -300 + self.Owner:GetUp() * 100 )
			elseif self.Owner:KeyDown( IN_MOVELEFT ) then
				self.Owner:SetVelocity( self.Owner:GetRight() * -300 + self.Owner:GetUp() * 100 )
			elseif self.Owner:KeyDown( IN_MOVERIGHT ) then
				self.Owner:SetVelocity( self.Owner:GetRight() * 300 + self.Owner:GetUp() * 100 )
			else
				self.Owner:SetVelocity( self.Owner:GetUp() * 300 )
			end
		end
	elseif IsFirstTimePredicted() then
		self.AirDashTime = CurTime()
	end

	if self.ParryTime < CurTime() + 0.3 then
		self.Parrying = false
	end

	if self.DroneActive == true and not self.Drone:IsValid() and SERVER then
		self.Drone = ents.Create("ent_pod")
		self.Drone:SetOwner( self.Owner )
		self.Drone:SetAngles(self.Owner:EyeAngles())
		local pos = self.Owner:GetShootPos()
			pos = pos + self.Owner:GetForward() * -10
			pos = pos + self.Owner:GetRight() * -25
			pos = pos + self.Owner:GetUp() * 25
		self.Drone:SetPos(pos)
		self.Drone:SetPhysicsAttacker(self.Owner)
		self.Drone:Spawn()
		self.Drone:Activate()
	end
	
	self:NextThink(CurTime())
	
end

/*---------------------------------------------------------
Initialize
---------------------------------------------------------*/
function SWEP:Initialize()
	self:SetWeaponHoldType(self.HoldType) 	-- Hold type of the 3rd person animation
end

function SWEP:Parry( target, dmg )
	if target == self.Owner then
		if self.ParryTime > CurTime() then
			
			local damageForce = dmg:GetDamageForce()
			self.Weapon:EmitSound( "bounce.wav" )
			dmg:ScaleDamage( 0 )
			dmg:SetDamageForce( damageForce )
			
		end
	end
end

function Reflect(target, dmg)

	if !target:IsValid() or !target:IsPlayer() then return end
	
	local Wep = target:GetActiveWeapon()
	if !IsValid( Wep ) then return end
	if !Wep:IsWeapon() then return end
	if !Wep.MadCow then return end
	if Wep:GetClass() != "weapon_mad_2b" then return end
	
	if dmg:GetDamageType() == DMG_FALL then
		dmg:SetDamage( 0 )
		return
	end
	
	Wep:Parry( target, dmg )

end
hook.Add( "EntityTakeDamage", "2bReflect", Reflect );

function SWEP:DroneShoot()

	if not self.Drone then return end
	if not self.Drone:IsValid() then return end
	if self.Drone.HurtTime > CurTime() then return end
	
	self.Drone:EmitSound( "weapons/pod042/a.wav", 160, 100, 1, CHAN_WEAPON )
	if SERVER then
		local shot = ents.Create("ent_pod_shot")
		shot:SetAngles(self.Drone:EyeAngles())

		local pos = self.Drone:GetPos()
			pos = pos + self.Drone:GetRight() * -5
		shot:SetPos(pos)

		shot:SetOwner(self.Owner)
		shot:SetPhysicsAttacker(self.Owner)
		shot:Spawn()
		shot:Activate()

		local trace = util.TraceLine( {
			start = self:GetOwner():GetShootPos(),
			endpos = self:GetOwner():GetShootPos() + self.Owner:GetAimVector() * 10000,
			filter = self:GetOwner()
		} )
		trace.mask = MASK_SHOT
		local lookAng = ( trace.HitPos - self.Drone:GetPos() ):Angle()
		
		local phys = shot:GetPhysicsObject()
		if phys:IsValid() then
			phys:SetVelocity( ( trace.HitPos - self.Drone:GetPos() ):GetNormalized() * 3500 + Vector( 2000 * ( math.random() - 0.5 ) * self.Primary.Cone, 2000 * ( math.random() - 0.5 ) * self.Primary.Cone, 2000 * ( math.random() - 0.5 ) * self.Primary.Cone ))
		end
		--phys:AddAngleVelocity(Vector(0, 500, 0))
	end
end

/*---------------------------------------------------------
   Name: SWEP:SecondaryAttack()
   Desc: +attack2 has been pressed.
---------------------------------------------------------*/
function SWEP:SecondaryAttack()
	
	if not IsFirstTimePredicted() then return end

	// Holst/Deploy your fucking weapon
	if (not self.Owner:IsNPC() and self.Owner:KeyDown(IN_USE)) then
		if self.Weapon:GetNetworkedBool("Holsted") or self.Owner:KeyDown(IN_SPEED) then return end
		if self.ShootTime > CurTime() then return end

		if (SERVER) then
			self:DroneShoot()
			timer.Simple( 0.1, function() self:DroneShoot() end )
			timer.Simple( 0.2, function() self:DroneShoot() end )
			timer.Simple( 0.3, function() self:DroneShoot() end )
			timer.Simple( 0.4, function() self:DroneShoot() end )
		end
		
		self.ShootTime = CurTime() + 0.5
		return
	end

	if self.Weapon:GetNetworkedBool("Holsted") or self.Owner:KeyDown(IN_SPEED) or self.Weapon:GetDTBool(0) then return end

	self.Weapon:SetNextPrimaryFire(CurTime() + self.Primary.Delay + self.SwingTimeAlt - 0.05)
	self.Weapon:SetNextSecondaryFire(CurTime() + self.Primary.Delay + self.SwingTimeAlt - 0.05)
	self.ComboReset = CurTime() + self.Primary.Delay + self.SwingTimeAlt + 0.65
	self.Owner:SetAnimation(PLAYER_ATTACK1)
	
	local ani = math.random( 1, 3 )
	if ani == 1 then
		self.Weapon:SendWeaponAnim(ACT_VM_MISSLEFT)
		self.Owner:GetViewModel():SetPlaybackRate(1.25)
	elseif ani == 2 then
		self.Weapon:SendWeaponAnim(ACT_VM_MISSRIGHT)
		self.Owner:GetViewModel():SetPlaybackRate(1.25)
	else 
		self.Weapon:SendWeaponAnim(ACT_VM_PULLBACK_HIGH)
		self.Owner:GetViewModel():SetPlaybackRate(1.25)
	end
	
	timer.Simple( self.SwingTimeAlt, function()
		
		local hitted = false
		self.Secondary.Combo = self.Secondary.Combo + 1
	
		if not self:IsValid() or self.Idling == 0 then return end
		self.ParryTime = CurTime()
		self.Parrying = false
		
		self.Weapon:EmitSound("TFA_L4D2_OREN.Swing")

		local ents = ents.FindInSphere(self.Owner:GetPos(), self.MeleeRange)

		local dmginfo = DamageInfo()
			dmginfo:SetAttacker( self.Owner )
			dmginfo:SetInflictor( self )
		
		for k, v in pairs(ents) do
			if v ~= self and v ~= self.Owner and IsValid(v) and self:EntityFaceFront( v, 50 ) and self.Owner:GetPos() ~= v:GetPos() then
				if self:EntityFaceBack(v) then
					dmginfo:SetDamage( 450 + self.Secondary.Combo * 50 )
				else 
					dmginfo:SetDamage( 145 + self.Secondary.Combo * 15 )
				end
				-- self.Weapon:EmitSound("TFA_L4D2_OREN.HitWorld")
				hitted = true
				dmginfo:SetDamageForce( ( v:GetPos() - self.Owner:GetPos() ):GetNormalized() * 50000 )
				if SERVER then
					v:TakeDamageInfo( dmginfo )
				end
				if v:GetPhysicsObject():IsValid() and not string.find(v:GetClass(), "ent_pod") then
					v:GetPhysicsObject():ApplyForceCenter( ( v:GetPos() - self.Owner:GetPos() ):GetNormalized() * 50000 )
				end
			end
		end
		
		self.Primary.Combo = 0
		
		local trace = util.TraceLine( {
			start = self.Owner:GetShootPos(),
			endpos = self.Owner:GetShootPos() + self.Owner:GetAimVector() * self.MeleeRange,
			filter = self.Owner
		} )
		trace.mask = MASK_SHOT
		if (trace.Hit) then
			hitted = true
			if trace.Entity:GetClass() == "func_door_rotating" or trace.Entity:GetClass() == "prop_door_rotating" then
			elseif trace.Entity:IsNPC() or trace.Entity:IsPlayer() then
			else
				bullet = {}
				bullet.Num    = 1
				bullet.Src    = self.Owner:GetShootPos()
				bullet.Dir    = self.Owner:GetAimVector()
				bullet.Spread = Vector(0, 0, 0)
				bullet.Tracer = 0
				bullet.Force  = 0
				bullet.Damage = 25
				bullet.AmmoType = "357"
				self.Owner:FireBullets(bullet)
				--self.Weapon:EmitSound("TFA_L4D2_OREN.HitWorld")
			end
		end

		if hitted then
			self.Weapon:EmitSound("TFA_L4D2_OREN.HitWorld")
		end
		
		if ((game.SinglePlayer() and SERVER) or CLIENT) then
			self.Weapon:SetNetworkedFloat("LastShootTime", CurTime())
		end

		self:IdleAnimationDelay( 0.3, 1 )
	
	end)
	
end

/*---------------------------------------------------------
   Name: SWEP:PrimaryAttack()
   Desc: +attack1 has been pressed.
---------------------------------------------------------*/
function SWEP:PrimaryAttack()
	
	if not IsFirstTimePredicted() then return end
	
	// Holst/Deploy your fucking weapon
	if (not self.Owner:IsNPC() and self.Owner:KeyDown(IN_USE)) then
		bHolsted = !self.Weapon:GetDTBool(0)
		self:SetHolsted(bHolsted)

		self.Weapon:SetNextPrimaryFire(CurTime() + 0.3)
		self.Weapon:SetNextSecondaryFire(CurTime() + 0.3)

		self:SetIronsights(false)

		return
	end
	
	self.ParryTime = CurTime()
	
	if self.Weapon:GetNetworkedBool("Holsted") or self.Owner:KeyDown(IN_SPEED) or self.Weapon:GetDTBool(0) then return end

	self.Weapon:SetNextPrimaryFire(CurTime() + self.Primary.Delay + self.SwingTime - 0.05)
	self.Weapon:SetNextSecondaryFire(CurTime() + self.Primary.Delay + self.SwingTime - 0.05)
	self.ComboReset = CurTime() + self.Primary.Delay + self.SwingTime + 0.65
	self.Owner:SetAnimation(PLAYER_ATTACK1)
	
	local ani = math.random( 1, 3 )
	if ani == 1 or self.Primary.Combo == 4 then
		self.Weapon:SendWeaponAnim(ACT_VM_HITLEFT)
		self.Owner:GetViewModel():SetPlaybackRate(1.25)
	elseif ani == 2 then
		self.Weapon:SendWeaponAnim(ACT_VM_HITRIGHT)
		self.Owner:GetViewModel():SetPlaybackRate(1.25)
	else 
		self.Weapon:SendWeaponAnim(ACT_VM_PULLBACK)
		self.Owner:GetViewModel():SetPlaybackRate(1.25)
	end
	
	timer.Simple( self.SwingTime, function()

		local hitted = false
		self.Primary.Combo = self.Primary.Combo + 1
		
		if not self:IsValid() or self.Idling == 0 then return end
		self.ParryTime = CurTime()
		self.Parrying = false
		
		self.Weapon:EmitSound("TFA_L4D2_OREN.Swing")

		local ents = ents.FindInSphere(self.Owner:GetPos(), self.MeleeRange)

		local dmginfo = DamageInfo()
			dmginfo:SetAttacker( self.Owner )
			dmginfo:SetInflictor( self )
		
		if self.Primary.Combo < 5 then
			for k, v in pairs(ents) do
				if v ~= self and v ~= self.Owner and IsValid(v) and self:EntityFaceFront( v, 35 ) and self.Owner:GetPos() ~= v:GetPos() then
					if self:EntityFaceBack(v) then
						dmginfo:SetDamage( 235 + self.Primary.Combo * 15 )
					else 
						dmginfo:SetDamage( 100 + self.Primary.Combo * 10 )
					end
					--self.Weapon:EmitSound("TFA_L4D2_OREN.HitWorld")
					hitted = true
					dmginfo:SetDamageForce( ( v:GetPos() - self.Owner:GetPos() ):GetNormalized() * 50000 )
					if SERVER then
						v:TakeDamageInfo( dmginfo )
					end
					if v:GetPhysicsObject():IsValid() and not string.find(v:GetClass(), "ent_pod") then
						v:GetPhysicsObject():ApplyForceCenter( ( v:GetPos() - self.Owner:GetPos() ):GetNormalized() * 50000 )
					end
				end
			end
		else
			self.Weapon:EmitSound("TFA_L4D2_OREN.HitFlesh")
			self:RushFiveBomb()
			self.Primary.Combo = 0
			self.Secondary.Combo = 0
		end
		
		self.Secondary.Combo = 0
		
		local trace = util.TraceLine( {
			start = self.Owner:GetShootPos(),
			endpos = self.Owner:GetShootPos() + self.Owner:GetAimVector() * self.MeleeRange,
			filter = self.Owner
		} )
		trace.mask = MASK_SHOT
		if (trace.Hit) then
			hitted = true
			if trace.Entity:GetClass() == "func_door_rotating" or trace.Entity:GetClass() == "prop_door_rotating" then
			elseif trace.Entity:IsNPC() or trace.Entity:IsPlayer() then
			else
				bullet = {}
				bullet.Num    = 1
				bullet.Src    = self.Owner:GetShootPos()
				bullet.Dir    = self.Owner:GetAimVector()
				bullet.Spread = Vector(0, 0, 0)
				bullet.Tracer = 0
				bullet.Force  = 0
				bullet.Damage = 25
				bullet.AmmoType = "357"
				self.Owner:FireBullets(bullet)
				--self.Weapon:EmitSound("TFA_L4D2_OREN.HitWorld")
			end
		end

		if hitted then
			self.Weapon:EmitSound("TFA_L4D2_OREN.HitWorld")
		end
		
		if ((game.SinglePlayer() and SERVER) or CLIENT) then
			self.Weapon:SetNetworkedFloat("LastShootTime", CurTime())
		end

		self:IdleAnimationDelay( 0.3, 1 )
	
	end)
	
end