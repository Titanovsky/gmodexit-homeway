AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

if SERVER then
	function SWEP:Bomb()
		local k, v
		local dmg = DamageInfo()
			dmg:SetDamage(1000)
			dmg:SetDamageType(DMG_DISSOLVE)
			dmg:SetAttacker(self.Owner)
			dmg:SetInflictor(self.Owner)
			
		self.Owner:EmitSound("TFA_L4D2_OREN.Swing")
		
		for i=1, 8 do
			local sparks = ents.Create( "env_spark" )
				sparks:SetPos( self.Owner:GetPos() + Vector( math.random( -40, 40 ), math.random( -40, 40 ), math.random( -40, 40 ) ) )
				sparks:SetKeyValue( "MaxDelay", "0" )
				sparks:SetKeyValue( "Magnitude", "2" )
				sparks:SetKeyValue( "TrailLength", "3" )
				sparks:SetKeyValue( "spawnflags", "0" )
				sparks:Spawn()
				sparks:Fire( "SparkOnce", "", 0 )
		end
		local explosioneffect = ents.Create( "prop_combine_ball" )
			explosioneffect:SetPos(self.Owner:GetPos())
			explosioneffect:Spawn()
			explosioneffect:Fire( "explode", "", 0 )
		
		for k, v in pairs ( ents.FindInSphere( self.Owner:GetPos(), 500 ) ) do
			if v:IsValid() and v != self.Owner then
				dmg:SetDamageForce( ( v:GetPos() - self.Owner:GetPos() ):GetNormalized() * 100000 )
				v:TakeDamageInfo( dmg )
			end	
		end
	end
	function SWEP:RushFiveBomb()
		local k, v
		local dmg = DamageInfo()
			dmg:SetDamage(300)
			dmg:SetAttacker(self.Owner)
			dmg:SetInflictor(self.Owner)
			
		self.Owner:EmitSound("TFA_L4D2_OREN.Swing")
		
		local explosioneffect = ents.Create( "prop_combine_ball" )
			explosioneffect:SetPos(self.Owner:GetPos())
			explosioneffect:Spawn()
			explosioneffect:Fire( "explode", "", 0 )
		
		for k, v in pairs ( ents.FindInSphere( self.Owner:GetPos(), 250 ) ) do
			if v:IsValid() and v != self.Owner and not string.find(v:GetClass(), "ent_yorha_drone") then
				dmg:SetDamageForce( ( v:GetPos() - self.Owner:GetPos() ):GetNormalized() * 50000 )
				v:TakeDamageInfo( dmg )
			end	
		end
	end
end