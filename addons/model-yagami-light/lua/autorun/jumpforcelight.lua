if SERVER then
	AddCSLuaFile()
end

player_manager.AddValidModel("Jump Force - Light Yagami", "models/konnie/jumpforce/lightyagami.mdl")
player_manager.AddValidHands( "Jump Force - Light Yagami", "models/weapons/arms/v_arms_lightyagami.mdl", 0, "00000000" )

local Category = "Jump Force"

local function AddNPC( t, class )
list.Set( "NPC", class or t.Class, t )
end

AddNPC( {
Name = "Light Yagami",
Class = "npc_citizen",
Category = Category,
Model = "models/konnie/jumpforce/lightyagami_f.mdl",
KeyValues = { citizentype = CT_UNIQUE, SquadName = "jumpforcelight_f" }
}, "npc_jumpforcelight_f" )