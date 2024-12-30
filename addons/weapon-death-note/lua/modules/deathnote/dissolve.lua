

function dn_module_dissolve(ply,target) -- Yes this function is just a mostly a copy of the heart attack with the damagetype being the dissolve the same damagetype the AR2 energy pallet use's (then use's the entity dissolver if they have hp left.
	local TerrorTownCheck = gmod.GetGamemode().FolderName == "terrortown" -- Let's make a terror town check
	if TerrorTownCheck then -- Let's See if it's Terror Town
		if not GetConVar("DeathNote_TTT_DT_Dissolve_Enable"):GetBool() then -- Let's check if Dissolve been disabled in terror town
			ply:PrintMessage(HUD_PRINTTALK,"Death Note: Dissolve death not enabled in server going to Heart Attack.") -- Let's tell the person it's disabled and going to heart attack
			hook.Run( "dn_module_heartattack", ply,target ) -- lets call the heart attack function
			return -- Where done here lets stop the code here
		end
	end
	if target:IsPlayer() then
		if target:InVehicle() then
			target:ExitVehicle()
		end
	end
	local dmgInfo = DamageInfo() -- let's use the damage type first so we don't have to use the entity dissolver
	dmgInfo:SetDamage( target:Health() )
	dmgInfo:SetAttacker( ply or target ) 
	dmgInfo:SetDamageForce( Vector(0,0,0) ) 
	dmgInfo:SetDamageType( DMG_DISSOLVE ) 
	target:TakeDamageInfo(dmgInfo)
	if target:Health() >= 1 then -- If they have health still let's use the entity dissolver
		dn_module_entity_dissolve(ply,target)
	end
	if TerrorTownCheck then -- If Teror Town
		for _, ent in ents.Iterator() do
			if ( ent:GetClass() == "prop_ragdoll" ) then
				if ent.sid64 == target:SteamID64() then
					dn_module_entity_dissolve(ply,ent)
				end
			end
		end
	end
	local tttmessage = "Has dissolved via the Death Note." 
	dn_messages(ply,target,tttmessage)
end
hook.Add( "dn_module_dissolve", "DN Heart Dissolve", dn_module_dissolve )

function dn_module_entity_dissolve(ply,target)
	target:SetName( "DN_dissolve_"..ply:Nick())
	if ( !IsValid( dissolver ) ) then
		dissolver = ents.Create( "env_entity_dissolver" )
		dissolver:SetPos( target:GetPos() )
		dissolver:Spawn()
		dissolver:Activate()
		dissolver:SetKeyValue( "magnitude", 100 )
		dissolver:SetKeyValue( "dissolvetype", 0 )
	end
	dissolver:Fire( "Dissolve", "DN_dissolve_"..ply:Nick())
end