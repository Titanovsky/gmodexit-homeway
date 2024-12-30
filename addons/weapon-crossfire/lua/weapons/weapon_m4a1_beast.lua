if SERVER then
	AddCSLuaFile()
else
	SWEP.ViewModelFOV	= 60
	killicon.Add("weapon_m4a1_beast", "killicon/m4a1_beast", color_white)
	killicon.Add("weapon_m4a1_beast_melee", "killicon/m4a1_beast_melee", color_white)
	SWEP.WepSelectIcon = surface.GetTextureID("killicon/m4a1_beast")
	SWEP.BounceWeaponIcon = false
end 

SWEP.Category	= "CrossFire"
SWEP.PrintName 		= "M4A1-S-Beast"
SWEP.Slot 			= 2
SWEP.SlotPos 		= 1

SWEP.Base 		= "weapon_cf_base"
SWEP.Spawnable 	= true
SWEP.HoldType 	= "ar2"

SWEP.ViewModel 	= "models/cf/c_m4a1_beast.mdl"
SWEP.WorldModel = "models/cf/w_m4a1_beast.mdl"

SWEP.Primary.Sound 		= Sound("weapons/m4a1_beast/rifle_fire_1.wav")
SWEP.Primary.Damage 	= 26
SWEP.Primary.Cone 		= 0.0185
SWEP.Primary.ClipSize 	= 38
SWEP.Primary.Delay 		= 0.1
SWEP.Primary.DefaultClip= 152
SWEP.Primary.Automatic 	= true
SWEP.Primary.Ammo 		= "smg1"

SWEP.MeleeRange 	= 38
SWEP.MeleeDamage 	= 55
SWEP.MeleeAttack	= 0.15
SWEP.MeleeDuration	= 0.95
SWEP.MeleeSound		= "weapons/m4a1_beast/rifle_melee.wav"
SWEP.MuzzleScale	= 0.75

SWEP.ReloadSequence	= 8
