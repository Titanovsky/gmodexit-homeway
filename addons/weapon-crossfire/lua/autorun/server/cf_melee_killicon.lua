CFMELEE = {["weapon_deagle_bornbeast"]=true,["weapon_ak47_beast"]=true,["weapon_m4a1_beast"]=true}
hook.Add("OnNPCKilled","test",function(npc,att,inf)
	if IsValid(inf) then
		cl = inf:GetClass()
		if CFMELEE[cl] and inf.NextHit then
			net.Start( "PlayerKilledNPC" )
			net.WriteString( npc:GetClass() )
			net.WriteString( cl.."_melee" )
			net.WriteEntity( att )
			net.Broadcast()
			return true
		end
	end
end)
--resource.AddWorkshop("941003056")