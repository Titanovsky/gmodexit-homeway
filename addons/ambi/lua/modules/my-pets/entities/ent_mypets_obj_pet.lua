local C, Ents = Ambi.General.Global.Colors, Ambi.RegEntity

local ENT = {}

ENT.Class       = 'mypets_obj_pet'
ENT.Type	    = 'anim'

ENT.PrintName	= 'Ball'
ENT.Author		= 'Ambi'
ENT.Category	= 'MyPets'
ENT.Spawnable   = false

ENT.Stats = {
    type = 'Entity',
    model = 'models/hunter/misc/sphere025x025.mdl',
    module = 'MyPets',
    date = '26.10.2021 15:05'
}

Ents.Register( ENT.Class, 'ents', ENT )

if CLIENT then
    ENT.RenderGroup = RENDERGROUP_BOTH

    function ENT:DrawTranslucent()
        Ents.Draw( self, false )

        --if ( LocalPlayer():GetPos():Distance( self:GetPos() ) > 1800 ) then return end
        --draw.SimpleTextOutlined( self.nw_NamePet, '24 Ambi', 4, 0, C.ABS_WHITE, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, C.ABS_BLACK )
    end

    return Ents.Register( ENT.Class, 'ents', ENT )
end 

function ENT:Initialize()
    Ents.Initialize( self, self.Stats.model )
    Ents.Physics( self, MOVETYPE_NONE, SOLID_NONE, COLLISION_GROUP_WORLD, false, false, true )
end

Ents.Register( ENT.Class, 'ents', ENT )