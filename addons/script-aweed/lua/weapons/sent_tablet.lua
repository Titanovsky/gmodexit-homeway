
AddCSLuaFile()

SWEP.PrintName				= "Планшет"
SWEP.Author					= "AmbitionProject"
SWEP.Purpose				= "пкм - Открыть"

SWEP.Slot					= 2
SWEP.SlotPos				= 1
SWEP.Category 				= "Drugs"

SWEP.Spawnable				= true
SWEP.AdminSpawnable			= true

SWEP.ViewModel				= Model( "models/weapons/c_tablet_v2.mdl" )
SWEP.WorldModel				= Model( "models/weapons/w_tablet_v2.mdl" )
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
	resource.AddFile("models/weapons/c_tablet_v2.mdl")
	resource.AddFile("models/weapons/w_tablet_v2.mdl")
	resource.AddFile("materials/models/weapons/c_tablet/tablet_b.vmt")
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
	self:SetSkin(2)
	self:SendWeaponAnim( ACT_VM_DRAW )
	timer.Simple(self:SequenceDuration(),function()
		if(IsValid(self)) then
			self:SetSkin(1)
			self:SendWeaponAnim( ACT_VM_IDLE )
		end
	end)
	return true
end

function SWEP:PrimaryAttack()
	if(CLIENT && IsFirstTimePredicted()) then
		if(WEED_PANEL != nil) then
			WEED_PANEL:Remove()
		end
		WEED_PANEL = vgui.Create("dWeeder")
	end
	return
end

function SWEP:SecondaryAttack()

	return

end

function SWEP:Holster(wep)
    return true
end
