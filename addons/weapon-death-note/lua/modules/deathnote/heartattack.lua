

function dn_module_heartattack(ply,target) -- Look at lua/autorun/deathnote_config.lua at like 84 to see this code with comment's
	-- DeathNoteDeathInUse("heartattack",true)
	if target:IsPlayer() then
		if target:InVehicle() then
			target:ExitVehicle()
		end 
		local tttmessage = "has had a heart attack via the Death Note." 
		dn_messages(ply,target,tttmessage) 
	end 
	local dmgInfo = DamageInfo() 
	dmgInfo:SetDamage( target:Health() )
	dmgInfo:SetAttacker( ply or target )
	dmgInfo:SetDamageForce( Vector(0,0,0) )
	target:TakeDamageInfo(dmgInfo)
	DeathNote_RemoveEntity(ply,target)
	DeathNote_TTT_Corpse_Edit(target)
end
hook.Add( "dn_module_heartattack", "DN Heart Attack Death", dn_module_heartattack ) 