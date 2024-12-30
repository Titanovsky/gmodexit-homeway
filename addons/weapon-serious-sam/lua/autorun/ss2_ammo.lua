local ammo = {
	{"Cannonball", "cannonball"},
	{"Klodovik", "klodovik"},
	{"Serious Bombs", "seriousbomb"}
}

for k, v in pairs(ammo) do
	game.AddAmmoType({name = v[2]})
	if CLIENT then language.Add(v[2].."_ammo", v[1]) end
end

-- this one already exists in the game
if CLIENT then
	language.Add("sniperround_ammo", "Sniper Bullets")
end