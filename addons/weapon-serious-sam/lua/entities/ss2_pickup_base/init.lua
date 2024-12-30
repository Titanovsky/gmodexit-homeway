AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')

ENT.ResizeModel = true
ENT.ModelScale = 2
ENT.TriggerBounds = 32
ENT.Respawnable = true
ENT.PickupSounds = {
	Sound("serioussam2/weaponpickup/weaponpickup01.wav"),
	Sound("serioussam2/weaponpickup/weaponpickup02.wav"),
	Sound("serioussam2/weaponpickup/weaponpickup03.wav"),
	Sound("serioussam2/weaponpickup/weaponpickup04.wav")
}

function ENT:SpawnFunction(ply, tr)
	if !tr.Hit then return end
	local SpawnPos = tr.HitPos + tr.HitNormal * 35
	local ent = ents.Create(self.ClassName)
	ent:SetPos(SpawnPos)
	ent:Spawn()
	ent:Activate()
	return ent
end

function ENT:Initialize()
	self:SetModel(self.model)
	if self.ResizeModel then
		self:SetModelScale(self.ModelScale, 0)
	end
	self:SetMoveType(MOVETYPE_NONE)
	self:SetSolid(SOLID_NONE)
	self:SetAngles(Angle(0,90,0))
	self:DrawShadow(true)
	self.Available = true
	self:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
	self:SetRenderMode(RENDERMODE_TRANSALPHA)
	self:SetTrigger(true)
	self:UseTriggerBounds(true, self.TriggerBounds)
end

function ENT:Think()
	if self.RespawnTime and CurTime() >= self.RespawnTime then
		self.RespawnTime = nil
		self.Available = true
		self:SetNoDraw(false)
	end
end

function ENT:Touch(ent)
	if IsValid(ent) and ent:IsPlayer() and ent:Alive() and self.Available then
		if game.SinglePlayer() or !self.Respawnable then
			self:Remove()
		else
			self.Available = false
			self:SetNoDraw(true)
			self.RespawnTime = CurTime() + 6
		end
		if ent:HasWeapon(self.WeapName) then
			local wep = ent:GetWeapon(self.WeapName)
			local ammo = wep:GetPrimaryAmmoType()
			local ammoCount = ent:GetAmmoCount(ammo)
			if ammoCount < self.MaxAmmo then
				ent:SetAmmo(math.min(ammoCount + wep.Primary.DefaultClip, self.MaxAmmo), ammo)
			end
		end
		ent:Give(self.WeapName)
		ent:EmitSound(self.PickupSound or self.PickupSounds[math.random(1, #self.PickupSounds)], 85, 100, 1, CHAN_ITEM)
	end
end