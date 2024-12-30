local function SS2_SettingsPanel(Panel)
	Panel:AddControl("Label", {Text = "Server"})
	Panel:AddControl("CheckBox", {Label = "Allow Cannonball Gibbing", Command = "ss2_sv_cannonball_gib"})
	Panel:AddControl("CheckBox", {Label = "Restrict Cannon", Command = "ss2_sv_restrictcannon"})
	Panel:AddControl("CheckBox", {Label = "Spawn With SS2 Weapons", Command = "ss2_sv_loadout"})
	Panel:AddControl("CheckBox", {Label = "Unlimited Ammo", Command = "ss2_sv_unlimitedammo"})
	Panel:AddControl("Slider", {Label = "Ammo Equip Multiplier", Command = "ss2_sv_ammomultiplier", Type = "Integer", Min = 0, Max = 10})
	Panel:AddControl("Label", {Text = "Client"})
	Panel:AddControl("CheckBox", {Label = "Crosshair", Command = "ss2_cl_crosshair"})
	Panel:AddControl("CheckBox", {Label = "Particles", Command = "ss2_cl_particles"})
end

local function SS2_PopulateToolMenu()
	spawnmenu.AddToolMenuOption("Utilities", "Serious Sam", "SS2Settings", "Serious Sam 2 Settings", "", "", SS2_SettingsPanel)
end

hook.Add("PopulateToolMenu", "SS2_PopulateToolMenu", SS2_PopulateToolMenu)