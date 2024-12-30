

include('shared.lua')

SWEP.PrintName = "Death Note"
SWEP.Slot = 5
SWEP.SlotPos = 20
SWEP.DrawAmmo = false
SWEP.DrawCrosshair = false

function SWEP:DrawHUD()
	local x = ScrW() / 2
	local y = ScrH() / 2
	surface.SetDrawColor( 50, 50, 50, 255 )
	local gap = math.abs(math.sin(CurTime() * 1.5) * 6);
	local length = gap + 5
	surface.DrawLine( x - length, y, x - gap, y )
	surface.DrawLine( x + length, y, x + gap, y )
	surface.DrawLine( x, y - length, x, y - gap )
	surface.DrawLine( x, y + length, x, y + gap )
end