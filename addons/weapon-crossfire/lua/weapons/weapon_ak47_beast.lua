if SERVER then
	AddCSLuaFile()
else
	SWEP.ViewModelFOV	= 60
	killicon.Add("weapon_ak47_beast", "killicon/ak47_beast", color_white)
	killicon.Add("weapon_ak47_beast_melee", "killicon/ak47_beast_melee", color_white)
	SWEP.WepSelectIcon = surface.GetTextureID("killicon/ak47_beast")
	SWEP.BounceWeaponIcon = false
end 

SWEP.Category	= "CrossFire"
SWEP.PrintName 		= "AK47 - Iron Beast"
SWEP.Slot 			= 2
SWEP.SlotPos 		= 1

SWEP.Base 		= "weapon_cf_base"
SWEP.Spawnable 	= true
SWEP.HoldType 	= "ar2"

SWEP.ViewModel 	= "models/cf/c_ak47_beast.mdl"
SWEP.WorldModel = "models/cf/w_ak47_beast.mdl"

SWEP.Primary.Sound 		= Sound("weapons/ak47_beast/rifle_fire_1.wav")
SWEP.Primary.Damage 	= 32
SWEP.Primary.Cone 		= 0.03
SWEP.Primary.ClipSize 	= 35
SWEP.Primary.Delay 		= 0.1
SWEP.Primary.DefaultClip= 140
SWEP.Primary.Automatic 	= true
SWEP.Primary.Ammo 		= "ar2"

SWEP.MeleeRange 	= 62
SWEP.MeleeDamage 	= 51
SWEP.MeleeAttack	= 0.22
SWEP.MeleeDuration	= 0.85
SWEP.MeleeSound		= "weapons/ak47_beast/rifle_melee.wav"

SWEP.MuzzleAttach	= 2
SWEP.MuzzleScale	= 1
SWEP.ShellEffect	= true

-- function SWEP:CustomDeploy()
-- 	timer.Simple(0.03125,function() -- 1/fps
-- 		if IsValid(self) then
-- 			self:SendWeaponAnim(ACT_VM_DEPLOY)
-- 		end
-- 	end)
-- end