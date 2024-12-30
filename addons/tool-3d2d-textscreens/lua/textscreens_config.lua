textscreenFonts = {}

local function addFont(font, t)
	if CLIENT then
		t.size = 100
		surface.CreateFont(font, t)
		t.size = 50
		surface.CreateFont(font .. "_MENU", t)
	end

	table.insert(textscreenFonts, font)
end

--[[
---------------------------------------------------------------------------
Custom fonts - requires server restart to take affect -- "Screens_" will be removed from the font name in spawnmenu
---------------------------------------------------------------------------
--]]

-- Default textscreens font
addFont( 'Homeway', {
	font = "Montserrat",
	weight = 400,
	antialias = false,
	extended = true,
	outline = true
})

if CLIENT then

	local function addFonts(path)
		local files, folders = file.Find("resource/fonts/" .. path .. "*", "MOD")

		for k, v in ipairs(files) do
			if string.GetExtensionFromFilename(v) == "ttf" then
				local font = string.StripExtension(v)
				if table.HasValue(textscreenFonts, "Screens_" .. font) then continue end
print("-- "  .. font .. "\n" .. [[
addFont("Screens_ ]] .. font .. [[", {
	font = font,
	weight = 400,
	antialias = false,
	outline = true
})
				]])
			end
		end

		for k, v in ipairs(folders) do
			addFonts(path .. v .. "/")
		end
	end

	concommand.Add("get_fonts", function(ply)
		addFonts("")
	end)

end
