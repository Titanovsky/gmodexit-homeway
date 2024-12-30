
if CLIENT then

	SWEP.PrintName			= "Uzi"
	SWEP.Author				= "Upset"
	SWEP.Slot				= 2
	SWEP.SlotPos			= 2
	SWEP.ViewModelFOV		= 58
	-- SWEP.UpAngle			= 10
	SWEP.WepIcon			= surface.GetTextureID("interface/weaponicons/uzi")
	
end

if SERVER then
	function SWEP:NPCShoot_Primary(ShootPos, ShootDir)
		local owner = self:GetOwner()
		if !IsValid(owner) then return end
		timer.Create("SS2UziNPCAttack"..self.Owner:EntIndex(), self.Primary.Delay, 4, function()
			if !owner or !IsValid(owner) then return end
			self:PrimaryAttack()
		end)
	end
end

SWEP.FireSounds = {
	Sound("serioussam2/weapons/uzi/uzi_fire12.wav"),
	Sound("serioussam2/weapons/uzi/uzi_fire13.wav")
}

SWEP.HoldType			= "duel"
SWEP.Base				= "weapon_ss2_base"
SWEP.Category			= "Serious Sam 2"
SWEP.Spawnable			= true

SWEP.ViewModel			= Model("models/serioussam2/weapons/v_uzi.mdl")
SWEP.WorldModel			= Model("models/serioussam2/weapons/w_uzi.mdl")

SWEP.Primary.Cone			= .02
SWEP.Primary.Delay			= .09
SWEP.Primary.DefaultClip	= 100
SWEP.Primary.Ammo			= "smg1"
SWEP.Primary.Damage 		= 8

SWEP.MuzzleScale			= 12

SWEP.Akimbo					= true