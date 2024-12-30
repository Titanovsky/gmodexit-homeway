
if CLIENT then

	SWEP.PrintName			= "Auto Shotgun"
	SWEP.Author				= "Upset"
	SWEP.Slot				= 2
	SWEP.SlotPos			= 0
	SWEP.ViewModelFOV		= 50
	-- SWEP.UpAngle			= 5.2
	SWEP.WepIcon			= surface.GetTextureID("interface/weaponicons/autoshotgun")

end

SWEP.HoldType			= "shotgun"
SWEP.Base				= "weapon_ss2_base"
SWEP.Category			= "Serious Sam 2"
SWEP.Spawnable			= true

SWEP.ViewModel			= Model("models/serioussam2/weapons/v_autoshotgun.mdl")
SWEP.WorldModel			= Model("models/serioussam2/weapons/w_autoshotgun.mdl")

SWEP.Primary.Sound			= Sound("serioussam2/weapons/autoshotgun/autoshotgun_fire05.wav")
SWEP.Primary.Damage			= 12
SWEP.Primary.NumShots		= 7
SWEP.Primary.Cone			= .08
SWEP.Primary.Delay			= 1
SWEP.Primary.DefaultClip	= 10
SWEP.Primary.Ammo			= "Buckshot"

SWEP.MuzzleScale			= 15
SWEP.SmokeType				= 2