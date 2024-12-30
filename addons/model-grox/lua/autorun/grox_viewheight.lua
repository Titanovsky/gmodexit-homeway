CreateConVar( "player_grox_viewheight", "1", { FCVAR_NOTIFY, FCVAR_ARCHIVE } )

hook.Add("PlayerSpawn",  "player_grox_viewheight_Offset", function(ply)
	if not ply or not ply:IsValid() then return end
	if (ply:GetModel() == "models/models/justagrox/groxv2/groxv2_pm.mdl") then
	timer.Simple(0.1, function()
	if GetConVarNumber( "player_grox_viewheight" ) == 1 then
	ply:SetViewOffset( Vector(0,0,50) )
	ply:SetViewOffsetDucked( Vector(0,0,30) )
	ply:SetHull( Vector( -16, -16, 0 ), Vector( 16, 16, 64 ) )
	ply:SetHullDuck( Vector( -16, -16, 0 ), Vector( 16, 16, 30 ) )
	end
	end)
else
	ply:SetViewOffset( Vector(0,0,64) )
	ply:SetViewOffsetDucked( Vector(0,0,28) )
	ply:SetHull( Vector( -16, -16, 0 ), Vector( 16, 16, 70 ) )
	ply:SetHullDuck( Vector( -16, -16, 0 ), Vector( 16, 16, 34 ) )
	end
end)