local ENT = ENT

local manual_load = false

if not ENT then

	ENT = {}

	manual_load = true

end



ENT.PrintName = "Christmas Tree"

--ENT.Base = "gmod_entity"

ENT.Base = "base_anim"

ENT.Category = "Christmas Tree"

ENT.Spawnable = true

ENT.AdminOnly = true


if CLIENT then



	local lightpos1 = Vector(0,0,512)

	local lightpos2 = Vector(0,0,950)

	--local lightdir1 = Vector(0,0,-1)

	function ENT:Think()

		local color = GetCurrentChristmasLightsColor()



		--[[local l1dir = Vector( lightdir1.x, lightdir1.y, lightdir1.z )

		l1dir:Rotate( self:GetAngles() )]]

		local idx = self:EntIndex() + 8192

		local l1 = DynamicLight( idx )

		l1.pos = self:LocalToWorld( lightpos1 )

		l1.r = color.r

		l1.g = color.g

		l1.b = color.b

		l1.brightness = 3

		l1.minlight = 0

		l1.Decay = 1

		l1.Size = 1500

		l1.noworld = true

		l1.DieTime = CurTime() + 0.066

		--[[l1.dir = l1dir

		l1.innerangle = 60

		l1.outerangle = 70]]

		local l2 = DynamicLight( idx + 1 )

		l2.pos = self:LocalToWorld( lightpos2 )

		l2.r = 255

		l2.g = 230

		l2.b = 128

		l2.brightness = 3

		l2.minlight = 0

		l2.Decay = 1

		l2.Size = 1024

		l2.noworld = true

		l2.DieTime = CurTime() + 0.066

	end



else -- SERVER

	function ENT:Initialize()

		self:SetModel("models/grinchfox/foliage/christmastree.mdl")

		self:SetSolid( SOLID_VPHYSICS )

		self:PhysicsInit( SOLID_VPHYSICS )

		self:SetMoveType( MOVETYPE_NONE )

		self:SetCollisionGroup(COLLISION_GROUP_NONE)

		local phys = self:GetPhysicsObject()

		if IsValid(phys) then

			phys:EnableMotion( false )

		end

	end

end





if manual_load then

	scripted_ents.Register(ENT,"christmas_tree")

end



