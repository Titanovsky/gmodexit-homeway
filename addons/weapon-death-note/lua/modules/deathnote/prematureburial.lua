

function dn_module_prematureburial(ply,target) 
	local TerrorTownCheck = gmod.GetGamemode().FolderName == "terrortown" -- Let's make a terror town check
	if target:IsPlayer() then -- Kicking the player out of Vehicle To Kill THem
		if target:InVehicle() then
			target:ExitVehicle()
		end
	end
	local Pos = target:GetPos()
	DeathNoteDeathInUse("prematureburial",true) -- let's add it from the use list
	local DN_Burial_Count = 0
	if target:IsPlayer() then 
		target:Freeze( true ) -- Move freeze up to see if they can be buried while frozen
	end
	timer.Create( "BuryTime", 1, 16, function()
		DN_Burial_Count = DN_Burial_Count + 1
		if not IsValid(target) then 
			DeathNoteDeathInUse("prematureburial",nil) 
			timer.Remove("BuryTime") 
			return 
		end -- If victim no longer exiscts stop the timer and function
		if DN_Burial_Count <= 4 then -- Count To Bury the victim
			target:SetPos(target:GetPos() + Vector(0,0,-20))
			if DN_Burial_Count == 4 then
				target:SetPos(target:GetPos() + Vector(0,0,-1500)) -- LET REALLY MOVE THEM DOWN (no more proplems with multiple floors and what not	
				PreBuryGrave(Pos,target,TerrorTownCheck) 
			end
		elseif DN_Burial_Count == 16 then -- Outright Kill the victim and kill the npc after a while
			local dmgInfo = DamageInfo()
			dmgInfo:SetDamage( target:Health() )
			dmgInfo:SetAttacker( ply or target )
			dmgInfo:SetDamageForce( Vector(0,0,0) ) 
			target:TakeDamageInfo(dmgInfo)
			dn_bury_end(ply,target,TerrorTownCheck)
			if IsValid(target) then -- Sorry people "RemoveEntity" is not used in the death to prevent NPC from getting stuck underground and will always be removed
				target:Remove()
			end
			return
		end
		if DN_Burial_Count >= 5 then -- Deal damage while underground
			if target:IsPlayer()then
				if target:Alive() then
					local dmgInfo = DamageInfo()
					dmgInfo:SetDamage( 10 )
					dmgInfo:SetAttacker( ply or target )
					dmgInfo:SetDamageForce( Vector(0,0,0) ) 
					target:TakeDamageInfo(dmgInfo)
				else
					dn_bury_end(ply,target,TerrorTownCheck)
				end		
			end
		end
	end)
end
hook.Add( "dn_module_prematureburial", "DN Premature Bury Death", dn_module_prematureburial )

function dn_bury_end(ply,target,TerrorTownCheck)
	if target:IsPlayer() then 
		if TerrorTownCheck then -- let's remove TTT corpse so in not falling into a infinte abyss
			for _, ent in ents.Iterator() do
				if ( ent:GetClass() == "prop_ragdoll" ) then
					if ent.sid64 == target:SteamID64() then
						ent:Remove()
					end
				end
			end
			if GetConVar("DeathNote_Debug"):GetBool() then
				print("[Death Note Debug] Premature Burial Removed TTT corpse for: "..target:Nick()) -- Prints loaded module's i only use to make sure module where loaded    
			end		
		end
		target:Freeze( false ) 
		local tttmessage = "has been buried alive!"
		dn_messages(ply,target,tttmessage)
	end -- Unfreeze the person
	DeathNoteDeathInUse("prematureburial",nil) -- let's remove it from the use list
	timer.Remove("BuryTime")
end

function PreBuryGrave(Pos,target,TerrorTownCheck)-- Will have to fix the text with the npcs
	Grave_Model = "models/props_c17/gravestone004a.mdl" -- see if i can make them just props with only world collusion and freeze them make code to block out 3rd ent for name?
	Shovel_Model = "models/props_junk/shovel01a.mdl"
	local Ang = target:GetAngles()
	if TerrorTownCheck then -- If terror town
		Grave = ents.Create( "prop_dynamic_override" ) -- we will use a normal prop, the grave cleanup will be handled by TTT round restart cleanup
	else
		Grave = ents.Create( "ent_death_mark" ) -- if sandbox use the ent that has writeing, sandbox ent will remove itself after 30 seconds
	end
	if ( !IsValid( Grave ) ) then return end 
	Grave:SetPos( Pos + Ang:Up() * 17 )
	Grave:SetAngles( Ang )
	Grave:SetOwner(target)
	Grave:SetModel(Grave_Model)
	Grave:Spawn()
	local Shovel = ents.Create( "prop_dynamic_override" )
	if ( !IsValid( Shovel ) ) then return end
	Shovel:SetPos( Pos + Ang:Up() * 23 + Ang:Forward() * -8 )
	Ang:RotateAroundAxis(Ang:Right(), -20)
	Ang:RotateAroundAxis(Ang:Forward(), 8)
	Ang:RotateAroundAxis(Ang:Up(), 180)
	Shovel:SetAngles( Ang )
	Shovel:SetOwner(target)
	Shovel:SetModel(Shovel_Model)
	Shovel:Spawn()
	if not TerrorTownCheck then
		Grave.Shovel = Shovel -- link the shovel to the grave mostly for sandbox
	end
end