plogs.Register('Commands', false)

if (SERVER) then
	concommand._Run = concommand._Run or concommand.Run
	function concommand.Run(pl, cmd, args, arg_str)
		if IsValid(pl) and pl:IsPlayer() and (cmd ~= nil) and (plogs.cfg.CommandBlacklist[cmd] ~= true) then
			plogs.PlayerLog(pl, 'Commands', pl:NameID() .. ' активировал команду "' .. cmd .. '" с аргументами "' .. (arg_str or table.concat(args, ' ')) .. '"', {
				['Name']	= pl:Name(),
				['SteamID']	= pl:SteamID(),
			})
		end
		return concommand._Run(pl, cmd, args, arg_str)
	end
end