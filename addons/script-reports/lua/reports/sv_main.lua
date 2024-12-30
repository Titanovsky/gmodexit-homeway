if (!SH_REPORTS.ActiveReports) then
	SH_REPORTS.ActiveReports = {}
	SH_REPORTS.UniqueID = 0
	SH_REPORTS.InsertSQL = "INSERT IGNORE INTO"
end

if (SH_REPORTS.UseWorkshop) then
	resource.AddWorkshop("1141886968")
else
	resource.AddFile("materials/shenesis/general/back.png")
	resource.AddFile("materials/shenesis/general/close.png")
	resource.AddFile("materials/shenesis/reports/add.png")
	resource.AddFile("materials/shenesis/reports/stats.png")
	resource.AddFile("materials/shenesis/reports/star.png")
	resource.AddFile("resource/fonts/circular.ttf")
	resource.AddFile("resource/fonts/circular_bold.ttf")
end

function SH_REPORTS:DatabaseConnected()
	if (self.DatabaseMode == "mysqloo") then
		self:Query("SHOW TABLES LIKE 'sh_reports_performance'", function(q, ok, data)
			if (!ok) or (data and table.Count(data) > 0) then
				self:PostDatabaseConnected()
				return
			end

			self:Query([[
				CREATE TABLE `sh_reports_performance` (
				  `steamid` varchar(64) COLLATE utf8_unicode_ci NOT NULL,
				  `claimed` int(10) unsigned DEFAULT '0',
				  `closed` int(10) unsigned DEFAULT '0',
				  `timespent` int(10) unsigned DEFAULT '0',
				  `report_id` int(10) unsigned DEFAULT '0',
				  UNIQUE KEY `steamid_UNIQUE` (`steamid`,`report_id`)
				) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

				CREATE TABLE `sh_reports_performance_reports` (
				  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
				  `start_time` int(10) unsigned DEFAULT '0',
				  `end_time` int(10) unsigned DEFAULT '0',
				  PRIMARY KEY (`id`)
				) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
			]], function(q2, ok2, data2)
				self:DBPrint("Creating sh_reports_performance and sh_reports_performance_reports: " .. tostring(ok2) .. " (" .. tostring(data2) .. ")")
				self:PostDatabaseConnected()
			end)
		end)

		self:Query("SHOW TABLES LIKE 'sh_reports_performance_ratings'", function(q, ok, data)
			if (!ok) or (data and table.Count(data) > 0) then
				return end

			self:Query([[
				CREATE TABLE `sh_reports_performance_ratings` (
				  `steamid` varchar(64) COLLATE utf8_unicode_ci NOT NULL,
				  `total` int(10) unsigned DEFAULT '0',
				  `num` int(10) unsigned DEFAULT '0',
				  PRIMARY KEY (`steamid`)
				) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
			]], function(q2, ok2, data2)
				self:DBPrint("Creating sh_reports_performance_ratings: " .. tostring(ok2) .. " (" .. tostring(data2) .. ")")
			end)
		end)

		self:Query("SHOW TABLES LIKE 'sh_reports_performance_history'", function(q, ok, data)
			if (!ok) or (data and table.Count(data) > 0) then
				return end

			self:Query([[
				CREATE TABLE `sh_reports_performance_history` (
				  `id` int(10) unsigned NOT NULL,
				  `reporter` varchar(64) NOT NULL,
				  `reported` varchar(64) NOT NULL,
				  `reason` varchar(256),
				  `comment` varchar(2048),
				  `waiting_time` int(10) unsigned DEFAULT '0',
				  `date` int(10) unsigned DEFAULT '0',
				  `admin` varchar(64) NOT NULL,
				  `rating` int(10) unsigned DEFAULT '0',
				  PRIMARY KEY (`id`)
				) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
			]], function(q2, ok2, data2)
				self:DBPrint("Creating sh_reports_performance_history: " .. tostring(ok2) .. " (" .. tostring(data2) .. ")")
			end)
		end)
	else
		local function CreateTable(name, query)
			if (!sql.TableExists(name)) then
				sql.Query([[
					CREATE TABLE `]] .. name .. [[` (]] .. query .. [[)
				]])

				self:DBPrint("Creating " .. name .. ": " .. tostring(sql.TableExists(name)))
			end
		end

		CreateTable("sh_reports_performance", [[
			`steamid` varchar(64) NOT NULL PRIMARY KEY,
			`claimed` int(10) DEFAULT '0',
			`closed` int(10) DEFAULT '0',
			`timespent` int(10) DEFAULT '0',
			`report_id` int(10) DEFAULT '0'
		]])

		CreateTable("sh_reports_performance_reports", [[
			`id` int(10) NOT NULL PRIMARY KEY,
			`start_time` int(10) DEFAULT '0',
			`end_time` int(10) DEFAULT '0'
		]])

		CreateTable("sh_reports_performance_ratings", [[
			`steamid` varchar(64) NOT NULL PRIMARY KEY,
			`total` int(10) DEFAULT '0',
			`num` int(10) DEFAULT '0'
		]])

		CreateTable("sh_reports_performance_history", [[
			`id` int(10) NOT NULL PRIMARY KEY,
			`reporter` varchar(64) NOT NULL,
			`reported` varchar(64) NOT NULL,
			`reason` varchar(256),
			`comment` varchar(2048),
			`waiting_time` int(10) DEFAULT '0',
			`date` int(10) DEFAULT '0',
			`admin` varchar(64) NOT NULL,
			`rating` int(5) DEFAULT '0'
		]])

		self.InsertSQL = "INSERT OR IGNORE INTO"
		self:PostDatabaseConnected()
	end
end

function SH_REPORTS:PostDatabaseConnected()
	self:BetterQuery("SELECT * FROM sh_reports_performance_reports WHERE {time} < end_time ORDER BY id DESC", {time = os.time()}, function(q, ok, data)
		if (!ok) then
			return end

		if (data and #data > 0) then
			local d = table.Copy(data[1])
			d.id = tonumber(d.id)
			d.start_time = tonumber(d.start_time)
			d.end_time = tonumber(d.end_time)

			self.CurrentPerfReport = d
			self:DBPrint("Using performance report #" .. d.id .. ". It will last until " .. os.date(self.DateFormat, d.end_time) .. " 00:00.")
		else
			self:DBPrint("Creating new performance report as none were found.")
			self:CreatePerformanceReport()
		end
	end)

	if (self.StorageExpiryTime > 0) then
		self:BetterQuery("DELETE FROM sh_reports_performance_history WHERE {time} > date", {time = os.time() - self.StorageExpiryTime})
	end
end

function SH_REPORTS:CreatePerformanceReport()
	local days = 1
	if (self.PerformanceFrequency == "weekly") then
		days = 7 - tonumber(os.date("%w")) + self.PerformanceWeekDay
	elseif (self.PerformanceFrequency == "monthly") then
		days = 31
	end
	local mthen = self:GetMidnight(days)

	self:Query("SELECT id FROM sh_reports_performance_reports", function(q, ok, data)
		if (!ok) then
			return end

		local d = {id = table.Count(data) + 1, start_time = os.time(), end_time = mthen}
		self.CurrentPerfReport = d

		self:BetterQuery([[
			INSERT INTO sh_reports_performance_reports (id, start_time, end_time)
			VALUES ({id}, {start_time}, {end_time})
		]], d)

		self:DBPrint("Created performance report #" .. d.id .. ". It will last until " .. os.date(self.DateFormat, mthen) .. " 00:00.")
	end)

	self.CachedPerfReports = nil
end

function SH_REPORTS:NewReport(ply, data)
	if (self:IsAdmin(ply) and !self.StaffCanReport) then
		self:Notify(ply, "cannot_report_as_admin", false)
		return
	end

	if (data.reporter_id == data.reported_id) then
		self:Notify(ply, "cannot_report_self", false)
		return
	end

	local target = player.GetBySteamID64(data.reported_id)
	if (IsValid(target) and self:IsAdmin(target) and !self.StaffCanBeReported) then
		self:Notify(ply, "cannot_report_admin", false)
		return
	end

	local sid = ply:SteamID64()
	if (table.Count(self:GetAllReports(sid)) >= self.MaxReportsPerPlayer) then
		self:Notify(ply, "report_limit_reached", false)
		return
	end

	if (data.reported_id == "0" and !self.CanReportOther) then
		return end

	self.UniqueID = self.UniqueID + 1
	data.id = self.UniqueID
	self.ActiveReports[data.id] = table.Copy(data)

	self:Notify(ply, "report_submitted", true)
	self:Log(ply:Nick() .. " <" .. ply:SteamID() .. "> reported [#" .. data.id .. "] " .. data.reported_name .. " <" .. util.SteamIDFrom64(data.reported_id) .. "> for " .. self.ReportReasons[data.reason_id])

	easynet.Send(self:GetStaff(), "SH_REPORTS.ReportCreated", data)
end

function SH_REPORTS:PlayerSay(ply, str)
	local text = str:Replace("!", "/"):lower():Trim()

	if (self.AdminCommands[text]) then
		self:ShowReports(ply)
		return ""
	end

	if (self.ReportCommands[text]) then
		if (!self:IsAdmin(ply) or self.StaffCanReport) then
			easynet.Send(ply, "SH_REPORTS.QuickReport", {comment = "", lastkiller = ply.SH_LastKiller, lastarrester = ply.SH_LastArrester})
		else
			self:Notify(ply, "cannot_report_as_admin", false)
		end

		return ""
	end

	if (self.EnableQuickReport and !self:IsAdmin(ply) and text:StartWith("@")) then
		easynet.Send(ply, "SH_REPORTS.QuickReport", {comment = str:sub(2), lastkiller = ply.SH_LastKiller, lastarrester = ply.SH_LastArrester})
		return ""
	end

	if (text == "/reportstats") then
		if (self:IsAdmin(ply)) then
			self:BetterQuery("SELECT * FROM sh_reports_performance WHERE steamid = {steamid}", {steamid = ply:SteamID64()}, function(q, ok, data)
				if (!ok or !IsValid(ply)) then
					return end

				local claimed = 0
				local closed = 0
				for _, d in pairs (data) do
					claimed = claimed + tonumber(d.claimed)
					closed = closed + tonumber(d.closed)
				end

				ply:ChatPrint("Reports claimed: " .. string.Comma(claimed) .. " | Reports closed: " .. string.Comma(closed))
			end)
		end

		return ""
	end
end

function SH_REPORTS:ShowReports(ply)
	local tosend = {}
	if (self:IsAdmin(ply)) then -- If admin, send all reports, if not only send own
		tosend = self:GetAllReports()
	else
		tosend = self:GetAllReports(ply:SteamID64())
	end

	easynet.Send(ply, "SH_REPORTS.SendList", {
		server_time = os.time(),
		struct_reports = tosend,
	})
end

local function SendPerfReports(ply, preps)
	easynet.Send(ply, "SH_REPORTS.SendPerfReports", {
		struct_perf_reports = preps
	})
end

function SH_REPORTS:ShowPerformanceReports(ply)
	if (!self.UsergroupsPerformance[ply:GetUserGroup()]) then
		self:Notify(ply, "not_allowed_to_run_cmd", false)
		return
	end

	if (self.CachedPerfReports) then
		SendPerfReports(ply, self.CachedPerfReports)
	else
		self:BetterQuery("SELECT * FROM sh_reports_performance_reports", {time = os.time()}, function(q, ok, data)
			if (!ok or !IsValid(ply)) then
				return end

			local d = {}
			for k, v in pairs (data) do
				d[tonumber(v.id)] = v
			end

			self.CachedPerfReports = d
			if (IsValid(ply)) then
				SendPerfReports(ply, d)
			end
		end)
	end
end

function SH_REPORTS:RequestPerfReportStaff(ply, id)
	if (!self.UsergroupsPerformance[ply:GetUserGroup()]) then
		self:Notify(ply, "not_allowed_to_run_cmd", false)
		return
	end

	self:BetterQuery("SELECT steamid, claimed, closed, timespent FROM sh_reports_performance WHERE report_id = {id}", {id = id}, function(q, ok, data)
		if (!ok or !IsValid(ply)) then
			return end

		easynet.Send(ply, "SH_REPORTS.SendPerfReportStaff", {
			id = id,
			struct_perf_reports_staff = data
		})
	end)
end

function SH_REPORTS:RequestStaffRatings(ply)
	if (!self.UsergroupsPerformance[ply:GetUserGroup()]) then
		self:Notify(ply, "not_allowed_to_run_cmd", false)
		return
	end

	self:BetterQuery("SELECT steamid, num, total FROM sh_reports_performance_ratings", {}, function(q, ok, data)
		if (!ok or !IsValid(ply)) then
			return end

		easynet.Send(ply, "SH_REPORTS.SendRatings", {
			struct_rating = data
		})
	end)
end

function SH_REPORTS:RequestReportHistory(ply)
	if (!self.UsergroupsPerformance[ply:GetUserGroup()]) then
		self:Notify(ply, "not_allowed_to_run_cmd", false)
		return
	end

	self:BetterQuery("SELECT * FROM sh_reports_performance_history", {}, function(q, ok, data)
		if (!ok or !IsValid(ply)) then
			return end

		-- Factorize the SteamID's to save on bytes
		local t_steamids = {}

		local t = {}
		for _, dat in pairs (data) do
			t[tonumber(dat.id)] = dat

			t_steamids[dat.reporter] = true
			t_steamids[dat.reported] = true
			t_steamids[dat.admin] = true
		end

		local steamids = {}
		for steamid in pairs (t_steamids) do
			t_steamids[steamid] = table.insert(steamids, {steamid = steamid})
		end

		local t_list = {}
		for id, dat in pairs (t) do
			table.insert(t_list, {
				report_id = tonumber(dat.id),
				reporter_nid = t_steamids[dat.reporter],
				reported_nid = t_steamids[dat.reported],
				reason = dat.reason,
				comment = dat.comment,
				rating = dat.rating,
				date = dat.date,
				waiting_time = dat.waiting_time,
				admin_nid = t_steamids[dat.admin],
			})
		end

		easynet.Send(ply, "SH_REPORTS.SendHistoryList", {
			struct_history_steamids = steamids,
			struct_history_list = t_list,
		})
	end)
end

function SH_REPORTS:ClaimReport(admin, report)
	local sid = admin:SteamID64()
	for _, rep in pairs (self:GetAllReports()) do
		if (rep.admin_id == sid) then
			self:Notify(admin, "claimed_report_still_active", false)
			return false
		end
	end

	if (report.admin_id ~= "") then
		return false
	end

	report.claim_time = os.time()
	report.admin_id = sid
	self:Notify(player.GetBySteamID64(report.reporter_id), "admin_claimed_your_report", true)

	easynet.Send(admin, "SH_REPORTS.MinimizeReport", {report_id = report.id})
	easynet.Send(self:GetStaff(), "SH_REPORTS.ReportClaimed", {report_id = report.id, admin_id = report.admin_id})

	if (self.CurrentPerfReport) and (!report.is_admin or self.AdminReportsCount) then
		self:BetterQuery([[
			]] .. self.InsertSQL .. [[ sh_reports_performance (steamid, report_id)
			VALUES ({steamid}, {report_id});
			UPDATE sh_reports_performance SET claimed = claimed + 1
			WHERE steamid = {steamid} AND report_id = {report_id}
		]], {steamid = admin:SteamID64(), report_id = self.CurrentPerfReport.id})
	end

	return true
end

function SH_REPORTS:ClaimAndTeleport(admin, id, bring, bring_reported)
	if (!self:IsAdmin(admin)) then
		self:Notify(admin, "not_allowed_to_run_cmd", false)
		return
	end

	local report = self:FindReport(id)
	if (!report) then
		self:Notify(admin, "report_non_existent", false)
		return
	end

	if (self.ClaimNoTeleport) then
		return end

	local target = player.GetBySteamID64(report.reporter_id)
	if (!IsValid(target)) then
		return end

	if (!self:ClaimReport(admin, report)) then
		return end

	admin.SH_PosBeforeReport = admin:GetPos()
	target.SH_PosBeforeReport = target:GetPos()

	if (self.UseULXCommands) then
		-- Bad idea? ULX sucks anyways
		if (bring) then
			ulx.bring(admin, {target})
		else
			ulx.goto(admin, target)
		end

		if (bring_reported) then
			local reported = player.GetBySteamID64(report.reported_id)
			if (IsValid(reported)) then
				reported.SH_PosBeforeReport = reported:GetPos()

				if (bring) then
					ulx.bring(admin, {reported})
				else
					ulx.send(admin, reported, target)
				end
			end
		end
	else
		local a, b = admin, target
		if (bring) then
			a, b = target, admin
		end

		self:TeleportPlayer(a, b:GetPos())

		if (bring_reported) then
			local reported = player.GetBySteamID64(report.reported_id)
			if (IsValid(reported)) then
				reported.SH_PosBeforeReport = reported:GetPos()

				self:TeleportPlayer(reported, b:GetPos())
			end
		end
	end

	self:Log(admin:Nick() .. " <" .. admin:SteamID() .. "> claimed " .. target:Nick() .. "'s <" .. target:SteamID() .. "> report [#" .. id .. "]")
end

function SH_REPORTS:ClaimAndCSit(admin, id)
	if (!csitsystem) then
		return end

	if (!self:IsAdmin(admin)) then
		self:Notify(admin, "not_allowed_to_run_cmd", false)
		return
	end

	local report = self:FindReport(id)
	if (!report) then
		self:Notify(admin, "report_non_existent", false)
		return
	end

	local target = player.GetBySteamID64(report.reporter_id)
	if (!IsValid(target)) then
		return end

	if (!self:ClaimReport(admin, report)) then
		return end

	admin.SH_PosBeforeReport = admin:GetPos()
	target.SH_PosBeforeReport = target:GetPos()

	report.sit_id = csitsystem.HandOver(admin, target, player.GetBySteamID64(report.reported_id))

	self:Log(admin:Nick() .. " <" .. admin:SteamID() .. "> claimed " .. target:Nick() .. "'s <" .. target:SteamID() .. "> report [#" .. id .. "] and started a sit")
	-- self:CloseReport(admin, id)
end

function SH_REPORTS:CloseReport(ply, id)
	local report = self:FindReport(id)
	if (!report) then
		self:Notify(ply, "report_non_existent", false)
		return
	end

	local sid = ply:SteamID64()
	if (self:IsAdmin(ply) and ((report.admin_id == "" and self.CanDeleteWhenUnclaimed) or report.admin_id == sid)) or (report.reporter_id == sid) then
		self.ActiveReports[id] = nil

		self:Notify(ply, "report_closed", true)
		easynet.Send(self:GetStaff(), "SH_REPORTS.ReportClosed", {report_id = id})

		local target = player.GetBySteamID64(report.reporter_id)
		local admin = player.GetBySteamID64(report.admin_id)
		if (IsValid(target)) then
			if (report.reporter_id ~= sid) then
				self:Notify(target, "your_report_was_closed", true)
			elseif (report.admin_id ~= "") then
				if (IsValid(admin) and admin ~= ply) then
					self:Notify(admin, "reporter_closed_report", true)
				end
			end

			easynet.Send(target, "SH_REPORTS.ReportClosed", {report_id = id})
		end

		if (!report.is_admin or self.AdminReportsCount) then
			if (report.admin_id ~= "") then
				local claim_time = os.time() - report.claim_time

				if (self.CurrentPerfReport) then
					self:BetterQuery([[
						]] .. self.InsertSQL .. [[ sh_reports_performance (steamid, report_id, timespent)
						VALUES ({steamid}, {report_id}, {timespent});
						UPDATE sh_reports_performance SET closed = closed + 1, timespent = timespent + {timespent}
						WHERE steamid = {steamid} AND report_id = {report_id}
					]], {steamid = report.admin_id, report_id = self.CurrentPerfReport.id, timespent = claim_time})
				end

				if (sid == report.reporter_id) then
					self:Log(ply:Nick() .. " <" .. ply:SteamID() .. "> closed their own report [#" .. id .. "]")
				else
					if (IsValid(target) and self.AskRating) then
						if (!target.SH_ReportsCompleted) then
							target.SH_ReportsCompleted = {}
						end
						target.SH_ReportsCompleted[id] = ply:SteamID64()

						easynet.Send(target, "SH_REPORTS.PromptRating", {report_id = id, admin_name = ply:Nick()})
					end

					self:Log(ply:Nick() .. " <" .. ply:SteamID() .. "> closed the report [#" .. id .. "] from " .. report.reporter_name .. "<" .. util.SteamIDFrom64(report.reporter_id) .. ">")
				end
			elseif (self:IsAdmin(ply)) then
				if (self.CurrentPerfReport) then
					self:BetterQuery([[
						]] .. self.InsertSQL .. [[ sh_reports_performance (steamid, report_id)
						VALUES ({steamid}, {report_id});
						UPDATE sh_reports_performance SET closed = closed + 1
						WHERE steamid = {steamid} AND report_id = {report_id}
					]], {steamid = sid, report_id = self.CurrentPerfReport.id})
				end

				if (sid == report.reporter_id) then
					self:Log(ply:Nick() .. " <" .. ply:SteamID() .. "> closed their own UNCLAIMED report [#" .. id .. "]")
				else
					self:Log(ply:Nick() .. " <" .. ply:SteamID() .. "> closed the UNCLAIMED report [#" .. id .. "] from " .. report.reporter_name .. "<" .. util.SteamIDFrom64(report.reporter_id) .. ">")
				end
			end
		end

		if (report.admin_id ~= "") then
			if (report.sit_id) then
				csitsystem.EndSit(report.sit_id)
			end

			if (self.TeleportPlayersBack) then
				if (IsValid(target)) then
					self:ReturnPlayer(target)
				end

				local admin = player.GetBySteamID64(report.admin_id)
				if (IsValid(admin)) then
					self:ReturnPlayer(admin)
				end

				local reported = player.GetBySteamID64(report.reported_id)
				if (IsValid(reported)) then
					self:ReturnPlayer(reported)
				end
			end

			if (self.StoreCompletedReports ~= "none") then
				self:BetterQuery([[
					]] .. self.InsertSQL .. [[ sh_reports_performance_history (id, reporter, reported, reason, comment, waiting_time, date, admin)
					VALUES ({id}, {reporter}, {reported}, {reason}, {comment}, {waiting_time}, {date}, {admin});
				]], {id = id, reporter = report.reporter_id, reported = report.reported_id, reason = self.ReportReasons[report.reason_id], comment = report.comment, waiting_time = os.time() - report.time, date = os.time(), admin = report.admin_id})
			end
		end
	else
		self:Notify(ply, "not_allowed_to_run_cmd", false)
	end
end

function SH_REPORTS:RateAdmin(ply, report_id, rating)
	if (!ply.SH_ReportsCompleted or !ply.SH_ReportsCompleted[report_id]) then
		self:Notify(ply, "report_non_existent", false)
		return
	end

	local admin_id = ply.SH_ReportsCompleted[report_id]
	rating = math.Clamp(rating, 1, 5)

	self:BetterQuery([[
		]] .. self.InsertSQL .. [[ sh_reports_performance_ratings (steamid, total, num)
		VALUES ({steamid}, 0, 0);
		UPDATE sh_reports_performance_ratings SET total = total + {rating}, num = num + 1
		WHERE steamid = {steamid}
	]], {steamid = admin_id, rating = rating})

	if (self.StoreCompletedReports ~= "none") then
		self:BetterQuery([[
			UPDATE sh_reports_performance_history SET rating = {rating}
			WHERE id = {id}
		]], {id = report_id, rating = rating})
	end

	if (self.NotifyRating) then
		local admin = player.GetBySteamID64(admin_id)
		if (IsValid(admin)) then
			local rstr = ""
			for i = 1, 5 do
				rstr = rstr .. (rating >= i and "★" or "☆")
			end

			self:Notify(admin, "rate_notification\t" .. ply:Nick() .. "\t" .. rstr, rating >= 3)
		end
	end

	ply.SH_ReportsCompleted[report_id] = nil
	self:Notify(ply, "rate_thanks", true)
end

function SH_REPORTS:PlayerReady(ply)
	if (self.NotifyAdminsOnConnect and self:IsAdmin(ply)) then
		local num = 0
		local pending = {}
		for id, report in pairs (self:GetAllReports()) do
			if (report.admin_id == "") then
				num = num + 1
				table.insert(pending, report)
			end
		end

		if (num > 0) then
			easynet.Send(ply, "SH_REPORTS.ReportsPending", {num = num, struct_reports = pending})
		end
	end
end

function SH_REPORTS:PlayerDisconnected(ply)
	local sid = ply:SteamID64()
	for id, report in pairs (self:GetAllReports()) do
		if (report.reporter_id == sid) then
			self.ActiveReports[id] = nil
			easynet.Send(self:GetStaff(), "SH_REPORTS.ReportClosed", {report_id = id})

			local admin = player.GetBySteamID64(report.admin_id)
			if (IsValid(admin)) then
				self:Notify(admin, "reporter_closed_report", false)
			end
		elseif (self:IsAdmin(ply) and report.admin_id == sid) then
			report.admin_id = ""
			easynet.Send(self:GetStaff(), "SH_REPORTS.AdminLeft", {report_id = id})

			local reporter = player.GetBySteamID64(report.reporter_id)
			if (IsValid(reporter)) then
				easynet.Send(reporter, "SH_REPORTS.AdminLeft", {report_id = id})
				self:Notify(reporter, "admin_has_disconnected", false)
			end
		end
	end
end

function SH_REPORTS:ReturnPlayer(ply)
	if (!ply.SH_PosBeforeReport) then
		return end

	ply:SetPos(ply.SH_PosBeforeReport)
	ply.SH_PosBeforeReport = nil

	if ply:IsJail() then ply:Spawn() end
end

function SH_REPORTS:MidnightCheck()
	local perf = self.CurrentPerfReport
	if (!perf) then
		return end

	if (os.time() >= perf.end_time) then
		self:DBPrint("Current performance report #" .. perf.id .. " expired, creating new one..")
		self:CreatePerformanceReport()
	end
end

function SH_REPORTS:Notify(ply, msg, good)
	easynet.Send(ply, "SH_REPORTS.Notify", {msg = msg, positive = good})
end

function SH_REPORTS:GetStaff(ply)
	local t = {}
	for _, v in ipairs (player.GetAll()) do
		if (self:IsAdmin(v)) then
			table.insert(t, v)
		end
	end

	return t
end

local function CheckObstruction(ply, pos)
	local t = {
		start = pos,
		endpos = pos + Vector(0, 0, 72),
		mins = Vector(-16, -16, 0),
		maxs = Vector(16, 16, 4),
		filter = ply
	}

	return bit.band(util.PointContents(pos), CONTENTS_SOLID) > 0 or util.TraceHull(t).Hit
end

local coords = {
	Vector(48, 0, 0),
	Vector(-48, 0, 0),
	Vector(0, 48, 0),
	Vector(0, -48, 0),
	Vector(48, 48, 0),
	Vector(-48, 48, 0),
	Vector(48, -48, 0),
	Vector(-48, -48, 0),
}

function SH_REPORTS:TeleportPlayer(ply, pos, exact)
	if (!exact) then
		if (CheckObstruction(ply, pos)) then
			for _, c in ipairs (coords) do
				if (!util.TraceLine({start = pos, endpos = pos + c, filter = ents.GetAll()}).Hit and !CheckObstruction(ply, pos + c)) then
					pos = pos + c
					break
				end
			end
		end
	end

	ply.SH_PositionBeforeTeleport = ply:GetPos()
	ply:SetPos(pos)
end

function SH_REPORTS:FindReport(id)
	return self.ActiveReports[id]
end

function SH_REPORTS:GetAllReports(author)
	local t = {}
	for id, report in pairs (self.ActiveReports) do
		if (author and report.reporter_id ~= author) then
			continue end

		t[id] = report
	end

	return t
end

function SH_REPORTS:Log(s)
	if (!self.UseServerLog) then
		return end

	ServerLog(s .. "\n")
end

hook.Add("PlayerDisconnected", "SH_REPORTS.PlayerDisconnected", function(ply)
	SH_REPORTS:PlayerDisconnected(ply)
end)

hook.Add("PlayerSay", "SH_REPORTS.PlayerSay", function(ply, str)
	local r = SH_REPORTS:PlayerSay(ply, str)
	if (r) then
		return r
	end
end)

hook.Add("DoPlayerDeath", "SH_REPORTS.DoPlayerDeath", function(ply, atk, dmginfo)
	if (IsValid(atk) and atk:IsPlayer() and atk ~= ply) then
		ply.SH_LastKiller = atk
	end
end)

hook.Add("playerArrested", "SH_REPORTS.playerArrested", function(ply, time, arrester)
	if (IsValid(arrester) and arrester:IsPlayer() and arrester ~= ply) then
		ply.SH_LastArrester = arrester
	end
end)

hook.Add("PlayerButtonDown", "SH_REPORTS.PlayerButtonDown", function(ply, btn)
	if (!IsFirstTimePredicted()) then
		return end

	if (btn == SH_REPORTS.ReportKey) then
		if (!SH_REPORTS:IsAdmin(ply) or SH_REPORTS.StaffCanReport) then
			easynet.Send(ply, "SH_REPORTS.QuickReport", {comment = "", lastkiller = ply.SH_LastKiller, lastarrester = ply.SH_LastArrester})
		else
			SH_REPORTS:Notify(ply, "cannot_report_as_admin", false)
		end
	elseif (btn == SH_REPORTS.ReportsKey) then
		SH_REPORTS:ShowReports(ply)
	end
end)

timer.Create("SH_REPORTS.MidnightCheck", 1, 0, function()
	SH_REPORTS:MidnightCheck()
end)

easynet.Callback("SH_REPORTS.NewReport", function(data, ply)
	local report = data
	data.reporter_name = ply:Nick()
	data.reporter_id = ply:SteamID64()
	data.time = os.time()
	data.admin_id = ""
	data.comment = data.comment:sub(1, SH_REPORTS.MaxCommentLength)
	data.is_admin = SH_REPORTS:IsAdmin(ply)

	SH_REPORTS:NewReport(ply, data)
end)

easynet.Callback("SH_REPORTS.Claim", function(data, ply)
	if (!SH_REPORTS:IsAdmin(ply)) then
		SH_REPORTS:Notify(ply, "not_allowed_to_run_cmd", false)
		return
	end

	local report = SH_REPORTS:FindReport(data.id)
	if (!report) then
		SH_REPORTS:Notify(ply, "report_non_existent", false)
		return
	end

	SH_REPORTS:ClaimReport(ply, report)
end)

easynet.Callback("SH_REPORTS.ClaimAndTeleport", function(data, ply)
	SH_REPORTS:ClaimAndTeleport(ply, data.id, data.bring, data.bring_reported)
end)

easynet.Callback("SH_REPORTS.ClaimAndCSit", function(data, ply)
	SH_REPORTS:ClaimAndCSit(ply, data.id)
end)

easynet.Callback("SH_REPORTS.CloseReport", function(data, ply)
	SH_REPORTS:CloseReport(ply, data.id)
end)

easynet.Callback("SH_REPORTS.RequestPerfReports", function(data, ply)
	SH_REPORTS:ShowPerformanceReports(ply)
end)

easynet.Callback("SH_REPORTS.RequestPerfReportStaff", function(data, ply)
	SH_REPORTS:RequestPerfReportStaff(ply, data.id)
end)

easynet.Callback("SH_REPORTS.PlayerReady", function(data, ply)
	SH_REPORTS:PlayerReady(ply)
end)

easynet.Callback("SH_REPORTS.RateAdmin", function(data, ply)
	SH_REPORTS:RateAdmin(ply, data.report_id, data.rating)
end)

easynet.Callback("SH_REPORTS.RequestStaffRatings", function(data, ply)
	SH_REPORTS:RequestStaffRatings(ply)
end)

easynet.Callback("SH_REPORTS.RequestReportHistory", function(data, ply)
	SH_REPORTS:RequestReportHistory(ply)
end)