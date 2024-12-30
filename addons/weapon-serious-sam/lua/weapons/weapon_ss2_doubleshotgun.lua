
if CLIENT then

	SWEP.PrintName			= "Double Shotgun"
	SWEP.Author				= "Upset"
	SWEP.Slot				= 2
	SWEP.SlotPos			= 1
	SWEP.ViewModelFOV		= 40
	-- SWEP.UpAngle			= 2.5
	SWEP.SBobScale			= .7
	SWEP.WepIcon			= surface.GetTextureID("interface/weaponicons/doubleshotgun")
	
end

SWEP.HoldType			= "shotgun"
SWEP.Base				= "weapon_ss2_base"
SWEP.Category			= "Serious Sam 2"
SWEP.Spawnable			= true

SWEP.ViewModel			= Model("models/serioussam2/weapons/v_doubleshotgun.mdl")
SWEP.WorldModel			= Model("models/serioussam2/weapons/w_doubleshotgun.mdl")

SWEP.Primary.Sound			= Sound("serioussam2/weapons/doubleshotgun/doubleshotgun_fire04.wav")
SWEP.Primary.Damage			= 12
SWEP.Primary.NumShots		= 14
SWEP.Primary.Cone			= .12
SWEP.Primary.Delay			= 1.35
SWEP.Primary.DefaultClip	= 20
SWEP.Primary.Ammo			= "Buckshot"

SWEP.AmmoToTake				= 2

SWEP.MuzzleScale			= 40
SWEP.SmokeType				= 2