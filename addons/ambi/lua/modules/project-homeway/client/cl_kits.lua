local C, GUI, Draw, UI, CL = Ambi.Packages.Out( '@d, ContentLoader' )
local W, H = ScrW(), ScrH()
local Add = Ambi.MultiHUD.Add

-- ---------------------------------------------------------------------------------------------------------------------------------------
function Ambi.Homeway.OpenKits()
end
concommand.Add( 'ambi_hw_kits', Ambi.Homeway.OpenKits )