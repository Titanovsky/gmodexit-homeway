
if CLIENT then

	SWEP.PrintName			= "RAPTOR Sniper Rifle"
	SWEP.Author				= "Upset"
	SWEP.Slot				= 4
	SWEP.SlotPos			= 0
	SWEP.ViewModelFOV		= 32
	-- SWEP.UpAngle			= 1.5
	SWEP.SBobScale			= .8
	SWEP.WepIcon			= surface.GetTextureID("interface/weaponicons/sniper")
	
	surface.CreateFont("SS2sniperfont", {
		font = "default",
		size = ScrH()/43,
		weight = 0,
		blursize = 0,
		scanlines = 0,
		antialias = true,
		underline = false,
		italic = false,
		strikeout = false,
		symbol = false,
		rotary = false,
		shadow = true,
		additive = false,
		outline = false
	})
	
local SniperMask = surface.GetTextureID("models/serioussam2/weapons/sniper/snipermask")
local SniperWheel = surface.GetTextureID("models/serioussam2/weapons/sniper/sniperwheel")
local SniperLed = surface.GetTextureID("models/serioussam2/weapons/sniper/sniperled")
local SniperArrow = surface.GetTextureID("models/serioussam2/weapons/sniper/sniperarrow")
local SniperEye = surface.GetTextureID("models/serioussam2/weapons/sniper/snipereye")

function SWEP:DrawHUD()
	if !self:GetZoom() then self:Crosshair() end
end

function SWEP:DrawHUDBackground()
	if self:GetZoom() then
		local x, y = ScrW() / 2, ScrH() / 2

		surface.SetTexture(SniperMask)
		surface.SetDrawColor(255, 255, 255, 255)		
		surface.DrawTexturedRectUV(x-y, 0, y, y, 0, 0, -1.006, 1)
		surface.DrawTexturedRectUV(x, 0, y, y, 0, 0, 1, 1)
		surface.DrawTexturedRectUV(x-y, y, y, y, 0, 0, -1.006, -1)
		surface.DrawTexturedRectUV(x, y, y, y, 0, 0, 1, -1)
		
		surface.SetTexture(SniperWheel)
		local tr = self.Owner:GetEyeTraceNoCursor()
		local wr, wg, wb = self:HealthDetect(tr)
		surface.SetDrawColor(wr, wg, wb, 100)
		surface.DrawTexturedRectRotated(x, y, y/3, y/3, self:GetZoomTime() *540 -180)
		
		surface.SetTexture(SniperLed)
		local r, g = 0, 255
		if self:GetAttackDelay() > 0 and self:GetAttackDelay() > CurTime() then
			r, g = 255, 0
		end
		surface.SetDrawColor(r, g, 0, 255)
		surface.DrawTexturedRect(x-y/5.5, y*1.12, y/17, y/17)
		
		local arrowx = x-y/1.435
		local eyex = x+y/1.6
		surface.SetTexture(SniperArrow)
		surface.SetDrawColor(255, 255, 0, 255)
		surface.DrawTexturedRect(arrowx, y/1.075, y/13, y/13)
		surface.SetTexture(SniperEye)
		surface.DrawTexturedRect(eyex, y/1.085, y/13, y/13)
		
		local textcol = Color(210,230,255,200)
		local dist = math.Round(self.Owner:GetPos():Distance(self.Owner:GetEyeTraceNoCursor().HitPos) /32, 1)
		draw.SimpleText(dist < 500 and dist or "---.-", "SS2sniperfont", arrowx, y*1.02, textcol, TEXT_ALIGN_LEFT)
		local zoomtext = math.Round((-self:GetZoomTime()+1.6)*3.31, 2).."x"
		local zoomw, zoomh = surface.GetTextSize(zoomtext)
		draw.SimpleText(zoomtext, "SS2sniperfont", (eyex-zoomw)*1.035, y*1.02, textcol, TEXT_ALIGN_LEFT)

		surface.SetDrawColor(0, 0, 0, 255)
		surface.DrawRect(0, 0, x-y/1.1, ScrH())
		surface.DrawRect(ScrW()-(x-y), 0, x-y, ScrH())
	end
end

end

function SWEP:PrimaryAttack()
	if self.Owner:IsNPC() and self:GetNextPrimaryFire() > CurTime() then return end

	if !self:CanPrimaryAttack() then return end
	self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
	self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
	self.Owner:SetAnimation(PLAYER_ATTACK1)
	self:WeaponSound()
	
	local dmg = self.Primary.Damage
	if self:GetZoom() then
		dmg = 300
	end
	
	self:ShootBullet(dmg, self.Primary.NumShots, self.Primary.Cone)
	self:SeriousFlash()
	self:TakeAmmo(self.AmmoToTake)
	self:IdleStuff()
	self:HolsterDelay()
	
	self:SetAttackDelay(CurTime() + self.Primary.Delay -.075)
end

function SWEP:SpecialHolster()
	self:OnRemove()
end

function SWEP:OnRemove()
	self:SetZoom(false)
	self:SetZoomStart(0)
	if self.ZoomSound then self.ZoomSound:Stop() end
	self:SetHoldType(self.HoldType)
end

function SWEP:SecondaryAttack()
	if !self:GetZoom() then
		self:SetZoom(true)
		self:SetZoomTime(1)
		self:SetHoldType("rpg")
		if !self.ZoomSound then
			self.ZoomSound = CreateSound(self.Owner, self.Primary.Special1)
		end
		self.ZoomSound:Play()
		self:SetZoomStart(CurTime()*self.ZoomSpeed)
	else 
		self:SetZoom(false)
		self:SetZoomTime(0)
		self:SetHoldType(self.HoldType)
	end	
end

function SWEP:SpecialThink()
	if self:GetZoomStart() > 0 then
		local ct = CurTime()*self.ZoomSpeed
		self:SetZoomTime(math.max(1-(ct - self:GetZoomStart()), 0))
		if self.Owner:KeyReleased(IN_ATTACK2) or ct-self.MaxZoom >= self:GetZoomStart() then
			self:SetZoomStart(0)
			if self.ZoomSound then self.ZoomSound:Stop() end
		end
	end
end

function SWEP:TranslateFOV(fov)
	if self:GetZoom() and self:GetZoomTime() > 0 then
		return (fov-30) * self:GetZoomTime()
	else
		return fov
	end
end

function SWEP:AdjustMouseSensitivity()
	if self:GetZoom() then
		return self.Owner:GetFOV() / self.Owner:GetInfoNum("fov_desired", 90)
	end
end

SWEP.HoldType			= "shotgun"
SWEP.Base				= "weapon_ss2_base"
SWEP.Category			= "Serious Sam 2"
SWEP.Spawnable			= true

SWEP.ViewModel			= Model("models/serioussam2/weapons/v_sniper.mdl")
SWEP.WorldModel			= Model("models/serioussam2/weapons/w_sniper.mdl")

SWEP.FireSounds = {
	Sound("serioussam2/weapons/sniper/sniper_fire19.wav"),
	Sound("serioussam2/weapons/sniper/sniper_fire20.wav"),
	Sound("serioussam2/weapons/sniper/sniper_fire21.wav")
}

SWEP.Primary.Special1		= Sound("serioussam2/weapons/sniper/sniper_zoom01.wav")
SWEP.Primary.Damage			= 70
SWEP.Primary.Cone			= .001
SWEP.Primary.Delay			= 1.05
SWEP.Primary.DefaultClip	= 5
SWEP.Primary.Ammo			= "SniperRound"

SWEP.Secondary.Automatic	= false

SWEP.ZoomSpeed				= .75
SWEP.MaxZoom				= .6

SWEP.MuzzleScale			= 26
SWEP.EnableSmoke			= true