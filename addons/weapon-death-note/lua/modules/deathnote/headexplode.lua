

if SERVER then -- Note This Death type is mostly done on the client's end - this death will most likely not work as well in TTT
	util.AddNetworkString( "deathnote_dm_headexplodec" )
end
function dn_module_headexplode(ply,target)
	local TerrorTownCheck = gmod.GetGamemode().FolderName == "terrortown" -- Let's make a terror town check
	if TerrorTownCheck then -- Let's See if it's Terror Town
		ply:PrintMessage(HUD_PRINTTALK,"Death Note: Head Explode not working in TTT Going to Heart Attack.") -- Let's tell the person it's disabled and going to heart attack
		hook.Run( "dn_module_heartattack", ply,target ) -- lets call the heart attack function
		return -- Where done here lets stop the code here
	end
	DeathNoteDeathInUse("headexplode",true) -- let's add it from the use list
	net.Start( "deathnote_dm_headexplodec" ) -- Send data to the clients to do the bone scale client side and abitly to get dead ragdoll entity as there a server and client side of player ragdolls
		net.WriteEntity(ply)
		net.WriteEntity(target)
	net.Broadcast()
	timer.Simple( 0.51, function() 
		DeathNoteDeathInUse("headexplode",nil)
		if target:IsPlayer() then
			if target:InVehicle() then
				target:ExitVehicle()
			end
		end 
		local dmgInfo = DamageInfo()
		dmgInfo:SetDamage( target:Health() )
		dmgInfo:SetAttacker( ply or target )
		target:TakeDamageInfo(dmgInfo)
		local tttmessage = "has had there head exploded via the Death Note." 
		dn_messages(ply,target,tttmessage)
		DeathNote_RemoveEntity(ply,target)
	end )
end
hook.Add( "dn_module_headexplode", "DN Head Explode Death", dn_module_headexplode )

/*
Most likely not going to get this death for working for TTT on how i would like to function.
Would like it to remove who's name is on the body but to much could go wroung. 
Like custom roles for TTT2 Custom scoreboards, The diffence's of how body could be reported
Useing the body grabber in dissolve deathtype can grab the body and edit the head scale bone.
*/