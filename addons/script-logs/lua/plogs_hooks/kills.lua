plogs.Register('Kills', true, Color(255,0,0))

plogs.AddHook('PlayerDeath', function(pl, _, attacker)
	local copy = {
		['Name'] = pl:Name(),
		['SteamID']	= pl:SteamID(),
	}
	local weapon = ''
	if IsValid(attacker) then
		if attacker:IsPlayer() then
			copy['Attacker Name'] = attacker:Name()
			copy['Attacker SteamID'] = attacker:SteamID()
			weapon = ' с ' .. (IsValid(attacker:GetActiveWeapon()) and attacker:GetActiveWeapon():GetClass() or 'unknown')
			attacker = attacker:NameID()
		else
			if attacker.CPPIGetOwner and IsValid(attacker:CPPIGetOwner()) then
				weapon = ' с ' .. attacker:GetClass()
				attacker = attacker:CPPIGetOwner():NameID()
			else
				attacker = attacker:GetClass()
			end
		end
	else
		attacker = tostring(attacker)
	end
	plogs.PlayerLog(pl, 'Kills', attacker .. ' убил ' .. pl:NameID() .. weapon, copy)
end)


plogs.Register('Damage', false)

plogs.AddHook('EntityTakeDamage', function(ent, dmginfo)
	if ent:IsPlayer() then
		local copy = {
	    	['Name'] = ent:Name(),
			['SteamID']	= ent:SteamID(),
	    }
	    local weapon = ''
	    local attacker = dmginfo:GetAttacker()
		if IsValid(attacker) then
			if attacker:IsPlayer() then
				copy['Attacker Name'] = attacker:Name()
				copy['Attacker SteamID'] = attacker:SteamID()
				weapon = ' с ' .. (IsValid(attacker:GetActiveWeapon()) and attacker:GetActiveWeapon():GetClass() or 'unknown')
				attacker = attacker:NameID()
			else
				if attacker.CPPIGetOwner and IsValid(attacker:CPPIGetOwner()) then
					weapon = ' с ' .. attacker:GetClass()
					attacker = attacker:CPPIGetOwner():NameID()
				else
					attacker = attacker:GetClass()
				end
			end
		else
			attacker = tostring(attacker)
		end
		plogs.PlayerLog(ent, 'Damage', attacker .. ' нанёс ' .. math.Round(dmginfo:GetDamage(), 0) .. ' урона ' .. ent:NameID() .. weapon, copy)
	end
end)