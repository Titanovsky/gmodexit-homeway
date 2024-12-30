list.Set( "PlayerOptionsAnimations", "PD2_Bulldozer", { "idle_all_angry", "idle_all_01", "menu_walk" } )
player_manager.AddValidModel( "PD2_Bulldozer", "models/mark2580/payday2/pd2_bulldozer_player.mdl" )
player_manager.AddValidHands( "PD2_Bulldozer", "models/mark2580/payday2/bulldozer_c_arms.mdl", 0, "00000000" )

local CBB = {}
function CBB.DrawRottenHands( vm, ply, weapon )
	if CLIENT then
		hskin = LocalPlayer():GetSkin()
		local hands = LocalPlayer():GetHands()
		if ( weapon.UseHands || !weapon:IsScripted() ) then
			if ( IsValid( hands ) ) then
				hands:DrawModel()
				hands:SetSkin(hskin)
			end
		end
	end
end
hook.Add("PostDrawViewModel", "Set player hand skin", CBB.DrawRottenHands)

local Category = "PAYDAY 2 NPCs"


local function fixHealthAndModelBull( ply, ent )
  if IsValid(ent) then
    if ent:GetModel() == "models/mark2580/payday2/pd2_bulldozer_combine.mdl" then 
      ent:SetHealth( 500 )
      ent:SetMaxHealth( 500 )
    elseif ent:GetModel() == "models/mark2580/payday2/pd2_bulldozer_rebel.mdl" then 
      ent:SetHealth( 500 )
      ent:SetMaxHealth( 500 )
    end
  end
end

local NPC = {
  Name = "PD2 Bulldozer (Enemy)", 
  Class = "npc_combine_s",
  Model = "models/mark2580/payday2/pd2_bulldozer_combine.mdl",
  Weapons = { "weapon_smg1", "weapon_ar2", "weapon_shotgun" },
  Health = 100,
  KeyValues = {
    SquadName = "GarogCombine",
    Numgrenades = 5
  },
  Category = Category
}

list.Set( "NPC", "pd2_bulldozer_combine", NPC )

local NPC = {
  Name = "PD2 Bulldozer (Friendly)", 
  Class = "npc_citizen",
  -- SpawnFlags = SF_CITIZEN_RANDOM_HEAD_MALE,
  Model = "models/mark2580/payday2/pd2_bulldozer_rebel.mdl",
  Health = 300,
  KeyValues = {
    --SquadName = "GarogRebel",
    citizentype = CT_UNIQUE --CT_REBEL CT_UNIQUE
  },
  Weapons = { "weapon_pistol", "weapon_ar2", "weapon_smg1", "weapon_ar2", "weapon_shotgun" },
  Category = Category
}

list.Set( "NPC", "pd2_bulldozer_rebel", NPC )

hook.Add( "PlayerSpawnedNPC", "BulldozerSpawned", fixHealthAndModelBull )