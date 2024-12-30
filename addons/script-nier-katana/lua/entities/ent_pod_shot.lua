AddCSLuaFile()

ENT.Type 			= "anim"
ENT.Base 			= "base_gmodentity"
ENT.PrintName		= "Pod Shot"
ENT.Author			= "Xaxidoro"
ENT.Information		= ""
ENT.Category		= "Mad Cows Weapons"

ENT.Spawnable		= false
ENT.AdminSpawnable	= false

ENT.LiveTime		= CurTime()

function ENT:Draw()
	
	self.Entity:DrawModel()
	
end

function ENT:Think()

	if not self.Entity:GetOwner():IsValid() and SERVER then
		self.Entity:Remove()
		return
	end
	
	if self.LiveTime < CurTime() and SERVER then
		self.Entity:Remove()
	end

end

if SERVER then

	function ENT:Initialize()

		self.Entity:SetModel("models/maxofs2d/hover_rings.mdl")
		self.Entity:SetMaterial("models/alyx/emptool_glow")
		self.Entity:SetColor(Color(255, 255, 0, 0))
		self.Entity:PhysicsInit(SOLID_VPHYSICS)
		self.Entity:SetMoveType(MOVETYPE_VPHYSICS)
		self.Entity:SetSolid(SOLID_VPHYSICS)
		self.Entity:DrawShadow(false)
		self.Entity:SetGravity(0)
		
		self.Entity:SetCollisionGroup(COLLISION_GROUP_INTERACTIVE_DEBRIS)
		self.LiveTime = CurTime() + 5
		
		local phys = self.Entity:GetPhysicsObject()
		
		if (phys:IsValid()) then
			phys:EnableGravity( false )
			phys:Wake()
		end

	end
	
	function ENT:PhysicsCollide(Data,Physics)

		local Ent = Data.HitEntity

		self.Entity:EmitSound("ambient/energy/spark" .. math.random(1, 6) .. ".wav")
		
		/*
		local Dir = Data.OurOldVelocity:GetNormal()
		local Norm = Data.HitNormal
		local TargetDir = Dir - 2 * (Norm:DotProduct( Dir ) * Norm)

		self.Entity:SetAngles(TargetDir:Angle())
		Physics:Sleep()
		Physics:Wake()

		Physics:ApplyForceCenter(TargetDir * 5000)
		*/
		
		local dmginfo = DamageInfo()
			dmginfo:SetDamage(15 + math.Rand(5,15))
			dmginfo:SetAttacker( self.Entity:GetOwner() )
			dmginfo:SetInflictor( self.Entity )
			dmginfo:SetDamageForce( ( Ent:GetPos() - self.Entity:GetPos() ) * 100 )
			
		local en = ents.FindInSphere(Data.HitPos, 50)
		
		for k, v in pairs(en) do
			if v:IsValid() and v != self.Entity:GetOwner() and not string.find(v:GetClass(), "ent_yorha_drone") then
				dmginfo:SetDamageForce( ( v:GetPos() - self.Entity:GetPos() ):GetNormalized() * 50000 )
				v:TakeDamageInfo( dmginfo )
			end
		end
		--Ent:TakeDamageInfo( dmginfo )

		local FX = EffectData()
		FX:SetOrigin(Data.HitPos)
		FX:SetNormal(Data.HitNormal)
		FX:SetMagnitude(1.8)
		FX:SetScale(3)
		FX:SetRadius(5.5)

		util.Effect("sparks",FX,true,true)
		
		self.Entity:Remove()

	end
	
	function ENT:Touch( entity )
	
	end

	function ENT:OnTakeDamage( damage )
	
	end
	
end