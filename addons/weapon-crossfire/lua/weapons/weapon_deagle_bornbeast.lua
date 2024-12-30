if SERVER then
	AddCSLuaFile()
else
	SWEP.ViewModelFOV	= 60
	killicon.Add("weapon_deagle_bornbeast", "killicon/deagle_bornbeast", color_white)
	killicon.Add("weapon_deagle_bornbeast_melee", "killicon/deagle_bornbeast_melee", color_white)
	SWEP.WepSelectIcon = surface.GetTextureID("killicon/deagle_bornbeast")
	SWEP.BounceWeaponIcon = false
end

SWEP.Category	= "CrossFire"
SWEP.PrintName 		= "Deagle - Born Beast"
SWEP.Slot 			= 1
SWEP.SlotPos 		= 0

SWEP.Base 		= "weapon_cf_base"
SWEP.Spawnable 	= true
SWEP.HoldType 	= "pistol"

SWEP.ViewModel 	= "models/cf/c_deagle_beast.mdl"
SWEP.WorldModel = "models/cf/w_deagle_beast.mdl"

SWEP.Primary.Sound 		= Sound("weapons/deagle_beast/deagle-1.wav")
SWEP.Primary.Damage 	= 51
SWEP.Primary.Cone 		= 0.0125
SWEP.Primary.ClipSize 	= 11
SWEP.Primary.Delay 		= 0.3
SWEP.Primary.DefaultClip= 55
SWEP.Primary.Automatic 	= false
SWEP.Primary.Ammo 		= "357"


SWEP.MeleeRange 	= 50
SWEP.MeleeDamage 	= 62
SWEP.MeleeDuration	= 0.9
SWEP.DeployDuration	= 0.6
SWEP.MeleeAttack 	= 0.165
SWEP.MuzzleScale	= 1.3

SWEP.DeploySequence = 3
SWEP.MeleeSequence = 12

local single = game.SinglePlayer()
function SWEP:CustomDeploy(ct)
	self.NextReload = ct
	self.Owner:DoAnimationEvent(ACT_HL2MP_GESTURE_RANGE_ATTACK_MELEE)
	self.NextHit = ct
	self:AttackTrace()
	self.NextHit = nil
	if single then
		self:CallOnClient( "Deploy" )
	end
end