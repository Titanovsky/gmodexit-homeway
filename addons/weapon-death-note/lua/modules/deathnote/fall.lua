

function dn_module_fall(ply,target)
	DeathNoteDeathInUse("fall",true) -- let's add it from the use list
	local TerrorTownCheck = gmod.GetGamemode().FolderName == "terrortown" -- Let's make a terror town check
	if target:IsPlayer() then -- Kicking the player out of Vehicle To Kill THem
		if target:InVehicle() then
			target:ExitVehicle()
		end
	end
	target:SetVelocity(Vector(0,0,1000))
	timer.Simple( 1, function() 
		if target:IsPlayer() then
			if target:Health() >= 1 and !GetConVar("mp_falldamage"):GetBool() and not TerrorTownCheck then -- this gets if realitic fall damage is off
				target:SetHealth(1) -- and sets hp to 1
			else
				if target:Health() >= target:GetMaxHealth() then
					target:SetHealth(target:GetMaxHealth())
				end
			end
		else
			timer.Simple( 1, function()  -- Timer for npcs to take damage
				local d = DamageInfo()
				d:SetDamage( target:Health() )
				d:SetAttacker( ply or target )
				d:SetDamageType( DMG_GENERIC ) 
				target:TakeDamageInfo(d)
				DeathNote_RemoveEntity(ply,target)
			end)
		end 
		if TerrorTownCheck then
			target.was_pushed = {att=ply, t=CurTime(), wep="death_note_ttt"} 
		end
		target:SetVelocity(Vector(0,0,-1000))
		if not TerrorTownCheck then -- Sandbox End Code, Sandbox does not repeat due to respawn they could die and respawn before the alive chec ktriggers and could repeat so lets try once
			DeathNoteDeathInUse("fall",nil) -- It's not TTT and this death can loop if people respawn to quickly so it ends here for non TTT
			if target:IsPlayer() then
				if target:Alive() then
					target:PrintMessage(HUD_PRINTTALK,"Death Note: You Survived the Fall Damage Death")
					ply:PrintMessage(HUD_PRINTTALK,"Death Note: "..target:Nick().." Failed to die from the Fall Death.")
				else
					target:PrintMessage(HUD_PRINTTALK,"Death Note: Died via the Death-Note killed by '"..ply:Nick().."'")
				end
			end
		else -- TTT Repeat until death or round end
		timer.Simple( 2, function() -- To try and kill the one that stay's withing a safe spot (Change this to Terror Town)
			if target:Alive() then -- If they are alive
				timer.Create( "FallDeath", 3, 0, function()
					if target:Alive() and GetRoundState() == ROUND_ACTIVE then   -- If they are alive and the round is active try to kill them again
						local Rand1 = math.random(-1000, 1000)
						local Rand2 = math.random(-1000, 1000)
						target:SetVelocity(Vector(Rand1,Rand2,1000))
						timer.Simple( 1, function() 
							target:SetVelocity(Vector(0,0,-1000)) 
							target.was_pushed = {att=ply, t=CurTime(), wep="death_note_ttt"} 
						end )
					else
						if GetRoundState() != ROUND_ACTIVE then
							target:PrintMessage(HUD_PRINTTALK,"Death Note: Round not active stopping fall death.")
							timer.Remove("FallDeath")
							return
						end
						dn_module_fall_ttt_end(ply,target)
					end
				end )
			else
				dn_module_fall_ttt_end(ply,target)
			end
			end )
		end	
	end )
end
hook.Add( "dn_module_fall", "DN fall Death", dn_module_fall )

function dn_module_fall_ttt_end(ply,target)
	local tttmessage = "has been flung via the Death Note."
	DeathNote_TTT_Corpse_Edit(target,"fall")
	DeathNoteDeathInUse("fall",nil)
	dn_messages(ply,target,tttmessage) -- Lets Do the fundion i made for the TTT Messages (this was in the code multiple times)
	timer.Remove("FallDeath")
end