local weapons = {
	["weapon_ss2_autoshotgun"] = "SS2 Auto Shotgun",
	["weapon_ss2_colt"] = "SS2 Colt",
	["weapon_ss2_doubleshotgun"] = "SS2 Double Shotgun",
	//["weapon_ss2_klodovik"] = "SS2 Klodovik",
	["weapon_ss2_grenadelauncher"] = "SS2 Grenade Launcher",
	["weapon_ss2_sniper"] = "SS2 Sniper Rifle",
	["weapon_ss2_cannon"] = "SS2 Cannon",
	["weapon_ss2_uzi"] = "SS2 Uzi",
	["weapon_ss2_plasmarifle"] = "SS2 Plasma Rifle",
	["weapon_ss2_minigun"] = "SS2 Minigun",
	["weapon_ss2_rocketlauncher"] = "SS2 Rocket Launcher",
	["weapon_ss2_zapgun"] = "SS2 Zapgun"
}

for wep, name in SortedPairs(weapons) do
	list.Add("NPCUsableWeapons", {class = wep, title = name})
end