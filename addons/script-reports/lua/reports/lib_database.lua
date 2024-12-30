local base_table = SH_REPORTS
local prefix = "SH_REPORTS."

base_table.DatabaseConfig = {
	host = "localhost",
	user = "root",
	password = "",
	database = "mysql",
	port = 3306,
}

function base_table:DBPrint(s)
	local src = debug.getinfo(1)
	local _, __, name = src.short_src:find("addons/(.-)/")
	MsgC(Color(0, 200, 255), "[" .. name:upper() .. " DB] ", color_white, s, "\n")
end

function base_table:ConnectToDatabase()
	local dm = self.DatabaseMode
	if (dm == "mysqloo") then
		require("mysqloo")

		local cfg = self.DatabaseConfig

		self:DBPrint("Connecting to database")

		local db = mysqloo.connect(cfg.host, cfg.user, cfg.password, cfg.database, cfg.port)
		db:setAutoReconnect(true)
		db:setMultiStatements(true)
		db.onConnected = function()
			self:DBPrint("Connected to database!")
			self.m_bConnectedToDB = true

			if (self.DatabaseConnected) then
				self:DatabaseConnected()
			end
		end
		db.onConnectionFailed = function(me, err)
			self:DBPrint("Failed to connect to database: " .. err .. "\n")
			print(err)
			self.m_bConnectedToDB = false
		end
		db:connect()
		_G[prefix .. "DB"] = db
	else
		self:DBPrint("Defaulting to sqlite")
		self.m_bConnectedToDB = true

		if (self.DatabaseConnected) then
			self:DatabaseConnected()
		end
	end
end

function base_table:IsConnectedToDB()
	return self.m_bConnectedToDB
end

function base_table:Query(query, callback)
	if (!self:IsConnectedToDB()) then
		return end

	local dm = self.DatabaseMode

	callback = callback or function(q, ok, ret) end

	if (dm == "mysqloo") then
		local q = _G[prefix .. "DB"]:query(query)
		q.onSuccess = function(me, data)
			_SH_QUERY_LAST_INSERT_ID = me:lastInsert()
			callback(query, true, data)
			_SH_QUERY_LAST_INSERT_ID = nil
		end
		q.onError = function(me, err, fq)
			callback(query, false, err .. " (" .. fq .. ")")
			self:DBPrint(err .. " (" .. fq .. ")")
		end
		q:start()
	else
		local d = sql.Query(query)
		if (d ~= false) then
			callback(query, true, d or {})
		else
			callback(query, false, sql.LastError())
			print("sqlite error (" .. query .. "): " .. sql.LastError())
		end
	end
end

function base_table:Escape(s)
	local dm = self.DatabaseMode
	if (dm == "mysqloo") then
		return _G[prefix .. "DB"]:escape(s)
	else
		return sql.SQLStr(s, true)
	end
end

function base_table:BetterQuery(query, args, callback)
	for k, v in pairs (args) do
		if (isstring(v)) then
			v = self:Escape(v)
		end

		query = query:Replace("{" .. k .. "}", "'" .. v .. "'")
		query = query:Replace("[" .. k .. "]", v)
	end

	self:Query(query, callback)
end

hook.Add("InitPostEntity", prefix .. "ConnectToDatabase", function()
	base_table:ConnectToDatabase()
end)

if (_G[prefix .. "DB"]) then
	base_table.m_bConnectedToDB = _G[prefix .. "DB"]:status() == 0
end