
AddCSLuaFile()

SWEP.PrintName				= "Бонг"
SWEP.Author					= "Ambition Role Play"
SWEP.Purpose				= "пкм - Курить"

SWEP.Slot					= 2
SWEP.SlotPos				= 1
SWEP.Category 				= "Drugs"

SWEP.Spawnable				= true
SWEP.AdminSpawnable			= true

SWEP.ViewModel				= Model( "models/weapons/c_bong.mdl" )
SWEP.WorldModel				= Model( "models/weapons/w_bong.mdl" )
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

SWEP.MaxAmmo				= 100	-- Maxumum ammo

local HealSound = Sound( "HealthKit.Touch" )
local DenySound = Sound( "WallHealth.Deny" )

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
		Right = 0,
		Forward = 0,
	}
}

function SWEP:Ammo1()
	return self.Owner:GetNWInt( "WeedAmmount",0 )
end

function SWEP:Ammo2()
	return self.Owner:GetNWInt( "WeedQuality",1 )
end

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

function SWEP:CreateSmoke()
	local smoke = EffectData()
	smoke:SetEntity( self.Owner )
	util.Effect( "weed_smoke", smoke )
end

function SWEP:PrimaryAttack()

	if ( CLIENT ) then return end

	if ( self.Owner:GetNWInt("WeedAmmount") >= 1 ) then

		timer.Simple(0.3,function()
			self:EmitSound("ambient/fire/mtov_flame2.wav")
		end)

		local am = math.random(1,10)
		self.Owner:SetNWInt("WeedAmmount",math.Clamp(self.Owner:GetNWInt("WeedAmmount")-am,0,1000) )

		self.Owner:SetWeed(math.Clamp(self.Owner:GetWeed()+self.Owner:GetNWInt("WeedQuality",1)/8 + math.random(1,10),0,500))

		self:SendWeaponAnim( ACT_VM_PRIMARYATTACK )

		self:SetNextPrimaryFire( CurTime() + self:SequenceDuration() + 0.5 )
		self.Owner:SetAnimation( PLAYER_ATTACK1 )

		table.insert(SMOKEPUFFS_TABLE,{self.Owner:GetPos(),am*10})

		for k=1,3 do
			timer.Simple(0.5+k/3,function()
				self.Owner:EmitSound("ambient/water/water_spray1.wav")
			end)
		end

		timer.Simple(0.7,function()
			local smoke = EffectData()
			smoke:SetEntity( self.Owner )
			util.Effect( "weed_smoke", smoke )
			self:CallOnClient("CreateSmoke")
		end)



		-- Even though the viewmodel has looping IDLE anim at all times, we need this to make fire animation work in multiplayer
		timer.Create( "weapon_idle" .. self:EntIndex(), self:SequenceDuration(), 1, function() if ( IsValid( self ) ) then
			self:SendWeaponAnim( ACT_VM_IDLE )
			if(math.random(1,5) == 1) then
				self.Owner:EmitSound("ambient/voices/cough1.wav")
				if(SERVER) then
					self.Owner:TakeDamage(self.Owner:Health()/10)
				end
			end
		end end )

	else

		self.Owner:EmitSound( DenySound )
		self:SetNextPrimaryFire( CurTime() + 1 )

	end

end

function SWEP:SecondaryAttack()
end

function SWEP:OnRemove()

	timer.Stop( "weapon_idle" .. self:EntIndex() )

end

function SWEP:Holster()

	timer.Stop( "weapon_idle" .. self:EntIndex() )

	return true

end

function SWEP:CustomAmmoDisplay()

	self.AmmoDisplay = self.AmmoDisplay or {}
	self.AmmoDisplay.Draw = false
	self.AmmoDisplay.PrimaryClip = self.Owner:GetNWInt("WeedAmmount")
	self.AmmoDisplay.SecondaryClip = self.Owner:GetNWInt("WeedQuality")

	return self.AmmoDisplay

end

if CLIENT then
	surface.CreateFont( "Trebuchet26", {
	font = "Trebuchet",
	size = 24,
	weight = 500,
	} )
end

function SWEP:DrawHUD()

	local col = HSVToColor( CurTime() % 6 * 60, 1, 1 )

	for k=0,68 do
		surface.SetDrawColor(35+col.r-k*4,75+k*2+col.g,25+col.b+k*2,255)
		surface.DrawRect(ScrW()-140-36,ScrH()-96+k,72,1)
		surface.DrawRect(ScrW()-140-36+86,ScrH()-96+k,72,1)

		surface.SetDrawColor(35+col.r-k*4,75+k*2+col.g,25+col.b+k*2,math.cos(RealTime()*16+k*2)*255)
		surface.DrawRect(ScrW()-140-36+math.cos(RealTime()-k)*(LocalPlayer():GetWeed()/5),ScrH()-96+k+math.sin(RealTime()+k)*(LocalPlayer():GetWeed()/5),72,1)
		surface.DrawRect(ScrW()-140-36+86+math.sin(RealTime()+k)*(LocalPlayer():GetWeed()/5),ScrH()-96+k+math.cos(RealTime()+k)*(LocalPlayer():GetWeed()/5),72,1)
	end

	draw.SimpleText(self.Owner:GetNWInt("WeedAmmount"),"DermaLarge",ScrW()-140+1,ScrH()-96+32+1,Color(25,25,25),TEXT_ALIGN_CENTER)
	draw.SimpleText(math.Round(self.Owner:GetNWInt("WeedQuality")),"DermaLarge",ScrW()-140+86+1,ScrH()-96+32+1,Color(25,25,25),TEXT_ALIGN_CENTER)

	draw.SimpleText("Weed","Trebuchet26",ScrW()-140+1,ScrH()-92+2,Color(25,25,25),TEXT_ALIGN_CENTER)
	draw.SimpleText("Quality","Trebuchet26",ScrW()-140+86+1,ScrH()-92+2,Color(25,25,25),TEXT_ALIGN_CENTER)

	draw.SimpleText("Weed","Trebuchet26",ScrW()-140,ScrH()-92,Color(235,235,235),TEXT_ALIGN_CENTER)
	draw.SimpleText(self.Owner:GetNWInt("WeedAmmount"),"DermaLarge",ScrW()-140,ScrH()-96+32,Color(235,235,235),TEXT_ALIGN_CENTER)

	draw.SimpleText("Quality","Trebuchet26",ScrW()-140+86,ScrH()-92,Color(235,235,235),TEXT_ALIGN_CENTER)
	draw.SimpleText(math.Round(self.Owner:GetNWInt("WeedQuality")),"DermaLarge",ScrW()-140+86,ScrH()-96+32,Color(235,235,235),TEXT_ALIGN_CENTER)

end
