
AddCSLuaFile()

SWEP.PrintName				= "Измеритель"
SWEP.Author					= "AmbitionProject"
SWEP.Purpose				= "пкм - Проверить"

SWEP.Slot					= 2
SWEP.SlotPos				= 1
SWEP.Category 				= "Drugs"

SWEP.Spawnable				= true
SWEP.AdminSpawnable			= true

SWEP.ViewModel				= Model( "models/weapons/c_messure.mdl" )
SWEP.WorldModel				= Model( "models/weapons/w_messure.mdl" )
SWEP.ViewModelFOV			= 54
SWEP.UseHands				= true

SWEP.Primary.ClipSize		= 0
SWEP.Primary.DefaultClip	= 0
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "none"

SWEP.Secondary.ClipSize		= 1
SWEP.Secondary.DefaultClip	= 1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

if SERVER then
	util.AddNetworkString("OpenTablet")
end

function SWEP:Initialize()

	self:SetHoldType( "slam" )

end

SWEP.Offset = {
	Pos = {
		Up = -4,
		Right = -3,
		Forward = 1,
	},
	Ang = {
		Up = 0,
		Right = 5,
		Forward = 0,
	}
}


function SWEP:DrawWorldModel( )
	local hand, offset, rotate

	if not IsValid( self.Owner ) then
		self:DrawModel( )
		return
	end

	if not self.Hand then
		self.Hand = self.Owner:LookupAttachment( "anim_attachment_rh" )
	end

	hand = self.Owner:GetAttachment( self.Hand )

	if not hand then
		self:DrawModel( )
		return
	end

	offset = hand.Ang:Right( ) * self.Offset.Pos.Right + hand.Ang:Forward( ) * self.Offset.Pos.Forward + hand.Ang:Up( ) * self.Offset.Pos.Up

	hand.Ang:RotateAroundAxis( hand.Ang:Right( ), self.Offset.Ang.Right )
	hand.Ang:RotateAroundAxis( hand.Ang:Forward( ), self.Offset.Ang.Forward )
	hand.Ang:RotateAroundAxis( hand.Ang:Up( ), self.Offset.Ang.Up )

	self:SetRenderOrigin( hand.Pos + offset )
	self:SetRenderAngles( hand.Ang )

	self:DrawModel( )
end

function SWEP:Deploy()
	self:SendWeaponAnim( ACT_VM_DRAW )
end

function SWEP:PrimaryAttack()

	return
end

function SWEP:SecondaryAttack()

	return

end

function SWEP:Think()
	if(IsValid(self.Owner:GetEyeTrace().Entity) && self.Owner:GetEyeTrace().Entity:GetClass() == "sent_pot") then
		self.Owner:GetViewModel(0):SetPoseParameter("health_nail",self.Owner:GetEyeTrace().Entity:Health()/100)
		self.Owner:GetViewModel(0):SetPoseParameter("water_nail",self.Owner:GetEyeTrace().Entity:GetNWInt("Water",0)/self.Owner:GetEyeTrace().Entity:GetNWInt("MaxWater",0))
	else
		self.Owner:GetViewModel(0):SetPoseParameter("health_nail",0)
		self.Owner:GetViewModel(0):SetPoseParameter("water_nail",0)
	end
end
