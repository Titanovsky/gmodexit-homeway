

function deathnote_sandbox_names(DeathNotePlayerList) -- Sandbox version of adding names into the list as well as NPC, 
	for k,v in pairs(player.GetAll()) do -- Let's first grab all the players
		DeathNotePlayerList:AddLine(v:Name(),v:EntIndex()) -- Add lines for player's
	end -- and end it to start the one for npc's doing it this why makes sure the players are on the top of the list
	if GetConVar("DeathNote_GUI_ShowNPCs"):GetBool() then
		if GetConVar("DeathNote_GUI_FastNPCsNames"):GetBool() then -- Getting there class as a name only removing and adding a fance npc titles and useing class instead most modded npcs are citizens though
			for k,v in pairs(ents.GetAll()) do -- let's grab every entity
				if ( v:IsNPC() or v:IsNextBot() ) then -- See if entity is a a NPC or NextBot
					if not DN_NPCHideList[v:GetClass()] then
						local npc_type = deathnote_npc_type_fix(v) -- let's go to a function to get there name as it can be used with the fancy name if it breaks somehow
						local npc_name = deathnote_npc_classname(v) -- Let go the a function to get there Ai type
						npc_name = npc_type..npc_name -- Add the fancy type and stiped name again
						DeathNotePlayerList:AddLine(npc_name,v:EntIndex()) -- Then add lines for NPC's/NextBots
					end
				end
			end
		else -- Now let's if the player wants to get there nice fancy name
			deathnote_npc_nicenamecache() -- Let's create the tables for the bad habbit table checking.
			for k,v in pairs(ents.GetAll()) do -- let's grab every entity
				if ( v:IsNPC() or v:IsNextBot() ) then -- See if entity is a a NPC or NextBot
					if not DN_NPCHideList[v:GetClass()] then
						local npc_name = "???" -- Lets set the tempory name to something
						local npc_type = deathnote_npc_type_fix(v) -- Let go the a function to get there Ai type
						if DN_NPCListCache[v:GetModel()] then -- Now let's check the cache table to see if there npc's model is in it
							npc_name = DN_NPCListCache[v:GetModel()].Name -- now lets grab the name that was assigned to the model
						elseif DN_NPCListCache[v:GetClass()] then -- if it has no model let's see if it has a class in there
							npc_name = DN_NPCListCache[v:GetClass()].Name -- now lets grab the name that was assigned to the class
						else -- if nothing found there was a error with the chached table
							if not table.IsEmpty( DN_NPCListCache ) then -- If chache table has data
								table.Empty(DN_NPCListCache) -- let's clear it out so the next time the death note is open it can remake it
								if GetConVar("DeathNote_Debug"):GetBool() then -- Debug Messages
									print("[Death Note Debug] Cache error forceing reset on next GUI open.\nCaused by "..v:GetClass())
								end
							end
						npc_name = deathnote_npc_classname(v) -- let's use the non table fast name for the rest of the npcs
						end
						npc_name = npc_type..npc_name -- let's add the npc type to the fancy name
						DeathNotePlayerList:AddLine(npc_name,v:EntIndex()) -- Then add lines for NPC's/NextBots
					end
				end
			end
		end
	end
end

function deathnote_npc_type_fix(npc)
	if npc:IsNPC() then -- If they are a base NPC
		return "[NPC] "	-- lets return the string for NPC
	elseif npc:IsNextBot() then -- If they are a NextBot
		return "[NextBot] " -- lets return the string for NextBot
	elseif npc:IsPlayer() then -- If it's a Player? this should never trigger.
		return "[Player?] " -- -- return Player class? but how did this happen?
	end
	return "[???] " -- If it's neither let's return question marks
end

function deathnote_npc_classname(npc) -- Used for Fast Class and fallback for fancy name one done
	local npc_name = npc:GetClass()
	if string.StartsWith(npc:GetClass(), "npc_") then -- If they have npc_
		npc_name = string.TrimLeft(npc:GetClass(), "npc_") -- let's remove it
		npc_name = string.SetChar(npc_name, 1, string.upper( string.sub( npc_name, 1, 1 ))) -- let's capitalize the first character.
	end
	return npc_name
end

DN_NPCListCache = {} -- The list the will hold the cached model's and class with there name's

function deathnote_npc_nicenamecache()
	if table.IsEmpty( DN_NPCListCache ) then -- let's check if the table has been made if not make it.
		local DN_NPCList = list.Get( "NPC" ) -- let's grab every available npc listed in GMod
		for k, v in pairs( DN_NPCList ) do -- let's loop though the list
			if v.Model != nil then -- if it has a model assigned to it it's most likely a modded npc
				DN_NPCListCache[string.lower(v.Model)]={Name=v.Name} -- let's add the model as a key and the name to the model
			else -- if no model was found we will use the class name instead
				local CitizenNameFix = language.GetPhrase( v.Name ) -- Let's pre grab the name of the class and get's it's language translated name
				if v.Class == "npc_citizen" then -- if it's a marked as Citizen copy
					CitizenNameFix = language.GetPhrase( "#npc_citizen" ) -- let's inforce the citizen name as medic tends to get done first  
				end
				DN_NPCListCache[string.lower(v.Class)]={Name=CitizenNameFix} -- lets add the class and name to the cache list
			end
		end
		deathnote_fix_HLSource_cache() -- Half Life: Source, has some entity's that don't get cached this is just a manual override
		if GetConVar("DeathNote_Debug"):GetBool() then -- Debug Messages
			print("[Death Note Debug] NPC's tables created and cached.")
		end
	else
		if GetConVar("DeathNote_Debug"):GetBool() then-- Debug Messages for already cached
			print("[Death Note Debug] NPC's tables already cached.")
		end
	end
end

function deathnote_ttt_names(DeathNotePlayerList) -- Orginal TTT Version of adding names no NPC's and teammate roles
	if GetRoundState() == ROUND_ACTIVE then -- Only work if round is in the active state
		local PlayerRole = deathnote_ttt_simple_team() -- pair's innocents and detectives together and traitors to traitors
		for k,v in pairs(player.GetAll()) do -- Grab all the players
			if v != LocalPlayer() then
				FixNoRole = v:GetRoleString()  -- Get all there roles
				if string.lower(v:GetRoleString()) == "no role" then FixNoRole = "Innocent" end -- A Simple TTT2 innocent fix if ttt2 table failedd to load
				Name = "["..string.Left(FixNoRole,1).."] "..v:Nick() -- Grab the first letter of the person's role
				local hideteam = v:GetRole() != PlayerRole -- Check if they are not a traitor for the if statement below
				local alive = v:Alive() and v:Team() == TEAM_TERROR -- only if there alive and on the team of terror (terror team is alive and playing), orginally was coded as not in spectator team
				if hideteam and alive then -- if they are not a tratior and alive or not in team soec
						DeathNotePlayerList:AddLine(Name,v:EntIndex()) -- Add the lines to the Death Note.
				end
			end
		end
	end
end

function deathnote_ttt_simple_team()
	if LocalPlayer():GetRole() == ROLE_INNOCENT then -- if there innocent
		return ROLE_DETECTIVE -- make there team same as detective to hide detectives in the list
	end 
	return LocalPlayer():GetRole() -- and team can be gotten for detective and tratior
end


function deathnote_ttt2_names_xopez(DeathNotePlayerList) -- Thanks xopez for allowing me to use your TTT2 version with better custom team support
	if GetRoundState() == ROUND_ACTIVE then
		for k, v in ipairs(player.GetAll()) do
			Name = ""
			local plyRoleData = v:GetSubRoleData()
			if plyRoleData.isPublicRole then
				Name = "[" .. string.Left(v:GetRoleString(), 1) .. "] " .. v:Nick()
			else
				Name = "[I] " .. v:Nick()
			end

			local teammate = TTT2 and v:GetTeam() == LocalPlayer():GetTeam() or v:GetRole() == LocalPlayer():GetRole()
			if not teammate and v:Alive() and v:Team() == TEAM_TERROR then
				DeathNotePlayerList:AddLine(Name, v:EntIndex()) -- Add lines
			end
		end
	end
end

function deathnote_gui(DN_DeathTypes) 

	TargetPlayer = "?"
	TargetDeathType = "?" -- Let's give a bad death type so that you can select heart attack and if they don't set one lets just make it heart attack when it gets sent if it was not changed

	CBlack = Color( 25, 25, 25 )
	CGrey = Color( 150, 150, 150 )
	CWhite = Color( 255, 255, 255 )
	
	
	local DeathNote = vgui.Create( "DFrame" )
	DeathNote:SetSize( 400, 619 )
	DeathNote:Center()
	DeathNote:SetTitle( "" )
	DeathNote:SetVisible( true )
	DeathNote:SetBackgroundBlur( true )
	DeathNote:SetDraggable( false )
	-- DeathNote:ShowCloseButton( true )
	DeathNote:ShowCloseButton( false )
	DeathNote:MakePopup()
	
	DeathNote.Paint = function()
		tex = surface.GetTextureID( "vgui/deathnote_vgui"  )
		surface.SetTexture(tex)
		surface.SetDrawColor(255,255,255,255)
		surface.DrawTexturedRect(0, 0, 400, 600)
	end
	
	local DNCloseButten = vgui.Create( "DButton" ) -- Close button was moved up to allow the butten to work on client draw error just in case
	DNCloseButten:SetParent( DeathNote ) -- Set parent to our "DermaPanel"
	DNCloseButten:SetText( "" )
	DNCloseButten:SetPos( 253, 484 )
	DNCloseButten:SetSize( 114, 60 )
	DNCloseButten.Paint = function() end
	DNCloseButten.DoClick = function()
		DeathNote:Close()
		net.Start( "deathnote_pen" ) -- Send a dummy message to the server ro remove the abilty to use the entity deathnote as it varrible can persist though death untill the next use.
			net.WriteString("?")
			net.WriteString("3nt.F1x") -- just some stange charters for the deathtype to check for the dummy message leave as is (as this should be numbers)
		net.SendToServer()
	end
	
	local DeathNotePlayerList = vgui.Create("DListView")
	DeathNotePlayerList:SetParent(DeathNote)
	DeathNotePlayerList:SetPos(38, 150)
	DeathNotePlayerList:SetSize(114, 316)
	DeathNotePlayerList:SetMultiSelect(false)
	DeathNotePlayerList:AddColumn("Name")
	DeathNotePlayerList:SelectFirstItem()
	if gmod.GetGamemode().FolderName == "terrortown" then -- a check to see to get the TTT or Sandbox list of names
		if gmod.GetGamemode().Name == "TTT2" then
			deathnote_ttt2_names_xopez(DeathNotePlayerList) -- TTT2 Player Making List
		else
			deathnote_ttt_names(DeathNotePlayerList) -- TTT Player Making List	
		end
	else
		deathnote_sandbox_names(DeathNotePlayerList) -- Sandbox Plaayer/NPC making
	end
	DeathNotePlayerList.OnRowSelected = function( panel, rowIndex, row )
		local Target = ents.GetByIndex(row:GetValue(2))
		chat.AddText( Color( 25, 25, 25 ), "Death Note: ", CGrey, row:GetValue(1), CWhite," Selected" )
		TargetPlayer = row:GetValue(2)
		TargetPlayerName = row:GetValue(1)
	end

	DeathNotePlayerList.Paint = function() end
	
	local DeathType = vgui.Create("DListView")
	DeathType:SetParent(DeathNote)
	DeathType:SetPos(253, 150)
	DeathType:SetSize(116, 318)
	DeathType:SetMultiSelect(false)
	DeathType:AddColumn("Death Type") -- Add column     table.Count( table tbl )
	for k, v in pairs( DN_DeathTypes ) do
		local line = DeathType:AddLine(DN_DeathTypes[v])
		if DN_DeathTypes[v] == "heartattack" then line:SetSelected( true ) end
	end 

	DeathType:SortByColumn( 1 )
	DeathType.Paint = function() end
	DeathType.OnRowSelected = function( panel, rowIndex, row )
		-- chat.AddText( Color( 25, 25, 25 ), "Death Note: ", CGrey, row:GetValue(1), CWhite," Death Selected" )
		TargetDeathType = row:GetValue(1)
	end
	
	local DNWrite = vgui.Create( "DButton" )
	DNWrite:SetParent( DeathNote ) -- Set parent to our "DermaPanel"
	DNWrite:SetText( "" )
	DNWrite:SetPos( 38, 484 )
	DNWrite:SetSize( 114, 60 )
	DNWrite.Paint = function() end
	DNWrite.DoClick = function()
		if TargetPlayer != "?" then
			if TargetDeathType == "?" then TargetDeathType = "heartattack" end -- let's fix the death type if they don't selected one
			DeathNote:Close()
			net.Start( "deathnote_pen" )
				net.WriteString(TargetPlayer)
				net.WriteString(TargetDeathType)
			net.SendToServer()
				chat.AddText( CBlack, "Death Note: ", CWhite, "You have selected, ", CGrey, TargetPlayerName, CWhite,", With ", CGrey, TargetDeathType )
		else
			chat.AddText( CBlack, "Death Note: ", CWhite, "Please choose a Target" )
		end
	end
	
	local DNCheck = vgui.Create( "DButton" ) --Easter Egg in GUI, and one debug for checking player list
	DNCheck:SetParent( DeathNote ) -- Set parent to our "DermaPanel"
	DNCheck:SetText( "" )
	DNCheck:SetPos( 260, 22 )
	DNCheck:SetSize( 40, 20 )
	DNCheck.Paint = function() end
	DNCheck.DoClick = function()
		for k,v in pairs(player.GetAll()) do --All this does is put some text in the chat if the 2 creators are on the server
			if v:SteamID64() == "76561198025795415" then chat.AddText( CBlack, "Death Note: ", Color( 0, 100, 255 ), "Blue-Pentagram", CWhite, " is on this server." ) end
			if v:SteamID64() == "76561198055281421" then chat.AddText( CBlack, "Death Note: ", CWhite, v:Nick().." AKA 'TheRowan' is on this server." ) end
		end
		if GetConVar("DeathNote_Debug"):GetBool() then -- Debug checking to see what list is being loaded
			if gmod.GetGamemode().FolderName == "terrortown" then  
				if gmod.GetGamemode().Name == "TTT2" then
					chat.AddText( CBlack, "Death Note: ", CWhite, "Useing Xopez's TTT2 Player list" )
				else
					chat.AddText( CBlack, "Death Note: ", CWhite, "Useing Orginal TTT Player list" )

				end
			else
				chat.AddText( CBlack, "Death Note: ", CWhite, "Death Note: Useing Sandbox Player list" )

			end
		end
	end

end

net.Receive( "deathnote_gui", function( len, pl )
	DN_DeathTypes = net.ReadTable()
	if gmod.GetGamemode().FolderName == "terrortown" then
		if not GetConVar("DeathNote_TTT_DT_Explode_Enable"):GetBool() then 
			DeathNote_Remove_TTT_Disabled_Death_Types("explode")
		end
		if not GetConVar("DeathNote_TTT_DT_Dissolve_Enable"):GetBool() then 
			DeathNote_Remove_TTT_Disabled_Death_Types("dissolve")
		end
	end
	deathnote_gui(DN_DeathTypes)
end )

function DeathNote_Remove_TTT_Disabled_Death_Types(DN_Neater_Menu) -- This was made due to fact i have a disable for dissolve for TTT, that was before it was tested in TTT
	if not DN_DeathTypes[DN_Neater_Menu] then return end
	DN_DeathTypes[DN_Neater_Menu] = nil
end
	
-- Below Not Requied for TTT at all
hook.Add( "PopulateToolMenu", "deathnote_q_utilities_settings", function()
	spawnmenu.AddToolMenuOption( "Utilities", "Death Note", "Death_Note_Q_General", "Settings", "", "", function( panel )
		panel:Clear()
		panel:Help("---[Client]---")
		panel:CheckBox( "Show NPC's in list", "DeathNote_GUI_ShowNPCs", 0, 1 )
		panel:CheckBox( "Fast NPC's Names in list", "DeathNote_GUI_FastNPCsNames", 0, 1 )
		panel:Help("---[Server]---")
		panel:ControlHelp("Note: Dedicated Server's will need to RCON for changes to work correctly.")
		panel:ControlHelp("[General]")
		panel:CheckBox( "Debugging (admin resetting/console messages)", "DeathNote_Debug", 0, 1 )
		panel:CheckBox( "Admin Messages", "DeathNote_Admin_Messages", 0, 1 )
		panel:CheckBox( "Use ULX Admin Options", "DeathNote_ulx_installed", 0, 1 )
		panel:Help("------------------------------------------------")
		panel:ControlHelp("[Sandbox]")
		panel:CheckBox( "Remove Unkillable Entitys", "DeathNote_RemoveUnkillableEntity", 0, 1 )
		panel:NumSlider( "Timer For Death", "DeathNote_DeathTime", 0, 60,false )
		panel:NumSlider( "Explosion Timer", "DeathNote_ExplodeTimer", 1, 60,false )
		panel:Help("------------------------------------------------")
		panel:ControlHelp("[Shared]")
		panel:CheckBox( "Heart Attack Fallback", "DeathNote_Heart_Attack_Fallback", 0, 1 )
		panel:CheckBox( "Explosion Countdown", "DeathNote_ExplodeCountDown", 0, 1 )
		panel:NumSlider( "Explosion Countdown", "DeathNote_ExplodeCountDownFrom", 1, 60,false )
		panel:Help("------------------------------------------------")
		panel:ControlHelp("[Trouble in Terriost Town]")
		panel:CheckBox( "[TTT] Always Die", "DeathNote_TTT_AlwaysDies", 0, 1 )
		panel:NumSlider( "[TTT] Timer For Death", "DeathNote_TTT_DeathTime", 0, 60,false )
		panel:NumSlider( "[TTT] Explosion Time", "DeathNote_TTT_Explode_Time", 0, 60,false )
		panel:CheckBox( "[TTT] Lose DN on fail", "DeathNote_TTT_LoseDNOnFail", 0, 1 )
		panel:NumSlider( "[TTT] Time until return", "DeathNote_TTT_DNLockOut", 0, 60,false )
		panel:CheckBox( "[TTT] Chance Bypass", "DeathNote_TTT_BypassChance", 0, 1 )
		panel:CheckBox( "[TTT] Show Killer", "DeathNote_TTT_ShowKiller", 0, 1 )
		panel:CheckBox( "[TTT] Message About Death", "DeathNote_TTT_MessageAboutDeath", 0, 1 )
		panel:CheckBox( "[TTT] Enable Explode", "DeathNote_TTT_DT_Explode_Enable", 0, 1 )
		panel:CheckBox( "[TTT] Enable Dissolve", "DeathNote_TTT_DT_Dissolve_Enable", 0, 1 ) -- Does not work with TTT

	end )
end )

function deathnote_fix_HLSource_cache() -- Manual entries
	DN_NPCListCache["hornet"]={Name=language.GetPhrase( "#hornet" )}
	DN_NPCListCache["class C_AI_BaseNPC"]={Name=language.GetPhrase( "#monster_tentacle" )}
	DN_NPCListCache["nihilanth_energy_ball"]={Name=language.GetPhrase( "#nihilanth_energy_ball" )}
end

DN_NPCHideList = {
	nihilanth_energy_ball = true
} 
