AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include('shared.lua')

function ENT:Initialize()
	//Reel model path : models/zerochain/props_casino/wheelofluck/wheelofluck_wheel.mdl
	self:SetModel("models/zerochain/props_casino/wheelofluck/wheelofluck_wheel.mdl")
	self:PhysicsInit( SOLID_NONE )
	self:SetMoveType( MOVETYPE_NONE )
	self:SetSolid( SOLID_VPHYSICS )

	local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake() 
	end
end